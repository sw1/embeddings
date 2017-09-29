#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=3G
#$ -l h_vmem=4G
#$ -q all.q

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/3.6-current

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/kmers
REFS=/home/$USERNAME/embedding/refs
CODE=/home/$USERNAME/embedding/code
KMERS=/home/$USERNAME/embedding/kmers

py=/mnt/HA/opt/python/3.6.1/bin/python3
script=0_genkmers.py


mkdir -p $SCRATCH

cp $REFS/*.gz $SCRATCH/
cp $CODE/embed_params.py $CODE/embed_functions.py $CODE/$script $SCRATCH

cd $SCRATCH

$py $script $1 $2 $3 > $SCRATCH/$1_$2_status.out

mv $SCRATCH/$1_$2_kmers.csv.gz $SCRATCH/$1_$2_ids.pkl $1_$2_status.out $KMERS/

exit 0
