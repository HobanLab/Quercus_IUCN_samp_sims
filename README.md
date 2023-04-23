# Quercus_IUCN_samp_sims
**Project: Species-tailored sampling guidelines remain the most efficient method to conserve genetic diversity ex situ: a study on threatened oaks.**  
Repository storing code, simulation, and parameter files that represent 14 IUCN Red List endangered oaks. This project was completed in collaboration by Kaylee Rosenberger, Emily Schumacher, Dr. Sean Hoban, and Dr. Alissa Brown from the Morton Arboretum.  
  
Results published in [Biological Conservation](https://doi.org/10.1016/j.biocon.2022.109755). Kaylee Rosenberger, Emily Schumacher, Alissa Brown, Sean Hoban (2022). Species-tailored sampling guidelines remain an efficient method to conserve genetic diversity ex situ: A study on threatened oaks. *Biological Conservation*, 275.  

### Overview
The overall aim of this project is to contribute to practical seed sampling guidelines for creating and maintaining genetically diverse collections for botanic garden and arboreta. Informing these sampling guidelines is one way to ensure a genetically representative sample is obtained from wild populations. Prior work has found that it is important to consider species' traits like dispersal, mode of reproduction, population history, and more, when sampling from wild populations. For this project, we focused on the genus Quercus (oaks) and studied 14 species that the IUCN Red List describes as vulnerable. Oaks are keystone species for many environments and have a high ecological importance. In addition, oaks cannot be seed banked using traditional methods, so they must be conserved through living collections. Since maintaining living collections requires extensive space and energy for gardens, creating efficient collections that represent the diversity of wild oak populations is extremely important. Thus, creating and maintaining genetically diverse collections in botanic gardens and arboreta is essential for the future survival and restoration of these rare, endangered species, and this can be achieved through proper sampling techniques.

Here, we aim to determine if closely-related species (within the same genus) with similar biology, dispersal, and life history traits but different ranges and population sizes would have similar minimum sample sizes.

There were three main goals in this project: 
1) Determine minimum sample sizes to capture 95% diversity for 14 threatened oaks
2) Determine if one minimum sample size can fit all 14 oaks studied
3) Determine if parameter uncertainty impacts the minimum sample size 


### Summary
We chose 14 species of oaks from the IUCN Red List of Endangered Species in the US. Each of these oaks the IUCN Red List describes as vulnerable. We created species-tailored parameter values to represent each species realistically in simulation, using the software fastsimcoal. In addition, we run alternative simulations for each species, varying the parameter value that we had the least amount of confidence in, so that we can account for estimations within our parameter values. We then created scripts with R that represent sampling from the simulated populations. Here, we tested a broad entire range of sampling for each species--from one individual, to 500 individuals. From this, we determine the minimum sample size required to capture 95% of the species’ genetic diversity (a common threshold for sufficient genetic diversity). With this data, we aim to recommend a minimum sample size to capture sufficient genetic diversity for each of these species, which would be directly useful to botanic gardens and arboreta. Furthermore, we aim to determine whether one minimum sample size can be recommended to sufficiently capture the diversity of all of these vulnerable oaks. 

We also determine if changing the parameter values used for simulation significantly impacts the minimum sample size required, by creating 'alternative' simulations. In the alternative simulations for each species, we varied a parameter value that we had the least amount of confidence in, so that we can account for estimations within our parameter values and determine how much the parameters chosen for simulation impact the minimum sample size.

Finally, we run additional simulations to test the impact of a constant parameter in all simulations, where we vary the time since populations merged. In our simulations, we use a timeframe of 10,000 generations, so we changed the value to 500 generations for 3 test species. 

### Analysis
We ran a generalized linear model (GLM) to determine the minimum sample sizes needed to adequately capture genetic diversity for each of the 14 oak species. We calculated pairwise contrasts using the emmeans package (Lenth, 2021) to determine whether the difference between the number of alleles captured between the two simulation types (original and alternative) was significant for each taxon.


### File types
**Parameter files:**    
    .par .txt  
    Edited in text editor Notepad++  
    These are input to the software fastsimcoal to create genetic datasets The .par signifies parameter files.  They contain information to create the genetic datasets via a coalescent simulation, including population sizes and migration rates. Parameter files are written in the text editor Notepad++   
    You can run fastsimcoal through the command line with the prompt: fsc26 <\file_name> -g 1 -n 1000  
    Here we used 1 for the genetic data type of all simulations, representing diploid individuals and 1000 for 1000 simulation replicates.  
    
**Simulation output files:**    
    .par [.arp .gen .simparam]  
    Created through the software Simcoal2 after a parameter file (.par) is successfully imported into Simcoal2 and the simulation is run.  The .arp files (genetic data) are the initial dataset in Arlequin format; the .gen files are the datasets after conversion to genepop format.  The .simparam is just a mirror file of simulation parameters run.  
    Note that only the .par files for each species are stored on the GitHub repository. The simulation output files are stored on a local drive, due to the large number of replicates.   
    
**Rscripts:**    
    .R .Rdata  
    For this project, R scripts were used to import .arp files into R for conversion to .gen files through adegenet package, convert .gen files to genind objects through adegenet package, analyze data through functions associated with the adegenet package, run custom sampling scripts, and create figures for data visualization with package ggplot2  

### Directory contents
**Alternative_sim_files:** contains simulation parameter files for the alternative set of simulation parameters  
**Original_sim files:** contains simulation parameter files for the original set of simulation parameters  
**Empirical_data_files:** contains adegenet files for several species where empirical population genetic data was availabe for comparison to our simulated data
**R-scripts:** contains R-scripts used for importing and converting data, sampling, data analysis, and data visualization   
R scripts should be run in the order:   
    1_quercus_main_sampling.R (imports and converts files, runs main sampling loop)   
    2_quercus_data_processing.R (concatenates data for all species into one large, processed dataframe for ease of use in the following scripts)  
    3_min_size_fst_analysis.R (calculates minimum sample sizes and Fst of each species)  
    4_RL_oaks_GLM.R (runs GLM on the data, creates figures from the GLM output)  
    5_RL_oaks_maps.R (creates maps of each species distribution, which are saved in the Mapping folder below)  
    
There are also various .Rdata files which store the data we generated from simulations, sampling, and other processing in R:   
    quercus_final_results_alt.Rdata: 3D matrix storing the proportion of alleles captured during sampling for each species for the alternative simulations, created at the end of 1_quercus_main_sampling.R  
    quercus_final_results_orig.Rdata: 3D matrix storing the proportion of alleles captured during sampling for each species for the original simulations, created at the end of 1_quercus_main_sampling.R  
    quercus_total_alleles_alt.Rdata: 3D matrix storing the total alleles present for each species for the alternative simulations  
    quercus_total_alleles_orig.Rdata: 3D matrix storing the total alleles present for each species for the original simulations  
    quercus_num_alleles_capt_alt.Rdata: 3D matrix storing the number of alleles captured for each species in the alternative simulations (as opposed to proportion)  
    quercus_num_alleles_capt_orig.Rdata: 3D matrix storing the number of alleles captured for each species in the original simulations (as opposed to proportion)  
    combined_quercus_alt.Rdata: data frame made by concatenating all species matrices from quercus_final_results_alt.Rdata. the data frame is used to plot in ggplot  
    combined_quercus_orig.Rdata: data frame made by concatenating all species matrices from quercus_final_results_orig.Rdata. the data frame is used to plot in ggplot  
    quercus_fst_altern.Rdata: saves Fst data for each species in the alternative simulations   
    quercus_fst_orig.Rdata: saves Fst data for each species in the original simulations  
    fst_processed.Rdata: processed Fst data by taking the mean Fst for each species  
   
**Figures_tables:** contains data visualization figures in .png, .pdf, and .svg format  
**Mapping:** contains data used for mapping, R scripts to generate maps, as well as maps generated   
    
