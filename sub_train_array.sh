#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=180:00:00
#$ -P rosenPrj
#$ -pe shm 64
#$ -l mem_free=60G
#$ -l h_vmem=64G
#$ -q long.q
#$ -t 1-72

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/3.6-current

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/train
REFS=/home/$USERNAME/embedding/refs
CODE=/home/$USERNAME/embedding/code
KMERS=/home/$USERNAME/embedding/kmers
MODELS=/home/$USERNAME/embedding/models

py=/mnt/HA/opt/python/3.6.1/bin/python3
script=1_train.py

mkdir -p $SCRATCH

cp $KMERS/gg*csv.gz $SCRATCH/
cp $CODE/embed_params.py $CODE/embed_functions.py $CODE/$script $SCRATCH

cd $SCRATCH

$py embed_params.py

n_cores=64

$py $script $SGE_TASK_ID $n_cores

exit 0
