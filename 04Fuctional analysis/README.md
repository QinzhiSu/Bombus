#Overview

In this directory, the work-flow related to KEGG Orthology and carbohydrate-active enzymes functional analysis is described.

#1. Bee gut microbiota database pangenome gene KO and CAZyme annotation

COMMAND: sh 00KEGG.sh; sh 00dbcan.sh

#2. Merge KO or CAZyme copy number per SDP in each sample, and the samples ae sorted alphabetically

COMMAND: Rscript 01genes_merge.ko.R; Rscript 01genes_merge.dbcan.R

#3. Re-arrange sample names of SDP abundance file in alphabetical order
This step is necessary for downstream calculating.

COMMAND: Rscript 02specis_sort.R

#4. Copy number multiplied by SDP relative abundance to calculate KO or CAZyme abundance per SDP  

COMMAND: perl 03calculate2.pl genes_merge_ko.tsv relative_abundance.sort.txt;
         perl 03calculate2.pl genes_merge_dbcan.tsv relative_abundance.sort.txt

#5. Merge KO or CAZyme abundance across SDPs in each sample

COMMAND: sh 04ko_sum.sh; sh 04dbcan_sum.sh
