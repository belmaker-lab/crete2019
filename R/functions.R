library("googlesheets")
library("tidyverse")

# This sript contains functions used for getting.
# the bioblitz data from google drive. Which are:
# get_species_data() used to create a species data table. 
# get_list_of_locations() used to read location file.        
# gs_read_delayed() used to get individual worksheets.      
# get_data_from_location() creates a dataset from each file. 
# create_full_data() creates a raw dataset of all locations.  USE THIS IF YOU WANT DATA AS IS!
# clean_full_data() can create TWO datasets:
#      [[1]] for transect terrain attributes and [[2]] for cleaner data, if you pass 'get_terrain = T'.
#       Otherwise you just get cleaner data.
# add_species_data() adds species information columns: les, main_diet, a, b
#

get_species_data <- function() {
  library("googlesheets")
  library("tidyverse")
  species.data <- tibble::tribble(
    ~Species, ~les,      ~main_diet,  ~new_a, ~new_b,
    "Diplodus sargus",   0L, "Invertebrates",  0.0608,    2.5,
    "Siganus rivulatus",   1L,     "Herbivore",   0.022,   2.82,
    "Thalassoma pavo",   0L,   "Planktivore",  0.0092,  3.111,
    "Mycteroperca rubra",   0L,          "Fish",   0.008,  3.065,
    "Symphodus tinca",   0L, "Invertebrates", 0.02782,  2.733,
    "Chromis chromis",   0L,   "Planktivore",  0.0275,  2.703,
    "Lithognathus mormyrus",   0L,   "Detritivore",  0.0192,   2.83,
    "Serranus cabrilla",   0L, "Invertebrates",  0.0174,   2.85,
    "Gobius bucchichi",   0L, "Invertebrates",      NA,     NA,
    "Diplodus annularis",   0L, "Invertebrates",  0.0123,   3.13,
    "Diplodus vulgaris",   0L, "Invertebrates",  0.0194,   2.93,
    "Oblada melanura",   0L,   "Planktivore",   0.017,  2.934,
    "Scorpaena maderensis",   0L, "Invertebrates",   0.014,  3.065,
    "Parablennius gattorugine",   0L,   "Detritivore",  0.0084,  3.241,
    "Symphodus roissali",   0L, "Invertebrates",  0.0069,  3.386,
    "Sargocentron rubrum",   1L, "Invertebrates",  0.0571,  2.658,
    "Coris julis",   0L, "Invertebrates",  0.0082,  3.054,
    "Siganus luridus",   1L,     "Herbivore",   0.011,   3.04,
    "Serranus scriba",   0L, "Invertebrates",  0.0044,  3.409,
    "Epinephelus marginatus",   0L,          "Fish",  0.0127,  3.085,
    "Muraena helena",   0L,          "Fish",  0.0056,  2.776,
    "Pempheris vanicolensis",   1L,   "Planktivore",  0.0119,  3.026,
    "Tripterygion melanurus",   0L, "Invertebrates",      NA,     NA,
    "Balistes carolinensis",   0L, "Invertebrates",  0.0678,  2.429,
    "Scomberromorus commerson",   1L,          "Fish",   0.012,  2.812,
    "Sparisoma cretense",   0L,     "Herbivore", 0.01127,  3.052,
    "Symphodus mediterraneus",   0L, "Invertebrates",  0.0173,  2.902,
    "Apogon imberbis",   0L,   "Planktivore",   0.114,  2.117,
    "Taeniura grabata",   0L, "Invertebrates", 0.00869,      3,
    "Scarus ghobban",   1L,     "Herbivore",  0.0233,  2.919,
    "Diplodus cervinus",   0L, "Invertebrates",  0.0116,   3.14,
    "Diplodus puntazzo",   0L, "Invertebrates",  0.0044,  2.662,
    "Mullus surmuletus",   0L,   "Detritivore",  0.0083,   3.15,
    "Pomadasys incisus",   0L, "Invertebrates",  0.0199,  2.834,
    "Stephanolepis diaspros",   1L, "Invertebrates",  0.0162,   3.03,
    "Sparus aurata",   0L, "Invertebrates",  0.0266,  2.736,
    "Scorpaena porcus",   0L,          "Fish",   0.054,   2.59,
    "Parablennius incognitus",   0L, "Invertebrates",  0.0103,   3.06,
    "Tripterygion delaisi",   0L, "Invertebrates",      NA,     NA,
    "Parablennius rouxi",   0L,   "Detritivore",      NA,     NA,
    "Dasyatis pastinaca",   0L, "Invertebrates",  0.0149,   2.81,
    "Caranx crysos",   0L,          "Fish",    0.01,      3,
    "Mugilidae",   0L,   "Detritivore",  0.0104,  2.964,
    "Plotosus lineatus",   1L, "Invertebrates",   0.008,   2.95,
    "Trichonatos ovatos",   NA,   "Planktivore",      NA,     NA,
    "Parupeneus forsskali",   1L, "Invertebrates",  0.0037,  3.381,
    "Seriola dumerili",   0L,          "Fish",  0.0199,  2.964,
    "Fistularia commersonii",   1L,          "Fish",  0.0112,   2.54,
    "Boops boops",   0L,   "Planktivore", 0.01467,  2.877,
    "Cheilodipterus novemstriatus",   1L,          "Fish",      NA,     NA,
    "Epinephelus costea",   0L,          "Fish",  0.0176,  2.885,
    "Torquigener flavimaculosus",   1L, "Invertebrates",  0.0403,  2.902,
    "Lagocephalus sceleratus",   0L, "Invertebrates",   0.013,  2.933,
    "Spicara maena",   0L, "Invertebrates",  0.0089,    3.1,
    "Serranus hepatus",   0L, "Invertebrates",  0.0151,   3.04,
    "Symphodus doderleini",   0L, "Invertebrates",  0.0874,  2.028,
    "Sciaena umbra",   0L,          "Fish",  0.0069,  3.159,
    "Parablennius zvonimiri",   0L,   "Detritivore",      NA,     NA,
    "Parablennius pilicornis",   0L, "Invertebrates",      NA,     NA,
    "Pseudocaranx dentex",   0L,          "Fish",   0.131,   2.51,
    "Atherina boyeri",   0L,   "Planktivore",  0.0043,  3.187,
    "Sphyraena chrysotaenia",   1L,          "Fish",   0.012,   2.73,
    "Dicentrarchus punctatus",   0L,          "Fish", 0.00552,  3.188,
    "Pagellus acarne",   0L,   "Planktivore",  0.0186,  2.841,
    "Himantura uarnak",   1L, "Invertebrates",  0.0427,   2.94,
    "Epinephelus aeneus",   0L,          "Fish",   0.012,  2.987,
    "Sardina pilchardus",   0L,   "Planktivore", 0.00688,   3.05,
    "Dentex dentex",   0L,          "Fish",   0.013,  2.987,
    "Cryptocentrus caeruleopunctatus",   1L, "Invertebrates",      NA,     NA,
    "Abudefduf saxatilis",   0L,   "Planktivore",  0.0209,   3.12,
    "Herklotsichthys punctatus",   1L,   "Planktivore",      NA,     NA,
    "Spicara smaris",   0L,   "Planktivore",  0.0105,   2.97,
    "Belone belone",   0L,          "Fish",   9e-04,   3.04,
    "Anthias anthias",   0L,   "Planktivore",  0.0242,  2.611
  )
  return(species.data)
}

# function to read multiple worksheets
gs_read_delayed <- function(sheet, worksheets){
  library("googlesheets")
  library("tidyverse")
  result <- gs_read(sheet, worksheets)
  Sys.sleep(10)
  return(result)
}


# get_list_of_locations <- function(){
#   library("googlesheets")
#   library("tidyverse")
#   return(list(
#     michmoret = gs_title("MIchmoret April 7 2019"),
#     dor = gs_title("Dor April 8 2019"),
#     shikmona = gs_title("Shikmona April 29 2019"),
#     achziv = gs_title("Achziv April 30 2019")))}


get_data_from_location <- function(location){
  library(tidyverse)
  library(googlesheets)
  observer_tables <- location %>% 
    gs_ws_ls() %>% 
    grep(pattern = "Observer - ")
  
  
  worksheets <- map(observer_tables, ~ gs_read_delayed(location, worksheets = .x))
  
  location_observers <- do.call(bind_rows,worksheets) 
  #dor_observers <- dor_observers %>% select(-X15)
  
  location_observers_first <- location_observers[,1:7]
  location_observers_second <- location_observers[,8:14]
  
  colnames(location_observers_second) <- colnames(location_observers_first)
  
  location_observers_long <- location_observers_first %>% 
    bind_rows(location_observers_second)
  
  
  location_observers_long <- location_observers_long %>%
    filter(!is.na(TransID)) %>% 
    filter(TransID != "-----") 
  
  transect_tables <- location %>% 
    gs_ws_ls() %>% 
    grep(pattern = "Transects - ")
  
  trans_worksheets <- map(transect_tables, ~ gs_read_delayed(location, worksheets = .x))
  
  location_trans <- do.call(bind_rows,trans_worksheets)
  
  location_trans <- location_trans %>% filter(!is.na(SiteID))
  
  # location_trans %>% select(SiteID)
  
  trans_with_obs <- location_trans %>% 
    left_join(location_observers_long,by = "TransID")
  
  trans_with_obs <- trans_with_obs %>% filter(!is.na(Observer))
  
  site_meta <- gs_read(location,"Site Metadata - DO NOT EDIT") %>% filter(!is.na(TripID))
  
  site_with_trans_with_obs <- site_meta %>% 
    left_join(trans_with_obs,by = "SiteID") %>% 
    filter(TripID != "BLANK") %>% 
    filter(!is.na(Observer))
  
  
  trip_meta <- gs_read(location,"Trip Metadata - DO NOT TOUCH") %>% filter(TripID %in% site_with_trans_with_obs$TripID)
  
  location_complete <- trip_meta %>% 
    left_join(site_with_trans_with_obs,by = "TripID")
  
  return(location_complete)
  
}

# create_full_data <- function(){
#   library("googlesheets")
#   library("tidyverse")
#   complete_data_function <- do.call(what = bind_rows,lapply(get_list_of_locations(),get_data_from_location))
#   
#   complete_data_function <- complete_data_function %>% filter(!is.na(Buoy))
#   return(complete_data_function)
# }

# 
# clean_full_data <- function(complete_data_function,get_terrain = F){
#   useless.columns <- 
#     colnames(complete_data_function)[which(stringr::str_detect(colnames(complete_data_function)," ID"))]
#   
#   
#   terrain.columns <- 
#     colnames(complete_data_function)[which(stringr::str_detect(colnames(complete_data_function),"[0-9]"))]
#   
#   terrain.data <- complete_data_function %>% select(TransID,terrain.columns)
#   
#   complete_data_function_cleaner <- complete_data_function %>% select(-c(terrain.columns,useless.columns))
#   
#   complete_data_function_cleaner <- complete_data_function %>% 
#     select(-c(terrain.columns,useless.columns)) %>% 
#     group_by(TransID) %>%
#     nest() %>%
#     mutate(numeric_id = rownames(.)) %>% #add running transID number
#     unnest() %>% 
#     mutate(Observer_Name = if_else(Observer == "first",
#                                    `First Observer`,`Second Observer`), #change first/second to actual names
#            Date = lubridate::dmy(Date), #format date
#            Season = if_else(between(lubridate::month(Date),left = 3,right = 7),"Spring","Fall"), #create Season column
#            Year = lubridate::year(Date)) %>% #create Year column
#     rowwise() %>% 
#            mutate(Mean_Depth = mean(c(`Depth Start`,`Depth End`),na.rm = T), #create Mean_Depth columnn
#            Depth_Category = cut(Mean_Depth,
#                                 breaks = c(0,9,17.4,Inf), #breaks for each category
#                                 labels = c("shallow","medium","deep"))) #create Depth_Category columnn
#   traditional.names <- c("Dor" = "Habonim",
#                          "Michmoret" = "Gdor")
#   
#   complete_data_function_cleaner <- complete_data_function_cleaner %>% 
#     mutate(Location=dplyr::recode(Location,!!!traditional.names))
#   
#   if (get_terrain) return(list(terrain.data,complete_data_function_cleaner))
#   
#   return(complete_data_function_cleaner)
# }


# add_species_data <- function(complete_data_function_cleaner){
#   species.data <- get_species_data()
#   
#   bioblitz.data <- complete_data_function_cleaner %>% left_join(species.data,by = "Species")
# 
#   
#   return(bioblitz.data)
# }
# 
