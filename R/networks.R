library(MRFcov)
library(igraph)
library(tidyverse)

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
network_all <- predict_MRFnetworks(data = crete_mat, MRF_mod = crete_all)

# Graphic networks
graph_all <- graph.adjacency(crete_all$graph, weighted = T, mode = "undirected")
deg <- degree(graph_all, mode = "all")
plot.igraph(graph_all, layout = layout.circle(graph_all),
            edge.width = abs(E(graph_all)$weight),
            edge.color = ifelse(E(graph_all)$weight < 0, '#3399CC', '#FF3333'),
            vertex.size = deg,
            vertex.label.family = "sans",
            vertex.label.font	= 3,
            vertex.label.cex = 1,
            vertex.label.color = adjustcolor("#333333", 0.85),
            vertex.color = adjustcolor("#FFFFFF", .5))

