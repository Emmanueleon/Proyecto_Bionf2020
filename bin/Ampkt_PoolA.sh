!/bin/bash

#This script was made by Emmanuel Cervantes Monroy, it's objective is to demultiplex and filter sequences in order to create a .biom file 

#This script use the program amptk (https://amptk.readthedocs.io/en/latest/) and USEARCH v9.2.64 (http://www.drive5.com/usearch/download.html)
#This script assume that your working directory is bin directory. 
#In each step a `mv` command was used to organize the data in specific folder called `ampk_results` at `output` directory

### Run amp through conda
conda activate amptk

###Variable statement
mkdir ../output/ampkt_results
raw_dir=../data/raw/PoolA/
out_cleaned=../output/ampkt_results/

###1.-Pre processing Script 
#Objective: Assemble the Forward and Reverse primers, in addition to eliminate and filter from unnecessary primers and short sequences 
#The forward barcode is the same in the 96 samples (TGTGCC), the reverse barcode its different (in this case I use CGTGAT).
amptk illumina -i $raw_dir -o PoolA_preprocess -f TGTGCC -r CGTGAT -l 250 --full_length --cleanup

mv PoolA_preprocess* ../output/ampkt_results

###2.-Clustering using UPARSE with 97% of similarity
#Objective: A quality filter grouping according OTU sequences.
preprocess_dir=../output/ampkt_results/PoolA_preprocess.demux.fq.gz

amptk cluster -i $preprocess_dir -o PoolA_uparse

mv PoolA_uparse* ../output/ampkt_results

###3.-Filtering OTU table 
#Objective: Filter the OTU table eliminating unwanted readings related to the sequencing process. 
#Here we use a singleton filter (--min_reads_otu 2) and  % index bleed threshold between samples (-p 0.005).
otu_table=../output/ampkt_results/PoolA_uparse.otu_table.txt
otu_fasta=../output/ampkt_results/PoolA_uparse.cluster.otus.fa

amptk filter -i $otu_table -f $otu_fasta -o PoolA_filter -p 0.005 --min_reads_otu 2

mv PoolA_filter* ../output/ampkt_results

###4.-Assigning Taxonomy
#Objective: Assign to the OTU table a taxonomy hierarchy employing a ref database for 16S rRNA (-d 16S).
otu_table_filtered=../output/ampkt_results/PoolA_filter.final.txt
cluster_otu=../output/ampkt_results/PoolA_filter.filtered.otus.fa
mapping_file=../output/ampkt_results/PoolA_preprocess.mapping_file.txt

amptk taxonomy -i $otu_table_filtered -f $cluster_otu -o PoolA_taxonomy  -m $mapping_file -d 16S

mv PoolA_taxonomy* ../output/ampkt_results


