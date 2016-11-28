## Download and read in files on PM25 pollution for 1999, 2002, 2005, and 2008 as 
## well as pollution source identifiers.

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./pollution.zip")
unzip("pollution.zip")
datedownload <- date()
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Determine which SCC relate to combustion of coal.

library(dplyr)
comb <- SCC[grep("Combustion", SCC$SCC.Level.One),]
combcoal <- comb[grep("Coal", comb$Short.Name),]
SCC.combcoal <- combcoal$SCC

## Pull NEI data with SCC matching combustion of coal.

NEIcombcoal <- NEI[NEI$SCC %in% SCC.combcoal,]
sumcombcoal <- with (NEIcombcoal, tapply(Emissions, year, sum))
sumcombcoal <- as.data.frame(sumcombcoal)
sumcombcoal <- cbind(rownames(sumcombcoal), sumcombcoal)
names(sumcombcoal) <- c("Year", "Total.Emissions")

## Create and save plot displaying US combustion of coal emission trends.

library(ggplot2)
p <- ggplot(sumcombcoal, aes(x = Year, y = Total.Emissions))
p + geom_line(group = 1, color = "red") 
        + labs(title = "Total US Coal Combustion Emissions")
ggsave(filename = "plot4.png")
