#Generic sampling script 

#Library functions
library(adegenet)
library(car)
library(diveRsity)
library(ggplot2)
library(ggpubr)
library(ggsignif)
library(tidyr)

#Set working directory
mydir = "C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Simulations"
setwd(mydir)

#creating a list of the species we have simulated
species_list = c("\\q_acerifolia",
                 "\\q_oglethorpensis")

#defining the maximum number of individuals we want to sample
#for practical purposes, this will be 500 indivduals 
max_sample_size = 500

#number of replicates of genetic simulation
num_replicates = 100

#Defining an import function
#converts all arlequin files in a folder to genepop files
import_arp2gen_files = function(mypath, mypattern) {
  setwd(mypath)
  temp_list_1 = list.files(mypath, mypattern)
  temp_list_2 = list(length = length(temp_list_1))
  for(z in 1:length(temp_list_1)){temp_list_2[[z]]=arp2gen(temp_list_1[z])}
  temp_list_2
}

#converting all simulation files from arlequin format to genepop format using defined import function
for(x in 1:length(species_list)) {
  import_arp2gen_files(paste(mydir,species_list[x],sep=""),".arp$")
}

#pre-defining the array to store results
#first dimension: 16, for 16 quercus species. this is represented by the outer for loop
#second dimension: 500, sampling from 1 to 500 individuals per species, saving results for each iteration
#third dimension: 100 fir 100 simulation replicates per species
results_all_quercus = array(0, dim = c(16,500,100))

total_alleles_all_quercus = array(0, dim=c(16,500,100))

#Loop to simulate sampling
#First, create a list of all genepop files (all replicates) to loop over
#the variable 'i' represents each replicate
for(i in 1:length(species_list)) {
  setwd(paste(mydir,species_list[i],sep=""))
  list_files = list.files(paste(mydir,species_list[i],sep=""), pattern = ".gen$")
  for(j in 1:length(list_files)) {
    #creating a temporary genind object (using Adegenet package) for each simulation replicate
    temp_genind = read.genepop(list_files[[j]], ncode=3) 
    
    #defining the first and last individuals of the entire population, so we know where to sample between
    first_ind = 1
    last_ind = sum(table(temp_genind@pop)) 
    
    #for each replicate, sample up to 500 individuals, starting with 1
    for(k in 1:max_sample_size) {
      
      #choosing which rows of the matrix to sample from
      #rows indicate individuals
      rows_to_samp = sample(first_ind:last_ind, k+1) #had to add 1 here, because it was giving errors for sampling 1 individual
      
      #saving the alleles sampled
      sample_n_alleles = sum(colSums(temp_genind@tab[rows_to_samp,])>0)
      
      #calculating the total alleles
      total_alleles = ncol(temp_genind@tab)
      
      #saving the proportion of alleles captured -> alleles sampled/total alleles
      #represents genetic conservation success
      results_all_quercus[i,k,j] = sample_n_alleles/total_alleles
      
      total_alleles_all_quercus[i,k,j] = total_alleles
      
    }
  }
}

setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
save(results_all_quercus, file="all_quercus_results.Rdata")
