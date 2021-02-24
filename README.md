This pipeline contains five parts, mainly focusing on metagenomic binning, bee gut microbiota database building, function and SNV analysis. 
Tips:These scripts need to be modified according to your own situation during application.

#PART I:01Shotgun sequencing data preprocessing

In this part, we processed quality control and then used metaWRAP pipeline to remove host and extract individual draft genomes (bins) from shotgun sequencing reads.


#PART II:02Build bee gut microbiota database

Next, we used the draft genomes (bins) from part I and genomes downloaded from NCBI to build a bee gut microbiota database based on MIDAS pipeline. This database mainly containing genomes from bumble bee and honey bee gut microbiome was used to facilitate taxonomic profiling, function and SNV analysis.


#PART III:03Taxonomic, gene and SNV profiling

Then, taxonomic, gene and SNV profiling was done by mapping reads to bee gut microbiota database by MIDAS pipeline. And the results were used to downstream analysis. 


#PART IV:04Fuctional analysis

In this part, multiple scripts were used to do the analysis related to KEGG Orthology and carbohydrate-active enzymes from results of PART III.


#PART V:05SNV analysis

In this part, the strain diversity of population or individual was profiled using customed scripts from PART III results.
