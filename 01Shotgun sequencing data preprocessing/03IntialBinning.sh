#!bin/bash
assembly_data=~/bombus/02assembly/final
raw_data=~/bombus/02assembly/data
result=~/bombus/03intial_binning
cat $result/<sample.list> | parallel --gnu -j 5 "metawrap binning -o $result/{} -t 6 -a $assembly_data/{}/final_assembly.fasta --metabat2 --maxbin2 --concoct $raw_data/{}/*fastq"
