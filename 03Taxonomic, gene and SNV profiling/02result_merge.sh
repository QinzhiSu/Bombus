#MIDAS environment
conda activate ~/conda_env/python3.6

#the path of result
export result=~/bombus/02metagenome/midas/result
#a list of the path about every sample 
export sample=~/bombus/02metagenome/midas/result/<sample name>
#the path of database
export db=~/database/bee_gut_database/

merge_midas.py species $result/species_merge -i $sample -t list -d $db
merge_midas.py genes $result/genes_merge -i $sample -t list -d $db
merge_midas.py snps $result/snps_merge -i $sample -t list -d $db --snp_type bi --site_depth 5 --site_prev 0.05 --allele_freq 0.01 --sample_depth 5.0 --fract_cov 0.4

conda deactivate