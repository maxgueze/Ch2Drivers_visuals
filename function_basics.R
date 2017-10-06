# Function test Aidin: get data from WDI and summary statistics
function_test_Aidin4Max<-function(x){
  library(WDI)
  library(plyr)
  t<-WDI(country = "all", indicator = x, start = 1960, end = 2017, extra = TRUE, cache = NULL)
  colnames(t)[3]<- "t_indic"
  t<-ddply(t,"iso3c",summarise,sd=sd(t_indic,na.rm=TRUE),mean=mean(t_indic,na.rm=TRUE))
  colnames(t)<-c("iso3",paste0("StDv__",x),paste0("MEAN__",x))
  return(t)
}

test<-function_test_Aidin4Max("SN.ITK.DEFC.ZS")
test<-function_test_Aidin4Max("EN.POP.SLUM.UR.ZS")

# Function test Max: get years in columns
function_test_2<-function(x){
  library(WDI)
  library(plyr)
  t<-WDI(country = "all", indicator = x, start = 1960, end = 2017, extra = TRUE, cache = NULL)
  colnames(t)[3]<- "t_indic"
  reshape(t[,3:5], idvar="iso3c", timevar="year", direction="wide")
  return(t)
}

test<-function_test_2("SN.ITK.DEFC.ZS")

# Function test FAO
function_test_FAO<-function(x, y, z){
  library(FAOSTAT)
  w<-getFAOtoSYB(domainCode=x, elementCode=y, itemCode=z, useCHMT = TRUE)
  w<- translateCountryCode(data = w$entity, from = "FAOST_CODE", to = "ISO3_WB_CODE")
  w<-w[,-1]
  colnames(t)[3]<- "t_indic"
  w<-reshape(w, idvar="ISO3_WB_CODE", timevar="Year", direction="wide")
  w<-w[order(w$ISO3_WB_CODE), order(colnames(w))]
  return(w)
  }

# To find x (domain), y (element) and z (item) for each indicator we need to run

FAOmetaTable
# or
FAOsearch()

test<-function_test_FAO("EW", 7222, 6720)
test<-function_test_FAO("EL", 7208, 6671)


# Function visualization
function_visualize<- function(x){
  library(rgdal)
  basemap<-readOGR(dsn="TM_WORLD_BORDERS_SIMPL-0.3", layer="TM_WORLD_BORDERS_SIMPL-0.3")
  basemap@data<-data.frame(basemap@data, x[match(basemap@data[,"ISO3"], x[,"iso3"]),])
  library(RColorBrewer)
  pal1<-brewer.pal(n=7, name="Reds") #n is the number of cuts we want to use
  plot<-spplot(basemap, zcol="MEAN__SN.ITK.DEFC.ZS", col.regions=pal1, cuts=6, sub="MEAN__SN.ITK.DEFC.ZS") # Number of cuts must be one minus the number of colors
  print(plot) #sp explicitly need to be printed within the function
  }

test2<-function_visualize(test)
