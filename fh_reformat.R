##
##  Created by Nicholas R. Davis (nicholas@democracyobserver.org)
##  on 2017-06-05 11:56:50. Created for distribution.
##
##########################################################
###################   Freedom House   ####################
##########################################################

setwd("~/Freedom House") # change this to point to a reasonable working directory

###################   LOAD  ##############################

# ensure required packages are installed
list.of.packages <- c("countrycode", "gdata", "reshape", "car")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# load required packages
sapply(list.of.packages, require, character.only=T)

rm(list=c("list.of.packages", "new.packages"))

####################  CODE  ##############################

# load spreadsheet -- see ReadMe; you can change the "location" as needed
location <- "Country_and_Territory_Ratings_and_Statuses_FIW1973-2019.xls"
fh <- read.xls(location, 
	sheet=2, # get the ratings, statuses tab
	header=FALSE, # source formatting precludes using a header
	skip=1, # skip the first line
	na.strings=c("-"), 
	stringsAsFactors=F)

# reformat years - note that 1982 is combined with 1981, and will be added later
fh[1,2:ncol(fh)] <- sort(rep(c(1972:1981, 1983:2018), times=3))
# note that you will need to change the end year in the above line should you get a more recent version of the data

# reformat names, this will make sense later
names(fh)[1] <- "country.name"
names(fh)[2:ncol(fh)] <- paste(fh[2,2:ncol(fh)], fh[1,2:ncol(fh)])

# melt and recast data to convert wide --> long
mfh <- melt(fh[3:nrow(fh),], id.vars=c("country.name"))
# ensure there are no double spaces
mfh$variable <- gsub("  ", " ", mfh$variable, fixed=T)
# populate year
mfh$year <- sapply(strsplit(as.character(mfh$variable), " "), function(x)unlist(x)[2])
# fix variable field
mfh$variable <- sapply(strsplit(as.character(mfh$variable), " "), function(x)unlist(x)[1])

# cast melted data as long dataframe
fhscores <- cast(mfh, formula = country.name + year ~ variable)#, value = "value")
names(fhscores) <- tolower(names(fhscores))

# fix south africa 1972
fhscores[which(fhscores$country.name == "South Africa" & fhscores$year == 1972), 3:5] <- c("6", "5", "NF")

# alter variable classes
fhscores[,2:4] <- apply(fhscores[,2:4], 2, function(x)as.numeric(as.character(x)))

# add country codes
fhscores$cown <- countrycode(fhscores$country.name, "country.name", "cown")
# manual fixes
fhscores$cown[which(fhscores$country.name == "Serbia")] <- 345
fhscores$cown[which(fhscores$country.name == "Micronesia")] <- 987
# additional country id
fhscores$iso3c <- countrycode(fhscores$cown, "cown", "iso3c")

# additional calculated variables
fhscores$fh.score <- round((fhscores$cl + fhscores$pr)/2, 2)

fhscores$fh.score.rev <- 8-fhscores$fh.score
fhscores$fh.score.rstd <- scale(fhscores$fh.score.rev)

# recodes and reorders
fhscores$status <- factor(car::recode(as.character(fhscores$status), "'F'=3; 'PF'=2; 'NF'=1"), levels=1:3, labels=c("Not Free", "Partly Free", "Free"))

# 1982
tmp <- fhscores[which(fhscores$year == 1981),]
tmp$year <- 1982
fhscores <- rbind(fhscores, tmp)

fhscores <- fhscores[order(fhscores$country.name, fhscores$year),c(7,6,1,2,3,4,8,5,9,10)]

# variable labels
attr(fhscores, "variable.labels") <- c("ISO character ID", "COW numeric ID", "Country name", "Year", "Civil liberties score", "Political rights score", "Combined score (mean)", "Freedom status", "Combined score, reversed", "Combined score, reversed and standardized")

# write out
save(fhscores, file="fhscores.rda")
