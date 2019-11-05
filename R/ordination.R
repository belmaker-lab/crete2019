library("vegan")
library("tidyverse")

# load data (see 'meta.R' for wrangling history of this file)
# Calculate slope (=|Depth Start-Depth End|)
# Reorder columns
crete_data <- read_csv("data_for_analysis.csv", col_types = cols(notes = "c")) %>% # col_types to avoid error parsing this column
  mutate(slope = abs(depth_start - depth_end)) %>% 
  select(lon, lat, trans_id, site_id, depth, slope, species, sp_n, length)
crete_data

# Transform to species matrix
crete_mat <- crete_data %>% 
group_by(site_id, trans_id, species) %>% # Note it only shows sites and species (with coordinate-locations)
  summarise(n = mean(sp_n)) %>% 
  spread(species, n, fill = 0)

crete_mat
# First species is at col 2 (Apogon imberbis)

### NMDS non metric multi-dimentional scaling
# nmds_data <- decostand(crete_mat[,2:ncol(crete_mat)], method = "log")

nmds_data <- crete_mat %>% ungroup() %>% as.data.frame()
rownames(nmds_data) <- nmds_data$trans_id
nmds_data <- nmds_data %>% select(-c(trans_id, site_id))
nmds_data

sites <- factor(crete_mat$site_id)
sites <- gsub(pattern = "ASSECret", replacement = "C", x = sites, ignore.case = FALSE)
sites <- substr(sites, 1, 8)
sites
col_loc <- as.numeric(sites) # set color for each type of site (north/south)

ord <- metaMDS(nmds_data, trace = FALSE)
stressplot(ord)
plot(ord, display = "sites")
ordihull(ord, groups = sites, col = col_loc, draw = "polygon", label = F)


