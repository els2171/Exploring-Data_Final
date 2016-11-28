## Download and read in files on PM25 pollution for 1999, 2002, 2005, and 2008 as 
## well as pollution source identifiers.

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./pollution.zip")
unzip("pollution.zip")
datedownload <- date()
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset the data just for Baltimore

Baltimore <- subset(NEI, fips == "24510")

## Find the total emissions in Baltimore per year for 1999, 2002, 2005, and 2008.

Baltimore_Yrly <- with(Baltimore, tapply(Emissions, year, sum))

## Plot the total emissions per year in Baltimore for 1999, 2002, 2005, and 2008.

png(filename = "plot2.png")
plot(Baltimore_Yrly, xlab = "Year", ylab = "Total Emissions", 
     main = "Total Emissions Per Year - Baltimore", type = "l", col = "green", lwd = 2)
dev.off()