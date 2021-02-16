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
mydir = "C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Simulations\\q_acerifolia"
setwd(mydir)


#Defining an import function
#converts all arlequin files in a folder to genepop files
import_arp2gen_files = function(mypath, mypattern) {
  setwd(mypath)
  temp_list_1 = list.files(mypath, mypattern)
  temp_list_2 = list(length = length(temp_list_1))
  for(i in 1:length(temp_list_1)){temp_list_2[[i]]=arp2gen(temp_list_1[i])}
  temp_list_2
}

#converting all simulation files from arlequin format to genepop format using defined import function
for(x in 1:length(species_list)) {
  import_arp2gen_files(paste(mydir,sep=""),".arp$")
}

results_q_acerifolia = array(0, dim = c(20, 100))

#Loop to simulate sampling
#First, create a list of all genepop files (all replicates) to loop over
#the variable 'i' represents each replicate
list_files = list.files(mydir, pattern = ".gen$")
for(i in 1:length(list_files)) {
  
  increment = 0.05
  counter = 0
  for(j in 1:20) {
    #creating a temporary genind object (using Adegenet package) for each simulation replicate
    temp_genind = read.genepop(list_files[[i]], ncode=3) 
    
    #defining population boundaries by the first individual and the last individuals in each population
    #last individual for every population as the cumulative sum of all populations (ie., last individual for pop 1 is the sum of pop 1)
    last_ind = as.numeric(cumsum(table(temp_genind@pop)))
    #first individual of every population begins at 1, then for following populations, it is the last individual (cumulative sum) + 1
    #for example, if the last individual for pop 1 is 30, the first individual for pop 2 would be 31
    first_ind = as.numeric(c(1, cumsum(table(temp_genind@pop)) +1))
    #selecting the first 4 values since we have 4 populations
    first_ind = first_ind[1:4] 
    
    #for the first iteration, we don't want to sample 0, we just want to sample 1
    if(counter == 0) {
      sample_size = c(1,1,1,1)
    } else {
      sample_size = as.numeric(table(temp_genind@pop)*increment*counter) 
      sample_size = ceiling(sample_size) 
    }
    
    rows_to_samp = c(sample(first_ind[1]:last_ind[1], sample_size[1]), sample(first_ind[2]:last_ind[2], sample_size[2]), sample(first_ind[3]:last_ind[3], sample_size[3]), sample(first_ind[4]:last_ind[4], sample_size[4]))
    
    sample_n_alleles = sum(colSums(temp_genind@tab[rows_to_samp,])>0)
    
    total_alleles = ncol(temp_genind@tab)
    
    results_q_acerifolia[j,i] = sample_n_alleles/total_alleles
    
    total_alleles_q_acerifolia[j,i] = total_alleles
    
    counter =  counter + 1
  }
}

setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
save(results_q_acerifolia, file="q_acerifolia_results.Rdata")
