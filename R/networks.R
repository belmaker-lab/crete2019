library(tidyverse)
library(MRFcov)

# Load data and select relevant columns
crete_data <- read_csv("data_for_analysis.csv", col_types = cols(notes = "c")) %>% 
  select(trans_id, species, sp_n) %>% 
  ##### s

# Create species matrix (with max species n)
crete_mat <- crete_data %>% 
  group_by(trans_id, species) %>%
  summarise(n = max(sp_n)) %>% 
  spread(species, n, fill = 0) %>% 
  as.data.frame()

# Prepare data for MRFcov 
row.names(crete_mat) <- crete_mat$trans_id
crete_mat$trans_id <- NULL

# Select species
colnames(crete_mat)
crete_mat

# Run MRF
crete_all <- MRFcov(data = crete_mat, family = "gaussian")
plotMRF_hm(crete_all, main =  "All of Crete")
