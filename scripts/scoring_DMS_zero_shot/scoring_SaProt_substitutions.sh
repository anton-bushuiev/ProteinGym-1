#!/bin/bash
#SBATCH --account=open-35-8
#SBATCH --job-name=scoring_SaProt_substitutions
#SBATCH --output=scoring_SaProt_substitutions.out
#SBATCH --error=scoring_SaProt_substitutions.err
#SBATCH --time=24:00:00
#SBATCH --partition=qgpu
#SBATCH --nodes=1
#SBATCH --gpus=1

cd ${WORK}/ttt/ProteinGym-ProteinTTT/scripts/scoring_DMS_zero_shot

eval "$(conda shell.bash hook)"
conda activate SaProt

# 1. Dataset config

# source ../zero_shot_config.sh
source ../zero_shot_config_priority_viruses.sh
# source ../zero_shot_config_priority_viruses_who.sh

# 2. Model config

# export SaProt_model_path="/scratch/project/open-35-8/antonb/models/SaProt_35M_AF2" #Path where you have downloaded all SaProt model/tokenizer files from the HF hub (https://huggingface.co/westlake-repl/SaProt_650M_AF2)
# export output_scores_folder="${DMS_output_score_folder_subs}/SaProt-35M"
# export foldseek_bin="/scratch/project/open-35-8/antonb/software/foldseek/bin/foldseek" #(Download from here: https://github.com/steineggerlab/foldseek?tab=readme-ov-file)
# export protein_ttt_cfg="null"

# export SaProt_model_path="/scratch/project/open-35-8/antonb/models/SaProt_650M_AF2" #Path where you have downloaded all SaProt model/tokenizer files from the HF hub (https://huggingface.co/westlake-repl/SaProt_650M_AF2)
# export output_scores_folder="${DMS_output_score_folder_subs}/SaProt-650M"
# export foldseek_bin="/scratch/project/open-35-8/antonb/software/foldseek/bin/foldseek" #(Download from here: https://github.com/steineggerlab/foldseek?tab=readme-ov-file)
# export protein_ttt_cfg="null"

# export SaProt_model_path="/scratch/project/open-35-8/antonb/models/SaProt_35M_AF2" #Path where you have downloaded all SaProt model/tokenizer files from the HF hub (https://huggingface.co/westlake-repl/SaProt_650M_AF2)
# export output_scores_folder="${DMS_output_score_folder_subs}/SaProt-35M-ProteinTTT"
# export foldseek_bin="/scratch/project/open-35-8/antonb/software/foldseek/bin/foldseek" #(Download from here: https://github.com/steineggerlab/foldseek?tab=readme-ov-file)
# export protein_ttt_cfg=${PROTEINGYM_CACHE}/proteinttt_configs/SaProt-35M.yaml

export SaProt_model_path="/scratch/project/open-35-8/antonb/models/SaProt_650M_AF2" #Path where you have downloaded all SaProt model/tokenizer files from the HF hub (https://huggingface.co/westlake-repl/SaProt_650M_AF2)
export output_scores_folder="${DMS_output_score_folder_subs}/SaProt-650M-ProteinTTT"
export foldseek_bin="/scratch/project/open-35-8/antonb/software/foldseek/bin/foldseek" #(Download from here: https://github.com/steineggerlab/foldseek?tab=readme-ov-file)
export protein_ttt_cfg=${PROTEINGYM_CACHE}/proteinttt_configs/SaProt-650M.yaml

for DMS_index in $(seq 0 216); do
    python ../../proteingym/baselines/saprot/compute_fitness.py \
        --foldseek_bin ${foldseek_bin} \
        --SaProt_model_name_or_path ${SaProt_model_path} \
        --DMS_reference_file_path ${DMS_reference_file_path_subs} \
        --DMS_data_folder ${DMS_data_folder_subs} \
        --structure_data_folder ${DMS_structure_folder} \
        --DMS_index $DMS_index \
        --output_scores_folder ${output_scores_folder} \
        --protein_ttt_cfg ${protein_ttt_cfg}
done
