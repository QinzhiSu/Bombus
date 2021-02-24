#!/bin/bash
result=~/bombus/05bin_reassembly
assembly_raw=~/bombus/02assembly/data
bin_refinement=~/bombus/04bin_refinement
cat $result/<sample.list> | parallel --gnu -j 4 "metawrap reassemble_bins -o $result/{} -1 $assembly_raw/{}/*_1.fastq -2 $assembly_raw/{}/*_2.fastq -t 5 -m 800 -c 70 -x 10 -b $bin_refinement/{}/metawrap_70_10_bins"
