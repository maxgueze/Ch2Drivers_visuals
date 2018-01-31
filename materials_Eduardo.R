setwd("C:/Users/maximilien.gueze/OneDrive - United Nations Development Programme/Mapping/Ch2_Drivers/Eduardo_materials/R")

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
library(rgeos)
library(dplyr)

# simpleshp has been created from http://mapshaper.org/
simpleshp<-readShapePoly("C:/Users/maximilien.gueze/OneDrive - United Nations Development Programme/Mapping/Shapefiles IPBES regions/Simplified_20180110/IPBES_Regions_20170308.shp")
colnames(simpleshp@data)[3] <- "iso3c"
shp_land<-simpleshp[simpleshp$type=="Land",]
shp<-merge(shp_land, materials, by='iso3c')
writeOGR(obj=shp, dsn ="shapefile_simp" , layer="shp_land_simp", driver="ESRI Shapefile" )

#Dissolve countrry polygons into IPBES subregions, done in QGIS. Here we read the outcome regions shapefile
regions<-readShapePoly("C:/Users/maximilien.gueze/OneDrive - United Nations Development Programme/Mapping/Shapefiles IPBES regions/Simplified_20180110/IPBES_regions_dissolved.shp")
regions<-regions[regions$IPBES_r!="Excluded",]
regions <- regions[,4:5, drop=FALSE]
colnames(regions@data)[2] <- "IPBES_regi"
shp<-shp[shp@data$IPBES_regi!="Excluded",]
#Calculate mean percapita consumption
cons_perc_1980<-aggregate(shp@data$cons_perc_1980, list(IPBES_regi = shp@data$IPBES_regi), mean, na.rm=T)
cons_perc_2008<-aggregate(shp@data$cons_perc_2008, list(IPBES_regi = shp@data$IPBES_regi), mean, na.rm=T)
#Calculate sum of total consumption/extraction/trade and merge with per capita dataframes
reg_data<-aggregate(. ~ IPBES_regi, shp, sum, na.rm=T)
reg_data$cons_perc_1980<-NULL
reg_data$cons_perc_2008<-NULL
reg_data1<-merge(reg_data, cons_perc_1980, by='IPBES_regi')
reg_data2<-merge(reg_data1, cons_perc_2008, by='IPBES_regi')
colnames(reg_data2)[15] <- "cons_perc_1980"
colnames(reg_data2)[16] <- "cons_perc_2008"
#Merge data frame with region shapefile
reg_shp<-merge(regions, reg_data2, by='IPBES_regi')
writeOGR(obj=reg_shp, dsn ="reg_shp" , layer="reg_shp", driver="ESRI Shapefile" )

# Same for subregions
subregions<-readShapePoly("C:/Users/maximilien.gueze/OneDrive - United Nations Development Programme/Mapping/Shapefiles IPBES regions/Simplified_20180110/IPBES_subregions_dissolved.shp")
subregions<-subregions[subregions$IPBES_r!="Excluded",]
subregions <- subregions[,7, drop=FALSE]
colnames(subregions@data)[1] <- "IPBES_sub"
#Calculate mean per capita consumption
subcons_perc_1980<-aggregate(shp@data$cons_perc_1980, list(IPBES_sub = shp@data$IPBES_sub), mean, na.rm=T)
subcons_perc_2008<-aggregate(shp@data$cons_perc_2008, list(IPBES_sub = shp@data$IPBES_sub), mean, na.rm=T)
#Calculate sum of total consumption/extraction/trade and merge with per capita dataframes
subreg_data<-aggregate(. ~ IPBES_sub, shp, sum, na.rm=T)
subreg_data$cons_perc_1980<-NULL
subreg_data$cons_perc_2008<-NULL
subreg_data1<-merge(subreg_data, subcons_perc_1980, by='IPBES_sub')
subreg_data2<-merge(subreg_data1, subcons_perc_2008, by='IPBES_sub')
colnames(subreg_data2)[15] <- "cons_perc_1980"
colnames(subreg_data2)[16] <- "cons_perc_2008"
#Merge data frame with subregion shapefile
subreg_shp<-merge(subregions, subreg_data2, by='IPBES_sub')
writeOGR(obj=subreg_shp, dsn ="subreg_shp" , layer="subreg_shp", driver="ESRI Shapefile" )


robin<-"+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"   
crs.geo <- CRS(robin)
proj4string(subreg_shp) <- crs.geo 
proj4string(reg_shp) <- crs.geo 

### MAP1: EXTRACTION ABSOLUTE  + CONSUMPTION ABSOLUTE, PER IPBES REGION, 1980
#CONSUMPTION ON A COLOR RAMP
#EXTRACTION HATCHED

### MAP2: EXTRACTION ABSOLUTE  + CONSUMPTION ABSOLUTE, PER IPBES REGION, 2008
#CONSUMPTION ON A COLOR RAMP
#EXTRACTION HATCHED

### MAP3: CONSUMPTION PER CAPITA, 1980

### MAP4: CONSUMPTION PER CAPITA, 2008

### GRAPH1: TRADE BALANCE, ABSOLUTE, PER IPBES SUBREGIONS
library(plotly)
#plot by IPBES regions
plot_ly(reg_shp@data, x=~IPBES_regi, y=~ptb_abs_1980, type='bar', name=' trade balance 1980')%>%
  add_trace(y = ~ptb_abs_2008, name = 'trade balance 2008') %>%
  layout(yaxis = list(title='kT'), barmode = 'group')
#plot by IPBES subregions
subreg_shp<-subreg_shp[subreg_shp@data$IPBES_sub!="Excluded",]
plot_ly(subreg_shp@data, x=~IPBES_sub, y=~ptb_abs_1980, type='bar', name=' trade balance 1980')%>%
  add_trace(y = ~ptb_abs_2008, name = 'trade balance 2008') %>%
  layout(yaxis = list(title='kT'), barmode = 'group')
#plot by WDI categories
typo<-read.csv(text=getURL("https://raw.githubusercontent.com/maxgueze/Ch2Drivers_visuals/master/country_typology.csv"), header=T)
materialswdi<-merge(shp, typo, by='iso3c')       
materialswdi2<-as.data.frame(materialswdi@data)
wdi_ptb_1980<-aggregate(materialswdi2$ptb_abs_1980, list(WDI_typo = materialswdi2$category), sum, na.rm=T)
colnames(wdi_ptb_1980)[2] <- "ptb_1980"
wdi_ptb_2008<-aggregate(materialswdi2$ptb_abs_2008, list(WDI_typo = materialswdi2$category), sum, na.rm=T)
colnames(wdi_ptb_2008)[2] <- "ptb_2008"
wdi_ptb<-merge(wdi_ptb_1980, wdi_ptb_2008, by='WDI_typo')
WDI_typo<-c(1, 2, 3, 4, 5, 6)
incometype<-c("High income OECD", "High income oil", "Other high income", "Upper middle income", "Lower middle income", "Low income")
names<-data.frame(WDI_typo, incometype)
wdi_ptb2<-merge(wdi_ptb, names, by='WDI_typo')

plot_ly(wdi_ptb2, x=~incometype, y=~ptb_1980, type='bar', name=' trade balance 1980')%>%
  add_trace(y = ~ptb_2008, name = 'trade balance 2008') %>%
  layout(yaxis = list(title='kT'), barmode = 'group')
