#MIDAS environment
conda activate ~/conda_env/python3.6

#the path of metagenome
export data=~/bombus/02metagenome/midas/data
#the path of saving result
export result=~/bombus/02metagenome/midas/result
#the path of database
export db=~/database/bee_gut_database

cat $data/<sample.list> | parallel --gnu -j 40 "
run_midas.py species $result/{} -1 $data/{}/{}_1.*fastq* -2 $data/{}/{}_2.*fastq* -t 2 -d $db;
run_midas.py genes $result/{} -1 $data/{}/{}_1.*fastq* -2 $data/{}/{}_2.*fastq* -t 2 -d $db --species_cov 3;
run_midas.py snps $result/{} -1 $data/{}/{}_1.*fastq* -2 $data/{}/{}_2.*fastq* -t 2 -d $db"

conda deactivate