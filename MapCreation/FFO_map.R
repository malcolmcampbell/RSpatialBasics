# Mapping GeoHealth Fast Food Outlets
################################################################################
# Copyright A.Prof. Malcolm Campbell 2024, all rights reserved.
library(sf)
library(tmap)
library(tmaptools)
library(dplyr)

# Source: GeoHealth Lab, NZ
url <-"https://www.canterbury.ac.nz/content/dam/uoc-main-site/documents/zip-files/geohealth-laboratory/Fast-food.zip"
temp <- tempfile()
temp2 <- tempfile()
download.file(url, temp)
unzip(zipfile = temp, exdir = temp2)

NZ_COAST <- read_sf("https://github.com/malcolmcampbell/CensusMapADay/raw/main/Data/NZ_COAST.gpkg")

# read in shapefile/data using {sf}
FFO <- read_sf(temp2)
unlink(c(temp, temp2))
rm (temp, temp2, url)

# test plot
tmap_mode("view")
tm_shape ( FFO ) + tm_dots()

tmap_mode("plot")
FFOmap <-  
  tm_shape(NZ_COAST) +tm_polygons() +
  tm_shape ( FFO ) + tm_dots(col="red", shape=23) +
  tm_legend(text.size=1,title.size=1.2,position=c("left","top")) + 
  tm_layout(main.title="Fast Food Outlets, New Zealand") +
  tm_compass(position=c("right","bottom"), type="rose", size=4) +
  tm_scale_bar(width=0.15, position=c("right","bottom")) +
  tm_credits(text = "Created by A.Prof Malcolm Campbell \n
             Source: GeoHealth Laboratory, NZ") 
FFOmap

tmap_mode("view")
FFOmap
# END