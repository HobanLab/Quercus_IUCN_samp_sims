#All quercus data prep for plotting
library(dplyr)
#################################################################################################
#PROCESSING

setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
load("all_quercus_results.Rdata")

#converting matrices to data frames
#splitting each species into its own dataframe for processing and naming columns

q_acerifolia_df = as.data.frame(all_quercus_results[1,,]) #making results array into a dataframe
q_acerifolia_df = rowMeans(q_acerifolia_df) #taking the means of the replicates for cleaner plot
q_acerifolia_df = as.data.frame(q_acerifolia_df) #rowMeans takes it out of dataframe format, so we convert BACK to dataframe again
num_sampled = (1:500) #defining a column for sample size
q_acerifolia_df$num_sampled = num_sampled #adding column to dataframe
colnames(q_acerifolia_df) = c("avg_prop_all", "num_sampled") #changing column names
species = rep("q_acerifolia", 500) #defing species name
q_acerifolia_df$species=species #adding column to dataframe


q_arkansana_df = as.data.frame(all_quercus_results[2,,])
q_arkansana_df = rowMeans(q_arkansana_df)
q_arkansana_df = as.data.frame(q_arkansana_df)
q_arkansana_df$num_sampled = num_sampled
colnames(q_arkansana_df) = c("avg_prop_all", "num_sampled")
species = rep("q_arkansana", 500)
q_arkansana_df$species = species


q_boyntonii_df = as.data.frame(all_quercus_results[3,,])
q_boyntonii_df = rowMeans(q_boyntonii_df)
q_boyntonii_df = as.data.frame(q_boyntonii_df)
q_boyntonii_df$num_sampled = num_sampled
colnames(q_boyntonii_df) = c("avg_prop_all", "num_sampled")
species = rep("q_boyntonii", 500)
q_boyntonii_df$species=species


q_carmenesis_df = as.data.frame(all_quercus_results[4,,])
q_carmenesis_df = rowMeans(q_carmenesis_df)
q_carmenesis_df = as.data.frame(q_carmenesis_df)
q_carmenesis_df$num_sampled = num_sampled
colnames(q_carmenesis_df) = c("avg_prop_all", "num_sampled")
species = rep("q_carmenensis", 500)
q_carmenesis_df$species = species


q_cedrosensis_df = as.data.frame(all_quercus_results[5,,])
q_cedrosensis_df = rowMeans(q_cedrosensis_df)
q_cedrosensis_df = as.data.frame(q_cedrosensis_df)
q_cedrosensis_df$num_sampled = num_sampled
colnames(q_cedrosensis_df) =c("avg_prop_all", "num_sampled")
species = rep("q_cedrosensis", 500)
q_cedrosensis_df$species = species


q_engelmannii_df = as.data.frame(all_quercus_results[6,,])
q_engelmannii_df = rowMeans(q_engelmannii_df)
q_engelmannii_df = as.data.frame(q_engelmannii_df)
q_engelmannii_df$num_sampled = num_sampled
colnames(q_engelmannii_df) =  c("avg_prop_all", "num_sampled")
species = rep("q_engelmannii", 500)
q_engelmannii_df$species = species


q_georgiana_df = as.data.frame(all_quercus_results[7,,])
q_georgiana_df = rowMeans(q_georgiana_df)
q_georgiana_df = as.data.frame(q_georgiana_df)
q_georgiana_df$num_sampled = num_sampled
colnames(q_georgiana_df) =  c("avg_prop_all", "num_sampled")
species = rep("q_georgiana", 500)
q_georgiana_df$species = species


q_graciliformis_df = as.data.frame(all_quercus_results[8,,])
q_graciliformis_df = rowMeans(q_graciliformis_df)
q_graciliformis_df = as.data.frame(q_graciliformis_df)
q_graciliformis_df$num_sampled = num_sampled
colnames(q_graciliformis_df) =  c("avg_prop_all", "num_sampled")
species = rep("q_graciliformis", 500)
q_graciliformis_df$species = species


q_harvardii_df = as.data.frame(all_quercus_results[9,,])
q_harvardii_df = rowMeans(q_harvardii_df)
q_harvardii_df = as.data.frame(q_harvardii_df)
q_harvardii_df$num_sampled = num_sampled
colnames(q_harvardii_df) =  c("avg_prop_all", "num_sampled")
species = rep("q_harvardii", 500)
q_harvardii_df$species = species


q_hinckleyii_df = as.data.frame(all_quercus_results[10,,])
q_hinckleyii_df = rowMeans(q_hinckleyii_df)
q_hinckleyii_df = as.data.frame(q_hinckleyii_df)
q_hinckleyii_df$num_sampled = num_sampled
colnames(q_hinckleyii_df) =  c("avg_prop_all", "num_sampled")
species = rep("q_hinckleyii", 500)
q_hinckleyii_df$species = species


q_oglethorpensis_df = as.data.frame(all_quercus_results[11,,])
q_oglethorpensis_df = rowMeans(q_oglethorpensis_df)
q_oglethorpensis_df = as.data.frame(q_oglethorpensis_df)
q_oglethorpensis_df$num_sampled = num_sampled
colnames(q_oglethorpensis_df) =  c("avg_prop_all", "num_sampled")
species = rep("q_oglethorpensis", 500)
q_oglethorpensis_df$species = species


q_pacifica_df = as.data.frame(all_quercus_results[12,,])
q_pacifica_df = rowMeans(q_pacifica_df)
q_pacifica_df = as.data.frame(q_pacifica_df)
q_pacifica_df$num_sampled = num_sampled
colnames(q_pacifica_df) =  c("avg_prop_all", "num_sampled")
species = rep("q_pacifica", 500)
q_pacifica_df$species = species


#use rbind() to combined all vertically - it's going to be really large.
combined_quercus = rbind(q_acerifolia_df, q_arkansana_df, q_boyntonii_df, q_carmenesis_df, q_cedrosensis_df, q_engelmannii_df, q_georgiana_df, q_graciliformis_df, q_harvardii_df, q_hinckleyii_df, q_oglethorpensis_df, q_pacifica_df)

#saving the combined dataframe in .Rdata file
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
save(combined_quercus, file="combined_quercus.Rdata")
