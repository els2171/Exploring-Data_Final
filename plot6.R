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

## Subset NEI data for Baltimore and LA County relating to motor vehicles.

Balt_LA <- subset(NEI, fips == "24510" | fips == "06037")
BaltLA_vehicles <- Balt_LA[Balt_LA$SCC %in% SCC.vehicles,]

## Create a new dataframe sorting the information by city and year,
## then summarize the information to find the total yearly emissions by city.

vehicle_city <- group_by(BaltLA_vehicles, fips, year)
vehicle_city_emi <- summarise(vehicle_city, sum(Emissions))
vehicle_city_emi[vehicle_city_emi == "06037"] <- "LA County"
vehicle_city_emi[vehicle_city_emi == "24510"] <- "Baltimore City"
names(vehicle_city_emi) <- c("Location", "Year", "Total.Emissions")

## Using ggplot2, produce a line graph showing the total motor vehicle emissions
## by city to determine the general trend for each city from 1999 to 2008.

library(ggplot2)
vehicle_city_emi$log.Emissions <- log(vehicle_city_emi$Total.Emissions)
p <- ggplot(vehicle_city_emi, aes(x = Year, y = log.Emissions))
p + geom_line(aes(color = Location), lwd = 3) 
        + labs(title = "Total Motor Vehicle Emissions by City")
ggsave(filename = "plot6.png")
