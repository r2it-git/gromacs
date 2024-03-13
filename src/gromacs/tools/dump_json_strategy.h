#ifndef GMX_TOOLS_DUMP_STRATEGY_JSON_H
#define GMX_TOOLS_DUMP_STRATEGY_JSON_H

#define XX 0
#define YY 1
#define ZZ 2

#include <stack>

#include "gromacs/utility/basedefinitions.h"
#include "gromacs/utility/real.h"
#include "gromacs/tools/dump_strategy.h"
#include "gromacs/tools/dump_json_components.h"

class DumpJsonStrategy : public DumpStrategy {
private:
    std::stack<JsonDumpComponent*> componentsStack;
public:
    DumpJsonStrategy(FILE* fp) {
        JsonDumpComponent* root = new JsonRootComponent(fp);
        componentsStack.push(root);
    }

    ~DumpJsonStrategy() {
        while (componentsStack.size() > 1) {
            componentsStack.pop();
        }
        if (!componentsStack.empty()) {
            JsonDumpComponent* comp = componentsStack.top();
            componentsStack.pop();
            delete comp;
        }
    }

    bool available(const void* p, const char* title) override;
    void pr_filename(const char* filename) override;
    void pr_title(const char* title) override;
    void pr_title_i(const char* title, int i) override;
    void pr_title_n(const char* title, int n) override;
    void pr_title_nxn(const char* title, int n1, int n2) override;
    void close_section() override;
    void pr_is_present(const char* title, gmx_bool b) override;
    void pr_named_value(const char* name, const Value& value) override;
    void pr_name(const char* name) override;
    void pr_matrix(const char* title, const rvec* m, gmx_bool bMDPformat) override;
    void pr_sim_annealing(const char* title, const SimulatedAnnealing sa[], int n, gmx_bool bMDPformat) override;
    void pr_vec_row(const char* title, const Value vec[], int n, gmx_bool bShowNumbers) override;
    void pr_rvec(const char* title, const real vec[], int n, gmx_bool bShowNumbers) override;
    void pr_rvec_row(const char* title, const real vec[], int n, gmx_bool bShowNumbers) override;
    void pr_rvecs(const char* title, const rvec vec[], int n) override;
    void pr_ivec(const char* title, const int vec[], int n, gmx_bool bShowNumbers) override;
    void pr_ivec_row(const char* title, const int vec[], int n, gmx_bool bShowNumbers) override;
    void pr_ivecs(const char* title, const ivec vec[], int n) override;
    void pr_ivec_block(const char* title, const int vec[], int n, gmx_bool bShowNumbers) override;
    void pr_kvtree(const gmx::KeyValueTreeObject kvTree) override;
    void pr_grps(gmx::ArrayRef<const AtomGroupIndices> grps, const char* const* const* grpname) override;
    void pr_group_stats(gmx::EnumerationArray<SimulationAtomGroupType, std::vector<int>>* gcount) override;
    // void pr_int(const char* title, int i);
    // void pr_int64(const char* title, int64_t i);
    // void pr_real(const char* title, real r);
    // void pr_double(const char* title, double d);
    // void pr_reals(const char* title, const real vec[], int n);
    // void pr_doubles(const char* title, const double* vec, int n);
    // void pr_reals_of_dim(const char* title, const real* vec, int n, int dim);
    // void pr_strings(const char* title, const char* const* const* nm, int n, gmx_bool bShowNumbers);
};

#endif
