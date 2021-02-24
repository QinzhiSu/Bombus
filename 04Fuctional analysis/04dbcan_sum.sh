#!/bin/bash
awk -F '[|\t]' 'NR==1{print $0}NR>1{
for(i=4;i<=NF;i++){
a[$3,i]+=$i}
b[$3]=b[$3]$1"/"
c[$3]=c[$3]$2"/"
d[$3]
}
END{for(i in d){printf(b[i]"|"c[i]"|"i);for(j=4;j<=NF;j++){printf "\t" a[i,j]};print ""}}' gene_relative_copynum.txt > gene_relative_copynum_sumdbcan.txt

sed -i 's$//$/$g' gene_relative_copynum_sumdbcan.txt

