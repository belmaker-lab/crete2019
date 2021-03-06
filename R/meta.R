library("tidyverse")

# LOCATIONS MAP
library(sf)
library(extrafont)

crete_locations <- read_csv("~/Lab stuff/Crete/CreteDives.csv") %>% 
  mutate(site_name = str_extract(.$Name, "\\d\\d"))
colnames(crete_locations) <- c("lon", "lat", "site", "dive", "site_name")
crete_locations$site_name <- as.factor(crete_locations$site_name)
crete_locations

# Load shapefile
theme_set(theme_bw())
gr_shp <- st_read("~/Lab stuff/Crete/greece shp/Crete.shp")

# png("Crete_locations.png", height = 800, width = 1600, bg = 'transparent')
ggplot(crete_locations) +
  geom_sf(data = gr_shp) + 
  geom_jitter(aes(x = lon, y = lat, fill = site_name), cex = 10, alpha = 0.5, shape = 24) + 
  geom_text(aes(x = lon, y = lat, label = crete_locations$site_name), check_overlap = TRUE) +
  labs(title = "Crete survey locations", x = "", y = "", fill = "Site (date)") + 
  scale_fill_brewer(palette = "Dark2") +
  theme(text = element_text(size = 16,  family = "Segoe UI"))
# dev.off()

# source("~/R/code_snips/opendir.R")
# opendir()

# TRIP/SAMPLING META DATA
crete_data <- read_csv("UVC_crete_2019.csv", col_types = cols(Notes = "c")) %>%
  mutate(Species = stringr::str_to_sentence(Species)) %>% # fix Species == "ThalASSoma pavo"
  filter(Observer == "first") %>% # Note: only first observer data included!
  select("lon", "lat", "TransID", "SiteID",  "Depth Start", "Depth End",
         "Species", "Confidence", "Amount", "Length", "Depth_Category", "Notes") %>%
  mutate_all(~replace(., . == "Epinephelus costea", "Epinephelus costae"))
colnames(crete_data) <- c("lon", "lat", "trans_id", "site_id", "depth_start", "depth_end", "species",
                          "confidence", "sp_n", "length", "depth", "notes")
crete_data
# write_csv(crete_data, "data_for_analysis.csv")

crete_species <- crete_data %>% distinct(species)
count(crete_species)
# 71 species (2 observers)
# 59 species (first observer only)

transects <- crete_data %>% distinct(trans_id)
count(transects)
# 167 transects
count(transects)/8
count(transects)/8

no_of_dives <- 6*3 + 2*2 # 6 days with 3 dives and 2 days with 2 dives 
no_of_dives
# 22 dives (sites)

no_of_days_with_reps <- 6*3*3 + 3*1*2 + 2*1*2 # days*dives_per_day*teams_per_dive
no_of_days_with_reps
# 64 repetitions


