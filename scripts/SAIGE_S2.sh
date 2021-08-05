#!/bin/bash
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Jobs
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Errors
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Outs
mkdir /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Texts
for i in {1..22}
do
cat > /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Jobs/chronic_back_pain_SAIGE_Step_2_chr${i}.job << EOT
#!/bin/bash
#SBATCH --job-name=chronic_back_pain_SAIGE_Step_2_chr${i}.job
#SBATCH -n 32
#SBATCH -N 1
#SBATCH --mem=2G
#SBATCH -t 24:00:00
#SBATCH -A def-audginny
#SBATCH -e /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Errors/chronic_back_pain_SAIGE_Step_2_chr${i}.error
#SBATCH -o /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Outs/chronic_back_pain_SAIGE_Step_2_chr${i}.out
date
export MUGQIC_INSTALL_HOME=/cvmfs/soft.mugqic/CentOS6
module use $MUGQIC_INSTALL_HOME/modulefiles
module load mugqic/R_Bioconductor/3.6.0_3.9
/cvmfs/soft.mugqic/CentOS6/software/R_Bioconductor/R_Bioconductor-3.6.0_3.9/lib/R/bin/Rscript /home/loveni9/projects/def-audginny/SAIGE/SAIGE-0.35.8.3/extdata/step2_SPAtests.R \
--minMAF=0 \
--minMAC=1 \
--bgenFile=/lustre03/project/6007297/clsa/raw/190213_McGill_LDiatchenko_DEC2020/Genomics3_clsa/Genomics3_clsa/clsa_imp_${i}_v3.bgen \
--bgenFileIndex=/lustre03/project/6007297/clsa/raw/190213_McGill_LDiatchenko_DEC2020/Genomics3_clsa/Genomics3_clsa/clsa_imp_${i}_v3.bgen.bgi \
--sampleFile=/lustre03/project/6048803/loveni9/CLSA/DATA/clsa_imp_v3_new.sample \
--GMMATmodelFile=/home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Texts/chronic_back_pain_SAIGE_Step_1.rda \
--varianceRatioFile=/home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_1/Texts/chronic_back_pain_SAIGE_Step_1.varianceRatio.txt \
--SAIGEOutputFile=/home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Texts/chronic_back_pain_SAIGE_Step_2_chr${i}.txt \
--numLinesOutput=2 \
--IsDropMissingDosages=FALSE \
--LOCO=FALSE   
date
EOT
sbatch /home/loveni9/projects/def-audginny/loveni9/Job_launch/SAIGE/Step_2/Jobs/chronic_back_pain_SAIGE_Step_2_chr${i}.job
done