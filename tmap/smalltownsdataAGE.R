# SMALL TOWNS
# copyright Assoc.Prof. Malcolm Campbell 2023. August.
# to be updated with 2023 Census data in late 2024.
library(tidyverse)
library(sf, tmap)
library(tidyr)

# Read the census data (2018 - from nz.stat - AGE)
census_data <- read_csv ( "https://github.com/malcolmcampbell/RSpatialBasics/raw/master/Data/broad_age_UrbanRural.csv" )
census_data$UR2018_V1_ <- census_data$AREA
census_data <- census_data %>%
  select (-c(YEAR, SEX, ETHNICITY, AGE, `Ethnic group`, `Sex`))

# read in Rural-Urban shapefile
# https://datafinder.stats.govt.nz/layer/92218-urban-rural-2018-generalised/data/
UrbRur2018_sf <- st_read ("https://github.com/malcolmcampbell/RSpatialBasics/raw/master/Data/UrbRur2018_sf.gpkg")
head(UrbRur2018_sf)
names(UrbRur2018_sf)

# Merge census data with Urban Rural Shapefile / Geopackage
UrbRur2018_sf <- left_join ( UrbRur2018_sf, census_data, by = "UR2018_V1_")

# take out the Chatham Islands (sorry Chatham Islands...)
testUrbRur2018_sf <- UrbRur2018_sf %>%
  filter ( Area!="Waitangi (Chatham Islands" &
           Area!="Inland water Chatham Islands" &
           Area!="Other rural Chatham Islands" )


# SPLIT into YEARS
UrbRur2006_sf <- UrbRur2018_sf %>%
  filter ( Year==2006)
UrbRur2013_sf <- UrbRur2018_sf %>%
  filter ( Year==2013)
UrbRur2018_sf <- UrbRur2018_sf %>%
  filter ( Year==2018)

#####################################
# ?spread command
# http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/
UrbRur2018_sf_wide <- spread (UrbRur2018_sf, `Age group`, Value)

# calculating proportions data
UrbRur2018_sf_wide <- UrbRur2018_sf_wide %>%
  mutate (ageunder15 = c((`Under 15 years`      / `Total people - age group`)*100),
          age15to29 = c((`15-29 years`       / `Total people - age group`)*100),
          age30to64 = c((`30-64 years`       / `Total people - age group`)*100),
          age65plus = c((`65 years and over` / `Total people - age group`)*100)
          )

# setting the maps to interactive
tmap_mode("view")

#tm_shape(UrbRur2018_sf_wide) + tm_polygons(col = "ageunder15", palette = "Greens")
#tm_shape(UrbRur2018_sf_wide) + tm_polygons(col = "age15to29", palette = "Greens")
#tm_shape(UrbRur2018_sf_wide) + tm_polygons(col = "age30to64", palette = "Greens")
#tm_shape(UrbRur2018_sf_wide) + tm_polygons(col = "age65plus", palette = "Greens")

age65plusUrbRur2018_sf_wide <- tm_shape(UrbRur2018_sf_wide) + tm_polygons(col = "age65plus", palette = "Greens",
       popup.vars = c("Settlement Name" = "UR2018_V_1",
                      "Under 15 (%)" = "ageunder15",
                      "15 to 29 (%)" = "age15to29",
                      "30 to 64 (%)" = "age30to64",
                      "Over 65 (%)" = "age65plus",
                      "Over 65 (n)" = "65 years and over"),
       id="UR2018_V_1") 
age65plusUrbRur2018_sf_wide

tmap_save(tm=age65plusUrbRur2018_sf_wide, filename="UrbRur2018_sf_wide.jpg")
# to find the file
getwd()
#END - AUGUST 2024