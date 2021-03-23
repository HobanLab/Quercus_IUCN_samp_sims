#Script to plot results for quercus

####################################################################################################
#GRAPHICS
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
load("combined_quercus.Rdata")

#plot containing all oak species
ggplot(data=combined_quercus, aes(x=num_sampled, y=avg_prop_all, color=species)) +
  geom_line() +
  ylim(0.6,1)
