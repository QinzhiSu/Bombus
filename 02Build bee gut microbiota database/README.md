#PART I:Data preparation for building database

#  name_cluster_fna_gff_faa_ffn & all_genomes.mapfile

Before building the database, we need to organize two files in advance:
1) name_cluster_fna_gff_faa_ffn: this file separated by tab key, include 6 columns:
	a)genome file name
	b)cluster which strain belongs to
	c)absolute path of genome file (*.fna)
	d)absolute path of gff file (*.gff)
	e)absolute path of protein sequence file (*.faa)
	f)absolute path of genes file (*.ffn)
2) all_genomes.mapfile: this file separated by tab key, include 3 columns:
	a)genome file name
	b)cluster which strain belongs to
	c)bool value, '1' means the strain is the representative strain of the cluster, '0' is not.


#PART II:Build the MIDAS database


#  process.sh

In this script, we do the following things:
1)Prepare and organize the bee gut microbial genome in suitable folder named 'bee_gut_genome' 
using the file 'name_cluster_fna_gff_faa_ffn' prepared above;
2)Make genes file
3)Build MIDAS database using the folder 'bee_gut_genome' and the file 'all_genomes.mapfile' mentioned above.
COMMAND: sh process.sh