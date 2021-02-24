#!/bin/bash
data=~/bombus/09bins_function_annotation/data
prokka=~/bombus/09bins_function_annotation/prokka
cd $data
for i in *
do
j=`echo $i | sed 's/.fasta//'`
prokka $i --kingdom Bacteria --outdir $prokka/$j --locustag $j --prefix $j --cpus 5
done
