#!/bin/bash
crms=ALL_150.CRM_count_*.crm



for crm in ${crms}
do
    pbs="run_exrtact_cre_"${crm}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python extract_binding_sites.py ${crm}" >> ${pbs}
    #qsub ${pbs}



    pbs="run_count_crm_"${crm}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python count_total_bp.py  ${crm}" >> ${pbs}
    #qsub ${pbs}

    pbs="run_extract_crm_length_"${crm}".pbs"
    echo -e ${pbs_header} > ${pbs}
    echo -e "python extract_crm_length.py ${crm}" >> ${pbs}
    qsub ${pbs}
done
