#!/bin/bash 

source ../zero_shot_config.sh
source activate prosst

export model_checkpoint="/scratch/project/open-35-8/antonb/models/esm2_t12_35M_UR50D.pt"
export dms_output_folder=${DMS_output_score_folder_subs}/ESM2-35M-ProteinTTT 
export protein_ttt_cfg=${PROTEINGYM_CACHE}/proteinttt_configs/ESM2-35M.yaml

## Regression weights are at: https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt
#https://dl.fbaipublicfiles.com/fair-esm/regression/esm2_t33_650M_UR50S-contact-regression.pt

export model_type="ESM2"
export scoring_strategy="masked-marginals"
for DMS_index in $(seq 1 217); do  # Loop over all experiment indices
    python ../../proteingym/baselines/esm/compute_fitness.py \
        --model-location ${model_checkpoint} \
        --dms_index $DMS_index \
        --dms_mapping ${DMS_reference_file_path_subs} \
        --dms-input ${DMS_data_folder_subs} \
        --dms-output ${dms_output_folder} \
        --scoring-strategy ${scoring_strategy} \
        --model_type ${model_type} \
        --proteinttt_cfg ${protein_ttt_cfg}
done