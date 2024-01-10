#include "gromacs/tools/dump_text_components.h"

void TextDumpComponent::printValue(const Value& value) {
    if (std::holds_alternative<int>(value)) {
        fprintf(fp, "%d", std::get<int>(value));
    } else if (std::holds_alternative<double>(value)) {
        fprintf(fp, "%f", std::get<double>(value));
    } else if (std::holds_alternative<std::string>(value)) {
        fprintf(fp, "%s", std::get<std::string>(value).c_str());
    } else if (std::holds_alternative<int64_t>(value)) {
        char buf[STEPSTRSIZE];
        fprintf(fp, "%s", gmx_step_str(std::get<int64_t>(value), buf));
    } else if (std::holds_alternative<real>(value)) {
        fprintf(fp, "%g", std::get<real>(value));
    }
}

TextObjectComponent* TextDumpComponent::addTextSection(const std::string& name) {
    return new TextObjectComponent(fp, indent, name);
}

TextObjectComponent* TextDumpComponent::addTextObject(const std::string& name) {
    return new TextObjectComponent(fp, indent + INDENT, name);
}

TextObjectComponent* TextDumpComponent::addTextObject(const char* format, ...) {
    va_list args;
    va_start(args, format);
    
    TextObjectComponent* object = new TextObjectComponent(fp, indent + INDENT, format, args);
    
    va_end(args);

    return object;
}

TextArrayComponent* TextDumpComponent::addTextArray(const std::string& name) {
    return new TextArrayComponent(fp, indent + INDENT, name);
}

void TextDumpComponent::addTextLeaf(const std::string& key, const Value& value) {
    fprintf(fp, "\n%*s%-30s= ", indent + INDENT, "", key.c_str());
    printValue(value);
}

void TextDumpComponent::addTextLeaf(const Value& value) {
    fprintf(fp, "\n%*s", indent + INDENT, "");
    printValue(value);
}
    
void TextDumpComponent::addTextVectorLeaf(const float values[3], int size) {
    const char* fshort = "%12.5e";
    fprintf(fp, "{ ");
    for (int i = 0; i < size - 1; i++) {
        printValue(values[i]);
        fprintf(fp, ", ");
    }
    printValue(values[size - 1]);
    fprintf(fp, "}");
}

void TextDumpComponent::addFormattedTextLeaf(const char* format, ...) {
    fprintf(fp, "\n%*s", indent + INDENT, "");

    va_list args;
    va_start(args, format);
    
    vfprintf(fp, format, args);
    
    va_end(args);
}
