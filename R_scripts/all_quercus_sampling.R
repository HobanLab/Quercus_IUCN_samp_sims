#Generic sampling script 

#Library functions
library(adegenet)
library(car)
library(diveRsity)
library(ggplot2)
library(ggpubr)
library(ggsignif)
library(tidyr)

#FLAGS
converted = TRUE

#Set working directory
mydir = "C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Simulations"
setwd(mydir)

#creating a list of the species we have simulated
species_list = c("\\q_acerifolia",
                 "\\q_arkansana",
                 "\\q_boyntonii",
                 "\\q_carmenensis",
                 "\\q_cedrosensis",
                 "\\q_engelmannii",
                 "\\q_georgiana",
                 "\\q_graciliformis",
                 "\\q_havardii",
                 "\\q_hinckleyii",
                 "\\q_oglethorpensis",
                 "\\q_pacifica")

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
if(converted == FALSE) {
  for(x in 1:length(species_list)) {
    import_arp2gen_files(paste(mydir,species_list[x],sep=""),".arp$")
  }
}

#pre-defining the array to store results
#first dimension: 16, for 16 quercus species. this is represented by the outer for loop
#second dimension: 500, sampling from 1 to 500 individuals per species, saving results for each iteration
#third dimension: 100 fir 100 simulation replicates per species
all_quercus_results = array(0, dim = c(12,500,100))

total_alleles_all_quercus = array(0, dim=c(12,500,100))

###############################################################################################
#SAMPLING

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
      
      #this is a check to make sure that k, the sample size, doesn't exceed the species total pop. size
      #the loop will break if k is greater than the total pop. size
      #in other words, sampling stops once the entire population has been sampled, or when 500 samples is reached
      if(k <= sum(table(temp_genind@pop))) {
        #choosing which rows of the matrix to sample from
        #rows indicate individuals
        rows_to_samp = sample(first_ind:last_ind, k)
        
        #saving the alleles sampled
        if(k == 1) {
          sample_n_alleles = sum(temp_genind@tab[rows_to_samp,]>0)
        } else {
          sample_n_alleles = sum(colSums(temp_genind@tab[rows_to_samp,])>0)
        }
        
        #calculating the total alleles
        total_alleles = ncol(temp_genind@tab)
        
        #saving the proportion of alleles captured -> alleles sampled/total alleles
        #represents genetic conservation success
        all_quercus_results[i,k,j] = sample_n_alleles/total_alleles
        
        #saving the total alleles present across the populations for each species, and each replicate
        total_alleles_all_quercus[i,k,j] = total_alleles
      }else {
        break
      }
    }
  }
}

#saving results to a .Rdata file 
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
save(all_quercus_results, file="all_quercus_results.Rdata")

#################################################################################################
#PROCESSING

#converting matrices to data frames
#splitting each species into its own dataframe for processing and naming columns

q_acerifolia_df = as.data.frame(all_quercus_results[1,,])
q_acerifolia_df_long = gather(q_acerifolia_df, replicate, prop_all)
species=rep("q_acerifolia", 50000)
q_acerifolia_df_long$species=species
num_sampled=rep(1:500, 100)
q_acerifolia_df_long$num_sampled=num_sampled

q_arkansana_df = as.data.frame(all_quercus_results[2,,])
q_arkansana_df_long = gather(q_arkansana_df, replicate, prop_all)
species=rep("q_arkansana", 50000)
q_arkansana_df_long$species=species
num_sampled=rep(1:500, 100)
q_arkansana_df_long$num_sampled=num_sampled

q_boyntonii_df = as.data.frame(all_quercus_results[3,,])
q_boyntonii_df_long = gather(q_boyntonii_df, replicate, prop_all)
species=rep("q_boyntonii", 50000)
q_boyntonii_df_long$species=species
num_sampled=rep(1:500, 100)
q_boyntonii_df_long$num_sampled=num_sampled

q_carmenesis_df = as.data.frame(all_quercus_results[4,,])
q_carmenesis_df_long = gather(q_carmenesis_df, replicate, prop_all)
species=rep("q_carmenesis", 50000)
q_carmenesis_df_long$species=species
num_sampled=rep(1:500, 100)
q_carmenesis_df_long$num_sampled=num_sampled

q_cedrosensis_df = as.data.frame(all_quercus_results[5,,])
q_cedrosensis_df_long = gather(q_cedrosensis_df, replicate, prop_all)
species=rep("q_cedrosensis", 50000)
q_cedrosensis_df_long$species=species
num_sampled=rep(1:500, 100)
q_cedrosensis_df_long$num_sampled=num_sampled

q_engelmannii_df = as.data.frame(all_quercus_results[6,,])
q_engelmannii_df_long = gather(q_engelmannii_df, replicate, prop_all)
species=rep("q_engelmannii", 50000)
q_engelmannii_df_long$species=species
q_engelmannii_df_long$num_sampled=num_sampled

q_georgiana_df = as.data.frame(all_quercus_results[7,,])
q_georgiana_df_long = gather(q_georgiana_df, replicate, prop_all)
species=rep("q_georgiana", 50000)
q_georgiana_df_long$species=species
q_georgiana_df_long$num_sampled=num_sampled

q_graciliformis_df = as.data.frame(all_quercus_results[8,,])
q_graciliformis_df_long = gather(q_graciliformis_df, replicate, prop_all)
species=rep("q_graciliformis", 50000)
q_graciliformis_df_long$species=species
q_graciliformis_df_long$num_sampled=num_sampled

q_harvardii_df = as.data.frame(all_quercus_results[9,,])
q_harvardii_df_long = gather(q_harvardii_df, replicate, prop_all)
species=rep("q_harvardii", 50000)
q_harvardii_df_long$species=species
q_harvardii_df_long$num_sampled=num_sampled

q_hinckleyii_df = as.data.frame(all_quercus_results[10,,])
q_hinckleyii_df_long = gather(q_hinckleyii_df, replicate, prop_all)
species=rep("q_hinckleyii", 50000)
q_hinckleyii_df_long$species=species
q_hinckleyii_df_long$num_sampled=num_sampled

q_oglethorpensis_df = as.data.frame(all_quercus_results[11,,])
q_oglethorpensis_df_long = gather(q_oglethorpensis_df, replicate, prop_all)
species=rep("q_oglethorpensis", 50000)
q_oglethorpensis_df_long$species=species
q_oglethorpensis_df_long$num_sampled=num_sampled

q_pacifica_df = as.data.frame(all_quercus_results[12,,])
q_pacifica_df_long = gather(q_pacifica_df, replicate, prop_all)
species=rep("q_pacifica", 50000)
q_pacifica_df_long$species=species
q_pacifica_df_long$num_sampled=num_sampled

#use rbind() to combined all vertically - it's going to be really large.
combined_quercus_df = rbind(q_acerifolia_df_long, q_arkansana_df_long, q_boyntonii_df_long, q_carmenesis_df_long, q_cedrosensis_df_long, q_engelmannii_df_long, q_georgiana_df_long, q_graciliformis_df_long, q_harvardii_df_long, q_hinckleyii_df_long, q_oglethorpensis_df_long, q_pacifica_df_long)

#saving the combined dataframe in .Rdata file
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
save(combined_quercus_df, file="combined_quercus_df.Rdata")

####################################################################################################
#GRAPHICS

#plot containing all oak species
ggplot(data=combined_quercus_df, aes(x=num_sampled, y=prop_all, color=species)) +
  geom_line()

