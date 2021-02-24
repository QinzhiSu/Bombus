#!/usr/bin
cat <sample.list> | parallel --gnu -j 3 "
cd ~/bombus/01clean_data
gzip -d {}/{}_1.fq.clean.gz;
gzip -d {}/{}_2.fq.clean.gz;
mkdir -p {}/bmtagger_tmp;
bmtagger.sh -b ~/database/bmtagger_index/<Bombus, Acer, Amel>.bitmask -x ~/database/bmtagger_index/<Bombus, Acer, Amel>.srprism -T {}/bmtagger_tmp -q1\
         -1 {}/{}_1.fq.clean -2 {}/{}_2.fq.clean\
         -o {}/{}.bmtagger.list;
skip_human_reads.py {}/{}.bmtagger.list {}/{}_1.fq.clean | gzip > {}/{}_1.clean.fastq.gz;
skip_human_reads.py {}/{}.bmtagger.list {}/{}_2.fq.clean | gzip > {}/{}_2.clean.fastq.gz;
gzip {}/{}_1.fq.clean;
gzip {}/{}_2.fq.clean;
rm -r {}/bmtagger_tmp;
rm {}/{}.bmtagger.list;
perl fq_stat_gz.pl {}/{}_1.fq.clean.gz {}/{}_2.fq.clean.gz {}/{}_1.clean.fastq.gz {}/{}_2.clean.fastq.gz > {}/{}.stats"
