# Prediction of chronic pain trajectories in the aging population using genetic data
## Project Objective
The objective of this research project is to predict chronic pain trajectories in the aging population using genetic data from the Canadian Longitudinal Study on Aging (CLSA) through genome-wide association studies (GWAS) and to use statistical methods to construct polygenic risk scores (PRS) with higher levels of predictive power compared to PRS developed at a single timepoint. The PRS developed in the CLSA is to be validated by using data from the UK Biobank.

## Running GWAS 
Genome-wide association studies are used to detect the association between a certain variation in the genetic code and a physical trait (phenotype). The phenotype that we are looking into is chronic back pain, which we defined as a binary trait. Since most binary traits tend to have fewer cases than controls, the usually used linear or logistic mixed models are not efficient since they cause significant type I error rates with unbalanced control-case proportions. SAIGE (Scalable and Accurate Implementation of GEneralized mixed model) however is able to control for these high type I error rates and therefore will be used for analysis. 

### Installing instructions for SAIGE
SAIGE can be installed using a conda environment following instructions here: https://github.com/weizhouUMICH/SAIGE/wiki/Genetic-association-tests-using-SAIGE#installing-saige 

In case there's a SAIGE version issue during the runs, singularity can be used in the script for the steps; else, there is no need for singularity and the SAIGE_S1/S2.sh scripts can be used.

### Steps
Step 1:
Fitting a logistic mixed model for the binary trait (chronic back pain) across 22 autosomes

- Input files: Genotype plink binary files (in .bim, .fam, .bed files) with only 22 autosomes (the other sex and MT chromosomes were removed from the initial complete set of files using "awk '($1 ~ /\d+/)' file.bim > snp.txt" and "plink --bfile file --extract snp.txt --make-bed --out newfile") and phenotype file (covariates, binary phenotype, IDs)

- Output files: variance ratio file, model file, association result file for subset of randomly selected markers

Step 2: 
Doing association test chromosome by chromosome

- Input files: Dosage file, sample file, model file from Step 1, variance ratio file from Step 1

- Output file: Association test results file

After steps 1 and 2 have been successful, a quality control filtering is carried out on the SNPs (single nucleotide polymorphisms).

### Visualization of results
This step is performed with a platform called FUMA (FUnctional Mapping and Annotation) which is useful to visualize and annotate results from GWAS. 
The SNP2GENE function was used: this takes GWAS summary statistics (obtained from the step 2 results post filtering) as input and provides annotation for all SNPs in the input data and gives genome-wide plots like Manhattan/QQ plots that can show significant SNPs if they are present. Also, a summary of results and result tables are also obtained. 

Here are the Manhattan and QQ plots that were obtained from FUMA:

![Screenshot 2021-08-21 135155](https://user-images.githubusercontent.com/84378192/130857966-53b2f23a-1628-40ae-ba4f-b460d26c6455.png)

![Screenshot 2021-08-21 135222](https://user-images.githubusercontent.com/84378192/130857838-e37f7b64-e55e-47ce-860e-2ecad3a318c8.png)

## Future work
- Construction of polygenic risk scores could not be performed due to time constraints and could be performed later to predict chronic pain states

## Background Readings
- [9781119487845.ch21.pdf](https://github.com/Loveni09/micm-summer-2021/files/6614401/9781119487845.ch21.pdf)
- [dyz173.pdf](https://github.com/Loveni09/micm-summer-2021/files/6614403/dyz173.pdf)
- [Johnston et al. - 2019 - Genome-wide association study of multisite chronic.pdf](https://github.com/Loveni09/micm-summer-2021/files/6614404/Johnston.et.al.-.2019.-.Genome-wide.association.study.of.multisite.chronic.pdf)
- [Johnston_PloSGenetics_SM.pdf](https://github.com/Loveni09/micm-summer-2021/files/6614408/Johnston_PloSGenetics_SM.pdf)
- [9781119487845.ch3.pdf](https://github.com/Loveni09/micm-summer-2021/files/6693342/9781119487845.ch3.pdf)
- [MPR-27-e1608.pdf](https://github.com/Loveni09/micm-summer-2021/files/6760044/MPR-27-e1608.pdf)
- [SAIGE_nature_genetics.pdf](https://github.com/Loveni09/micm-summer-2021/files/6855249/SAIGE_nature_genetics.pdf)



