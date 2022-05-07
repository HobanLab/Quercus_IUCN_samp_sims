###This script was created by Emily Schumacher
##for use in Kaylee Rosenberger's manuscript on predicting minimum 
#sample size on the 14 IUCN red listed oaks. 
#This script specifically calculates the genetic diversity levels in 
#empirical data sets. 

#####################
#     Libraries     #
#####################

library(adegenet)
library(tidyr)
library(hierfstat)
library(poppr)
library(Demerelate)


##########################
#     load in files      #
##########################
#set working directory 
setwd("G:/Shared drives/Emily_Schumacher/ten_oaks_gen")

tenoak_list <- c("QUAC", "QUHI", "QUPA", "QUTO")

#create data frame 
QU_sp_df <- matrix(nrow = length(tenoak_list), ncol = 5)

#loop to run summary stats on data files
for(sp in 1:length(tenoak_list)){
  
  #comment in if you need to convert
  arp2gen(paste0(tenoak_list[[sp]], "/", tenoak_list[[sp]], "_wild.arp"))
  
  #read in data file 
  sp_genind <- read.genepop(paste0(tenoak_list[[2]], "/", tenoak_list[[2]], "_wild.gen"), ncode = 3)
  
  sp_nomd <- missingno(sp_genind, type = "geno", cutoff = 0.25, quiet = FALSE, freq = FALSE)

  #save allelic richness in the data frame
  QU_sp_df[sp,1] <- mean(colMeans(allelic.richness(sp_nomd)$Ar))
  
  #create poppr file
  sp_poppr <- poppr(sp_nomd)
  
  #save hexp in data file 
  QU_sp_df[sp,2] <- mean(sp_poppr$Hexp[1:length(names(table(sp_genind@pop)))])
  
  #convert to pwfst 
  fst_conversion <- genind2hierfstat(sp_genind)
  
  ##calculate fst 
  fst_spp <- pairwise.neifst(fst_conversion)
  
  #now save mean in the data frame 
  QU_sp_df[sp,3] <- mean(fst_spp, na.rm = TRUE)
  QU_sp_df[sp,4] <- max(fst_spp, na.rm = TRUE)
  QU_sp_df[sp,5] <- min(fst_spp, na.rm = TRUE)
  
}

rownames(QU_sp_df) <- tenoak_list
colnames(QU_sp_df) <- c("All_Rich", "HExp", "mean_pwfst", "max_pwfst", "min_pwfst")

write.csv(QU_sp_df, "QUsp_gendiv_sumstat_df.csv")
