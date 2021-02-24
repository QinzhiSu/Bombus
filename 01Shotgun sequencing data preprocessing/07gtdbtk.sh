#!/bin/bash
classify_bins=~/bombus/08classify_bins
gtdbtk classify_wf --genome_dir $classify_bins/data --out_dir $classify_bins/gtdbtk --cpus 30 -x fasta
FastTree $classify_bins/gtdbtk/gtdbtk.bac120.user_msa.fasta>$classify_bins/gtdbtk/gtdbtk.bac120.user_msa.tree