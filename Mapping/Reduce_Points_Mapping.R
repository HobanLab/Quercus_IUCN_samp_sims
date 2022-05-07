###########This script was created to plot maps of the 14 threatened oak species in ArcGIS.
#########We downloaded occurrence records from personal records and the IUCN red list 
########before loading them into R and removing points within 20 km of each other. 
#######Finally, exported data frames of cleaned occurrence records which were plotted in ArcGIS 
######and finaly maps were generated and placed in the supplemental text of the manuscript. 

###################
#### Libraries ####
###################
library(geosphere)

#########################################
### Reduce Points by Autocorrelation ####
#########################################
##create a list to store all occurrence records 
oak_occ <- list()

##list out all species 
oak_names <- c("QUAC", "QUAR", "QUAU", "QUBO",
               "QUCA", "QUCE", "QUEN", "QUGE",
               "QUGR", "QUHA", "QUHI", "QUOG",
               "QUPA", "QUTO")

##project spdf list 
oak_pcs_spdf_list <- list()

##list for saving occurrences 
occurence_no_auto <- list()

##list of data frames 
oak_red_dfs <- list()

##Projection string - Albers Equal Area Conic 
projection <- c("+proj=aea +lat_1=20 +lat_2=60 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs")

###This loop pulls in occurrence records for each species, projects them to the 
##Albers Equal Area Conic projection, and then reduces points that are within 20 km of each other
#Then writes out the reduced coordinates in a data frame 
for(sp in 1:length(oak_names)){
  
  ##load in occurrence records for each species 
  oak_occ <- read.csv(paste0(oak_names[[sp]], "/", oak_names[[sp]], "_occ.csv"))
  
  ##create spatial point data frame for each species 
  oak_occ_spdf <- matrix(nrow = length(oak_occ[,1]), ncol = length(oak_occ[,1]))
  
  ##interior loop to calculate the distance between each point for each species and convert to whether 
  ##The distance is less than or greater than 20 km 
  for(lon in 1:length(oak_occ[,1])){
    for(lat in 1:length(oak_occ[,1])){
      
      oak_occ_spdf[lon,lat] <- (distm(oak_occ[lon,2:3], oak_occ[lat,2:3])/1000) < 20
      
    }
  }
  
  ##create tri matrix of all the true and false values for each point 
  oak_occ_spdf[lower.tri(oak_occ_spdf, diag=TRUE)] <- NA
  
  ##now determine the points that are within 20 km of each other 
  auto_cols <- colSums(oak_occ_spdf, na.rm=TRUE) == 0
  
  ##now subset the the original coordinate data frame with the individuals reduced by distance  
  occurence_no_auto <- oak_occ[auto_cols,]
  
  ##create data frames of reduced individual data frames 
  oak_red_dfs <- data.frame(occurence_no_auto)
  
  ##write out data frame of occurrence records for each species 
  write.csv(oak_red_dfs, paste0(oak_names[[sp]], "/", oak_names[[sp]], "_occ_red.csv"))
  
}
