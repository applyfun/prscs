#!/bin/bash -l
#SBATCH --partition brc,shared
#SBATCH --time=0-16:00
#SBATCH --mem-per-cpu=4G
#SBATCH --job-name=prscs_array
#SBATCH --output=array_prscs.%A_%a.out
#SBATCH --cpus-per-task=4
#SBATCH --array=1-22%12

module load devtools/anaconda/2019.3-python3.7.3

conda init bash

conda activate prscs

# if this is the first time script is being run then create conda environment first:

## conda create -n prscs2 python=3.7.3 scipy numpy pandas h5py

# pull in args

traitgwaspath=$1
traitgwasfile=$2
softwarepath=$3
ldmatrixfile=$4
targetfile=$5
samplesize=$6

echo "The trait GWAS file is: ${traitgwasfile}"

# set directories

cd ${traitgwaspath}

#set array number 

echo ${SLURM_ARRAY_TASK_ID}

chrom=${SLURM_ARRAY_TASK_ID}

# run PRScs

python ${softwarepath}/PRScs.py

echo "Entering PRScs loop"

echo "Loop number"${chrom}

python ${softwarepath}/PRScs.py --ref_dir=${ldmatrixfile} \
        --bim_prefix=${targetfile} \
        --sst_file=${traitgwaspath}${traitgwasfile} \
        --n_gwas=${samplesize} \
        --chrom=${chrom} \
        --a=1 \
        --b=0.5 \
        --phi=0.02 \
        --n_iter=1000 \
        --n_burnin=500 \
        --thin=5 \
        --out_dir=${traitgwaspath}_scz

echo "all done"

