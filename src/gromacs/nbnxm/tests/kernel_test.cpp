/*
 * This file is part of the GROMACS molecular simulation package.
 *
 * Copyright 2023- The GROMACS Authors
 * and the project initiators Erik Lindahl, Berk Hess and David van der Spoel.
 * Consult the AUTHORS/COPYING files and https://www.gromacs.org for details.
 *
 * GROMACS is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1
 * of the License, or (at your option) any later version.
 *
 * GROMACS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with GROMACS; if not, see
 * https://www.gnu.org/licenses, or write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA.
 *
 * If you want to redistribute modifications to GROMACS, please
 * consider that scientific software is very special. Version
 * control is crucial - bugs must be traceable. We will be happy to
 * consider code for inclusion in the official distribution, but
 * derived work must not be called official GROMACS. Details are found
 * in the README & COPYING files - if they are missing, get the
 * official version at https://www.gromacs.org.
 *
 * To help us fund GROMACS development, we humbly ask that you cite
 * the research papers on the package. Check out https://www.gromacs.org.
 */

/*! \internal \file
 * \brief Tests for NBNxM pair kernel forces and energies.
 *
 * These tests covers all compiled flavors of the NBNxM kernels, not only
 * those used by default by mdrun.
 * The forces and energies are compared to reference data for the force+energy
 * kernel. The reference data is only stored once for kernels that are expected
 * to produce the same output (i.e. only different kernel layout or analytical
 * vs tabulated Ewald LR correction).
 * For the force only kernel, the forces are compared to those produced
 * by the force+energy flavor.
 *
 * The only thing currently not covered is LJ-PME with the Lorentz-Berthelot
 * combination rule, as this is only implemented in the plain-C reference kernel
 * and currently the reference data is generated by the SIMD kernels.
 *
 * \author Berk Hess <hess@kth.se>
 * \ingroup module_nbnxm
 */

#include "gmxpre.h"

#include <numeric>
#include <vector>

#include "gromacs/ewald/ewald_utils.h"
#include "gromacs/gpu_utils/hostallocator.h"
#include "gromacs/math/vec.h"
#include "gromacs/mdlib/forcerec.h"
#include "gromacs/mdlib/gmx_omp_nthreads.h"
#include "gromacs/mdtypes/atominfo.h"
#include "gromacs/mdtypes/interaction_const.h"
#include "gromacs/mdtypes/simulation_workload.h"
#include "gromacs/nbnxm/gridset.h"
#include "gromacs/nbnxm/kernel_common.h"
#include "gromacs/nbnxm/nbnxm.h"
#include "gromacs/nbnxm/nbnxm_simd.h"
#include "gromacs/nbnxm/pairlistset.h"
#include "gromacs/nbnxm/pairlistsets.h"
#include "gromacs/nbnxm/pairsearch.h"
#include "gromacs/nbnxm/simd_energy_accumulator.h"
#include "gromacs/pbcutil/ishift.h"
#include "gromacs/pbcutil/pbc.h"
#include "gromacs/topology/topology.h"
#include "gromacs/utility/fatalerror.h"
#include "gromacs/utility/listoflists.h"
#include "gromacs/utility/logger.h"

#include "testutils/refdata.h"
#include "testutils/testasserts.h"
#include "testutils/testinit.h"

#include "spc27_coords.h"

namespace gmx
{

namespace test
{

namespace
{

// Set this macro to 1 when generating reference data
#define GENERATE_REFERENCE_DATA 0

#if GENERATE_REFERENCE_DATA && !GMX_DOUBLE
#    error "We should only generate reference data with double precision"
#endif

//! The options for the kernel
struct KernelOptions
{
    //! Whether to use a GPU, currently GPUs are not supported
    bool useGpu = false;
    //! The number of OpenMP threads to use
    int numThreads = 1;
    //! The kernel setup
    Nbnxm::KernelSetup kernelSetup;
    //! The modifier for the VdW interactions
    InteractionModifiers vdwModifier = InteractionModifiers::PotShift;
    //! The LJ combination rule
    LJCombinationRule ljCombinationRule = LJCombinationRule::None;
    //! Whether we are using PME for LJ
    bool useLJPme = false;
    //! Ewald relative tolerance for LJ
    real ewaldRTolLJ = 1e-4;
    //! LJ combination rule for the LJ PME mesh part
    LongRangeVdW ljPmeCombinationRule = LongRangeVdW::Geom;
    //! The pairlist and interaction cut-off
    real pairlistCutoff = 0.9;
    //! The Coulomb Ewald coefficient
    real ewaldRTol = 1e-6;
    //! The Coulomb interaction function
    CoulombKernelType coulombType = CoulombKernelType::Ewald;
};

//! Description of the system used for benchmarking.
struct TestSystem
{
    /*! \brief Constructor
     *
     * Generates test system of a cubic box partially filled with 27 water molecules.
     * It has parts with uncharged molecules, normal SPC/E and part with full LJ.
     */
    TestSystem(LJCombinationRule ljCombinationRule);

    //! Number of different atom types in test system.
    int numAtomTypes;
    //! Storage for parameters for short range interactions.
    std::vector<real> nonbondedParameters;
    //! Storage for atom type parameters.
    std::vector<int> atomTypes;
    //! Storage for atom partial charges.
    std::vector<real> charges;
    //! Atom info
    std::vector<int64_t> atomInfo;
    //! Information about exclusions.
    ListOfLists<int> excls;
    //! Storage for atom positions.
    std::vector<gmx::RVec> coordinates;
    //! System simulation box.
    matrix box;
};

// A 3-site water model
//! The number of atoms in a molecule
constexpr int numAtomsInMolecule = 3;
//! The atom type of the oxygen atom
constexpr int typeO = 0;
//! The atom type of a hydrogen atom with LJ
constexpr int typeHWithLJ = 1;
//! The atom type of a hydrogen atom without LJ
constexpr int typeHWithoutLJ = 2;
//! The charge of the oxygen atom
constexpr real chargeO = -0.8476;
//! The charge of the hydrogen atom
constexpr real chargeH = 0.4238;
//! The LJ sigma parameter of the Oxygen atom
constexpr real sigmaO = 0.316557;
//! The LJ epsilon parameter of the Oxygen atom
constexpr real epsilonO = 0.650194;
//! The LJ sigma parameter of Hydrogen atoms with LJ
constexpr real sigmaH = 0.04;
//! The LJ epsilon parameter Hydrogen atoms with LJ
constexpr real epsilonH = 0.192464;

//! Generate a C6, C12 pair using the combination rule
std::pair<real, real> combineLJParams(const real              sigma0,
                                      const real              epsilon0,
                                      const real              sigma1,
                                      const real              epsilon1,
                                      const LJCombinationRule ljCombinationRule)
{
    real sigma6;
    if (ljCombinationRule == LJCombinationRule::Geometric)
    {
        sigma6 = std::pow(sigma0 * sigma1, 3);
    }
    else
    {
        sigma6 = std::pow(0.5 * (sigma0 + sigma1), 6);
    }
    real c6  = 4 * sqrt(epsilon0 * epsilon1) * sigma6;
    real c12 = c6 * sigma6;

    return { c6, c12 };
}

const int c_numEnergyGroups = 3;

TestSystem::TestSystem(const LJCombinationRule ljCombinationRule)
{
    numAtomTypes = 3;
    nonbondedParameters.resize(numAtomTypes * numAtomTypes * 2, 0);
    std::tie(nonbondedParameters[0], nonbondedParameters[1]) =
            combineLJParams(sigmaO, epsilonO, sigmaO, epsilonO, ljCombinationRule);
    std::tie(nonbondedParameters[8], nonbondedParameters[9]) =
            combineLJParams(sigmaH, epsilonH, sigmaH, epsilonH, ljCombinationRule);
    std::tie(nonbondedParameters[2], nonbondedParameters[3]) =
            combineLJParams(sigmaO, epsilonO, sigmaH, epsilonH, ljCombinationRule);
    nonbondedParameters[6] = nonbondedParameters[2];
    nonbondedParameters[7] = nonbondedParameters[3];

    coordinates = spc27Coordinates;
    copy_mat(spc27Box, box);
    put_atoms_in_box(PbcType::Xyz, box, coordinates);

    const int numAtoms = coordinates.size();
    GMX_RELEASE_ASSERT(numAtoms % (3 * numAtomsInMolecule) == 0,
                       "Coordinates should be a multiple of 3 x whole water molecules");

    atomTypes.resize(numAtoms);
    charges.resize(numAtoms);
    atomInfo.resize(numAtoms);

    for (int a = 0; a < numAtoms; a++)
    {
        // The first third of the atoms has no charge to cover all code paths
        const bool hasCharge = (a >= numAtoms / 3);

        if (a % numAtomsInMolecule == 0)
        {
            // Oxgygen
            atomTypes[a] = typeO;
            charges[a]   = hasCharge ? chargeO : 0;
            atomInfo[a] |= gmx::sc_atomInfo_HasVdw;
        }
        else
        {
            // Hydrogen
            // Make the last third of molecules have LJ on all atoms
            if (a >= numAtoms * 2 / 3)
            {
                atomTypes[a] = typeHWithLJ;
                atomInfo[a] |= gmx::sc_atomInfo_HasVdw;
            }
            else
            {
                atomTypes[a] = typeHWithoutLJ;
            }
            charges[a] = hasCharge ? chargeH : 0;
        }
        if (hasCharge)
        {
            atomInfo[a] |= gmx::sc_atomInfo_HasCharge;
        }

        // Set the energy group, 0, 1 or 2
        atomInfo[a] |= (a / (numAtoms / c_numEnergyGroups));

        // Generate the exclusions like for water molecules
        excls.pushBackListOfSize(numAtomsInMolecule);
        gmx::ArrayRef<int> exclusionsForAtom   = excls.back();
        const int          firstAtomInMolecule = a - (a % numAtomsInMolecule);
        std::iota(exclusionsForAtom.begin(), exclusionsForAtom.end(), firstAtomInMolecule);
    }
}

//! Sets up and returns a Nbnxm object for the given benchmark options and system
std::unique_ptr<nonbonded_verlet_t> setupNbnxmForBenchInstance(const KernelOptions& options,
                                                               const TestSystem&    system)
{
    real minBoxSize = norm(system.box[XX]);
    for (int dim = YY; dim < DIM; dim++)
    {
        minBoxSize = std::min(minBoxSize, norm(system.box[dim]));
    }
    if (options.pairlistCutoff > 0.5 * minBoxSize)
    {
        gmx_fatal(FARGS, "The cut-off should be shorter than half the box size");
    }

    // We don't want to call gmx_omp_nthreads_init(), so we init what we need
    gmx_omp_nthreads_set(ModuleMultiThread::Pairsearch, options.numThreads);
    gmx_omp_nthreads_set(ModuleMultiThread::Nonbonded, options.numThreads);

    const auto pinPolicy =
            (options.useGpu ? PinningPolicy::PinnedIfSupported : PinningPolicy::CannotBePinned);
    const int numThreads = options.numThreads;
    // Note: the options and Nbnxm combination rule enums values should match
    const int combinationRule = static_cast<int>(options.ljCombinationRule);

    PairlistParams pairlistParams(options.kernelSetup.kernelType, false, options.pairlistCutoff, false);

    Nbnxm::GridSet gridSet(
            PbcType::Xyz, false, nullptr, nullptr, pairlistParams.pairlistType, false, numThreads, pinPolicy);

    auto pairlistSets = std::make_unique<PairlistSets>(pairlistParams, false, 0);

    auto pairSearch = std::make_unique<PairSearch>(
            PbcType::Xyz, false, nullptr, nullptr, pairlistParams.pairlistType, false, numThreads, pinPolicy);

    auto atomData = std::make_unique<nbnxn_atomdata_t>(pinPolicy,
                                                       MDLogger(),
                                                       options.kernelSetup.kernelType,
                                                       combinationRule,
                                                       system.numAtomTypes,
                                                       system.nonbondedParameters,
                                                       c_numEnergyGroups,
                                                       numThreads);

    if (options.kernelSetup.kernelType != Nbnxm::KernelType::Cpu4x4_PlainC)
    {
        // We normally only get the energy group energy accumulator when we use energy
        // groups. For this test it's convenient to have both types of accumulators,
        // so we can run one and multiple energy groups without rebuilding atomData.
        // So we manually add the single energy group accumulator here.
        for (int th = 0; th < numThreads; th++)
        {
            atomData->outputBuffer(th).accumulatorSingleEnergies =
                    std::make_unique<EnergyAccumulator<false, true>>();
        }
    }

    // Put everything together
    auto nbv = std::make_unique<nonbonded_verlet_t>(
            std::move(pairlistSets), std::move(pairSearch), std::move(atomData), options.kernelSetup, nullptr);

    GMX_RELEASE_ASSERT(!TRICLINIC(system.box), "Only rectangular unit-cells are supported here");
    const rvec lowerCorner = { 0, 0, 0 };
    const rvec upperCorner = { system.box[XX][XX], system.box[YY][YY], system.box[ZZ][ZZ] };

    const real atomDensity = system.coordinates.size() / det(system.box);

    nbv->putAtomsOnGrid(system.box,
                        0,
                        lowerCorner,
                        upperCorner,
                        nullptr,
                        { 0, int(system.coordinates.size()) },
                        atomDensity,
                        system.atomInfo,
                        system.coordinates,
                        0,
                        nullptr);

    nbv->constructPairlist(gmx::InteractionLocality::Local, system.excls, 0, nullptr);

    nbv->setAtomProperties(system.atomTypes, system.charges, system.atomInfo);

    return nbv;
}

//! Convenience typedef of the test input parameters
struct KernelInputParameters
{
    using TupleT = std::tuple<Nbnxm::KernelType, CoulombKernelType, int>;
    //! The kernel type and cluster pair layout
    Nbnxm::KernelType kernelType;
    //! The Coulomb kernel type
    CoulombKernelType coulombKernelType;
    //! The VdW interaction type
    int vdwKernelType;
    KernelInputParameters(TupleT t) :
        kernelType(std::get<0>(t)), coulombKernelType(std::get<1>(t)), vdwKernelType(std::get<2>(t))
    {
    }
};

//! Class that sets up and holds a set of N atoms and a full NxM pairlist
class NbnxmKernelTest : public ::testing::TestWithParam<KernelInputParameters>
{
public:
    NbnxmKernelTest(LJCombinationRule ljCombinationRule) : system_(ljCombinationRule) {}

    KernelOptions                       options_;
    TestSystem                          system_;
    std::unique_ptr<nonbonded_verlet_t> nbv_;
};

//! Returns the coulomb interaction type given the Coulomb kernel type
CoulombInteractionType coulombInteractionType(CoulombKernelType coulombKernelType)
{
    switch (coulombKernelType)
    {
        case CoulombKernelType::Ewald:
        case CoulombKernelType::Table:
        case CoulombKernelType::EwaldTwin:
        case CoulombKernelType::TableTwin: return CoulombInteractionType::Pme;
        case CoulombKernelType::ReactionField: return CoulombInteractionType::RF;
        default:
            GMX_RELEASE_ASSERT(false, "Unsupported CoulombKernelType");
            return CoulombInteractionType::Count;
    }
}

//! Return an interaction constants struct with members used in the benchmark set appropriately
interaction_const_t setupInteractionConst(const KernelOptions& options)
{
    t_inputrec ir;

    // The kernel selection code only use Cut and Pme
    ir.vdwtype      = (options.useLJPme ? VanDerWaalsType::Pme : VanDerWaalsType::Cut);
    ir.vdw_modifier = options.vdwModifier;
    if (options.coulombType == CoulombKernelType::EwaldTwin
        || options.coulombType == CoulombKernelType::TableTwin)
    {
        ir.rvdw = options.pairlistCutoff - 0.2;
    }
    else
    {
        ir.rvdw = options.pairlistCutoff;
    }
    ir.rvdw_switch = ir.rvdw - 0.2;
    if (ir.vdwtype == VanDerWaalsType::Pme)
    {
        GMX_RELEASE_ASSERT(options.ljPmeCombinationRule == LongRangeVdW::Geom,
                           "The SIMD kernels, used to generate the reference data, only support "
                           "geometric LJ-PME");

        ir.ljpme_combination_rule = options.ljPmeCombinationRule;
        ir.ewald_rtol_lj          = options.ewaldRTolLJ;
    }

    ir.coulombtype      = coulombInteractionType(options.coulombType);
    ir.coulomb_modifier = InteractionModifiers::PotShift;
    ir.rcoulomb         = options.pairlistCutoff;
    ir.ewald_rtol       = options.ewaldRTol;
    ir.epsilon_r        = 1;
    ir.epsilon_rf       = 0;

    gmx_mtop_t mtop;
    // Only reppow and functype[0] are used from mtop in init_interaction_const()
    mtop.ffparams.reppow = 12;
    mtop.ffparams.functype.resize(1);
    mtop.ffparams.functype[0] = F_LJ;

    interaction_const_t ic = init_interaction_const(nullptr, ir, mtop, false);
    init_interaction_const_tables(nullptr, &ic, options.pairlistCutoff, 0);

    return ic;
}

const EnumerationArray<CoulombKernelType, const char*> coulombKernelTypeName = { "ReactionField",
                                                                                 "Table",
                                                                                 "TableTwin",
                                                                                 "Ewald",
                                                                                 "EwaldTwin" };

const std::array<const char*, vdwktNR> vdwKernelTypeName = { "CutCombGeom", "CutCombLB",
                                                             "CutCombNone", "ForceSwitch",
                                                             "PotSwitch",   "EwaldCombGeom" };

/*! \brief Help GoogleTest name our test cases
 *
 * This is intended to work like a custom test-naming function that
 * would be passed as the fourth argument to INSTANTIATE_TEST_SUITE_P,
 * except that we are not using that macro for these tests. Only the
 * components of KernelInputParameters that affect the reference data
 * values affect this name.
 * name. */
std::string nameOfTest(const testing::TestParamInfo<KernelInputParameters>& info)
{
    // We give tabulated Ewald the same name as Ewald to use the same reference data
    CoulombKernelType coulombKernelType = info.param.coulombKernelType;
    switch (coulombKernelType)
    {
        case CoulombKernelType::Table: coulombKernelType = CoulombKernelType::Ewald; break;
        case CoulombKernelType::TableTwin: coulombKernelType = CoulombKernelType::EwaldTwin; break;
        default: break;
    }
    std::string testName = formatString("Coulomb%s_Vdw%s",
                                        coulombKernelTypeName[coulombKernelType],
                                        vdwKernelTypeName[info.param.vdwKernelType]);

    // Note that the returned names must be unique and may use only
    // alphanumeric ASCII characters. It's not supposed to contain
    // underscores (see the GoogleTest FAQ
    // why-should-test-suite-names-and-test-names-not-contain-underscore),
    // but doing so works for now, is likely to remain so, and makes
    // such test names much more readable.
    testName = replaceAll(testName, "-", "_");
    testName = replaceAll(testName, ".", "_");
    testName = replaceAll(testName, " ", "_");
    return testName;
}

bool isTabulated(const CoulombKernelType coulombKernelType)
{
    return coulombKernelType == CoulombKernelType::Table || coulombKernelType == CoulombKernelType::TableTwin;
}

/*! \brief Help GoogleTest name our test cases
 *
 * This is intended to work like a custom test-naming function that
 * would be passed as the fourth argument to INSTANTIATE_TEST_SUITE_P,
 * except that we are not using that macro for these tests. All
 * components of GatherInputParameters affect this name. */
std::string fullNameOfTest(const testing::TestParamInfo<KernelInputParameters>& info,
                           const std::string&                                   testName)
{
    return formatString(
            "type_%s_Tab%s_"
            "%s",
            lookup_kernel_name(info.param.kernelType),
            info.param.coulombKernelType == CoulombKernelType::Table
                            || info.param.coulombKernelType == CoulombKernelType::TableTwin
                    ? "Yes"
                    : "No",
            testName.c_str());
}

std::string makeRefDataFileName()
{
    // By default, the reference data filename is set via a call to
    // gmx::TestFileManager::getTestSpecificFileName() that queries
    // GoogleTest and gets a string that includes the return value for
    // nameOfTest(). The logic here must match that of the call to
    // ::testing::RegisterTest, so that it works as intended. In
    // particular, the name must include a "Coulomb" substring that
    // follows the name of the kernel type, so that this can be
    // removed.
    //
    // Get the info about the test
    const ::testing::TestInfo* testInfo = ::testing::UnitTest::GetInstance()->current_test_info();

    // Get the test name and prepare to remove the kernel type
    std::string testName(testInfo->name());
    auto        CoulombPos = testName.find("Coulomb");
    GMX_RELEASE_ASSERT(CoulombPos != testName.size(),
                       "Test name must include the 'Coulomb' fragment");

    // Build the complete refdata filename like
    // getTestSpecificFilename() would do it for a non-dynamical
    // parameterized test.
    std::string refDataFileName = formatString(
            "%s_%s.xml", testInfo->test_suite_name(), testName.substr(CoulombPos).c_str());
    // Use the check that the name isn't too long
    checkTestNameLength(refDataFileName);
    return refDataFileName;
}

} // namespace

/*! \brief Test case whose body checks that the NBNxM kernel produces correct output
 *
 * Normally the declaration of this class would be produced by a call
 * to a macro like TEST_P(KernelTest, WorksWith). That macro places
 * the body of the test case in the TestBody() method, which here is
 * done explicitly.
 *
 * Note that it is important to use parameters_ to access the values
 * that describe the particular test case, rather than the usual
 * GoogleTest function GetParam(), because the latter no longer
 * works. */
class NbnxmKernelTestBody : public NbnxmKernelTest
{
public:
    //! Constructor
    explicit NbnxmKernelTestBody(const KernelInputParameters& parameters) :
        NbnxmKernelTest(parameters.vdwKernelType == vdwktLJCUT_COMBGEOM
                                ? LJCombinationRule::Geometric
                                : LJCombinationRule::LorentzBerthelot),
        parameters_(parameters)
    {
    }

    //! The test parameters with which the test case was instantiated
    KernelInputParameters parameters_;

    //! The test
    void TestBody() override
    {
        options_.kernelSetup.kernelType = parameters_.kernelType;

        // Coulomb settings
        options_.kernelSetup.ewaldExclusionType = isTabulated(parameters_.coulombKernelType)
                                                          ? Nbnxm::EwaldExclusionType::Table
                                                          : Nbnxm::EwaldExclusionType::Analytical;
        options_.coulombType                    = parameters_.coulombKernelType;

        // Van der Waals settings
        switch (parameters_.vdwKernelType)
        {
            case vdwktLJCUT_COMBGEOM:
                options_.ljCombinationRule = LJCombinationRule::Geometric;
                break;
            case vdwktLJCUT_COMBLB:
                options_.ljCombinationRule = LJCombinationRule::LorentzBerthelot;
                break;
            default: options_.ljCombinationRule = LJCombinationRule::None; break;
        }
        switch (parameters_.vdwKernelType)
        {
            case vdwktLJFORCESWITCH:
                options_.vdwModifier = InteractionModifiers::ForceSwitch;
                break;
            case vdwktLJPOTSWITCH: options_.vdwModifier = InteractionModifiers::PotSwitch; break;
            default: options_.vdwModifier = InteractionModifiers::PotShift; break;
        }
        options_.useLJPme = (parameters_.vdwKernelType == vdwktLJEWALDCOMBGEOM);

        if (options_.kernelSetup.kernelType == Nbnxm::KernelType::Cpu4x4_PlainC
            && (options_.coulombType == CoulombKernelType::Ewald
                || options_.coulombType == CoulombKernelType::EwaldTwin))
        {
            // Analytical Ewald is not implemented for the plain-C kernel, skip this test
            return;
        }

        if (parameters_.vdwKernelType == vdwktLJCUT_COMBGEOM || parameters_.vdwKernelType == vdwktLJCUT_COMBLB)
        {
            // There are no combination rule versions of the plain-C kernel
            return;
        }

        nbv_ = setupNbnxmForBenchInstance(options_, system_);

        nbv_->constructPairlist(InteractionLocality::Local, system_.excls, 0, nullptr);

        const interaction_const_t ic = setupInteractionConst(options_);

        std::vector<RVec> shiftVecs(c_numShiftVectors);
        calc_shifts(system_.box, shiftVecs);

        StepWorkload stepWork;
        stepWork.computeForces = true;
        stepWork.computeEnergy = true;

        // Resize the energy output buffers to 1 to trigger the non-energy-group kernel
        nbv_->nbat().paramsDeprecated().numEnergyGroups = 1;
        nbv_->nbat().outputBuffer(0).Vvdw.resize(1);
        nbv_->nbat().outputBuffer(0).Vc.resize(1);

        // The reduction still acts on all groups pairs
        std::vector<real> vVdw(square(c_numEnergyGroups));
        std::vector<real> vCoulomb(square(c_numEnergyGroups));
        nbv_->dispatchNonbondedKernel(
                InteractionLocality::Local, ic, stepWork, enbvClearFYes, shiftVecs, vVdw, vCoulomb, nullptr);

        std::vector<RVec> forces(system_.coordinates.size(), { 0.0_real, 0.0_real, 0.0_real });
        nbv_->atomdata_add_nbat_f_to_f(AtomLocality::All, forces);

        // The reference data for double is generated with 44 accuracy bits,
        // so we should not compare with more than that accuracy
        const int  simdAccuracyBits = (GMX_DOUBLE ? std::min(GMX_SIMD_ACCURACY_BITS_DOUBLE, 44)
                                                  : std::min(GMX_SIMD_ACCURACY_BITS_SINGLE, 22));
        const real simdRealEps      = std::pow(0.5_real, simdAccuracyBits);

        TestReferenceData    refData(makeRefDataFileName());
        TestReferenceChecker forceChecker(refData.rootChecker());
        const real           forceMagnitude = 1000;
        const real           ulpTolerance   = 50;
        real                 tolerance      = forceMagnitude * simdRealEps * ulpTolerance;
        if (usingPmeOrEwald(ic.eeltype))
        {
            real ewaldRelError;
            if (isTabulated(options_.coulombType))
            {
                // The relative energy error for tables is 0.1 times the value at the cut-off.
                // We assume that for the force this factor is 1.
                ewaldRelError = options_.ewaldRTol;
            }
            else
            {
                ewaldRelError = GMX_DOUBLE ? 1e-11 : 1e-6;
            }
            const real maxEwaldPairForceError =
                    ic.epsfac * ewaldRelError * gmx::square(chargeO / ic.rcoulomb);
            // We assume that the total force error is at max 20 times that of one pair
            tolerance = std::max(tolerance, 20 * maxEwaldPairForceError);
        }
        if (ic.vdwtype == VanDerWaalsType::Pme)
        {
            const real ulpToleranceExp = 400;
            tolerance = std::max(tolerance, forceMagnitude * simdRealEps * ulpToleranceExp);
        }
        forceChecker.setDefaultTolerance(absoluteTolerance(tolerance));
        forceChecker.checkSequence(forces.begin(), forces.end(), "Forces");

        TestReferenceChecker ljEnergyChecker(refData.rootChecker());
        // Energies per atom are more accurate than forces, but there is loss
        // of precision due to summation over all atoms. The tolerance on
        // the energy turns out to be the same as on the forces.
        ljEnergyChecker.setDefaultTolerance(absoluteTolerance(tolerance));
        ljEnergyChecker.checkReal(vVdw[0], "VdW energy");
        TestReferenceChecker coulombEnergyChecker(refData.rootChecker());
        // Coulomb energy errors are higher
        coulombEnergyChecker.setDefaultTolerance(absoluteTolerance(10 * tolerance));
        coulombEnergyChecker.checkReal(vCoulomb[0], "Coulomb energy");

        // Now call the force only kernel
        stepWork.computeEnergy = false;

        nbv_->dispatchNonbondedKernel(
                InteractionLocality::Local, ic, stepWork, enbvClearFYes, shiftVecs, vVdw, vCoulomb, nullptr);

        std::vector<RVec> forces2(system_.coordinates.size(), { 0.0_real, 0.0_real, 0.0_real });
        nbv_->atomdata_add_nbat_f_to_f(AtomLocality::All, forces2);

        // Compare the forces to the forces computed with energies
        FloatingPointTolerance forcesOnlyTolerance(relativeToleranceAsUlp(1000.0, 10));

        for (int i = 0; i < gmx::ssize(forces); i++)
        {
            for (int d = 0; d < DIM; d++)
            {
                EXPECT_REAL_EQ_TOL(forces2[i][d], forces[i][d], forcesOnlyTolerance);
            }
        }

        // Now call the energy group pair kernel
        nbv_->nbat().paramsDeprecated().numEnergyGroups = c_numEnergyGroups;
        nbv_->nbat().outputBuffer(0).Vvdw.resize(square(c_numEnergyGroups));
        nbv_->nbat().outputBuffer(0).Vc.resize(square(c_numEnergyGroups));
        stepWork.computeEnergy = true;

        std::vector<real> vVdwGrps(gmx::square(c_numEnergyGroups));
        std::vector<real> vCoulombGrps(gmx::square(c_numEnergyGroups));
        nbv_->dispatchNonbondedKernel(
                InteractionLocality::Local, ic, stepWork, enbvClearFYes, shiftVecs, vVdwGrps, vCoulombGrps, nullptr);

        std::vector<RVec> forces3(system_.coordinates.size(), { 0.0_real, 0.0_real, 0.0_real });
        nbv_->atomdata_add_nbat_f_to_f(AtomLocality::All, forces3);

        for (int i = 0; i < gmx::ssize(forces); i++)
        {
            for (int d = 0; d < DIM; d++)
            {
                EXPECT_REAL_EQ_TOL(forces3[i][d], forces[i][d], forcesOnlyTolerance);
            }
        }

        ljEnergyChecker.checkSequence(vVdwGrps.begin(), vVdwGrps.end(), "VdW group pair energy");
        coulombEnergyChecker.checkSequence(
                vCoulombGrps.begin(), vCoulombGrps.end(), "Coulomb group pair energy");

        // Cross check the sum of group energies with the total energies
        real vVdwGrpsSum     = 0;
        real vCoulombGrpsSum = 0;
        for (int gg = 0; gg < gmx::ssize(vVdwGrps); gg++)
        {
            vVdwGrpsSum += vVdwGrps[gg];
            vCoulombGrpsSum += vCoulombGrps[gg];
        }
        EXPECT_REAL_EQ_TOL(vVdwGrpsSum, vVdw[0], absoluteTolerance(tolerance));
        EXPECT_REAL_EQ_TOL(vCoulombGrpsSum, vCoulomb[0], absoluteTolerance(10 * tolerance));
    }
};

#if GENERATE_REFERENCE_DATA
// The plain-C kernels only support tabulated Ewald.
// To get high accuracy in the reference data, we use SIMD kernels.
#    if GMX_HAVE_NBNXM_SIMD_4XM
const auto testKernelTypes = ::testing::Values(Nbnxm::KernelType::Cpu4xN_Simd_4xN);
#    else
#        if !GMX_HAVE_NBNXM_SIMD_2XMM
#            error "We need SIMD kernels for generating reference data"
#        else
const auto testKernelTypes = ::testing::Values(Nbnxm::KernelType::Cpu4xN_Simd_2xNN);
#        endif
#    endif
#else // GENERATE_REFERENCE_DATA
const auto testKernelTypes = ::testing::Values(Nbnxm::KernelType::Cpu4x4_PlainC
#    if GMX_HAVE_NBNXM_SIMD_4XM
                                               ,
                                               Nbnxm::KernelType::Cpu4xN_Simd_4xN
#    endif
#    if GMX_HAVE_NBNXM_SIMD_2XMM
                                               ,
                                               Nbnxm::KernelType::Cpu4xN_Simd_2xNN
#    endif
);
#endif // GENERATE_REFERENCE_DATA

/* Note that which tests are registered is determined at compile time, not dynamically.
 * The dynamic registration mechanism is only used to be able to call registerTests()
 * so we can supply different names for the test and the string used for the reference
 * data. This enables tests to share reference data.
 */
void registerTestsDynamically()
{
    // Form the Cartesian product of all test values we might check
    const auto testCombinations = testing::ConvertGenerator<KernelInputParameters::TupleT>(
            ::testing::Combine(testKernelTypes,
                               ::testing::Values(CoulombKernelType::ReactionField,
                                                 CoulombKernelType::Ewald,
                                                 CoulombKernelType::EwaldTwin
#if !GENERATE_REFERENCE_DATA
                                                 ,
                                                 CoulombKernelType::Table,
                                                 CoulombKernelType::TableTwin
#endif
                                                 ),
                               ::testing::Values(static_cast<int>(vdwktLJCUT_COMBGEOM),
                                                 static_cast<int>(vdwktLJCUT_COMBLB),
                                                 static_cast<int>(vdwktLJCUT_COMBNONE),
                                                 static_cast<int>(vdwktLJFORCESWITCH),
                                                 static_cast<int>(vdwktLJPOTSWITCH),
                                                 static_cast<int>(vdwktLJEWALDCOMBGEOM))));

    registerTests<NbnxmKernelTest, NbnxmKernelTestBody, decltype(testCombinations)>(
            "NbnxmKernelTest", nameOfTest, fullNameOfTest, testCombinations);
}

} // namespace test

} // namespace gmx
