#!bin/bash
snps_merge=~/bombus/02metagenome/midas/result/snps_merge
for i in `cat sdp_name.list`
do
perl $snps_merge/02calc_shared_SNV_fraction.pl $snps_merge/${i}/${i}.filter.freq
mv $snps_merge/*_shared_fraction.txt $snps_merge/${i}/
done
