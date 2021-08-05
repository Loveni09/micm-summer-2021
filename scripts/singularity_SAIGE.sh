# use of singularity on Compute Canada

# view available verisons of singularity
module spider singularity

# load singularity
module load singularity/3.7

# download SAIGE image
cd /home/loveni9/projects/def-audginny/loveni9

wget https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh

sh ./download-frozen-image-v2.sh saige wzhou88/saige:0.44

cd saige && tar cf ../saige.tar * && cd .

cd ..

# apply for node for installing saige
salloc --mem-per-cpu=2000 --cpus-per-task=4 --time=2:0:0 --account=def-audginny

singularity build saige.sif docker-archive://saige.tar

# run saige interactively
singularity shell  /scratch/xiangao/tool/saige.sif

# (in singularity)	Singularity> Rscript /usr/local/bin/step1_fitNULLGLMM.R --help

# run saige
