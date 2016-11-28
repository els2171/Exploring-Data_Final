## Download and read in files on PM25 pollution for 1999, 2002, 2005, and 2008 as 
## well as pollution source identifiers.

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./pollution.zip")
unzip("pollution.zip")
datedownload <- date()
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset the data just for Baltimore.

Baltimore <- subset(NEI, fips == "24510")

## Using dplyr, create a new dataframe sorting the information by type and year,
## then summarize the information to find the total yearly emissions by type.

library(dplyr)
Baltimore_type <- group_by(Baltimore, type, year)
Balt_typ_emi <- summarise(Baltimore_type, sum(Emissions))
colnames(Balt_typ_emi)[3] <- "Total.Emissions"

## Using ggplot2, produce a line graph showing the total year emissions by type
## to determine the general trend for each type from 1999 to 2008.

library(ggplot2)
p <- ggplot(Balt_typ_emi, aes(x = year, y = Total.Emissions))
p + geom_line(aes(color = type)) 
        + labs(title = "Total Yearly Emissions by Type - Baltimore")
ggsave(filename = "plot3.png")