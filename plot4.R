## plot4.R

library(downloader)
library(sqldf)
library(reshape2)
library(ggplot2)
library(gridExtra)

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

dev.off()
dev.set(2)
dev.cur()

## par(mfrow = c(2,2))
## mfrow=c(2,2)

gp1 <- ggplot(df_data, aes(as.POSIXct(Date_Time), Global_active_power)) + geom_line()
gp1 <- gp1 + theme_bw()
gp1 <- gp1 + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
gp1 <- gp1 + scale_x_datetime(date_labels = "%a", date_breaks = "1 day")
gp1 <- gp1 + xlab("") 
gp1 <- gp1 + ylab("Global Active Power (kilowatts)")
gp1 <- gp1 + theme(axis.text.y=element_text(size=rel(1), angle=90))

gp2 <- ggplot(df_data, aes(as.POSIXct(Date_Time), Voltage)) + geom_line()
gp2 <- gp2 + theme_bw()
gp2 <- gp2 + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
gp2 <- gp2 + scale_x_datetime(date_labels = "%a", date_breaks = "1 day")
gp2 <- gp2 + xlab("datetime") 
gp2 <- gp2 + ylab("Voltage")
gp2 <- gp2 + theme(axis.text.y=element_text(size=rel(1), angle=90))

melt_df_data <- melt(df_data, id.vars = "Date_Time", measure.vars = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

manual_colors <- c("Sub_metering_1"="black", "Sub_metering_2"="red", "Sub_metering_3"="blue")

gp3 <- ggplot(melt_df_data, aes(x=as.POSIXct(Date_Time), y=value, colour=variable, group=variable))
gp3 <- gp3 + scale_colour_manual(values = manual_colors)
gp3 <- gp3 + geom_line()
gp3 <- gp3 + theme_bw()
gp3 <- gp3 + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
gp3 <- gp3 + theme(legend.direction="vertical", legend.title = element_blank())
gp3 <- gp3 + theme(legend.justification = c(1,1), legend.position=c(1,1), legend.background = element_rect(linetype = "solid", colour="black"))
## gp3 <- gp3 + guides(fill = guide_legend(keyheight = 0.1, default.unit = "inch"))
gp3 <- gp3 + scale_x_datetime(date_labels = "%a", date_breaks = "1 day")
gp3 <- gp3 + xlab("") 
gp3 <- gp3 + ylab("Energy sub metering")
gp3 <- gp3 + theme(axis.text.y=element_text(size=rel(1), angle=90))

gp4 <- ggplot(df_data, aes(as.POSIXct(Date_Time), Global_reactive_power)) + geom_line()
gp4 <- gp4 + theme_bw()
gp4 <- gp4 + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
gp4 <- gp4 + scale_x_datetime(date_labels = "%a", date_breaks = "1 day")
gp4 <- gp4 + xlab("datetime") 
gp4 <- gp4 + ylab("Global_reactive_power")
gp4 <- gp4 + theme(axis.text.y=element_text(size=rel(1), angle=90))

grid.arrange(gp1, gp2, gp3, gp4, nrow = 2)

dev.copy(png, "./plot4.png")
dev.off()
