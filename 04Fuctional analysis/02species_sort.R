library(tidyr)
library(dplyr)

options(stringsAsFactors = FALSE)

path = '~/bombus/02metagenome/midas/result/species_merge'
setwd(path)

file <- '~/bombus/02metagenome/midas/result/species_merge/relative_abundance.txt'
data <- read.delim(file = file, header = TRUE, sep = '\t')

data_tmp <- gather(data = data, key = 'sample_id', value = 'abundance',-c('species_id'))
data_all_merge <- spread(data = data_tmp,key = sample_id,value = abundance)

write.table(data_all_merge,'./relative_abundance.sort.txt',sep = '\t',quote = FALSE,row.names =FALSE)
