## read_data.R

library(downloader)
library(sqldf)

setwd("C:/Users/afbir/Documents/GitHub/ExData_Plotting1")

if (!file.exists("./data/household_power_consumption.txt")) {

  url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

  if (!dir.exists("./data")) {
    dir.create("./data")
  }
  
  download(url, dest="./data/dataset.zip", mode="wb")
  unzip ("./data/dataset.zip", exdir = "./data")

}

df1 <- read.csv("./data/household_power_consumption.txt", sep=";")

df1$Date <- as.Date(df1$Date, "%d/%m/%Y")
df1$Date_Time <- strptime(paste(as.character(df1$Date, "%Y-%m-%d"), df1$Time, sep = " "), "%Y-%m-%d %H:%M:%S")

df2 <- subset(df1[df1$Date >= as.Date("2007-02-01", "%Y-%m-%d") & df1$Date <= as.Date("2007-02-02", "%Y-%m-%d"),])

write.csv(df2,"./data/household_power_consumption_feb01_feb02.txt")

rm(df1, df2)

df_data <- read.csv("./data/household_power_consumption_feb01_feb02.txt")

print(str(df_data))

rm(df_data)
