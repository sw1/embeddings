#!/bin/bash

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/ngram3
CODE=/home/$USERNAME/embedding/code
KMERS=/home/$USERNAME/embedding/kmers

script=4_ngram_parallel.py

mkdir -p $SCRATCH

cp $KMERS/query*.csv.gz $KMERS/kegg*.csv.gz $KMERS/query*.pkl $KMERS/kegg*.pkl $SCRATCH
cp $CODE/embed_params.py $CODE/embed_functions.py $CODE/$script $SCRATCH

qsub sub_ngram_array.sh

exit 0
