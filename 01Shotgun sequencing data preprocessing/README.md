##Overview

In the current directory, three parts scripts were used to process quality control, host removing and extract individual draft genomes.  


#PART I:Data preprocessing 


#1. Quality control

COMMAND: sh 01fastp.sh -i <input_folder> -o <output folder> -n <number of threads>

#2. Remove host (Bombus terrestris, Apis mellifera or Apis cerana) reads

COMMAND: sh 01RemoveHost.sh


#PART II:Metagenomic binning 


#1. De novo assembly

COMMAND: sh 02Assembly.sh

#2. Intial binning using three methods

COMMAND: sh 03IntialBinning.sh

#3. Integrate the intial bins obtained from three methods

COMMAND: sh 04BinRefinement.sh

#4. Extract reads mapping to bins and reassembly to obtain more complete bins 

COMMAND: sh 05ReassembleBins.sh

#5. Dereplicate bins 

COMMAND: sh 06de-replication.sh

#6. Classify bins using GTDB database

COMMAND: sh 07gtdbtk.sh


#PART III:Bins annotation


#1. Gene prediction

COMMAND: sh 08prokka.sh