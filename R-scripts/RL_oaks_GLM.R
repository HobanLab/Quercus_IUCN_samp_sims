
# This code does this following: 
# 1. restructures simulation output
# 2. constructs a generalized linear model(GLM)
# 3. calculates pairwise contrasts of model interaction terms
# 4. makes model predictions and plots them for each simulation type
# 5. calculates the minimum sample size needed for each taxon/simulation type

# Written by Alissa Brown; 19 Dec 2021

require(dplyr)
require(tidyr)
require(ggplot2)
require(gridExtra)
require(ggthemes)
require(emmeans)

# READ AND RESTRUCTURE DATA ---------------------------------------------------
load('data/quercus_num_alleles_capt_orig.RData')
capt_orig <- alleles_capt_all_quercus

load('data/quercus_num_alleles_capt_alt.RData')
capt_alt <- alleles_capt_all_quercus

load('data/quercus_total_alleles_orig.RData')
total_orig <- final_alleles_all_quercus

load('data/quercus_total_alleles_alt.RData')
total_alt <- final_alleles_all_quercus

taxa <- read.csv('data/all_existing_by_sp_df.csv', stringsAsFactors = FALSE)
taxa <- as.vector(taxa$X)

rm(alleles_capt_all_quercus, final_alleles_all_quercus)

# ORIGINAL SIMULATION PARAMETERS
# create df of number of alleles captured
n_samples <- dim(capt_orig)[1]
n_species <- dim(capt_orig)[3]
n_iter <- dim(capt_orig)[2]

captured_list <- list()
for(i in 1:n_species){
  captured_list[[i]] <- as.data.frame(t(capt_orig[,,i]))
  captured_list[[i]] <- pivot_longer(captured_list[[i]], 
                                     cols = 1:ncol(captured_list[[i]]), 
                                     names_to = 'n_samp', 
                                     values_to = 'n_capt')
  captured_list[[i]]$n_samp <- as.numeric(sub('.', '', captured_list[[i]]$n_samp))
  captured_list[[i]]$taxon <- taxa[i]
}
captured_df <- bind_rows(captured_list)

# create df of total number of alleles
total_list <- list()
for(i in 1:n_species){
  total_list[[i]] <- as.data.frame(t(total_orig[,,i]))
  total_list[[i]] <- pivot_longer(total_list[[i]], 
                                  cols = 1:ncol(total_list[[i]]), 
                                  names_to = 'n_samp', 
                                  values_to = 'n_total')
  total_list[[i]]$n_samp <- as.numeric(sub('.', '', total_list[[i]]$n_samp))
  total_list[[i]]$taxon <- taxa[i]
}
total_df <- bind_rows(total_list)

# bind dfs together (my computer won't let me use left_join b/c of space issues)
# so checking to see if columns match, and if so, then doing cbind
identical(total_df[,c(1,3)], captured_df[,c(1,3)])
df <- cbind(captured_df, total_df[,'n_total'])
df$fail <- df$n_total - df$n_capt


# ALTERNATIVE SIMULATION PARAMETERS
# create df of number of alleles captured
captured_list <- list()
for(i in 1:n_species){
  captured_list[[i]] <- as.data.frame(t(capt_alt[,,i]))
  captured_list[[i]] <- pivot_longer(captured_list[[i]], 
                                     cols = 1:ncol(captured_list[[i]]), 
                                     names_to = 'n_samp', 
                                     values_to = 'n_capt')
  captured_list[[i]]$n_samp <- as.numeric(sub('.', '', captured_list[[i]]$n_samp))
  captured_list[[i]]$taxon <- taxa[i]
}
captured_df <- bind_rows(captured_list)

# create df of total number of alleles
total_list <- list()
for(i in 1:n_species){
  total_list[[i]] <- as.data.frame(t(total_alt[,,i]))
  total_list[[i]] <- pivot_longer(total_list[[i]], 
                                  cols = 1:ncol(total_list[[i]]), 
                                  names_to = 'n_samp', 
                                  values_to = 'n_total')
  total_list[[i]]$n_samp <- as.numeric(sub('.', '', total_list[[i]]$n_samp))
  total_list[[i]]$taxon <- taxa[i]
}
total_df <- bind_rows(total_list)

# bind dfs together
identical(total_df[,c(1,3)], captured_df[,c(1,3)])
df_alt <- cbind(captured_df, total_df[,'n_total'])
df_alt$fail <- df_alt$n_total - df_alt$n_capt


# bind original and alt dfs together
df$type <- 'orig'
df_alt$type <- 'alt'
df_all <- rbind(df, df_alt)

# there are zeros for n_total and n_capt for two species (qugr, quhi)
# because they have small population sizes, so when n_samp
# exceeds their pop size, n_total (and n_capt) becomes 0. there are no 
# observations where n_total is not zero but n_capt is zero, so can replace
# all zeros in n_total and n_capt with NAs. Then replace # fail with NA if 
# n_total (or n_capt) is zero. 
df$n_total <- ifelse(df$n_total == 0, NA, df$n_total)
df$n_capt <- ifelse(df$n_capt == 0, NA, df$n_capt)
df$fail <- ifelse(is.na(df$n_total), NA, df$fail)

saveRDS(df_all, 'RL_oaks_GLM_df_V2.RDS')
df <- readRDS('RL_oaks_GLM_df_V2.RDS')


# RUN MODEL --------------------------------------------------------------------
y <- as.matrix(df[,c('n_capt','fail')])
mod <- glm(y ~ n_samp + taxon + type +
             n_samp:taxon + 
             type:taxon +
             n_samp:taxon:type, 
           family = binomial(link = 'logit'), 
           data = df)
saveRDS(mod, 'RL_oaks_mod.RDS')

# PAIRWISE CONTRASTS
emmeans(mod, ~type | taxon)


# PLOT RESULTS -----------------------------------------------------------------
# PLOT PREDICTION CURVES
# prepare prediction dataframe
taxa <- df[['taxon']]
taxa <- unique(taxa)
new_df <- data.frame(n_samp = rep(seq(1, 500, by = 10), 28),
                     taxon = rep(rep(taxa, each = 50), 2),
                     type = rep(c('orig', 'alt'), each = 700))
new_df$pred <- predict(mod, new_df, type = 'response')

# remove out of sample predictions for qugr and quhi
new_df$pred <- ifelse(new_df$taxon == 'QUGR' & 
                        new_df$type == 'orig' & 
                        new_df$n_samp > 325, NA, new_df$pred)
new_df$pred <- ifelse(new_df$taxon == 'QUHI' & 
                        new_df$n_samp > 300, NA, new_df$pred)
saveRDS(new_df, 'RL_oaks_predictions_for_plotting.RDS')

# PLOT ORIGINAL SIMULATIONS 
# rename taxon labels for plotting purposes
new_df$taxon <- factor(new_df$taxon, labels = c(
  'Q. acerifolia', 'Q. arksanana', 'Q. austrina', 'Q. boyntonnii', 'Q. carmenensis',
  'Q. cedrosensis', 'Q. engelmannii', 'Q. georgiana', 'Q. graciliformis', 
  'Q. havardii', 'Q. hinckleyii', 'Q. oglethorpensis', 'Q. pacifica', 'Q. tomentella'
))
colnames(new_df)[2] <- 'Species'

use_colors <- colorblind_pal()(8)
use_colors <- use_colors[-5]
use_colors <- c(use_colors, use_colors)

df_orig <- new_df[new_df$type == 'orig', ]
ggplot(data = df_orig, aes(x = n_samp, y = pred, color = Species, linetype = Species)) + 
  geom_line(size = 1, alpha = 0.7) + 
  scale_color_manual(values = use_colors) +
  scale_linetype_manual(values = c(rep(1, 7), rep(2, 7))) +
  geom_hline(yintercept = 0.95, linetype = 3, 
             color = 'red', alpha = 0.5) +
  ylab('Proportion of alleles captured\n') +
  xlab('\nNumber of unique individuals sampled') +
  theme_bw() +
  theme(legend.key.width = unit(1, 'cm'),
        legend.key.height = unit(0.75, 'line'),
        axis.title = element_text(size = 8),
        axis.text = element_text(size = 6),
        legend.text = element_text(size = 6),
        legend.title = element_text(size = 8),
        legend.title.align = 0.5)
ggsave('glm_preds_lines_orig.png', width = 6, height = 3, units = 'in')

# PLOT ALTERNATIVE SIMULATIONS 
df_alt <- new_df[new_df$type == 'alt', ]
ggplot(data = df_alt, aes(x = n_samp, y = pred, color = Species, linetype = Species)) + 
  geom_line(size = 1, alpha = 0.7) + 
  scale_color_manual(values = use_colors) +
  scale_linetype_manual(values = c(rep(1, 7), rep(2, 7))) +
  geom_hline(yintercept = 0.95, linetype = 3, 
             color = 'red', alpha = 0.5) +
  ylab('Proportion of alleles captured\n') +
  xlab('\nNumber of unique individuals sampled') +
  theme_bw() +
  theme(legend.key.width = unit(1, 'cm'),
        legend.key.height = unit(0.75, 'line'),
        axis.title = element_text(size = 8),
        axis.text = element_text(size = 6),
        legend.text = element_text(size = 6),
        legend.title = element_text(size = 8),
        legend.title.align = 0.5)
ggsave('glm_preds_lines_alt.png', width = 6, height = 3, units = 'in')


# DETERMINE MINIMUM SAMPLE SIZE NEEDED FOR EACH SPECIES X TYPE
# number of samples needed to reach 95% alleles captured
new_df_large <- data.frame(n_samp = rep(seq(1, 500, by = 1), 28),
                     taxon = rep(rep(taxa, each = 500), 2),
                     type = rep(c('orig', 'alt'), each = 7000))
new_df_large$pred <- predict(mod, new_df_large, type = 'response')
new_df_sub <- new_df_large[new_df_large$pred >= 0.95,]

# there are 4 combinations of taxon and type that do not ever reach 95%, so you'll 
# need to add 4 rows to the bottom of this dataframe for them to show up in 
# the summary table
new_df_sub[nrow(new_df_sub)+1, ] <- c(NA, 'QUCE', 'orig', 1)
new_df_sub[nrow(new_df_sub)+1, ] <- c(NA, 'QUEN', 'orig', 1)
new_df_sub[nrow(new_df_sub)+1, ] <- c(NA, 'QUEN', 'alt', 1)
new_df_sub[nrow(new_df_sub)+1, ] <- c(NA, 'QUHA', 'alt', 1)

which95 <- new_df_sub %>% 
  group_by(taxon, type) %>% 
  slice_min(pred)
which95 <- which95 %>% select(-pred)
which95$type <- factor(which95$type, labels = c('Alternative', 'Original'))

which95 <- pivot_wider(which95, names_from = type, values_from = n_samp)
which95 <- which95[,c(1,3,2)]

# calculate percent difference
which95[,c('Original', 'Alternative')] <- lapply(which95[,c('Original','Alternative')], as.numeric)
which95$percent_change <- round(((which95$Alternative - which95$Original) / which95$Original) * 100, digits = 1)

write.csv(which95, 'glm_results_min_sample_size_by_species.csv', row.names = FALSE)
