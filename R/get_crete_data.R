library("here")

source(here("R","functions.R"))

crete_data <- get_data_from_location(gs_title('Crete October 2019'))
crete_data_clean <- crete_data %>% clean_full_data()

nz <- read_csv(here("CreteDives.csv")) %>% mutate(Date = lubridate::dmy(Date))

full <- nz %>% mutate(Site = as.character(Site)) %>% 
  right_join(crete_data_clean, by = c("Date","Site")) %>% 
  select(-c("Lat(N)", "Lon(E)"))

write_csv(full, here("UVC_crete_2019.csv"))

terrain_data <- clean_full_data(crete_data, get_terrain = T)[[1]]
