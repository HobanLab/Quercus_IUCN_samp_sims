# 4_min_size_fst_analysis.R - Analysis for all quercus simulation results

#This script contains the calculation for getting the required sample size for all species required to capture
#95% of the total alleles. 
#This script also calculates the mean, min, and max Fst values for all species, to verify the realism of our 
#simulations

#This script was written in collaboration by Kaylee Rosenberger, Emily Schumacher, and Dr. Sean Hoban

##########################################################################################################
#MINIMUM SAMPLE SIZE

#Loading in results from all_quercus_sampling.R
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Allele_lim_check\\alt_sims")
load("combined_quercus_final.Rdata")

num_species = 1

#Loop to get the minimum sample size required to capture 95% of the alleles
#in 'wild' populations for each species
#averaging each row, which represents all 1000 replicates (so we are averaging across replicates)
minSize = vector(length=num_species)
for(i in 1:num_species) {
  minSize[i] = (min(which(rowMeans(final_quercus_results[,,i])>0.95)))
  
}
save(minSize, file="min_samp_size.Rdata")

#########################################################################################################
#QUARTILES 

#defining a list to save the quartiles for each species 
lower_quartile = vector(length = num_species)
upper_quartile = vector(length = num_species)
lower_quartile_row = vector(length = num_species)
upper_quartile_row = vector(length = num_species)
#Loop to calculate quartiles for each species
for(i in 1:num_species) {
  lower_quartile[i] = quantile(rowMeans(final_quercus_results[,,i]), probs = c(0.25))
  lower_quartile_row[i] = min(which(rowMeans(final_quercus_results[,,i])>=lower_quartile[i]))
  
  upper_quartile[i] = quantile(rowMeans(final_quercus_results[,,i]), probs = c(0.75))
  upper_quartile_row[i] = min(which(rowMeans(final_quercus_results[,,i])>=upper_quartile[i]))
}

##########################################################################################################
#Proportion captured in sample size of 50
prop_captured = vector(length=num_species)
for(i in 1:num_species) {
  prop_captured[i] = mean(final_quercus_results[50,,i])
}
save(prop_captured, file="prop_captured.Rdata")

##########################################################################################################
#Checking Fst - to make sure the simulations are realistic

#load in data from all_quercus_sampling.R
load("new_fst.Rdata")

#creating an array to store all Fst results in
#dimensions 14 (14 species) by 3 (first column is mean Fst, second column is min Fst, third column is max Fst)
fst_results = array(0, dim = c(num_species,3)) 

for(j in 1:num_species) {
  fst_results[j,] = rowMeans(mean_max_min_fst[,,j])
}
save(fst_results, file="fst_processed.Rdata")
