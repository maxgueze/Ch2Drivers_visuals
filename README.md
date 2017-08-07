# visuals-drivers
R scripts for maps and visuals for Ch 2 Drivers

# Function test Aidin
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
