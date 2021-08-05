for j in {1..50}
do
covar_list="${covar_list},PC${j}"
done
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW/Jobs_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW/Errors_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW/Outs_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW/Texts_NEW
cat > /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW/Jobs_NEW/chronic_back_pain_SAIGE_NEW_Step_1.job << EOT
#!/bin/bash
#SBATCH --job-name=chronic_back_pain_SAIGE_NEW_Step_1.job
#SBATCH -n 32
#SBATCH -N 1
#SBATCH --mem=8G
#SBATCH -t 12:00:00
#SBATCH -A def-audginny
#SBATCH -e /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW/Errors_NEW/chronic_back_pain_SAIGE_NEW_Step_1.error
#SBATCH -o /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_1_NEW/Outs_NEW/chronic_back_pain_SAIGE_NEW_Step_1.out
date

module load singularity
export MUGQIC_INSTALL_HOME=/cvmfs/soft.mugqic/CentOS6
module use $MUGQIC_INSTALL_HOME/modulefiles
module load mugqic/R_Bioconductor/3.6.0_3.9

singularity run -B /home/loveni9/projects/def-audginny/loveni9:/mnt/myinput /home/loveni9/projects/def-audginny/loveni9/saige.sif Rscript /usr/local/bin/step1_fitNULLGLMM.R \
--plinkFile=/mnt/myinput/CLSA/DATA/CLSA_EUR_AUTO \
--sampleIDColinphenoFile=ID \
--outputPrefix=/mnt/myinput/SAIGE_NEW/Step_1_NEW/Texts_NEW/chronic_back_pain_SAIGE_NEW_Step_1 \
--phenoFile=/mnt/myinput/CLSA/DATA/Merged_pheno_covar_table.tsv \
--phenoCol=ANY_C_BP \
--covarColList=PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,PC26,PC27,PC28,PC29,PC30,PC31,PC32,PC33,PC34,PC35,PC36,PC37,PC38,PC39,PC40,PC41,PC42,PC43,PC44,PC45,PC46,PC47,PC48,PC49,PC50,age_COM,sex_COM \
--traitType=binary \
--nThreads=16 \
--IsOverwriteVarianceRatioFile=FALSE \
--LOCO=FALSE \
--minMAFforGRM=0.01 \
--minCovariateCount=-1 \
--includeNonautoMarkersforVarRatio=FALSE \

date
EOT
