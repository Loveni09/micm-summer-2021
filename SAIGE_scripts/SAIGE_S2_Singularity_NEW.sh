#!/bin/bash
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Jobs_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Errors_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Outs_NEW
mkdir /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Texts_NEW
for i in {1..22}
do
cat > /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Jobs_NEW/SAIGE_S2_NEW_CLSA_EUR_chr${i}.job << EOT
#!/bin/bash
#SBATCH --job-name=SAIGE_S2_NEW_CLSA_EUR_chr${i}.job
#SBATCH -n 32
#SBATCH -N 1
#SBATCH --mem=2G
#SBATCH -t 48:00:00
#SBATCH -A def-audginny
#SBATCH -e /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Errors_NEW/SAIGE_S2_NEW_CLSA_EUR_chr${i}.error
#SBATCH -o /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Outs_NEW/SAIGE_S2_NEW_CLSA_EUR_chr${i}.out
date

module load singularity
export MUGQIC_INSTALL_HOME=/cvmfs/soft.mugqic/CentOS6
module use $MUGQIC_INSTALL_HOME/modulefiles
module load mugqic/R_Bioconductor/3.6.0_3.9

singularity run -B /home/loveni9/projects/def-audginny/loveni9:/mnt/myinput /home/loveni9/projects/def-audginny/loveni9/saige.sif Rscript /usr/local/bin/step2_SPAtests.R \
--minMAF=0 \
--minMAC=1 \
--bgenFile=/mnt/myinput/CLSA/DATA/Genomics3_clsa/clsa_imp_${i}_v3.bgen \
--bgenFileIndex=/mnt/myinput/CLSA/DATA/Genomics3_clsa/clsa_imp_${i}_v3.bgen.bgi \
--sampleFile=/mnt/myinput/CLSA/DATA/clsa_imp_v3_new.sample \
--idstoIncludeFile=/mnt/myinput/CLSA/DATA/IDs_CLSA_EUR_bgen_sample.txt \
--GMMATmodelFile=/mnt/myinput/SAIGE_NEW/Step_1_NEW/Texts_NEW/chronic_back_pain_SAIGE_NEW_Step_1.rda \
--varianceRatioFile=/mnt/myinput/SAIGE_NEW/Step_1_NEW/Texts_NEW/chronic_back_pain_SAIGE_NEW_Step_1.varianceRatio.txt \
--SAIGEOutputFile=/mnt/myinput/SAIGE_NEW/Step_2_NEW/Texts_NEW/SAIGE_S2_NEW_CLSA_EUR_chr${i}.txt \
--numLinesOutput=2 \
--IsDropMissingDosages=FALSE \
--LOCO=FALSE

date
EOT
sbatch /home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Jobs_NEW/SAIGE_S2_NEW_CLSA_EUR_chr${i}.job
done
