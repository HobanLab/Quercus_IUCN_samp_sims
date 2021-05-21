# 6_regression_anaylsis.R 

#This script tests several variables such as Fst, pop. sizes, and number of pops. to determine if 
#any of these parameters can predict the minimum sample size required for the species.

#This script was written in collaboration by Kaylee Rosenberger, Emily Schumacher, and Dr. Sean Hoban

####################################################################################################
#library functions
library(ggplot2)

#load in sampling data, Fst data, and minimum sample size data
setwd("C:\\Users\\kayle\\Documents\\Quercus_IUCN_samp_sims\\R_scripts")
load("combined_quercus_final.Rdata")
load("min_samp_size.Rdata")
load("fst_processed.Rdata")

#####################################################################################################
#Min size vs. Fst

#using only the mean Fst to plot
mean_fst_results = fst_results[,1]

#converting to dataframes
mean_fst_results = as.data.frame(mean_fst_results)
minSize = as.data.frame(minSize)

#merging dataframes for plotting
min_size_vs_fst = data.frame(minSize, mean_fst_results)

#making the linear model
fst_model = lm(minSize ~ mean_fst_results, data = min_size_vs_fst)
summary(fst_model)

#plotting results of the regression
#x axis -> mean Fst
#y axis -> minimum sample size required to capture 95% diversity
ggplot(min_size_vs_fst, aes(mean_fst_results, minSize)) +
  geom_point() +
  stat_smooth(method=lm) +
  ggtitle("Min size vs. Fst")

##################################################################################################
#Min size vs. total pop. size

#defining the sizes of the populations used for each species simulation
popSizes = array(14,1)
popSizes = c(530, 3460, 540, 1035, 3000, 8400, 20000, 500, 325, 5150, 300, 1000, 13000, 10500)
popSizes = as.data.frame(popSizes)

#combining the dataframes of min size. and pop sizes for plotting
min_size_vs_pop_size = data.frame(minSize, popSizes)

pop_size_model = lm(minSize ~ popSizes, data = min_size_vs_pop_size)
summary(pop_size_model)

#plotting results 
ggplot(min_size_vs_pop_size, aes(popSizes, minSize)) +
  geom_point() +
  stat_smooth(method=lm) +
  ggtitle("Min size vs. total pop. size")

###################################################################################################
#min size vs. number of pops

numPops = array(14,1)
numPops = c(4, 10, 9, 8, 3, 10, 4, 5, 3, 10, 4, 5, 3, 4)
numPops = as.data.frame(numPops)

min_size_vs_num_pops = data.frame(minSize, numPops)

num_pops_model = lm(minSize ~ numPops, data = min_size_vs_num_pops)
summary(num_pops_model)

#plotting results 
ggplot(min_size_vs_num_pops, aes(numPops, minSize)) +
  geom_point() +
  stat_smooth(method=lm) +
  ggtitle("Min size vs. number of pops.")
