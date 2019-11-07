library(MRFcov)
library(igraph)
library(tidyverse)

# Load data and select relevant columns
crete_data <- read_csv("data_for_analysis.csv", col_types = cols(notes = "c")) %>% 
  select(trans_id, species, sp_n)

# Select species
selected_fish <- c("Coris julis", "Diplodus puntazzo", "Sarpa salpa", "Siganus rivulatus",
                  "Siganus luridus", "Pagrus pagrus", "Torquigener flavimaculosus",
                  "Pterois miles", "Serranus cabrilla", "Serranus scriba", "Sparisoma cretense",
                  "Thalassoma pavo", "Epinephelus marginatus", "Epinephelus costae",
                  "Diplodus sargus", "Diplodus vulgaris", "Diplodus annularis")
filtered <- crete_data %>% filter(species %in% selected_fish)
  
# Create species matrix (with max species n)
crete_mat <- filtered %>% 
  group_by(trans_id, species) %>%
  summarise(n = max(sp_n)) %>% 
  spread(species, n, fill = 0) %>% 
  as.data.frame()
glimpse(crete_mat)

# Prepare data for MRFcov 
row.names(crete_mat) <- crete_mat$trans_id
crete_mat$trans_id <- NULL

colnames(crete_mat) # just checking
View(crete_mat)

# Run MRF
crete_net <- MRFcov(data = crete_mat, family = "gaussian")
plotMRF_hm(crete_net, main =  "Selected species")
network_all <- predict_MRFnetworks(data = crete_mat, MRF_mod = crete_net)

# Graphic networks
graph_crete <- graph.adjacency(crete_net$graph, weighted = T, mode = "undirected")
deg <- degree(graph_crete, mode = "all")
png("crete_network.png", width = 1000, height = 1000)
plot.igraph(graph_crete, layout = layout_in_circle(graph_crete),
            edge.width = abs(E(graph_crete)$weight),
            edge.color = ifelse(E(graph_crete)$weight < 0, '#3399CC', '#FF3333'),
            vertex.size = deg,
            vertex.label.family = "sans",
            vertex.label.font	= 3,
            vertex.label.cex = 1.5,
            vertex.label.color = adjustcolor("#333333", 0.85),
            vertex.color = adjustcolor("#FFFFFF", .5))
dev.off()

# source("~/R/learning_r/code_snips/opendir.R")
# opendir()
