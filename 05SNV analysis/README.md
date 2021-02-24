#Overview

In this directory, the scripts were used to filter sites with low frequency and calculate strain diversity within or between samples of each SDP.

#1. Copy 'genome.features' file of each SDP 

COMMAND: sh 00cp_genome_features.sh

#2. Filter sites with low frequency and calculate the proportion of SNVs within sample

COMMAND: Rscript 01snv_var_sample.R

#3. Calculate pairwise fraction of shared SNVs 

COMMAND: sh 02calc_shared_SNV_fraction.sh

#4. Generate jaccard distance matrix 

COMMAND: sh 03distance_matrix.sh
