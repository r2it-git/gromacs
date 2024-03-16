#include "gromacs/tools/dump/components/dump_components_text.h"

void TextDumpComponent::printValue(const Value& value) {
    if (std::holds_alternative<int>(value)) {
        fprintf(fp, "%d", std::get<int>(value));
    } else if (std::holds_alternative<long unsigned int>(value)) {
        fprintf(fp, "%ld", std::get<long unsigned int>(value));
    } else if (std::holds_alternative<double>(value)) {
        fprintf(fp, "%g", std::get<double>(value));
    } else if (std::holds_alternative<std::string>(value)) {
        fprintf(fp, "%s", std::get<std::string>(value).c_str());
    } else if (std::holds_alternative<int64_t>(value)) {
        char buf[STEPSTRSIZE];
        fprintf(fp, "%s", gmx_step_str(std::get<int64_t>(value), buf));
    } else if (std::holds_alternative<real>(value)) {
        fprintf(fp, "%g", std::get<real>(value));
    }
}

void TextDumpComponent::printFilename(const std::string& filename)
{
    fprintf(fp, "%s:", filename.c_str());
}

void TextDumpComponent::printFormattedText(const char* format, ...) {
    va_list args;
    va_start(args, format);
    
    vfprintf(fp, format, args);
    
    va_end(args);
}

TextDumpComponent* TextDumpComponent::addEmptySection()
{
    return new TextDumpComponent(fp, indent + indentValue);
}

TextObjectComponent* TextDumpComponent::addTextSection(const std::string& name) {
    fprintf(fp, "\n%*s%s:", indent, "", name.c_str());
    return (TextObjectComponent*) this;
}

TextObjectComponent* TextDumpComponent::addTextObject(const std::string& name) {
    return new TextObjectComponent(fp, indent, name);
}

TextObjectComponent* TextDumpComponent::addTextObject(const std::string& name, int index) {
    return new TextObjectComponent(fp, indent, name, index);
}

TextObjectComponent* TextDumpComponent::addTextObject(const char* format, ...) {
    va_list args;
    va_start(args, format);
    
    TextObjectComponent* object = new TextObjectComponent(fp, indent, format, args);
    
    va_end(args);

    return object;
}

TextArrayComponent* TextDumpComponent::addTextArray(const std::string& name) {
    return new TextArrayComponent(fp, indent, name);
}

void TextDumpComponent::addTextLeaf(const std::string& key, const Value& value) {
    fprintf(fp, "\n%*s%-30s = ", indent, "", key.c_str());
    printValue(value);
}

void TextDumpComponent::addTextLeaf(const Value& value) {
    fprintf(fp, "\n%*s", indent, "");
    printValue(value);
}

void TextDumpComponent::addAlignedTextLeaf(const std::string& key, const Value& value, int align) {
    fprintf(fp, "\n%*s%-*s = ", indent, "", align, key.c_str());
    printValue(value);
}
    
void TextDumpComponent::addTextVectorLeaf(const float values[3], int size) {
    const char* fshort = "%12.5e";
    fprintf(fp, "{");
    for (int i = 0; i < size - 1; i++) {
        fprintf(fp, fshort, values[i]);
        fprintf(fp, ", ");
    }
    fprintf(fp, fshort, values[size - 1]);
    fprintf(fp, "}");
}

void TextDumpComponent::addFormattedTextLeaf(const char* format, ...) {
    fprintf(fp, "\n%*s", indent, "");

    va_list args;
    va_start(args, format);
    
    vfprintf(fp, format, args);
    
    va_end(args);
}

void TextDumpComponent::addGroupStats(gmx::EnumerationArray<SimulationAtomGroupType, std::vector<int>>* gcount)
{
    int atot;
    fprintf(fp, "\nGroup statistics\n");
    for (auto group : keysOf(*gcount))
    {
        atot = 0;
        fprintf(fp, "%-12s: ", shortName(group));
        for (const auto& entry : (*gcount)[group])
        {
            fprintf(fp, "  %5d", entry);
            atot += entry;
        }
        fprintf(fp, "  (total %d atoms)\n", atot);
    }
}

void TextDumpComponent::addAttribute(const char* name, const Value& value)
{
    fprintf(fp, "\n%*s%s=", indent, "", name);
    printValue(value);
}

void TextDumpComponent::printList(const char* title, int index, const gmx::ArrayRef<const int> list)
{
    // TODO: show numbers
    bool bShowNumbers = true;
    if (list.empty())
    {
        fprintf(fp, "\n%*s%s[%d]={}", indent, "", title, index);
        return;
    }

    int size = fprintf(fp, "\n%*s%s[%d][num=%zu]={", indent, "", title, bShowNumbers ? index : -1, list.size()) - 1;

    bool isFirst = true;
    for (const int item : list)
    {
        if (!isFirst)
        {
            size += fprintf(fp, ", ");
        }
        if ((size) > (USE_WIDTH))
        {
            fprintf(fp, "\n");
            size = fprintf(fp, "%*s", indent + indentValue, "");
        }
        size += fprintf(fp, "%d", item);
        isFirst = false;
    }
    fprintf(fp, "}");
        // if (list.empty())
        // {
        //     size += fprintf(fp, "%s[%d]={", title, int(i));
        // }
        // else
        // {
        //     size += fprintf(fp, "%s[%d][num=%zu]={", title, bShowNumbers ? int(i) : -1, list.size());
        // }
        // bool isFirst = true;
        // for (const int j : list)
        // {
        //     if (!isFirst)
        //     {
        //         size += fprintf(fp, ", ");
        //     }
        //     if ((size) > (USE_WIDTH))
        //     {
        //         fprintf(fp, "\n");
        //         size = pr_indent(fp, indent + INDENT);
        //     }
        //     size += fprintf(fp, "%d", j);
        //     isFirst = false;
        // }
        // fprintf(fp, "}\n");
}