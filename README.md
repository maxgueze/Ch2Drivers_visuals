# visuals-drivers
R scripts for maps and visuals for Ch 2 Drivers


# Function test Aidin: fetch data from WDI and summary statistics
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


# Function test Max: fetch data from WDI (raw data) and get years in columns
function_test_2<-function(x){
  library(WDI)
  library(plyr)
  t<-WDI(country = "all", indicator = x, start = 1960, end = 2017, extra = TRUE, cache = NULL)
  colnames(t)[3]<- "t_indic"
  reshape(t[,3:5], idvar="iso3c", timevar="year", direction="wide")
  return(t)
}

test<-function_test_2("SN.ITK.DEFC.ZS")
print(test[order(t$iso3c),order(colnames(t))])


# Function test FAO: fetch data from FAOSTAT (raw data) and get years in column
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

