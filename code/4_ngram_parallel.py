#!/usr/bin/env python

from sys import argv
import os
import zipfile
from os.path import splitext, isfile
import gzip
import csv
import six.moves.cPickle
from collections import Counter
from shutil import copyfile

import numpy as np
import pandas as pd
from itertools import product, islice
from operator import itemgetter
from sklearn.manifold import TSNE
import random
import math
from scipy import sparse
import time
import multiprocessing as mp

from gensim.models import Word2Vec
from gensim.models.word2vec import LineSentence

import embed_functions as emb
import embed_params as p


def get_nn(line,r_ids,r_kmers,r_counts):
    
    max_count = 0
    tie_breaker = 0
    
    line = line.decode('utf-8').split()
    q_kmer = set(line)
    q_count = Counter(line)
        
    for r,r_kmer in enumerate(r_kmers):

            i_total = len(q_kmer & r_kmer)

            if i_total > max_count:

                tie_breaker = 0
                max_count = i_total
                nn = [r_ids[r]]

            elif i_total == max_count and i_total > 50:

                counts = q_count & r_counts[r]
                i_counts = sum(counts.values())

                if i_counts > tie_breaker:
                    tie_breaker = i_counts
                    nn = [r_ids[r]]
                elif i_counts == tie_breaker:
                    nn.append(r_ids[r])
            else:
                pass

    return nn

fn_row = int(argv[1]) - 1
ref_fn_in = open('fns.dat','r').readlines()[fn_row].rstrip()
query_fn_in = ref_fn_in.replace('kegg','query')
k = int(ref_fn_in.split('_')[1])

ngram_fn = ref_fn_in.replace('kegg','ngrams').replace('.csv.gz','.pkl')
ngram_dir = os.path.expanduser('~/embedding/ngrams')

ref_fn = 'tmp' + str(fn_row) + '_' + ref_fn_in
query_fn = 'tmp' + str(fn_row) + '_' + query_fn_in

r_ids_fn = 'kegg_' + str(k) + '_ids' + '.pkl'
q_ids_fn = 'query_' + str(k) + '_ids' + '.pkl'

if not os.path.exists(os.path.join(ngram_dir,ngram_fn)):

    while True:
        print('Copying ' + ref_fn_in)
        copyfile(ref_fn_in,ref_fn)
        if os.path.getsize(ref_fn_in) == os.path.getsize(ref_fn):
            break

    while True:
        print('Copying ' + query_fn_in)
        copyfile(query_fn_in,query_fn)
        if os.path.getsize(query_fn_in) == os.path.getsize(query_fn):
            break

    r_ids = six.moves.cPickle.load(open(r_ids_fn,'rb'))['ids']
    q_ids = six.moves.cPickle.load(open(q_ids_fn,'rb'))['ids']

    file_open = emb.open_file_method(ref_fn)
    r_file = file_open(ref_fn)
    
    print('Calculating reference counts.')
    r_lines = [line.decode('utf-8').split() for line in r_file]
    r_kmers = [set(line) for line in r_lines]
    r_counts = [Counter(line) for line in r_lines]

    file_open = emb.open_file_method(query_fn)
    q_file = file_open(query_fn)
    
    print('Finding nearest neighbors')

    def worker(lines):
 
        result = {id:get_nn(line,r_ids,r_kmers,r_counts) for id,line in lines}
        
        return result

    if __name__ == '__main__':

        n_lines = 10
        n_cores = 24

        nns = {}
        q_ids_iter = iter(q_ids)

        b = 0
        while True:

            if b == 5:
                break

            batch_lines = list(islice(q_file, n_lines * n_cores))
            batch_ids = list(islice(q_ids_iter, n_lines * n_cores))

            if not batch_lines or not batch_ids:
                break
            else:
                batch = list(zip(batch_ids,batch_lines))

            pool = mp.Pool(processes=n_cores)

            tmp = pool.map(worker,(batch[line:line + n_lines] for line in range(0,len(batch),n_lines)))

            for d in tmp:
                nns.update(d)
        
            b += 1

    print(nns)

    #print('Saving ngrams.')
    #six.moves.cPickle.dump({'nns':nns},
    #        open(os.path.join(ngram_dir,ngram_fn),'wb'),protocol=4)

else:

    print(ngram_fn + ' exists')
