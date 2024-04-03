#ifndef GMX_TOOLS_DUMP_COMPONENT_IPARAMS_H
#define GMX_TOOLS_DUMP_COMPONENT_IPARAMS_H

#include <vector>
#include <variant>
#include <string>

#include "gromacs/topology/idef.h"
#include "gromacs/utility/fatalerror.h"

#include "gromacs/tools/dump/dump_settings.h"

struct KeyFormatValue {
    const char* key;
    const char* format;
    const Value value;

    KeyFormatValue(const char* k, const char* f, const Value v)
        : key(k), format(f), value(v) {}
};

// TODO: as component that takes function that prints this

std::vector<KeyFormatValue> getInteractionParameters(t_functype ftype, const t_iparams &iparams);

#endif
