#https://cran.r-project.org/doc/manuals/r-release/R-lang.html
#https://cran.r-project.org/doc/manuals/r-release/R-intro.html#Writing-your-own-functions
#https://www.r-bloggers.com/how-to-write-and-debug-an-r-function/



hello<-function() cat("Hello, world!\n")
hello<-function() {cat(paste("Hello, ",system("whoami",T),"!\n",sep="",collapse=""))}

# Function that squares an incoming argument
# square.it takes the value of ARGUMENT x and squares it
# it saves the value into an OBJECT called "square"
# then it returns the VALUE of the object "square"
square.it <- function(x) {
  square <- x * x
  return(square)
}
# x can be anything that can be squared (scalar, vector, matrix)
square.it(c(1,2,3))
matrix1 <- cbind(c(3, 10), c(4, 5))
square.it(matrix1)


#We want a function to present fraction numbers into percentages, rounded to one decimal digit
# Script would be:
x <- c(0.458, 1.6653, 0.83112)
percent <- round(x * 100, digits = 1)
result <- paste(percent, "%", sep = )
print(result)
# now the function based on the script:
addPercent <- function(){percent <- round(x * 100, digits = 1) 
                          result <- paste(percent, "%", sep = )
                          return(result)
}




## Function for WDI?
x<-"SN.ITK.DEFC.ZS"
function.nur<- function(x) {
  # Call WDI library 
  library(WDI)
  library(plyr)
  library(data.table)
  # Get the data file
  und_nur<-WDI(country = "all", indicator = x, start = 1960, end = 2017, extra = TRUE, cache = NULL)
  # homogeneize column names
  und_nur<-data.table(und_nur)
  colnames(und_nur)[5]<-"ISO3_DIGIT"
  # ddply: Split Data Frame, Apply Function, And Return Results In A Data Frame
  test<-ddply(und_nur,"ISO3_DIGIT",summarise,sd_nurishmnt=sd(und_nur[,3],na.rm=TRUE),mean_nurishmnt=mean(und_nur[,3],na.rm=TRUE))
  # print the headers as return
  return(head(test))
}


# A function that dl from WDI and return a df with target indicator and ISO3 codes

f_GA2D_WDI_MG<- function(x){
  library(WDI)
  library(plyr)
  library(data.table)
  dl_01<-WDI(country = "all", indicator = x, start = 1960, end = 2017, extra = TRUE, cache = NULL)
  dl_01<-data.table(dl_01)
  dl_02<-ddply(dl_01,"iso3c",summarise,sd=sd(SL.IND.EMPL.ZS,na.rm=TRUE),mean=mean(SL.IND.EMPL.ZS,na.rm=TRUE))
  return(dl_02)
}

WDIsearch("Employment in industry")


name, iso3, 1960, 1961, ...., sd,mean

test<-f_GA2D_WDI_MG(x="SL.IND.EMPL.ZS")

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

# Function test Max to get years in columns
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

# PRUEBAS Reshape
library(WDI)
t<-WDI(country = "all", indicator = "SN.ITK.DEFC.ZS", start = 1960, end = 2017, extra = TRUE, cache = NULL)
reshape(t, idvar="iso3c", timevar="year", direction="wide")
reshape(t[,3:5], idvar="iso3c", timevar="year", direction="wide")


library(reshape)
cast<-cast(t, iso3c~year)

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
# WRITE an email to fillipo gheri to find out if it can be automatized
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