library(tidyr)
library(dplyr)

options(stringsAsFactors = FALSE)

#列出合并基因下的文件
path <- '~/bombus/02metagenome/midas/result/genes_merge'
setwd(path)
ls_dir <- list.dirs(path = path, full.names = TRUE, recursive = FALSE)

#读入dbcan注释文件
dbcan_file <- '~/database/bee_gut_pangenomes/pangenomes_genes_drep.faa.dbcan'
dbcan_index <- read.delim(file = dbcan_file, header = TRUE, sep = '\t')

#读入样本文件
sample_file <- '~/bombus/02metagenome/midas/data/sample.txt'
sam <- read.delim(file = sample_file, header = FALSE, sep = '\t')
sam <- sam$V1
sam_all <- vector(mode="character",length=0)
for (i in 1:length(sam)) {
  sam_all[i] <- gsub('-','.',sam[i])
}

#最终合并数据框
data_all <- data.frame(gene_id = character(0),species_id = character(0),dbcan_id = character(0),sample_id = character(0),abundance = numeric(0))

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
    #加dbcan_id
    data2dbcan <- match(data$gene_id,dbcan_index$gene_id)
    data$dbcan_id <- dbcan_index$dbcan_id[data2dbcan]
    #及没有dbcan注释的行
    data <- data[!is.na(data$dbcan_id),]
    if (nrow(data != 0)) {
      #宽表转长表
      data <- gather(data = data, key = 'sample_id', value = 'abundance',-c('gene_id','species_id','dbcan_id'))
      #合并
      data_all <- rbind(data_all,data)
    }
  }
}

#检查样本是否全面
#在这一步会把没有出现的样本补0
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

#调整样本顺序,按样本号从小到大排列比较好
data_tmp <- gather(data = data_all_merge, key = 'sample_id', value = 'abundance',-c('gene_id','species_id','dbcan_id'))
data_all_merge <- spread(data = data_tmp,key = sample_id,value = abundance)

#合并gene_id|species_id|dbcan_id
data_all_merge <- unite(data_all_merge,"gene_id|species_id",gene_id,species_id, sep = "/|", remove = TRUE)
data_all_merge <- unite(data_all_merge,"gene_id|species_id|dbcan_id",`gene_id|species_id`,dbcan_id, sep = "|", remove = TRUE)

#输出文件
oup_file <- paste0(path,'/','genes_merge.dbcan.tsv')
write.table(data_all_merge,oup_file,sep = '\t',quote = FALSE,row.names =FALSE)
