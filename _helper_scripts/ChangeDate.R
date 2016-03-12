## Quick script to update dates for the BIS180L posts

library(chron)

setwd("~/git/BIS180L_web/_posts/")

files <- dir(pattern="2015")

for(f in files) {
  date <- chron(dates. = regmatches(f,regexpr("^([[:digit:]]+-){2}[[:digit:]]+",f)),format="y-m-d")
  date <- date + 364 
  name <- sub("^([[:digit:]]+-){2}[[:digit:]]+",paste("20",date,sep=""),f)
  file.rename(f,name)
}
  