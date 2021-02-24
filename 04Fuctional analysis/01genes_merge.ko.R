library(tidyr)
library(dplyr)

options(stringsAsFactors = FALSE)

#list the directory
path <- '~/bombus/02metagenome/midas/result/genes_merge'
setwd(path)
ls_dir <- list.dirs(path = path, full.names = TRUE, recursive = FALSE)

#read the KO annotation file
ko_file <- '~/database/bee_gut_pangenomes/pangenomes_genes_drep.faa.kegg'
ko_index <- read.delim(file = ko_file, header = TRUE, sep = '\t')

#read the sample file
sample_file <- '~/bombus/02metagenome/midas/data/sample.txt'
sam <- read.delim(file = sample_file, header = FALSE, sep = '\t')
sam <- sam$V1
sam_all <- vector(mode="character",length=0)
for (i in 1:length(sam)) {
  sam_all[i] <- gsub('-','.',sam[i])
}

#the final merge dataframe
data_all <- data.frame(gene_id = character(0),species_id = character(0),ko_id = character(0),sample_id = character(0),abundance = numeric(0))

for (i in 1:length(ls_dir)) {
  dir <- ls_dir[i]
  file <- paste0(dir,'/','genes_copynum.txt')
  data <- read.delim(file = file, header = TRUE, sep = '\t')
  #去掉全是0的行
  data <- data[rowSums(data[-1])!=0,]
  if (nrow(data)!= 0) {
    #加species_id
    species_id <- unlist(strsplit(dir,split = '/'))
    species_id <- tail(species_id,1)
    data$species_id <- species_id
    #加ko_id
    data2ko <- match(data$gene_id,ko_index$gene_id)
    data$ko_id <- ko_index$KO_id[data2ko]
    #及没有ko注释的行
    data <- data[!is.na(data$ko_id),]
    if (nrow(data != 0)) {
      #宽表转长表
      data <- gather(data = data, key = 'sample_id', value = 'abundance',-c('gene_id','species_id','ko_id'))
      #合并
      data_all <- rbind(data_all,data)
    }
  }
}

#Check for missing samples 
#and the missing sample will add 0
#sample_all - sample
sample <- unique(data_all$sample_id)
sample_all <- sam_all
set <- setdiff(sample_all,sample)
if (!is.null(set)) {
  data_all_merge <- spread(data = data_all,key = sample_id,value = abundance,fill = 0)
  
  row <-nrow(data_all_merge)
  col <- length(set)
  data_set <- matrix(0,row,col)
  colnames(data_set) <- set
  data_set <- data.frame(data_set)
  
  data_all_merge <- cbind(data_all_merge,data_set)
}

#Adjust sample order 
data_tmp <- gather(data = data_all_merge, key = 'sample_id', value = 'abundance',-c('gene_id','species_id','ko_id'))
data_all_merge <- spread(data = data_tmp,key = sample_id,value = abundance)

#gene_id|species_id|ko_id
data_all_merge <- unite(data_all_merge,"gene_id|species_id",gene_id,species_id, sep = "/|", remove = TRUE)
data_all_merge <- unite(data_all_merge,"gene_id|species_id|ko_id",`gene_id|species_id`,ko_id, sep = "|", remove = TRUE)

#output
oup_file <- paste0(path,'/','genes_merge.ko.tsv')
write.table(data_all_merge,oup_file,sep = '\t',quote = FALSE,row.names =FALSE)
