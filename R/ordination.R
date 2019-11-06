library("vegan")
library("tidyverse")

# load data (see 'get_crete_data.R' for wrangling history of this file)
crete_data <- read_csv("data_for_analysis.csv", col_types = cols(notes = "c")) %>% # col_types to avoid error parsing this column
  select(lon, lat, trans_id, site_id, species, sp_n, length) # Reorder columns and keep only relevant ones
crete_data$species <- gsub(pattern = " ", replacement = "_", x = crete_data$species) # remove space from species names

# Create a dataframe with indormative site names (north/south + date):
crete_locations <- crete_locations <- read_csv("~/Lab stuff/Crete/CreteDives.csv")
colnames(crete_locations) <- c("lon", "lat", "site", "dive")
crete_data_full <- left_join(x = crete_locations, y = crete_data, by = c("lon", "lat"), name = "site")
crete_data_full <- crete_data_full %>% 
  mutate(side = str_extract(.$site, "\\D")) %>% 
  select(site, side, trans_id, species, sp_n)
crete_data_full

# Transform to species matrix
crete_mat <- crete_data_full %>% 
  group_by(site, side, trans_id, species) %>%
  summarise(n = max(sp_n)) %>% 
  spread(species, n, fill = 0)
crete_mat

### NMDS non metric multi-dimentional scaling
# nmds_data <- decostand(crete_mat[,2:ncol(crete_mat)], method = "log")
nmds_data <- crete_mat %>% ungroup() %>% as.data.frame()
rownames(nmds_data) <- nmds_data$trans_id
nmds_data <- nmds_data %>% select(-c(trans_id, site, side))
nmds_data

# Preps for convex hulls: one of the sites (site = day diving); one of the location (south/north)
sites <- factor(crete_mat$site)
col_loc <- c("aquamarine3", "antiquewhite4","gold3", "palevioletred", "slateblue3",
             "orange2", "yellowgreen", "deeppink") # set color for each type of site
side <- factor(crete_mat$side)
col_sn <- c("cyan4", "brown")

# Run NMDS
ord <- metaMDS(nmds_data, trace = FALSE, k = 2)
stressplot(ord)

# Plot NMDS with convex hulls
plot(ord, display = "sites")
ordihull(ord, groups = sites, col = col_loc, draw = "polygon", label = F)
ordihull(ord, groups = side, col = col_sn, draw = "polygon", label = T)


