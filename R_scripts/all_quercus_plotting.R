#Script to plot results for Quercus sampling
library(ggplot2)
####################################################################################################
#GRAPHICS
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
load("combined_quercus_new.Rdata")

#plot containing all oak species
#number sampled on x axis
#proportion of alleles on y axis
#
ggplot(data=combined_quercus, aes(x=num_sampled, y=avg_prop_all, color=species)) +
  geom_line(size=1,aes(linetype=species)) +
  scale_linetype_manual(values=c("solid", "dotted", "solid", "twodash", "dotted", "solid", "longdash", "solid", "dotdash", "solid", "dotted", "solid")) +
  ylim(0.7,1) +
  xlim(0,400) +
  ggtitle("Genetic diversity captured for varying sample sizes across 12 oak species") +
  xlab("Number of unique individuals sampled") +
  ylab("Proportion of alleles captured") +
  labs(fill = "Species") +
  theme(text = element_text(size=15)) +
  theme_bw() #white background


###################################################################################################
#Checking Fst - to make sure the simulations are somewhat realistic
load("mean_min_max_fst_new.Rdata")

#Q. acerifolia - low migration, small pops
q_acer_fst = rowMeans(mean_max_min_fst[,,1]) #averaging across replicates
q_acer_fst

#Q. arkansana
q_ark_fst = rowMeans(mean_max_min_fst[,,2])
q_ark_fst

#Q. boyntonii - high migration, relatively small pops
q_boyn_fst =rowMeans(mean_max_min_fst[,,3])
q_boyn_fst

#Q. carmenesis
q_carm_fst = rowMeans(mean_max_min_fst[,,4])
q_carm_fst

#Q. cedrosensis
q_cedro_fst = rowMeans(mean_max_min_fst[,,5])
q_cedro_fst

#Q. engelmannii - low migration, large pops
q_engel_fst = rowMeans(mean_max_min_fst[,,6])
q_engel_fst

#Q. georgiana
q_georg_fst = rowMeans(mean_max_min_fst[,,7])
q_georg_fst

#Q. graciliformis
q_grac_fst = rowMeans(mean_max_min_fst[,,8])
q_grac_fst

#Q. havardii
q_hav_fst = rowMeans(mean_max_min_fst[,,9])
q_hav_fst

#Q. hinckleyii
q_hinck_fst = rowMeans(mean_max_min_fst[,,10])
q_hinck_fst

#Q. oglethorpensis 
q_ogle_fst = rowMeans(mean_max_min_fst[,,11])
q_ogle_fst

#Q. pacifica 
q_pac_fst = rowMeans(mean_max_min_fst[,,12])
q_pac_fst
