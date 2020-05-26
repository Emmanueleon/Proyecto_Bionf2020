

conda activate amptk

###Variable statement
raw_dir=../data/PoolA/
out_cleaned=../output/ampkt_results/
export usearch=~/Reference\ databases/usearch9

###Pre processing Script (this it's only one of 24 different barcode sequence) 
amptk illumina -i $raw_dir -o $out_cleaned -f TGTGCC -r CGTGAT
