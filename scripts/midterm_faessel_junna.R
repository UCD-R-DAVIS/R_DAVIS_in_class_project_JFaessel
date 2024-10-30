## MIDTERM ##

## Question 1 ----- 
## Read in the file tyler_activity_laps_10-24.csv from the class github page.
library(tidyverse)
database <- read.csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv")
str(database)

## Question 2 ----- 
## Filter out any non-running activities.
## Question 3 -----
## Remove laps with a pace above 10 minute-per-mile pace and any abnormally fast laps (< 5 minute-per-mile pace) and abnormally short records where the total elapsed time is one minute or less.
running_stats <- database %>%
  filter(sport == 'running') %>%
  filter(minutes_per_mile <= 10 & minutes_per_mile >= 5) %>%
  filter(total_elapsed_time_s > 60)
running_stats

## Question 4 -----
## Create a new categorical variable, pace, that categorizes laps by pace: “fast” (< 6 minutes-per-mile), “medium” (6:00 to 8:00), and “slow” ( > 8:00). 
##Create a second categorical variable, form that distinguishes between laps run in the year 2024 (“new”, as Tyler started his rehab in January 2024) and all prior years (“old”).
running_stats <- database %>%
  mutate(pace = case_when(
    minutes_per_mile < 6 ~ "fast",
    minutes_per_mile >= 6 & minutes_per_mile <= 8 ~ "medium",
    minutes_per_mile > 8 ~ "slow"
    )) %>%
  mutate(form = ifelse(year == 2024, "new", "old"))
running_stats


## Question 5 -----
## Identify the average steps per minute for laps by form and pace, and generate a table showing these values with old and new as separate rows and pace categories as columns. 
## Make sure that slow speed is the second column, medium speed is the third column, and fast speed is the fourth column.
running_stats %>%
  group_by(pace, form) %>%
  summarize(avg_steps_per_minute = mean(steps_per_minute)) %>%
  pivot_wider(id_cols = form, names_from = pace, values_from = avg_steps_per_minute) %>%
  select(form, slow, medium, fast)


## Question 6 -----
## Summarize the minimum, mean, median, and maximum steps per minute results for all laps (regardless of pace category) run between January - June 2024 and July - October 2024 for comparison.
