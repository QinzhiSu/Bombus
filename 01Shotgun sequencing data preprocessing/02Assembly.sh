cd ~bombus/02assembly/data
cat ./<sample.list>| parallel --gnu -j 10 "metawrap assembly -1 {}/*_1.fastq -2 {}/*_2.fastq -m 800 -t 2 --metaspades -o ../final/{}"