/*
 * This file is part of the GROMACS molecular simulation package.
 *
 * Copyright 1991- The GROMACS Authors
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
/*! \file
 * \libinternal \brief
 * Methods to modify atoms during preprocessing.
 */
#ifndef GMX_GMXPREPROCESS_HACKBLOCK_H
#define GMX_GMXPREPROCESS_HACKBLOCK_H

#include <cstdio>

#include <array>
#include <string>
#include <vector>

#include "gromacs/gmxpreprocess/notset.h"
#include "gromacs/topology/ifunc.h"
#include "gromacs/utility/enumerationhelpers.h"

struct t_atom;
struct t_symtab;

namespace gmx
{
template<typename>
class ArrayRef;
}

/*! \brief
 * Used for reading .rtp/.tdb
 * BondedTypes::Bonds must be the first, new types can be added to the end
 * these *MUST* correspond to the arrays in hackblock.cpp
 */
enum class BondedTypes : int
{
    Bonds,
    Angles,
    ProperDihedrals,
    ImproperDihedrals,
    Exclusions,
    Cmap,
    Count
};
//! Names for interaction type entries
const char* enumValueToString(BondedTypes enumValue);
//! Numbers for atoms in the interactions.
int enumValueToNumIAtoms(BondedTypes enumValue);

/* if changing any of these structs, make sure that all of the
   free/clear/copy/merge_t_* functions stay updated */

/*! \libinternal \brief
 * Information about single bonded interaction.
 */
struct BondedInteraction
{
    //! Atom names in the bond.
    std::array<std::string, MAXATOMLIST> a;
    /*! \brief
     * Optional define string which gets copied from
     * .rtp/.tdb to .top and will be parsed by cpp
     * during grompp.
     */
    std::string s;
    //! Has the entry been found?
    bool match = false;
    //! Get name of first atom in bonded interaction.
    const std::string& ai() const { return a[0]; }
    //! Get name of second atom in bonded interaction..
    const std::string& aj() const { return a[1]; }
    //! Get name of third atom in bonded interaction.
    const std::string& ak() const { return a[2]; }
    //! Get name of fourth atom in bonded interaction.
    const std::string& al() const { return a[3]; }
    //! Get name of fifth atom in bonded interaction.
    const std::string& am() const { return a[4]; }
};

/*! \libinternal \brief
 * Accumulation of different bonded types for preprocessing.
 * \todo This should be merged with BondedInteraction.
 */
struct BondedInteractionList
{
    //! The type of bonded interaction.
    int type = -1;
    //! The actual bonded interactions.
    std::vector<BondedInteraction> b;
};

/*! \libinternal \brief
 * Information about preprocessing residues.
 */
struct PreprocessResidue
{
    //! Name of the residue.
    std::string resname;
    //! The base file name this rtp entry was read from.
    std::string filebase;
    //! Atom data.
    std::vector<t_atom> atom;
    //! Atom names.
    std::vector<char**> atomname;
    //! Charge group numbers.
    std::vector<int> cgnr;
    //! Delete autogenerated dihedrals or not.
    bool bKeepAllGeneratedDihedrals = false;
    //! Number of bonded exclusions.
    int nrexcl = -1;
    //! If Hydrogen only 1-4 interactions should be generated.
    bool bGenerateHH14Interactions = false;
    //! Delete dihedrals also defined by impropers.
    bool bRemoveDihedralIfWithImproper = false;
    //! List of bonded interactions to potentially add.
    gmx::EnumerationArray<BondedTypes, BondedInteractionList> rb;
    //! Get number of atoms in residue.
    int natom() const;
};

//! Declare different types of hacks for later check.
enum class MoleculePatchType
{
    //! Hack adds atom to structure/rtp.
    Add,
    //! Hack deletes atom.
    Delete,
    //! Hack replaces atom.
    Replace
};

/*! \libinternal \brief
 * Block to modify individual residues
 */
struct MoleculePatch
{
    //! Number of new are deleted atoms. NOT always equal to atom.size()!
    int nr;
    //! Old name for entry.
    std::string oname;
    //! New name for entry.
    std::string nname;
    //! New atom data.
    std::vector<t_atom> atom;
    //! Chargegroup number.
    int cgnr = NOTSET;
    //! Type of attachment.
    int tp = 0;
    //! Number of control atoms.
    int nctl = 0;
    //! Name of control atoms.
    std::array<std::string, 4> a;
    //! Is an atom to be hacked already present?
    bool bAlreadyPresent = false;
    //! Are coordinates for a new atom already set?
    bool bXSet = false;
    //! New position for hacked atom.
    rvec newx = { NOTSET };

    /*! \brief
     * Get type of hack.
     *
     * This depends on the setting of oname and nname
     * for legacy reasons. If oname is empty, we are adding,
     * if oname is set and nname is empty, an atom is deleted,
     * if both are set replacement is going on. If both are unset,
     * an error is thrown.
     */
    MoleculePatchType type() const;

    //! Control atom i name.
    const std::string& ai() const { return a[0]; }
    //! Control atom j name.
    const std::string& aj() const { return a[1]; }
    //! Control atom k name.
    const std::string& ak() const { return a[2]; }
    //! Control atom l name.
    const std::string& al() const { return a[3]; }
};
/*! \libinternal \brief
 * A set of modifications to apply to atoms.
 */
struct MoleculePatchDatabase
{
    //! Name of block
    std::string name;
    //! File that entry was read from.
    std::string filebase;
    //! List of changes to atoms.
    std::vector<MoleculePatch> hack;
    //! List of bonded interactions to potentially add.
    gmx::EnumerationArray<BondedTypes, BondedInteractionList> rb;
    //! Number of atoms to modify
    int nhack() const { return hack.size(); }
};

/*!\brief
 * Reset modification block.
 *
 * \param[inout] globalPatches Block to reset.
 * \todo Remove once constructor/destructor takes care of all of this.
 */
void clearModificationBlock(MoleculePatchDatabase* globalPatches);

/*!\brief
 * Copy residue information.
 *
 * \param[in] s Source information.
 * \param[in] d Destination to copy to.
 * \param[inout] symtab Symbol table for names.
 * \todo Remove once copy can be done directly.
 */
void copyPreprocessResidues(const PreprocessResidue& s, PreprocessResidue* d, t_symtab* symtab);

/*! \brief
 * Add bond information in \p s to \p d.
 *
 * \param[in] s Source information to copy.
 * \param[inout] d Destination to copy to.
 * \param[in] bMin don't copy bondeds with atoms starting with '-'.
 * \param[in] bPlus don't copy bondeds with atoms starting with '+'.
 * \returns if bonds were removed at the termini.
 */
bool mergeBondedInteractionList(gmx::ArrayRef<const BondedInteractionList> s,
                                gmx::ArrayRef<BondedInteractionList>       d,
                                bool                                       bMin,
                                bool                                       bPlus);

/*! \brief
 * Copy all information from datastructure.
 *
 * \param[in] s Source information.
 * \param[inout] d Destination to copy to.
 */
void copyModificationBlocks(const MoleculePatchDatabase& s, MoleculePatchDatabase* d);

/*!\brief
 * Add the individual modifications in \p s to \p d.
 *
 * \param[in] s Source information.
 * \param[inout] d Destination to copy to.
 */
void mergeAtomModifications(const MoleculePatchDatabase& s, MoleculePatchDatabase* d);

//! \copydoc mergeAtomModifications
void mergeAtomAndBondModifications(const MoleculePatchDatabase& s, MoleculePatchDatabase* d);

#endif
