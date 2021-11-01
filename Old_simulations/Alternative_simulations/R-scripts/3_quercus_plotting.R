# 3_quercus_plotting.R - Script to plot results for Quercus sampling

#This script plots the results of sampling with the x-axis representing the number of individuals sampled
#and the y-axis representing the proportion of alleles captured. All 14 species are shown on this plot, 
#represented by different color lines and different line types. Here, we use the processed data to plot
#(averaged across replicates).

##This script was written in collaboration by Kaylee Rosenberger, Emily Schumacher, and Dr. Sean Hoban

####################################################################################################
#library functions
library(ggplot2)

#load in data from all_quercus_processing.R
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Alternative_simulations\\R-scripts")
load("combined_quercus_final.Rdata")

#plot containing all oak species
#number sampled on x axis
#proportion of alleles on y axis
#
ggplot(data=combined_quercus_new, aes(x=num_sampled, y=avg_prop_all, color=species)) +
  geom_line(size=1,aes(linetype=species)) +
  scale_linetype_manual(values=c("solid", "dotted", "longdash", "solid", "twodash", "dotted", "solid", "longdash", "solid", "dotdash", "solid", "dotted", "solid", "longdash")) +
  ylim(0.7,1) +
  xlim(0,400) +
  ggtitle("Genetic diversity captured for varying sample sizes across 14 oak species") +
  xlab("Number of unique individuals sampled") +
  ylab("Proportion of alleles captured") +
  labs(fill = "Species") +
  theme(text = element_text(size=15)) +
  theme_bw() #white background

