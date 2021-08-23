#!/bin/bash
####################### YOUR INPUT GOES HERE: #########################################################################

####### INPUT INFO: #######
# type the path to the folder of the output files from your step-2 SAIGE run, ending with "/":
path_to_sept2_SAIGE_files=/home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/Step_2_NEW/Texts_NEW/

# type the prefix, i.e. the common name BEFORE the number of the chromosome, 
# of the output files from your step-2 SAIGE run:
prefix_step2_SAIGE_files=SAIGE_S2_NEW_CLSA_EUR_chr

# type the suffix, i.e. the common name AFTER the number of the chromosome, 
# of the output files from your step-2 SAIGE run (include file extension e.g. .txt, if any):
suffix_step2_SAIGE=.txt

# type the full path to the qc filter file:
path_to_filter_file=/lustre03/project/6048803/CLSA/QC_filters/EUR_QC_filters/EUR_QC_filter_10e6.tsv 

# type the names of the following columns from the summary stats files 
# (DO NOT CHANGE IF STATS FILES COME FROM SAIGE):
# rs ID:
rs=rsid

# First allele:
A1=SNPID

# Second allele:
A2=Allele1

####### OUTPUT INFO: #######
# type the path to the folder where the filtered files should be saved, ednding with "/":
path_to_output_folder=/home/loveni9/projects/def-audginny/loveni9/SAIGE_NEW/QC_filtered_files/

# type the common name, BEFORE the number of the chromosome, 
# you would like the resulting files from this qc filtering to have:
prefix_of_output=SAIGE_S2_NEW_CLSA_EUR_QC_filtered_chr

# If processing SAIGE summary statistics files, type TRUE, else type FALSE:
SAIGE=TRUE

###################### END OF INPUT ##################################################################################



###################### LEAVE THE REST TO THE COMPUTER: ###############################################################

dot=\.
sl=\\

# mkdir ${path_to_output_folder}sumstats_filtered/
path_to_output_folder=${path_to_output_folder}sumstats_filtered/

export MUGQIC_INSTALL_HOME=/cvmfs/soft.mugqic/CentOS6
module use $MUGQIC_INSTALL_HOME/modulefiles
module load mugqic/R_Bioconductor/3.6.0_3.9

fill=TRUE 

cat > ${path_to_output_folder}qc_filter.R << EOT
library(data.table)
library(dplyr)

####### INPUT INFO:
# The path to the output files from your step-2 SAIGE run:
path_to_SAIGE_files <- "${path_to_sept2_SAIGE_files}"

# The prefix, i.e. the common name BEFORE the number of the chromosome, 
# of the output files from your step-2 SAIGE run:
prefix <- "${prefix_step2_SAIGE_files}"

# The suffix, i.e. the common name AFTER the number of the chromosome, 
# of the output files from your step-2 SAIGE run (including file extension .txt):
suffix <- "${suffix_step2_SAIGE}"

# The full path to the qc filter file:
path_to_filter <- "${path_to_filter_file}"

####### OUTPUT INFO:
# The path to the folder where the filtered files should be saved:
path_to_output <- "${path_to_output_folder}"

# The common name, BEFORE the number of the chromosome, 
# you would like the resulting files from this qc filtering to have:
prefix1 <- "${prefix_of_output}"

#################### EXECUTABLE: #######################################################################################

global_start <- Sys.time()

#######

print("uploading the filter file... ")
start_time <- Sys.time()

incl <- fread(path_to_filter)

end_time <- Sys.time()
print("time to upload the filter file: ")
print(end_time - start_time)
print("")

#######

print("processing the filter file... ")
start_time <- Sys.time()

incl[ , A1_A2:=paste(pmin(REF,ALT), pmax(REF,ALT), sep='_')]
incl <- incl[,.(rsid, A1_A2, CHR)]
colnames(incl)[1] <- "${rs}"
nrow(incl)
gc()

end_time <- Sys.time()
print("time to process the filter file: ")
print(end_time - start_time)
print("")

#######

output_merged_file <- paste(path_to_output, prefix1, '_merged.txt', sep="")
output_FUMA_file <- paste(path_to_output, prefix1, '_FUMA.txt', sep="")

print("##################################################################################")
i <- 1
for(chrom in c(i:22)){
  print("##################################################################################")
  print("")
  print("chromosome: ")
  print(chrom)
  print("")
  local_start <- Sys.time()
  print("extracting a filtering subtable...")
  start_time <- Sys.time()

  incl_curr <- incl[CHR == chrom,] 
  incl_curr <- incl_curr[,.(${rs}, A1_A2)]
  incl <- incl[CHR > chrom,]  
  gc()

  end_time <- Sys.time()
  print("time to extract the filtering subtable: ")
  print(end_time - start_time)
  print("")

  file_path <- paste(path_to_SAIGE_files, prefix, chrom, suffix, sep="")

  print("uploading chromosome stats file... ")
  start_time <- Sys.time()
  
  chr <- fread(file_path)
  chr[,POS:=as.integer(POS)]

  end_time <- Sys.time()
  print("time to upload chromosome stats file: ")
  print(end_time - start_time)
  print("")

  print("filtering chromosome stats file... ")
  start_time <- Sys.time()
  
  chr <- mutate( chr, A1_A2 = paste(pmin(${A1}, ${A2}), pmax(${A1}, ${A2}), sep="_") )
  chr <- inner_join(chr, incl_curr, by=c("${rs}", "A1_A2"))

  end_time <- Sys.time()
  print("filtering time: ")
  print(end_time - start_time)
  print("")

  output_file <- paste(path_to_output, prefix1, '_chr', chrom, suffix, sep="")

  print("creating output files... ")
  start_time <- Sys.time()

  colnames(chr) <- gsub("${sl}${sl}${dot}", "_", colnames(chr))

  write.table(select(chr, c(1:(ncol(chr)-1))), output_file,
              append = FALSE, sep = "\t", quote = FALSE, col.names=TRUE, row.names=FALSE)

  if(chrom==i){
     write.table(select(chr, c(1:(ncol(chr)-1))), output_merged_file,
                 append = FALSE, sep = "\t", quote = FALSE, col.names=TRUE, row.names=FALSE)
  } else {
     write.table(select(chr, c(1:(ncol(chr)-1))), output_merged_file,
                 append = TRUE, sep = "\t", quote = FALSE, col.names=FALSE, row.names=FALSE)
  }
  
  saige <- ${SAIGE}
  if(saige){
     if(chrom==i){
        write.table(select(chr, CHR, POS, rsid, Allele1, Allele2, N, BETA, SE, p_value), 
                    output_FUMA_file,
                    append = FALSE, sep = "\t", quote = FALSE, col.names=TRUE, row.names=FALSE)
     } else {
        write.table(select(chr, CHR, POS, rsid, Allele1, Allele2, N, BETA, SE, p_value), 
                    output_FUMA_file,
                    append = TRUE, sep = "\t", quote = FALSE, col.names=FALSE, row.names=FALSE)
     }
  }
  end_time <- Sys.time()
  print("time to create output files: ")
  print(end_time - start_time)
  print("")
  rm(chr)
  local_end <- Sys.time()
  print("Time elapsed: ")
  print(local_end-local_start)
}
print("##################################################################################")

print("")
global_end <- Sys.time()
print("Total time of filtering: ")
print(global_end - global_start)

EOT

####################### EXECUTION OF R SCRIPT: #####################################################################

module load gcc/7.3.0 r/3.6.0

Rscript ${path_to_output_folder}qc_filter.R

####################### COMPRESSION OF OUTPUT FILE: ################################################################

echo "Compressing the filtered files... "
date

gzip -k ${path_to_output_folder}${prefix_of_output}_merged.txt

if [ ${SAIGE} = TRUE ]
then
   gzip -k ${path_to_output_folder}${prefix_of_output}_FUMA.txt
fi

echo "Compression complete"
date
