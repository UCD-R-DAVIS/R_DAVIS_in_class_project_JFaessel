## Question 1 -----
## Create a tibble named surveys from the portal_data_joined.csv file.
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)

## Question 2 -----
## Subset surveys using Tidyverse methods to keep rows with weight between 
## ... 30 and 60, and print out the first 6 rows.
surveys %>%
  filter(weight >= 30 & weight <= 60) %>%
  head(surveys, n = 6)

## Question 3 -----
## Create a new tibble showing the maximum weight for each species + sex combination and name it biggest_critters. 
## ... Sort the tibble to take a look at the biggest and smallest species + sex combinations.

biggest_critters <- surveys %>%
  group_by(species_id, sex) %>%
  filter(!is.na(weight)) %>%
  summarize(max_weight = max(weight)) %>%
  arrange(-max_weight)

biggest_critters

## Question 4 -----
## Try to figure out where the NA weights are concentrated in the data
##... is there a particular species, taxa, plot, etc where there are lots of NA values?

surveys %>%
  filter(is.na(weight)) %>%
  group_by(species) %>%
  tally () %>%
  arrange(desc(n))

surveys %>%
  filter(is.na(weight)) %>%
  group_by(plot_id) %>%
  tally () %>%
  arrange(desc(n))

surveys %>%
  filter(is.na(weight)) %>%
  group_by(year) %>%
  tally () %>%
  arrange(desc(n))

## Question 5 -----
## Take surveys, remove the rows where weight is NA and add a column that contains 
## ... the average weight of each species+sex combination to the full surveys dataframe. 
## ... Then get rid of all the columns except for species, sex, weight, and your new average weight column. 
## ... Save this tibble as surveys_avg_weight.

surveys_avg_weight <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(species, sex) %>%
  mutate(avg_weight = mean(weight)) %>%
  select(species, sex, weight, avg_weight)
surveys_avg_weight

## Question 6 -----
## Take surveys_avg_weight and add a new column called above_average that contains logical values
##... stating whether or not a row’s weight is above average for its species+sex combination.

surveys_avg_weight <- surveys_avg_weight %>%
  mutate(above_average = weight > avg_weight)
surveys_avg_weight