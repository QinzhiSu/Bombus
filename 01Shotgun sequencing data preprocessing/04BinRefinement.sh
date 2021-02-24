#!/bin/bash
intial_binning=~/bombus/03intial_binning
result=~/bombus/04bin_refinement
cat $result/<sample.list> | parallel --gnu -j 5 "metawrap bin_refinement -o $result/{} -t 4 -A $intial_binning/{}/metabat2_bins/ -B $intial_binning/{}/maxbin2_bins/ -C $intial_binning/{}/concoct_bins/ -c 70 -x 10"
