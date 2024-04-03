#include "gromacs/tools/dump/strategies/dump_strategy_yaml.h"

bool YamlStrategy::available(const void* p, const char* title) {
    if (!p) {
        componentsStack.top()->printKeyValue(title, "Not available");
    }
    return (p != nullptr);
}

void YamlStrategy::pr_filename(const char* filename) {
    componentsStack.top()->printKeyValue("file", filename);
}

void YamlStrategy::pr_title(const char* title) {
    YamlComponent* comp = componentsStack.top()->addYamlObject(title);
    componentsStack.push(comp);
}

void YamlStrategy::pr_title_i(const char* title, int i) {
    std::string n_title;
    n_title += title;
    n_title += " ";
    n_title += std::to_string(i);
    YamlComponent* comp = componentsStack.top()->addYamlObject(n_title);
    componentsStack.push(comp);
}

void YamlStrategy::pr_title_n(const char* title, int n) {
    std::string n_title;
    n_title += title;
    n_title += " (";
    n_title += std::to_string(n);
    n_title += ")";
    YamlComponent* comp = componentsStack.top()->addYamlObject(n_title);
    componentsStack.push(comp);
}

void YamlStrategy::pr_title_nxn(const char* title, int n1, int n2) {
    std::string nxn_title;
    nxn_title += title;
    nxn_title += " (";
    nxn_title += std::to_string(n1);
    nxn_title += "x";
    nxn_title += std::to_string(n2);
    nxn_title += ")";
    YamlComponent* comp = componentsStack.top()->addYamlObject(nxn_title);
    componentsStack.push(comp);
}

void YamlStrategy::close_section() {
    componentsStack.pop();
}

void YamlStrategy::pr_named_value(const char* name, const Value& value) {
    componentsStack.top()->printKeyValue(name, value);
}
    
void YamlStrategy::pr_attribute(const char* name, const Value& value)
{
}

void YamlStrategy::pr_attribute_quoted(const char* name, const std::string& value)
{
}

void YamlStrategy::pr_vec_attributes(const char* title, int i, const char** names, char** values, int n)
{
}

void YamlStrategy::pr_ivec(const char* title, const int vec[], int n)
{
}

void YamlStrategy::pr_ivec_row(const char* title, const int vec[], int n)
{
}
    
void YamlStrategy::pr_ivecs(const char* title, const ivec vec[], int n)
{
}

void YamlStrategy::pr_ivec_block(const char* title, const int vec[], int n)
{
}

void YamlStrategy::pr_rvec(const char* title, const real vec[], int n) {
    if (available(vec, title)) {
        pr_title_n(title, n);
        YamlComponent* comp = componentsStack.top();
        for (int i = 0; i < n; i++) {
            std::string cord_title;
            cord_title += "x";
            cord_title += std::to_string(i);
            comp->printKeyValue(cord_title.c_str(), vec[i]);
            // fprintf(fp, "%s[%d]=%12.5e\n", title, bShowNumbers ? i : -1, vec[i]);
        }
        componentsStack.pop();
    }
}

void YamlStrategy::pr_rvec_row(const char* title, const real vec[], int n)
{
}

void YamlStrategy::pr_dvec_row(const char* title, const double vec[], int n)
{
}

void YamlStrategy::pr_svec_row(const char* title, const char* vec[], int n)
{
}

void YamlStrategy::pr_rvecs(const char* title, const rvec vec[], int n) {
    const char* fshort = "%12.5e";
    const char* flong  = "%15.8e";
    const char* format = (getenv("GMX_PRINT_LONGFORMAT") != nullptr) ? flong : fshort;
    int         i, j;

    if (available(vec, title)) {
        pr_title_nxn(title, n, DIM);

        for (i = 0; i < n; i++) {
            for (j = 0; j < DIM; j++) {
                std::string cord_title;
                cord_title += "x";
                cord_title += std::to_string(i);
                cord_title += "_";
                cord_title += "y";
                cord_title += std::to_string(j);
                pr_named_value(cord_title.c_str(), vec[i][j]);
            }
        }

        componentsStack.pop();
    }
}

void YamlStrategy::pr_matrix(const char* title, const rvec* m) {
    if (bMDPformat) {
        pr_title(title);
        pr_named_value("x_x", m[XX][XX]);
        pr_named_value("y_y", m[YY][YY]);
        pr_named_value("z_z", m[ZZ][ZZ]);
        pr_named_value("x_y", m[XX][YY]);
        pr_named_value("x_z", m[XX][ZZ]);
        pr_named_value("y_z", m[YY][ZZ]);
        componentsStack.pop();
    } else {
        pr_rvecs(title, m, DIM);
    }
}

void YamlStrategy::pr_kvtree(const gmx::KeyValueTreeObject kvTree)
{
}

void YamlStrategy::pr_tpx_header(const TpxFileHeader* sh)
{
}
