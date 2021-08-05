#!/bin/bash

for j in {1..50}
do
covar_list="${covar_list},PC${j}"
done
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Jobs
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Errors
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Outs
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Texts
cat > /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/chronic_back_pain_SAIGE_Step_1.job << EOT
#!/bin/bash
#SBATCH --job-name=chronic_back_pain_SAIGE_Step_1.job
#SBATCH --mail-user=loveni.hanumunthadu@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH -n 32
#SBATCH -N 1
#SBATCH --mem=8G
#SBATCH -t 24:00:00
#SBATCH -A def-audginny
#SBATCH -e /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Errors/chronic_back_pain_SAIGE_Step_1.error
#SBATCH -o /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Outs/chronic_back_pain_SAIGE_Step_1.out
date
export MUGQIC_INSTALL_HOME=/cvmfs/soft.mugqic/CentOS6
module use $MUGQIC_INSTALL_HOME/modulefiles
module load mugqic/R_Bioconductor/3.6.0_3.9
			
/cvmfs/soft.mugqic/CentOS6/software/R_Bioconductor/R_Bioconductor-3.6.0_3.9/lib/R/bin/Rscript /project/6048803/SAIGE/SAIGE-0.35.8.3/extdata/step1_fitNULLGLMM.R \
--plinkFile=/lustre03/project/6048803/peterher/CLSA/DATA/CLSA_EUR_AUTO/CLSA_EUR_AUTO \
--sampleIDColinphenoFile=ID \
--outputPrefix=/home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Texts/chronic_back_pain_SAIGE_Step_1 \
--phenoFile=/home/loveni9/projects/def-audginny/loveni9/CLSA/DATA/Merged_pheno_covar_table.tsv \
--phenoCol=ANY_C_BP \
--covarColList=${covar_list},age_COM,sex_COM \
--traitType=binary \
--nThreads=16 \
--LOCO=FALSE

date
EOT