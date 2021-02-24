#!/usr/bin/ Rscript
rm(list=ls())
setwd("~/bombus/02metagenome/midas/result/snps_merge")
getwd()
library(tidyverse)

dirs<-list.dirs(path = ".", full.names = F, recursive = F)

for (i in dirs){
  freq_file<-str_c(i,"/snps_freq.txt",seq="")
  feature_file<-str_c(i,"/genome.features",seq="")
  feature<-read_tsv(feature_file) %>% mutate(gene_length=end-start+1) %>%
    select(gene_id,gene_length)
  info_file<-str_c(i,"/snps_info.txt",seq="")
  info<-read_tsv(info_file) %>% filter(gene_id != "NA")%>%
    filter(locus_type == "CDS") %>%
    select(site_id,gene_id) %>%
    left_join(feature)
  freq<-read_tsv(freq_file)
  freq[freq<0.01]<-0
  freq<-freq %>% filter_at(vars(starts_with("N")|starts_with("E")|starts_with("L")
                                |starts_with("DY")|starts_with("GY")|starts_with("Ac")
                                |starts_with("Am")|starts_with("Dr")|starts_with("Gr")),
                           any_vars(.>0)) %>%
    keep(~any(.x !=0))
  filt_freq_name<-str_c(i,"/",i,".filter.freq",seq="")
  write_tsv(freq,filt_freq_name)
  freq_within_sample<-freq %>% 
    pivot_longer(-site_id,names_to = "sample", values_to = "freq") %>%
    left_join(info) %>%
    filter(gene_id !="NA") %>%
    filter(freq !=0 & freq !=1) %>%
    group_by(sample,gene_id,gene_length) %>%
    summarise(gene_snvs=n()) %>%
    ungroup()
  gene_lenth<-freq_within_sample %>% select(gene_id,gene_length) %>%
    distinct_all()
  core_gene_length<-sum(gene_lenth$gene_length)
  freq_within_sample<-freq_within_sample %>% mutate(core_length=core_gene_length) %>%
    group_by(sample,core_length) %>%
    summarise(core_snvs=sum(gene_snvs))%>%
    ungroup() %>%
    mutate(snv_proportion=core_snvs/core_length *100) %>%
    mutate(SDP=i)
  snv_within_sample_name<-str_c(i,"/",i,".var.pro.txt",seq="")
  write_tsv(freq_within_sample,snv_within_sample_name)
}

