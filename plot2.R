## plot2.R

library(downloader)
library(sqldf)
library(ggplot2)

setwd("C:/Users/afbir/Documents/GitHub/ExData_Plotting1")

dev.set(2)

if (!file.exists("./data/household_power_consumption.txt")) {
  
  url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
  if (!dir.exists("./data")) {
    dir.create("./data")
  }
  
  download(url, dest="./data/dataset.zip", mode="wb")
  unzip ("./data/dataset.zip", exdir = "./data")
  
}

if (!file.exists("./data/household_power_consumption_feb01_feb02.txt")) {

  df1 <- read.csv("./data/household_power_consumption.txt", sep=";")

  df1$Date <- as.Date(df1$Date, "%d/%m/%Y")
  df1$Date_Time <- strptime(paste(as.character(df1$Date, "%Y-%m-%d"), df1$Time, sep = " "), "%Y-%m-%d %H:%M:%S")

  df2 <- subset(df1[df1$Date >= as.Date("2007-02-01", "%Y-%m-%d") & df1$Date <= as.Date("2007-02-02", "%Y-%m-%d"),])

  write.csv(df2,"./data/household_power_consumption_feb01_feb02.txt")

  rm(df1, df2)

}

df_data <- read.csv("./data/household_power_consumption_feb01_feb02.txt")

gp <- ggplot(df_data, aes(as.POSIXct(Date_Time), Global_active_power)) + geom_line()
gp <- gp + theme_bw()
gp <- gp + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
gp <- gp + scale_x_datetime(date_labels = "%a", date_breaks = "1 day")
gp <- gp + xlab("") 
gp <- gp + ylab("Global Active Power (kilowatts)")
gp <- gp + theme(axis.text.y=element_text(size=rel(1), angle=90))

plot(gp)

dev.copy(png, "./plot2.png")
dev.off()
