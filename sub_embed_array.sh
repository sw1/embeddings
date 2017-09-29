#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=8G
#$ -l h_vmem=10G
#$ -q all.q
#$ -t 1-30

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/3.6-current

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/embed
REFS=/home/$USERNAME/embedding/refs
CODE=/home/$USERNAME/embedding/code
KMERS=/home/$USERNAME/embedding/kmers
MODELS=/home/$USERNAME/embedding/models

py=/mnt/HA/opt/python/3.6.1/bin/python3
script=2_embed.py

name=query

mkdir -p $SCRATCH

cp $KMERS/${name}*csv.gz $KMERS/${name}*.pkl $SCRATCH
cp $REFS/*.fna.gz $SCRATCH
cp $CODE/embed_params.py $CODE/embed_functions.py $CODE/$script $SCRATCH
cp $MODELS/* $SCRATCH

ls $MODELS -1 | grep .pkl$ > $SCRATCH/fns.dat

cd $SCRATCH

$py $script $name $SGE_TASK_ID

exit 0
