## Course 4: Exploratory Data Analysis
## Asignment: Course Project 1
## Student: Brenda Cooney
## Plot: Plot 4

## Check to see if the data file exists in the current folder
## If it doesn't then download it else do not
## Note: I could bring this much further and check to ensure the file is readable
## but it's not part of the exercise so I'm leaving it out!
if(!file.exists("household_power_consumption.txt")) {
        ## Create a temporary file that will hold the zipped file
        tempfile <- tempfile()
        URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        ## Download the zipped file, unzip and store the contents in the current directory
        download.file(URL, tempfile, method = "curl")
        unzip(tempfile)
        unlink(tempfile) ## Remove the temporary file from memory
}

## Name of file in zipped folder
fileName <- "household_power_consumption.txt"

## Read the data in a data.frame and set it's column names and types
## Skip the first 66638 rows and then read in the data from rows where date is set to
## '2007-02-01' and '2007-02-02'
data <- read.table(file=fileName, 
                   sep=";", col.names=c("Date", "Time", "Global_active_power",
                                        "Global_reactive_power", "Voltage",
                                        "Global_intensity", "Sub_metering_1",
                                        "Sub_metering_2", "Sub_metering_3"),
                   colClasses = c("character", "character", "numeric",
                                  "numeric", "numeric", "numeric",
                                  "numeric", "numeric", "numeric"),
                   skip=66638,
                   nrows=2879,                             
                   stringsAsFactors = FALSE)

## Combine 'Date' and 'Time' and store result in a new column 'DateTime'
data_set_newCol <- cbind(data, DateTime=paste(data$Date, data$Time), stringsAsFactors = FALSE)
## Remove column 'Time' and 'Date'
data_set <- data_set_newCol[,3:10]
## Remove data no longer needed
remove(data, data_set_newCol)
## Set 'DateTime' to be of time 'Date'
data_set$DateTime <- strptime(data_set$DateTime, "%d/%m/%Y %H:%M:%S")

## Open 'graphics'png' device, create 'plot4.png' in working directoy 
png(file="plot4.png", width = 480, height = 480, units="px")

## Specify the number of rows and columns to appear on the screen
par(mfrow=c(2,2))

## Create 'Plot1'
plot(data_set$DateTime, data_set$Global_active_power, type="l", 
     xlab="", ylab="Global Active Power")

## Create 'Plot2'
plot(data_set$DateTime, data_set$Voltage, type="l", 
     xlab="datetime", ylab="Voltage")

##Create 'Plot3'
plot(data_set$DateTime, data_set$Sub_metering_1, type="l", 
     xlab="", ylab="Energy sub metering")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", 
                            "Sub_metering_3"), cex=0.6, lwd=3, col=c("black","red","blue"))
points(data_set$DateTime, data_set$Sub_metering_2, type="l", col = "red")
points(data_set$DateTime, data_set$Sub_metering_3, type="l", col = "blue")

## Create 'Plot4'
plot(data_set$DateTime, data_set$Global_reactive_power, type="l", 
     xlab="datetime", ylab="Global_reactive_power")

dev.off() ## Close the 'png' device that was opened above