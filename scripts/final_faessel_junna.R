## FINAL ##

## Question 1 ----- 
library(tidyverse)
library(ggplot2)
library("RColorBrewer")
url <- 'https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/refs/heads/main/data/tyler_activity_laps_12-6.csv'
tyler_laps <- read_csv(url)

## Question 2 -----
## Filter out any non-running activities.
## Question 3 -----
## Remove laps with a pace above 10 minute-per-mile pace and any abnormally fast laps (< 5 minute-per-mile pace) and abnormally short records where the total elapsed time is one minute or less.
tyler_running <- tyler_laps |>
  filter(sport == 'running') |>
  filter(minutes_per_mile <= 10 & minutes_per_mile >= 5) |>
  filter(total_elapsed_time_s > 60)
tyler_running

## Question 4 -----
## Group observations into three time periods corresponding to pre-2024 running, Tyler’s initial rehab efforts from January to June of this year, and activities from July to the present.
tyler_running <- tyler_running |>
  mutate(time_period = case_when(
    year < 2024 ~ "Pre-2024",
    year == 2024 & month <=6 ~ "Jan-June2024",
    year == 2024 & month >=7 ~ "July2024-Present"
  ))
glimpse(tyler_running$time_period)
unique(tyler_running$time_period)

## Question 5 -----
## Make a scatter plot that graphs SPM over speed by lap.
## Question 6 -----
## Make 5 aesthetic changes to the plot to improve the visual.
## Question 7 -----
## Add linear (i.e., straight) trendlines to the plot to show the relationship between speed and SPM for each of the three time periods.
tyler_running |>
  ggplot(aes(x = steps_per_minute, y = minutes_per_mile)) +
  geom_point(alpha = 0.5) +
  geom_smooth(mapping = aes(color = time_period), se = FALSE)+
  scale_color_brewer(palette = "YlGnBu") +
  labs(x = "Steps per Minute", y = "Speed (Minutes per Mile)") +
  ggtitle("Tyler's Laps: SPM over Speed") +
  theme_light() +
  theme(plot.title = element_text(hjust = 0.5))