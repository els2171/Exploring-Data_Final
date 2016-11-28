## Download and read in files on PM25 pollution for 1999, 2002, 2005, and 2008 as 
## well as pollution source identifiers.

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./pollution.zip")
unzip("pollution.zip")
datedownload <- date()
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Determine which SCC relate to motor vehicles.

library(dplyr)
vehicles <- SCC[grep("[Vv]ehicles", SCC$EI.Sector),]
SCC.vehicles <- vehicles$SCC

## Pull NEI data for Baltimore relating to motor vehicles.

Baltimore <- subset(NEI, fips == "24510")
Baltvehicles <- Baltimore[Baltimore$SCC %in% SCC.vehicles,]
sumBaltvehicles <- with(Baltvehicles, tapply(Emissions, year, sum))
sumBaltvehicles <- as.data.frame(sumBaltvehicles)
sumBaltvehicles <- cbind(rownames(sumBaltvehicles), sumBaltvehicles)
names(sumBaltvehicles) <- c("Year", "Total.Emissions")

## Plot Baltimore motor vehicle emissions from 1999 to 2008.

library(ggplot2)
p <- ggplot(sumBaltvehicles, aes(x = Year, y = Total.Emissions))
p + geom_line(group = 1, color = "orange") 
        + labs(title = "Total Motor Vehicle Emissions for Baltimore")
ggsave(filename = "plot5.png")

