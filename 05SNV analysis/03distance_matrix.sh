#!bin/bash
snps_merge=~/bombus/02metagenome/midas/result/snps_merge
for i in `cat sdp_name.list`
do
Rscript $snps_merge/03distance_matrix.R $snps_merge/${i}/${i}_shared_fraction.txt $snps_merge/${i}/${i}_dist_matrix.txt
done
