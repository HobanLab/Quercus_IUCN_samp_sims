# 2_querucs_processing.R - All quercus data prep for plotting

#This script imports the saved results array from all_quercus_sampling.R containing the proportion of alleles 
#captured by the sample size across all replicates for all species. This script converts the results array
#into separate dataframes for each species. Here, we also add column names and data to aid in plotting (add
#number sampled columns, and species name columns to keep track of this information when plotting).
#It is important to note that in this script, we average the simulation replicates for each sample size; this
#is achieved using the rowMeans() function. We do this in order to create a smaller dataframe, and to create
#a cleaner plot. 

#This script was written in collaboration by Kaylee Rosenberger, Emily Schumacher, and Dr. Sean Hoban

#################################################################################################
#Library functions
library(dplyr)

#Loading in results from all_quercus_sampling.R
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Allele_lim_change\\Original\\R-scripts")
load("quercus_allcheck_orig_results.Rdata")

#vector of species names
species_names = c("Q. acerifolia", "Q. arksanana", "Q. austrina", "Q. boyntonnii", "Q. carmenensis", "Q. cedrosensis", "Q. engelmannii", "Q. georgiana",
                  "Q. graciliformis", "Q. havardii", "Q. hinckleyii", "Q. oglethorpensis", "Q. pacifica", "Q. tomentella")

#varaible to hold sample range
num_sampled = (1:500)

#varaible to hold column names for dataframe
col_names = c("avg_prop_all", "num_sampled")

#saves a list of all newly processed dataframes. The list contains separate dataframes for each species
combined_quercus_list = list()

#data processing loop
for(i in 1:length(species_names)) {
  temp_data_frame = as.data.frame(final_quercus_results[,,i]) #creating a temporary data frame to hold the current  
  temp_data_frame = rowMeans(temp_data_frame) #taking means of simulation replicates for a cleaner plot
  temp_data_frame = as.data.frame(temp_data_frame) # rowMeans takes it out of dataframe format so converting back to dataframe
  temp_data_frame$num_sampled = num_sampled #defining a column of the sample size
  colnames(temp_data_frame) = col_names #setting the column names
  species = rep(species_names[i], 500) #creating a new column with the species names
  temp_data_frame$species = species #setting the new columns values
  
  combined_quercus_list[[i]] = temp_data_frame 
}

#using rbind() to vertically bind all dataframes to one large dataframe, so that all species can be plotted
#on the same graph in all_quercus_plotting.R
combined_quercus_new = do.call(rbind, combined_quercus_list)

#saving the combined dataframe in .Rdata file
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Allele_lim_change\\Original\\R-scripts")
save(combined_quercus_new, file="combined_quercus_final.Rdata")

