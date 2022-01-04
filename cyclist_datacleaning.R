#required packages

library(tidyverse)
library(janitor)

#importing Daata for analysis

Nov_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202111-divvy-tripdata.csv")
Oct_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202110-divvy-tripdata.csv")
Sep_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202109-divvy-tripdata.csv")
Aug_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202108-divvy-tripdata.csv")
Jul_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202107-divvy-tripdata.csv")
Jun_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202106-divvy-tripdata.csv")
May_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202105-divvy-tripdata.csv")
Apr_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202104-divvy-tripdata.csv")
Mar_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202103-divvy-tripdata.csv")
Feb_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202102-divvy-tripdata.csv")
Jan_21 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202101-divvy-tripdata.csv")
Dec_20 <- read.csv("C:\\Users\\justi\\Desktop\\Last 12 months Trip Data\\202012-divvy-tripdata.csv")

#combining Datasets in to one for cleaning 

cyclist_merged<- rbind(Nov_21, Oct_21, Sep_21, Aug_21, Jul_21, Jun_21, May_21, Apr_21, Mar_21, Feb_21, Jan_21, Dec_20)

#datacleaning process
#Changing the started at and ended at into date and time 

cyclist_merged$started_at <- as.POSIXlt(cyclist_merged$started_at, format = "%Y-%m-%d %H:%M:%S")
cyclist_merged$ended_at <- as.POSIXlt(cyclist_merged$ended_at, format = "%Y-%m-%d %H:%M:%S")

# removing rows with empty as I noticed empty station names 

cyclist_merged <- cyclist_merged %>%
  filter(
    !(is.na(start_station_name)|
        start_station_name == "")
  )%>%
  filter(
    !(is.na(end_station_name)|
        end_station_name == "")
  )

#creating additional information for analysis 

#calculate ridetime

cyclist_merged$ride_time <- difftime(cyclist_merged$ended_at,cyclist_merged$started_at,units = "mins")
range(cyclist_merged$ride_time)

#removing negative values in ride time

cyclist_merged <- cyclist_merged[cyclist_merged$ride_time >= 0,]

range(cyclist_merged$ride_time)


#creating a new data set for analysing date

cyclist_date_analysis = cyclist_merged %>%
  select(ride_id,started_at,ended_at)

#created new column for month  day and time of the day

cyclist_date_analysis$start_hr <- cyclist_date_analysis$started_at$hour
cyclist_date_analysis$start_day = weekdays(cyclist_date_analysis$started_at)
cyclist_date_analysis$start_month = months(cyclist_date_analysis$started_at)

# exporting files for further analysis 

write.csv(cyclist_merged, "C:\\Users\\justi\\Desktop\\Capstone Data Analysis\\cyclist_merged.csv", row.names = F)
write.csv(cyclist_date_analysis, "C:\\Users\\justi\\Desktop\\Capstone Data Analysis\\cyclist_date_analysis.csv", row.names = F)

