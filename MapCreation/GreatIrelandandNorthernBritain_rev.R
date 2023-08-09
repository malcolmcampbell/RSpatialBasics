# Associate Professor Malcolm Campbell
# Creative Commons License
# This work is licensed under a Creative Commons 
# Attribution-ShareAlike 4.0 International License.

# NOTE: you may need the command below to install {RNaturalEarthHiRes}
# install.packages("rnaturalearthhires", repos = "http://packages.ropensci.org", type = "source")

library(rnaturalearth)
library(rnaturalearthdata)
library(rnaturalearthhires)
library(sf)
library(tmap)
library(tmaptools)

# what does ?setwd() do?
# a:
?setwd()

# set your working directory (using the command above). Then check it has worked.
?getwd()


# what does this command (?ne_countries) allow us to map? (Note: the ? is the help command)
# a:
?ne_countries

UK <- ne_countries(country="United Kingdom", returnclass = "sf", scale=10)
plot(st_geometry(UK))

IRL <- ne_countries(country="Ireland", returnclass = "sf", scale=10)
plot(st_geometry(IRL))

# what is the differnce between ne_countries and ne_states?
# a:
?ne_states

# using the st_union command to join geographic units together
# how do we find the help ? file for the st_union command?
# a:
NI <- ne_states(geounit = "Northern Ireland", returnclass = "sf")
NI_union <- st_union(NI)
NI_union <- st_make_valid(NI_union)

SCOT <- ne_states(geounit = "SCOTLAND", returnclass = "sf")
SCOT_union <- st_union(SCOT)
SCOT_union <- st_make_valid(SCOT_union)

ENG <- ne_states(geounit = "England", returnclass = "sf")
ENG_union <- st_union (ENG)
ENG_union <- st_make_valid(ENG_union)

WALES <- ne_states(geounit = "Wales", returnclass = "sf")
WALES_union <- st_union (WALES)
WALES_union <- st_make_valid(WALES_union)

EandW_union <- st_union(WALES_union, ENG_union)
EandW_union <- st_make_valid(EandW_union)


IRELAND <- st_union(IRL, NI_union)
GINB <- st_union(IRELAND, SCOT_union)

# using the tmap library we can map things using the following commands.
# 1.) tm_shape(then enter the shape in the brackets here)
# 2.) tm_fill () - which fills the polygons
tm_shape(GINB) +tm_fill()

# OR....

# 1.) tm_shape(then enter the shape in the brackets here)
# 2.) tm_polygons () - which draws the polygons
tm_shape(GINB) + tm_polygons(border.col = "seagreen2")+
  tm_shape(ENG_union)  + tm_polygons(border.col="black", lty=3, col="white")

tm_shape(GINB) + tm_polygons(border.col = "seagreen2")+
  tm_shape(EandW_union) + tm_polygons(border.col="black", lty=3, col="white") 
tm_style("natural")

# We can also use the tm_style command
#
#"white"	White background, commonly used colors (default)
#"gray"/"grey"	Grey background, useful to highlight sequential palettes (e.g. in choropleths)
#"natural"	Emulation of natural view: blue waters and green land
#"bw"	Greyscale, obviously useful for greyscale printing
#"classic"	Classic styled maps (recommended)
#"cobalt"	Inspired by latex beamer style cobalt
#"albatross"	Inspired by latex beamer style albatross
#"beaver"	Inspired by latex beamer style beaver

tm_shape(GINB) +  tm_polygons(border.col = "seagreen2")+
  tm_shape(EandW_union) + tm_polygons(border.col="black", lty=3, col="white") +
  tm_style("natural") +
  tm_layout(title="The United Brexit Kingdom of \nGreat Ireland & Northern Britain")+
  tm_credits("Thanks to the referendum results of 23 June 2016", position="left", size=0.5)

# plus scale bar (tm_scale_bar) and compass (tm_compass)
tm_shape(GINB) + tm_polygons(border.col = "black")+
  tm_shape(EandW_union) + tm_polygons(border.col="black", lty=3, col="white") +
  tm_logo(file="https://raw.githubusercontent.com/malcolmcampbell/RSpatialBasics/master/MapCreation/homemadeflag.png", position=c("left","top"), height=5)+
  tm_credits("Thanks to the referendum results of 23 June 2016\n
             libraries {sf},{tmap},{tmaptools}, {rnaturalearth},\n 
             {rnaturalearthhisres}, {rnaturalearthdata}", position=c("left","top"), size=0.5) +
  tm_compass(position = "left", type="rose") +
  tm_scale_bar(width=0.15, position=c("left","bottom")) +
  tm_style("natural", title="The United Brexit Kingdom of \nGreat Ireland & Northern Britain") 

# adding the "capitals"
# first, a vector of the places
# then, using the geocode_OSM command
# finally, turn it into a Simple Features (sf) object using st_as_sf
capitals <- c("Dublin", "Belfast", "Edinburgh")
capitals <- geocode_OSM(capitals)
capital <- st_as_sf(capitals, coords=c("lon", "lat"), crs=4326)


# plus Capitals - using the tm_dots command
tm_shape(GINB) + tm_polygons(border.col = "black")+
  tm_shape(EandW_union) + tm_polygons(border.col="black", lty=3, col="white") +
  tm_shape(capital) + tm_dots(col="red", size=0.4) + tm_text("query", size=0.75, xmod=-1.5, ymod=-.5) +
  tm_style("natural") +
  tm_layout(title="The United Brexit Kingdom of \nGreat Ireland & Northern Britain")+
  tm_logo(file="https://raw.githubusercontent.com/malcolmcampbell/RSpatialBasics/master/MapCreation/homemadeflag.png", position=c("left","top"), height=5)+
  tm_credits("Thanks to the referendum results of 23 June 2016", position=c("left","top"), size=0.5) +
  tm_compass(position=c("right","bottom"), type="rose", size=4) +
  tm_scale_bar(width=0.15, position=c("left","bottom")) 

brexitkingdom <- tm_shape(GINB) + tm_polygons(border.col = "black")+
  tm_shape(EandW_union) + tm_polygons(border.col="black", lty=3, col="white") +
  tm_shape(capital) + tm_dots(col="red", size=0.4) + tm_text("query", size=0.75, xmod=-1.5, ymod=-.5) +
  tm_logo(file="https://raw.githubusercontent.com/malcolmcampbell/RSpatialBasics/master/MapCreation/homemadeflag.png", position=c("left","top"), height=5)+
  tm_credits("Thanks to the referendum results of 23 June 2016\n This example is purely fictional... for now", position=c("left","top"), size=0.5) +
  tm_compass(position=c("right","bottom"), type="rose", size=4) +
  tm_scale_bar(width=0.15, position=c("left","bottom")) +
  tm_style("natural", title="The United Brexit Kingdom of \nGreat Ireland & Northern Britain") 

# saving the output using tmap_save to a PNG file
tmap_save(brexitkingdom, "UnitedBrexit.png")

# finding a (wonky) centroid value
Cap <- st_centroid(GINB)
Cap$Title <- c("?Capital?")

brexitkingdomcaptial <- tm_shape(GINB) + tm_polygons(border.col = "black")+
  tm_shape(EandW_union) + tm_polygons(border.col="black", lty=3, col="white") +
  tm_shape(capital) + tm_dots(col="red", size=0.4) + tm_text("query", size=0.75, xmod=-1, ymod=-.5) +
  tm_shape(Cap) + tm_dots(col="blue", size=0.4, shape=15) + tm_text("Title", col="blue", size=0.75, xmod=-1.5, ymod=-.75) +
  tm_logo(file="https://raw.githubusercontent.com/malcolmcampbell/RSpatialBasics/master/MapCreation/homemadeflag.png", position=c("left","top"), height=5)+
  tm_credits("Thanks to the referendum results of 23 June 2016\n This example is purely fictional... for now", position=c("left","top"), size=0.5) +
  tm_compass(position=c("right","bottom"), type="rose", size=4) +
  tm_scale_bar(width=0.15, position=c("left","bottom")) +
  tm_style("natural", title="The United Brexit Kingdom of \nGreat Ireland & Northern Britain") 

tmap_save(brexitkingdomcaptial, "UnitedBrexitCapital.png")

# If you get really stuck, there are neat little build in examples called "vignettes"
# use the command vignette to find them, with the appropraite package - e.g. tmap
vignette(package="tmap")
vignette("tmap-getstarted")
# END
