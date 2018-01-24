setwd("C:/Users/maximilien.gueze/OneDrive - United Nations Development Programme/Mapping/Ch2_Drivers/Eduardo_materials/R")
library(downloader)

### DATA FILES (ISO3 added, saved in GitHub)
library(RCurl)
library(plyr)
extr_abs <-read.csv(text=getURL("https://raw.githubusercontent.com/maxgueze/Ch2Drivers_visuals/master/tot_extr_abs.csv"), header=T)
cons_abs <-read.csv(text=getURL("https://raw.githubusercontent.com/maxgueze/Ch2Drivers_visuals/master/tot_cons_abs.csv"), header=T)
cons_perc <-read.csv(text=getURL("https://raw.githubusercontent.com/maxgueze/Ch2Drivers_visuals/master/tot_cons_percap.csv"), header=T)
trad_abs <-read.csv(text=getURL("https://raw.githubusercontent.com/maxgueze/Ch2Drivers_visuals/master/tot_trade_abs.csv"), header=T)
#extract values for 1980 and 2008
extr_abs_1980<-subset(extr_abs, year==1980)
cons_abs_1980<-subset(cons_abs, year==1980)
cons_perc_1980<-subset(cons_perc, year==1980)
trad_abs_1980<-subset(trad_abs, year==1980)
extr_abs_2008<-subset(extr_abs, year==2008)
cons_abs_2008<-subset(cons_abs, year==2008)
cons_perc_2008<-subset(cons_perc, year==2008)
trad_abs_2008<-subset(trad_abs, year==2008)
rename(extr_abs_1980, c("year"="extr_abs_1980"))
rename(cons_abs_1980, c("year"="cons_abs_1980"))
rename(cons_perc_1980, c("year"="cons_perc_1980"))
rename(trad_abs_1980, c("year"="trad_abs_1980"))
rename(extr_abs_2008, c("year"="extr_abs_2008"))
rename(cons_abs_2008, c("year"="cons_abs_2008"))
rename(cons_perc_2008, c("year"="cons_perc_2008"))
rename(trad_abs_2008, c("year"="trad_abs_2008"))
#merge files
x<-merge(extr_abs_1980, extr_abs_2008, by.x="iso3c", by.y="iso3c", all=T)
x1<-merge(cons_abs_1980, cons_abs_2008, by.x="iso3c", by.y="iso3c", all=T)
x2<-merge(cons_perc_1980, cons_perc_2008, by.x="iso3c", by.y="iso3c", all=T)
x3<-merge(trad_abs_1980, trad_abs_2008, by.x="iso3c", by.y="iso3c", all=T)
x4<-merge(x, x1, by.x="iso3c", by.y="iso3c", all=T)
x5<-merge(x2, x3, by.x="iso3c", by.y="iso3c", all=T)
materials<-merge(x4, x5, by.x="iso3c", by.y="iso3c", all=T)
#rename columns
colnames(materials)[4] <- "extr_abs_1980"
colnames(materials)[7] <- "extr_abs_2008"
colnames(materials)[10] <- "cons_abs_1980"
colnames(materials)[13] <- "cons_abs_2008"
colnames(materials)[16] <- "cons_perc_1980"
colnames(materials)[19] <- "cons_perc_2008"
colnames(materials)[22] <- "ptb_abs_1980"
colnames(materials)[25] <- "ptb_abs_2008"
#remove useless columns
materials$year.x.x.x<-NULL
materials$country.y.x.x<-NULL
materials$year.y.x.x<-NULL
materials$country.x.y.x<-NULL
materials$year.x.y.x<-NULL
materials$country.y.y.x<-NULL
materials$year.y.y.x<-NULL
materials$country.x.x.y<-NULL
materials$year.x.x.y<-NULL
materials$country.y.x.y<-NULL
materials$year.y.x.y<-NULL
materials$country.x.y.y<-NULL
materials$year.x.y.y<-NULL
materials$country.y.y.y<-NULL
materials$year.y.y.y<-NULL


### PREPARE SHAPEFILE IPBES REGIONS AND SUBREGIONS, and join with data 
library(maptools)
library(raster)
library(rgdal)
library(gridExtra)

shapefile<-readShapePoly("C:/Users/maximilien.gueze/OneDrive - United Nations Development Programme/Mapping/Shapefiles IPBES regions/Shapefiles IPBES 20180110/IPBES_Regions_20170308.shp")
colnames(shapefile@data)[3] <- "iso3c"
shp<-merge(shapefile, materials, by='iso3c')
#remove EEZ and save shp
shp_land<-shp[shp$type=="Land",]
writeOGR(obj=shp_land, dsn ="shapefile" , layer="shp_land", driver="ESRI Shapefile") #the dsn here is newly created with this command


### MAP1: EXTRACTION ABSOLUTE  + CONSUMPTION ABSOLUTE, PER IPBES REGION, 1980
#CONSUMPTION ON A COLOR RAMP
#EXTRACTION HATCHED
reg.coords <- coordinates(shp_land)
reg.id <- cut(reg.coords[,1], quantile(reg.coords[,1]), include.lowest=TRUE)
reg.union<-unionSpatialPolygons(shp_land, reg.id)


### MAP2: EXTRACTION ABSOLUTE  + CONSUMPTION ABSOLUTE, PER IPBES REGION, 2008
#CONSUMPTION ON A COLOR RAMP
#EXTRACTION HATCHED

### MAP3: CONSUMPTION PER CAPITA, 1980

### MAP4: CONSUMPTION PER CAPITA, 2008

### GRAPH1: TRADE BALANCE, ABSOLUTE 


