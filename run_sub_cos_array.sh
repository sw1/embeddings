#!/bin/bash

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/cosim
REFS=/home/$USERNAME/embedding/refs
CODE=/home/$USERNAME/embedding/code
KMERS=/home/$USERNAME/embedding/kmers
MODELS=/home/$USERNAME/embedding/models
EMBEDS=/home/$USERNAME/embedding/embeddings

script=3_cosim.py

mkdir -p $SCRATCH

cp $CODE/embed_params.py $CODE/embed_functions.py $CODE/$script $SCRATCH
cp $EMBEDS/* $SCRATCH

ls $EMBEDS -1 | grep query > $SCRATCH/fns.dat

qsub sub_cos_array.sh

exit 0
