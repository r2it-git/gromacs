#include "moltype.h"

void MoltypeBuilder::build(DumpStrategy* strategy)
{
    strategy->pr_title_i("moltype", index);
    strategy->pr_attribute_quoted("name", *(moltype->name));
    AtomsBuilder(&(moltype->atoms)).build(strategy);
    ListOfListsBuilder("excls", moltype->excls).build(strategy);
    for (int i = 0; (i < F_NRE); i++)
    {
        strategy->pr_interaction_list(
            interaction_function[i].longname,
            ffparams.functype.data(),
            moltype->ilist[i],
            ffparams.iparams.data()
        );
    }
    strategy->close_section();
}
