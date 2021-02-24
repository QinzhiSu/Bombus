#!bin/bash
#Organize the bee gut microbial genome 
mkdir bee_gut_genome
cd bee_gut_genome
cp ../name_cluster_fna_gff_faa_ffn .
IFS=$'\n';
for i in `cat name_cluster_fna_gff_faa_ffn`;
do k=`echo ${i}|awk '{print $1}'`;
j=`echo ${i}|awk '{print $3}'`;
l=`echo ${i}|awk '{print $4}'`;
m=`echo ${i}|awk '{print $5}'`;
n=`echo ${i}|awk '{print $6}'`;
mkdir ${k};
cd ${k};
ln -s ${j} .;
ln -s ${l} .;
ln -s ${m} .;
ln -s ${n} .;
cd ..;
done
rm name_cluster_fna_gff_faa_ffn
cd ..

#make genes file
cd bee_gut_genome
for i in `ls`;
do
cd ${i}
awk  'NR==FNR{a[$0]}NR>FNR{ if(!($1 in a)) print $0}' *.fna *.gff | grep -v "#" | sed 's/ID=//g; s/;/\t/g' | awk '{print $9"\t"$1"\t"$4"\t"$5"\t"$7"\t"$3}' | sed '1i\gene_id\tscaffold_id\tstart\tend\tstrand\tgene_type' > ${i}.genes
rm *.gff
cd ..
done

#prepare mapfile in excel, '1' means the strain is the representative strain in the cluster, '0' is not
#all_genomes.mapfile

#build MIDAS database
build_midas_db.py bee_gut_genome all_genomes.mapfile bee_gut_database --threads 20


