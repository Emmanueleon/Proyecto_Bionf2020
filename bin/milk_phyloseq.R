###In this script we analyze a human milk microbiota .biom file.This data was generated through Qiime 1 pipe (I already had the data) instead of AMPkt. 
###I am still working with the AMPkt pipeline, but I want to make a possible route once I get the data.
###Sequencing was performed using a 2x250 bp Illumina platform.

###Context: There are 4 samples of human milk from to mothers (Px137) and (A24), for the extraction we use 4 and 6 mL of milk.

### Before start the analysis we need to set the enviroment
###We need the follow packages:
library(phyloseq)
library(vegan)
library(tidyverse)

###Moreover create output directory
outdir <- "../output/" #variable 

if(!file.exists(R_results)) {
  dir.create(R_results, mode = "0755", recursive=T)
}

###Then we import the .biom file
milk_microbiota <- import_biom("../output/leches_prueba.biom")
milk_microbiota
#As we can see the .biom file have the OTU and Tax table.

### Rename the columns of the taxa table to the taxonomic hierarchy
colnames(tax_table(milk_microbiota)) <- c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species")
head(tax_table(milk_microbiota))

### Check the number of the reads
no.read=sort(sample_sums(milk_microbiota))
no.read 

###Alpha diversity estimation
### At Phylum level (Abundance)
milk_abundance <- plot_bar(milk_microbiota, fill = "Phylum") + 
  geom_bar(aes(color=Phylum, fill=Phylum), stat="identity", position="stack")+
  labs(title = "Milk Abundance")
milk_abundance

### Presence-absence table using decostand (method "pa")
milk_decostand <- decostand(otu_table(milk_microbiota), method="pa")
head(milk_decostand)

### The alpha diversity was measure using two metrics(Observed & Fisher):
### We use the Presence-absence table
milk_diversity<- estimate_richness(milk_decostand, measures =c("Observed", "Fisher"))
milk_diversity

#Because .biom file doesnt have mapping file, we create two colums (Paciente and Botones) and then bind these columms to Diversity table
Paciente <- c("Px137", "Px137", "Px29", "Px29")
Botones <- c("4", "6", "4", "6")

Diversity_table <- cbind(milk_diversity,Paciente, Botones)
Diversity_table

###  To seee if there is a significant difference between the metrics, an Anova is used
### Anova between Patients with Fisher 
Fisher_patient <- aov(Fisher~Paciente, data = Diversity_table)
summary(Fisher_patient)

G1 <- ggplot(data = Diversity_table, aes(x=Paciente, y=Fisher, fill=Paciente))+
  geom_boxplot(show.legend = FALSE)+
  labs(x=NULL)+
  scale_fill_manual(values=c("#00467A","#94BF52"))+
  theme_cowplot(12)
G1

### Anova between Patients with Observed
Observed_patient <- aov(Observed~Paciente, data = Diversity_table)
summary(Observed_patient)

G2 <- ggplot(data = Diversity_table, aes(x=Paciente, y=Observed, fill=Paciente))+
  geom_boxplot()+
  labs(x=NULL)+
  scale_fill_manual(values=c("#00417A","#94BF52"))+
  theme_cowplot(12)
G2

### Anova between number of pellets with Fisher 
Fisher_pellets <- aov(Fisher~Botones, data = Diversity_table)
summary(Fisher_pellets)

G3 <- ggplot(data = Diversity_table, aes(x=Botones, y=Fisher, fill=Botones))+
  geom_boxplot(show.legend = FALSE)+
  labs(x=NULL)+
  scale_fill_manual(values=c("#00407A","#93BF52"))+
  theme_cowplot(12)
G3
### Anova between numer of pellets with Observed
Observed_pellets <- aov(Observed~Botones, data = Diversity_table)
summary(Observed_pellets)

G4 <- ggplot(data = Diversity_table, aes(x=Botones, y=Observed, fill=Botones))+
  geom_boxplot()+
  labs(x=NULL)+
  scale_fill_manual(values=c("#00407A","#93BF52"))+
  theme_cowplot(12)
G4

Alfa_diversity_graph <-plot_grid(G1,G2,G3,G4, 
                                 labels = c("A)", "B)", "C)", "D)"),
                                 label_size = 12,
                                 rel_widths = c(2, 2)) 
Alfa_diversity_graph
