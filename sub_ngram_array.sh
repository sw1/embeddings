#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenPrj
#$ -pe shm 24
#$ -l mem_free=14G
#$ -l h_vmem=16G
#$ -q all.q
#$ -t 1-1

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/3.6-current

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/ngram
CODE=/home/$USERNAME/embedding/code
KMERS=/home/$USERNAME/embedding/kmers

py=/mnt/HA/opt/python/3.6.1/bin/python3
script=4_ngram_parallel.py

mkdir -p $SCRATCH

cp $KMERS/query*.csv.gz $KMERS/kegg*.csv.gz $KMERS/query*.pkl $KMERS/kegg*.pkl $SCRATCH
cp $CODE/embed_params.py $CODE/embed_functions.py $CODE/$script $SCRATCH

ls $KMERS -1 | grep 'kegg' | grep .csv.gz$ > $SCRATCH/fns.dat

cd $SCRATCH

$py $script $SGE_TASK_ID

exit 0
