# Date-Time Classes

## Date-Time Classes in Base R -----
# Dates (just dates, i.e., 2012-02-10)
# POSIXct (“ct” == calendar time, best class for dates with times)
# POSIXlt (“lt” == local time)

## The string must be of the form YYYY-MM-DD to convert it into a Date object.
sample_dates_1 <- c("2018-02-01", "2018-03-21", 
                    "2018-10-05", "2019-01-01", "2019-02-18")
sample_dates_1 <- as.Date(sample_dates_1)
class(sample_dates_1)

## To fix formatting errors, you need to specify the format like so:
sample_dates_2 <- c("02-01-2018", "03-21-2018", 
                    "10-05-2018", "01-01-2019", "02-18-2019")
sample_dates_2<- as.Date(sample_dates_2, format = "%m-%d-%Y" )
sample_dates_2

## Complete list of date-time formats:
# Example: as.Date("Jul 04, 2019", format = "%b%d,%Y")
?strptime


## POSIXct is the best class to work with when working with times
tm1 <- as.POSIXct("2016-07-24 23:55:26")
tm1
tm2 <- as.POSIXct("25072016 08:32:07", format = "%d%m%Y %H:%M:%S")
tm2
## POSIXct assumes you collected data in the timezone the computer is set to. To change this, set the timezone parameter with "tz"
tm3 <- as.POSIXct("2010-12-01 11:42:03", tz = "GMT")
tm3


## Time-Date Classes in Tidyverse: Lubridate -----
## Includes a variety of functions like dmy(), myd(), ymd(), dym(), etc.
library(lubridate)

sample_dates_1 <- c("2018-02-01", "2018-03-21", 
                    "2018-10-05", "2019-01-01", "2019-02-18")
sample_dates_lub <- ymd(sample_dates_1)
sample_dates_lub
# Lubridate doesn't care if not all of the expected number of digits are used.
sample_dates_2 <- c("2-01-2018", "3-21-2018", 
                    "10-05-18", "01-01-2019", "02-18-2019")
sample_dates_lub2 <- mdy(sample_dates_2)
sample_dates_lub2

# More examples using lubridate:
lubridate::ymd("2016/01/01")   # --> 2016-01-01
lubridate::mdy("Feb 19, 2011") # --> 2011-02-19
lubridate::dmy("22051997")     # --> 1997-05-22
# NOTE: ymd is often preferred since it organizes data oldest to newest natively.

## Timezones -----
# "hms" means hours, minutes seconds. 
# To add time to a date, use functions that add "_hms" or "_hm"
lubridate::ymd_hm("2016-01-01 12:00", 
                  tz="America/Los_Angeles") # --> 2016-01-01 12:00:00
# 24 hour time:
lubridate::ymd_hm("2016/04/05 14:47", 
                  tz="America/Los_Angeles") # --> 2016-04-05 14:47:00
# converts 12 hour time into 24 hour time:
latime <- lubridate::ymd_hms("2016/04/05 4:47:21 PM", 
                             tz="America/Los_Angeles")
latime

## Change timezones using "with_tz"
with_tz(latime, tzone = "GMT")
with_tz(latime, tzone = "Pacific/Honolulu")


## Lubridate Formatting -----
# Make sure your data starts as character strings, not as dates and times, before converting to lubridate
# read_csv will see dates and times and guess that you want them as Date and Time objects, so you have to #explicitly tell it not to do this.

library(dplyr)
library(readr)
mloa1 <- read_csv("https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/main/data/mauna_loa_met_2001_minute.csv")
mloa1

# R tried to guess that the year, month, day, and hour columns were numbers
# Specify column types using "col_types"
mloa2 <- read_csv("https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/main/data/mauna_loa_met_2001_minute.csv",
                  col_types = "cccccccddddddddd")
mloa2

# Now make a datetime col so that we can use lubridate on it:
mloa2$datetime <- paste(mloa2$year, "-", mloa2$month,
                        "-", mloa2$day, ", ", mloa2$hour24, ":",
                        mloa2$min, sep = "")
glimpse(mloa2)

# 3 methods to progress from here:
## Method 1: Convert DateTime to POSIXct in local timezone (doesn't work here)
mloa2$datetime_test <- as_datetime(mloa2$datetime, 
                                   tz="America/Los_Angeles", 
                                   format="%Y-%m-%d, %H:%M")
## Method 2: Use lubridate ymd_functions (best)
mloa2$datetime_test <- ymd_hm(mloa2$datetime, 
                               tz = "Pacific/Honolulu")
## Method 2: Wrap in as.character()
mloa1$datetime <- ymd_hm(as.character(mloa2$datetime), 
                         tz="Pacific/Honolulu")
tz(mloa1$datetime)

## Extract different components from a lubridate object using Functions
# Functions called day(), month(), year(), hour(), minute(), second(), etc... will extract those elements of a datetime column.
months <- month(mloa2$datetime)
# Use the table function to get a quick summary of categorical variables
table(months)

# Add label and abbr arguments to convert numeric representations to have names
months <- month(mloa2$datetime, label = TRUE, abbr=TRUE)
table(months)

#how to check for daylight savings time
dst(mloa2$datetime_test[1])
dst(mloa2$datetime)

latime <- lubridate::ymd_hms("2016/04/05 4:47:21 PM", 
                             tz="America/Los_Angeles")
latime
dst(latime)

hi <- with_tz(latime, tzone = "Pacific/Honolulu")
dst(hi)



# Creating Functions

## Process of Writing Your Own function -----
## How do write a function: 
# 1. Identify what piece(s) will change within your commands AKA the argument
# 2. Remove it and replace with object(s) name(s)
# 3. Place code and argument into the function() function

## Pass-by-value: Changes or objects within the function only exist within the function (ie. what happens in the function, stays in the function)
# return is useful in functions with multiple variables as it retains the values.

f_to_k <- function(tempF) {
  ((tempF - 32) * 5/9) + 273.15
  return(k)
}
f_to_k(tempF = 72)


# Using dataframes in Functions -----
# Say you find yourself subsetting a portion of your dataframe again and again
library(tidyverse)
gapminder <- read.csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")
gapminder |>
  filter(country == "Canada", year %in% c(1950:1970)) |>
  summarize(meanGDP = mean(gdpPercap, na.rm = TRUE))

# Generalize the code (specific country & range of years)
avgGDP <- function(cntry, yr.range) {
  df <- gapminder |>
    filter(country == cntry, year %in% c(yr.range)) |>
    summarize(meanGDP = mean(gdpPercap, na.rm = TRUE))
  return(df)
}

avgGDP("United States", 1980:1995)