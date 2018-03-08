#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=48:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=14G
#$ -l h_vmem=16G
#$ -q all.q@@intelhosts
#$ -t 1-24

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/intelpython/3

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/train_intel
REFS=/home/$USERNAME/embedding/refs
CODE=/home/$USERNAME/embedding/code
KMERS=/home/$USERNAME/embedding/kmers
MODELS=/home/$USERNAME/embedding/models

py=/mnt/HA/opt/python/intel/2018/intelpython3/bin/python3
script=1_train.py

seed=423 #98
k=12

mkdir -p $SCRATCH

cp $KMERS/gg_${k}*csv.gz $SCRATCH/
cp $CODE/embed_params.py $CODE/embed_functions.py $CODE/$script $SCRATCH

cd $SCRATCH

$py embed_params.py

$py $script $SGE_TASK_ID $NSLOTS $seed

exit 0
