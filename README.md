# Quercus_IUCN_samp_sims
Repository storing code, simulation, and parameter files that represent IUCN Red List endangered oaks for my honor's capstone project at Northern Illinois University. This project is being completed in collaboration with Emily Schumacher and Dr. Sean Hoban from the Morton Arboretum and Dr. Holly Jones from Northern Illinois University. 

#### Background 
The overall aim of this project is to contribute to practical seed sampling guidelines for creating and maintaining genetically diverse collections for botanic garden and arboreta. Informing these sampling guidelines is one way to ensure a genetically representative sample is obtained from wild populations. Prior work has found that it is important to consider species' traits like dispersal, mode of reproduction, population history, and more, when sampling from wild populations. **For this project, we focused on the genus Quercus, using IUCN Red List endangered oaks in the US as our species of interest.** Oaks are keystone species for many environments and have a high ecological importance. In addition, oaks cannot be seed banked using traditional methods, so they must be conserved through living collections. Since maintaining living collections requires extensive space and energy for gardens, creating efficient collections that represent the diversity of wild oak populations is extremely important. Thus, creating and maintaining genetically diverse collections in botanic gardens and arboreta is essential for the future survival and restoration of these rare, endangered species, and this can be achieved through proper sampling techniques. 

#### Summary
We chose 16 species from the IUCN Red List of endangered species in the US. We create species-tailored parameter values to represent each species realistically in simulation, using the software Simcoal 2. We then created scripts with R that represent sampling from the simulated populations. Here, we test the entire range of sampling for each species--from one individual, to the entire population size. From this, we will be able to determine the minimum sample size required to capture 95% of the species’ genetic diversity (a common threshold for sufficient genetic diversity). With this data, we aim to recommend a minimum sample size to capture sufficient genetic diversity for each of these species, which would be directly useful to botanic gardens and arboreta.

#### File types
**Parameter files:**
    .par .txt
    Edited in text editor Notepad++
    These are input to the software Simcoal/Simcoal2 to create genetic datasets The .par signifies parameter files.  They contain information to create the genetic datasets via a coalescent simulation, including population sizes and migration rates. Parameter files are written in the text editor Notepad++ 
    There are multiple methods of running parameter files in Simcoal 2. You can run Simcoal 2 through the command line with the prompt: SIMCOAL2_1_2 <\file_name>
    You may also open the software Simcoal 2, which will then prompt for the parameter file name
    After both cases, Simcoal 2 will ask for the number of simulation replicates and the genetic data type. Here we used 1 for the genetic data type of all simulations, representing diploid individuals. 
**Simulation output files:**
    .par .arp .gen .simparam
    Created through the software Simcoal2 after a parameter file is successfully imported into Simcoal2 and the simulation is run.  The .arp files (genetic data) are the initial dataset in Arlequin format; the .gen files are the datasets after conversion to genepop format.  The .simparam is just a mirror file of simulation parameters run. 
    Note that only the first 25 simulation files for each species are stored on the GitHub repository. The rest are stored on a local drive, due to the large number of replicates. 
**Rscripts:**
    .R 
    For this project, R scripts were used to import .arp files into R for conversion to .gen files through adegenet package, convert .gen files to genind objects through adegenet package, analyze data through functions associated with the adegenet package, run custom sampling scripts, and create figures for data visualization with package ggplot2
    R scripts should be run in the order: 1_quercus_main_sampling.R -> 2_quercus_data_processing.R -> 3_quercus_plotting.R -> 4_min_size_fst_analysis.R -> 5_regression_analysis_plot.R

### Directory contents
    Figures: contains figures created in R with ggplot2
    R_scripts: contains R scripts and R data files
    Simulations: contains parameter files for simulations and the first 25 of the simulation output files 
