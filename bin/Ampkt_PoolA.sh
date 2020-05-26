

conda activate amptk

###Variable statement
raw_dir=../data/PoolA/
out_cleaned=../output/ampkt_results/
export usearch=/Users/psychodelic4901/Reference\ databases/usearch9

###Pre processing Script
amptk illumina -i $raw_dir -o $out_cleaned -f TGTGCC -r CGTGAT
