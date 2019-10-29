library("here")

source(here("R","functions.R"))

crete_data <- get_data_from_location(gs_title('Crete October 2019')) %>% clean_full_data(get_terrain = T)

nz <- read_csv("Crete_Locations.csv")

full <- nz %>% mutate(Site = as.character(Site)) %>% 
right_join(crete_data,by = c("Date","Site"))
