#!bin/bash
db=~/database/bee_gut_database/rep_genomes
snps_merge=~/bombus/02metagenome/midas/result/snps_merge
for i in `cat sdp_name.list`
do
cp $db/${i}/genome.features $snps_merge/${i}
done
