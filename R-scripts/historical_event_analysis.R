# 1_quercus_main_sampling.R - Sampling script for all quercus species

#First, this script imports simulation files in .arp format and converts them to .gen format.
#Then, the script runs the main sampling loop. This loop runs through every replicate of each species and
#samples from 1 to 500 individuals for each simulation replicate. From this, we calculate the proportion of
#alleles captured by the sample size, by dividing the captured alleles by the total alleles present in the
#simulation. The results are saved in an array, and then saved as .Rdata, which can be imported to the next
#R script, all_quercus_processing
#The loop also implements Fst calculations, which can be turned off using a flag: fst_flag
#similarly, the file conversion function can be turned off once files have been converted to .gen once
#(there is no need to convert more than once, unless simulation files are changed) using the flag: conversion_flag
#Finally, there is code within the loop to calculate the number of alleles existing in different "allele categories"
#such as global, globally rare, locally rare, etc...

#This script was written in collaboration by Kaylee Rosenberger, Emily Schumacher, and Dr. Sean Hoban

########################################################################################################
#Library functions
library(adegenet)
library(car)
library(diveRsity)
library(ggplot2)
library(ggpubr)
library(ggsignif)
library(tidyr)
library(hierfstat)

#FLAGS
#file conversion flag
#set to true once files have been converted once
#false if you want to convert files
conversion_flag = TRUE
#Fst flag
#Fst code adds a lot of time to run the code 
#so if you don't want to run it, keep Fst off by setting it FALSE
fst_flag = TRUE
#allele category flag
#this flag allows code that runs the allele category code to be turned on
#when the flag is set to TRUE
allele_cat_flag = FALSE

#Set working directory
mydir = "C:/Users/kayle/Documents/Quercus_IUCN_samp_sims_local/Historical_event_sim_files"
setwd(mydir)

#creating a list of the species we have simulated
species_list = c("/q_acerifolia",
                 "/q_boyntonii",
                 "/q_carmenensis",
                 "/q_oglethorpensis")

#defining the maximum number of individuals we want to sample
#for practical purposes, this will be 500 indivduals 
max_sample_size = 500

#number of replicates of genetic simulation
num_replicates = 100

#number of species simulated
num_species = length(species_list)

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
if(conversion_flag == TRUE) {
  if(.Platform$OS.type=="windows") { #Windows doesn't allow forking or mclapply(), so we do convert normally, which is time consuming
    for(x in 1:length(species_list)) {
      import_arp2gen_files(paste(mydir,species_list[x],sep=""),".arp$")
    }
  }else if(.Platform$OS.type=="unix") { # If Unix, can use mclapply(), which utilizes forking to speed up the conversion process by spreading the process over multiple cores
    for (scen in 1:length(species_list)){
      arp_file_list<-list.files(paste0(mydir,species_list[scen],sep="/"))
      mclapply(arp_file_list,arp2gen,mc.cores=28) #could go higher than 28
    }
  }
}

#including file with useful functions written by Dr. Sean Hoban
source("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R-scripts\\Fa_sample_funcs.R")
##functions
colMax <- function(data) sapply(data, max, na.rm = TRUE)
sample.pop<-function(genind_obj,vect_pop_ID,vect_samp_sizes){
  p<-length(vect_pop_ID)
  if (p>1) {
    for (p in 1:length(vect_pop_ID))
      alleles[p,]<-colSums(genind_obj[[vect_pop_ID[p]]]@tab[sample(1:nrow(genind_obj[[vect_pop_ID[p]]]@tab), vect_samp_sizes[p]),],na.rm=T)
    alleles<-colSums(alleles)
  } else {alleles<-colSums(genind_obj[[vect_pop_ID[p]]]@tab[sample(1:nrow(genind_obj[[vect_pop_ID[p]]]@tab), vect_samp_sizes[p]),],na.rm=T)}
  
  alleles
}    

#pre-defining the array to store sampling results
#first dimension: 500, sampling from 1 to 500 individuals per species, saving results for each iteration
#second dimension: 100 for 100 simulation replicates per species
#third dimension: 14, for 14 quercus species. this is represented by the outer for loop (14 matrix 'slices')
final_quercus_results = array(0, dim = c(500,100,4))

final_alleles_all_quercus = array(0, dim=c(500,100,4))

alleles_capt_all_quercus = array(0, dim=c(500,100,4))

#storing Fst results: min, max, mean of replicates 
mean_max_min_fst = array(dim = c(3,100,4))#Fst run on 100 replicates

#ALLELE CATEGORIES VARAIBLES 
##allele frequency categories 
list_allele_cat<-c("global","glob_v_com","glob_com","glob_lowfr","glob_rare","reg_rare","loc_com_d1","loc_com_d2","loc_rare")

##defining variables to store allele cap
all_cap_samp <- array(dim = c(100, length(list_allele_cat), num_species))

##
all_cap_samp_per <- array(dim = c(100, length(list_allele_cat), num_species))

##species abbreviations 
species_abbrevs <- c("QUAC","QUAR","QUAU", "QUBO","QUCA","QUCE","QUEN","QUGE","QUGR","QUHA","QUHI","QUOG","QUPA", "QUTO")

##allelic existing by species table 
all_existing_by_sp_df <- matrix(nrow = length(species_list), ncol = length(list_allele_cat))
colnames(all_existing_by_sp_df) <- list_allele_cat
rownames(all_existing_by_sp_df) <- species_abbrevs

all_existing_by_sp_reps = array(dim = c(100,length(list_allele_cat),length(species_abbrevs)))

##alleles captured by sampling mean 
all_cap_mean <- matrix(nrow = length(species_list), ncol = length(list_allele_cat))
colnames(all_cap_mean) <- list_allele_cat
rownames(all_cap_mean) <- species_abbrevs

##alleles sampled 
all_cap_cat_per <- matrix(nrow = length(species_list), ncol = length(list_allele_cat))
colnames(all_cap_cat_per) <- list_allele_cat
rownames(all_cap_cat_per) <- species_abbrevs

##combo data frame with alleles captured by category vs. % captured 
all_cap_cat_df <- matrix(nrow = length(species_list), ncol = length(list_allele_cat))

###############################################################################################
#SAMPLING/Fst

#Loop to simulate sampling
#First, create a list of all genepop files (all replicates) to loop over
#the variable 'i' represents each species, 'j' represents each replicate
for(i in 1:length(species_list)) {
  setwd(paste(mydir,species_list[i],sep=""))
  list_files = list.files(paste(mydir,species_list[i],sep=""), pattern = ".gen$")
  for(j in 1:(length(list_files))) { 
    #creating a temporary genind object (using Adegenet package) for each simulation replicate
    temp_genind = read.genepop(list_files[[j]], ncode=3) 
    
    if(allele_cat_flag == TRUE) {
      #Allele category processing
      #First, calculate number of individuals per population
      n_ind <- table(temp_genind@pop)
      
      ##Then create a genpop file for temp_genind
      Spp_tot_genpop <- genind2genpop(temp_genind)
      
      ##separate by population 
      Spp_tot_genind_sep <- seppop(temp_genind)
      
      ##get categories for all alleles captured 
      allele_cat_tot <- get.allele.cat(Spp_tot_genpop, c(1:5), 2, n_ind)
      
      ##calculate the total number of alleles in each frequency category over 9 allele categories
      for (a in 1:length(allele_cat_tot)) all_existing_by_sp_reps[j,a,i] <- sum(allele_cat_tot[[a]]>0,na.rm=T)
      
      ##create output for all alleles captured by 
      for(b in 1:length(allele_cat_tot)) all_existing_by_sp_df[i,b] <- mean(all_existing_by_sp_reps[,b,i])
    }
    
    #calculating Fst
    if((fst_flag == TRUE) && (j <=100)) {
      pwfst <- pairwise.neifst(genind2hierfstat(temp_genind))
      
      ##calculate - max, min, mean fst and save results in a matrix for all species
      mean_max_min_fst[1:3,j,i] <- c(mean(pwfst, na.rm = TRUE), min(pwfst, na.rm = TRUE), max(pwfst, na.rm = TRUE))
      
    }
    
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
        final_quercus_results[k,j,i] = sample_n_alleles/total_alleles
        
        #saving the total alleles present across the populations for each species, and each replicate
        final_alleles_all_quercus[k,j,i] = total_alleles
        
        #saving the total number of alleles captured for each species (as opposed to proportion)
        alleles_capt_all_quercus[k,j,i] = sample_n_alleles
      }else {
        break
      }
    }
    if(allele_cat_flag == TRUE) {
      
      ##start adding allelic capture code 
      #to change to export at n=50, make a different variable like rows to samp that randomly selects 50 rows. 
      alleles_cap <- colSums(temp_genind@tab[rows_to_samp,], na.rm = T)
      
      ##allelic capture code 
      for (b in 1:length(allele_cat_tot)) all_cap_samp[j,b,i] <- sum(alleles_cap[allele_cat_tot[[b]]]>0)
      
      ##alleles per category captured by sampling 
      for(b in 1:length(allele_cat_tot)) all_cap_mean[i,b] <- mean(all_cap_samp[,b,i])
      
      ##percent captured data frame 
      all_cap_samp_per[,,i] <- all_cap_samp[,,i]/all_existing_by_sp_reps[,,i]
      
      ##all_cap_cat
      for (c in 1:length(allele_cat_tot)) all_cap_cat_per[i,c] <- round(mean(all_cap_samp_per[,c,i])*100,3)
      
      ##loop to write out nice df 
      for(d in 1:length(species_abbrevs)){
        for(e in 1:length(allele_cat_tot)){
          all_cap_cat_df[d,e] <- paste0(signif(all_cap_cat_per[d,e], 3), "%", " ", "(", signif(all_cap_mean[d,e],3), ")")
        }
      }
    }
  }
}

#saving results to a .Rdata file 
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R-scripts")
save(final_quercus_results, final_alleles_all_quercus, alleles_capt_all_quercus, mean_max_min_fst, file="historical_event_sims_results.Rdata")

##write out alleles existing within each categories  
#write.csv(all_existing_by_sp_df, paste("all_existing_by_sp_df_", version, ".csv", sep=""))
#write.csv(all_cap_cat_df, paste("all_cap_cat_df_", version, ".csv", sep=""))
