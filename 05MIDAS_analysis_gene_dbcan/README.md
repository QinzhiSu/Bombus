################################################
#PART I:MIDAS downstream analysis----gene-dbcan
################################################
#=====================================================================================
#  01genes_merge.dbcan.R
#=====================================================================================
In this script, we will merge the gene Expression in each metagenome sample, and samples are sorted alphabetically.
COMMAND: Rscript 01genes_merge.dbcan.R

#=====================================================================================
#  02species_sort.R
#=====================================================================================
Use this script to adjust the sample order of the species abundance composition data,
so that it is arranged in alphabetical order.
This step is necessary for calculate gene abundance in each sample.
COMMAND: Rscript 02species_sort.R

#=====================================================================================
#  03calculate2.pl
#=====================================================================================
Preliminarily calculate the relative abundance of each gene to get the file 'relative_abundance.sort.txt'.
COMMAND: perl calculate2.pl genes_merge.tsv relative_abundance.sort.txt

#=====================================================================================
#  04dbcan_sum.sh
#=====================================================================================
This script will add the same dbcan together to get the file 'gene_relative_copynum_sumdbcan.txt'.
COMMAND: sh 04dbcan_sum.sh

#=====================================================================================
#  05calculate3.pl
#=====================================================================================
Calculate the proportion of each dbcan of different species in meta, and get the file 'gene_relative_copynum_abundance.txt'.
COMMAND: perl calculate3.pl gene_relative_copynum.txt gene_relative_copynum_sumdbcan.txt
