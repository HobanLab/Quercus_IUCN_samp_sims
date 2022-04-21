# 4_min_size_fst_analysis.R - Analysis for all quercus simulation results

#This script contains the calculation for getting the required sample size for all species required to capture
#95% of the total alleles. 
#This script also calculates the mean, min, and max Fst values for all species, to verify the realism of our 
#simulations

#This script was written in collaboration by Kaylee Rosenberger, Emily Schumacher, and Dr. Sean Hoban

##########################################################################################################
#MINIMUM SAMPLE SIZE

#version variable keeps track of which version of simulation parameters you are working with
#orig = original
#alt = alternative
version = "orig"

#Loading in results from all_quercus_sampling.R
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R-scripts")
load(paste("quercus_final_results_", version, ".Rdata", sep=""))

num_species = 14

#Loop to get the minimum sample size required to capture 95% of the alleles
#in 'wild' populations for each species
#averaging each row, which represents all 1000 replicates (so we are averaging across replicates)
minSize = vector(length=num_species)
for(i in 1:num_species) {
  minSize[i] = (min(which(rowMeans(final_quercus_results[,,i])>0.95)))
  
}
save(minSize, file=paste("min_samp_size_", version, ".Rdata", sep=""))

##########################################################################################################
#Checking Fst - to make sure the simulations are realistic

#version variable keeps track of which version of simulation parameters you are working with
#orig = original
#alt = alternative
version = "altern"

#Loading in results from all_quercus_sampling.R
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R-scripts")
load(paste("quercus_fst_", version, ".Rdata", sep=""))

#creating an array to store all Fst results in
#dimensions 14 (14 species) by 3 (first column is mean Fst, second column is min Fst, third column is max Fst)
fst_results = array(0, dim = c(num_species,3)) 

for(j in 1:num_species) {
  fst_results[j,] = rowMeans(mean_max_min_fst[,,j])
}
save(fst_results, file="fst_processed.Rdata")

fst_results
