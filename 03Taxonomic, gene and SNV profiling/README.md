#Overview

In this directory, the two scripts were used to map reads to bee_gut_database to estimate SDP composition, gene abundance and SNV frequency among population.

#01midas.sh

This pipeline contains the following steps:

1) estimate SDP profile in individul by mapping reads to marker genes (run_midas.py species);
2) map reads to bacterial pangenomes and quantify genes in our data(run_midas.py genes);
3) map reads to bacterial reference and quantify SNV along the entire genome (run_midas.py snps).

COMMAND: sh 01midas.sh

#02result_merge.sh

This pipeline contains the following steps:

1) merge SDP abundance files across samples;
2) merge results from pan-genome profiling across samples;
3) perform pooled-sample genome SNP calling.

COMMAND: sh 02result_merge.sh