# 4_min_size_fst_analysis.R - Analysis for all quercus simulation results

#This script contains the calculation for getting the required sample size for all species required to capture
#95% of the total alleles. 
#This script also calculates the mean, min, and max Fst values for all species, to verify the realism of our 
#simulations

#This script was written in collaboration by Kaylee Rosenberger, Emily Schumacher, and Dr. Sean Hoban

##########################################################################################################
#MINIMUMSAMPLE SIZE

#Loading in results from all_quercus_sampling.R
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
load("quercus_final_results.Rdata") 

#Loop to get the minimum sample size required to capture 95% of the alleles
#in 'wild' populations for each species
#averaging each row, which represents all 1000 replicates (so we are averaging across replicates)
minSize = vector(length=14)
for(i in 1:14) {
  minSize[i] = (min(which(rowMeans(final_quercus_results[,,i])>0.95)))
  
}
save(minSize, file="min_samp_size.Rdata")

###################################################################################################
#Checking Fst - to make sure the simulations are realistic

#load in data from all_quercus_sampling.R
load("new_fst.Rdata")

#creating an array to store all Fst results in
#dimensions 14 (14 species) by 3 (first column is mean Fst, second column is min Fst, third column is max Fst)
fst_results = array(0, dim = c(14,3)) 

for(j in 1:14) {
  fst_results[j,] = rowMeans(mean_max_min_fst[,,j])
}
save(fst_results, file="fst_processed.Rdata")
