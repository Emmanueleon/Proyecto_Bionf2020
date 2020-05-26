!/bin/bash

#This script was made by Emmanuel Cervantes Monroy, it's objective is to demultiplex and filter sequences in order to create a .biom file 

#This script use the program amptk (https://amptk.readthedocs.io/en/latest/)

### Run amp through conda
conda activate amptk

###Variable statement
#This script assume that your working directory is bin directory
raw_dir=../data/PoolA/
out_cleaned=../output/ampkt_results/

###Pre processing Script 
#Objective: Assemble the Forward and Reverse primers, in addition to eliminate and filter from unnecessary primers and short sequences 
amptk illumina -i $raw_dir -o $out_cleaned -f TGTGCC -r CGTGAT
