#########################################################################

#Comparison of min. size analysis
#Compare change in minumum sample size between original simulations
#and alternative simulations (with varied parameter values)

##########################################################################

setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
load("min_samp_size.Rdata")
minSize_original = minSize

setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\Alternative_simulations\\R-scripts")
load("min_samp_size.Rdata")
minSize_alternative = minSize

percent_change = c(rep(0,14))

for(i in 1:length(minSize_original)) {
  percent_change[i] = ((abs(minSize_original[i] - minSize_alternative[i]))/minSize_original[i])*100
  print(percent_change[i])
}

setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
save(percent_change, file="percent_change.Rdata")
