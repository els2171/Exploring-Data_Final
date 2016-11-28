## Download and read in files on PM25 pollution for 1999, 2002, 2005, and 2008 as 
## well as pollution source identifiers.

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "./pollution.zip")
unzip("pollution.zip")
datedownload <- date()
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Find the total amount of PM25 emissions per year for 1999, 2002, 2005, and 2008.

sumtotals <- with(NEI, tapply(Emissions, year, sum))

## Plot line graph of total PM25 emissions per year for 1999, 2002, 2005, and 2008.

png(filename = "plot1.png")
plot(sumtotals, xlab = "Year", ylab = "Total Emissions", 
     main = "Total PM25 Emissions Per Year", col = "blue", type = "l", lwd = 2)
dev.off()