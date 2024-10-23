# Data Manipulation 1a: Learning dplyr and tidyr
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)

# Select, Filter, and Pipes -----
## Select: Allows you to select certain columns, Filter: [...] by columns
month_day_year <- select(surveys, month, day, year)
## filtering by equals
filter(surveys, year == 1981)
year_1981 <- filter(surveys, year == 1981)

year_1981_baseR <- surveys[surveys$year == 1981,]
sum(year_1981$year != 1981, na.rm = T)
()()()

## filtering by range
filter(surveys, year %in% c(1981:1983))
# NOTE: NEVER do filter(surveys, year == c(1981, 1982, 1983)) bc that is 
# [...] index matching, not bucket searching, and recycles the vector
## same command
the80s <- surveys[surveys$year %in% 1981:1983,]
the80stidy <- filter(surveys, year %in% 1981:1983)


## filtering by multiple conditions
bigfoot_with_weight <- filter(surveys, hindfoot_length > 40 & !is.na(weight))
bigfoot_with_weight
## multi-step process
small_animals <- filter(surveys, weight < 5)
small_animals_ids <- select(small_animals, record_id, plot_id, species_id)

## same process, using nested functions
small_animal_ids <- select(filter(surveys, weight < 5), record_id, plot_id, species_id)
## same process, using a pipe... Cmd Shift M or %>%
small_animal_ids <- filter(surveys, weight < 5) %>% select(record_id, plot_id, species_id)
## or
small_animal_ids <- surveys %>% filter(
  weight < 5) %>% 
  select(record_id, 
         plot_id, species_id)



# Data Manipulation 1b
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)

# Mutate, Group_by, Summarize -----
## Mutate: Creates new columns of existing variables (tidyverse equivalent of $ in baseR)
surveys <- surveys %>% 
  mutate(weight_kg = weight/1000)
str(surveys)

## Adding multiple columns
surveys <- surveys %>% 
  mutate(weight_kg = weight/1000,
         weight_kg2 = weight_kg*2)
str(surveys)

# Filter out the NAs in multiple steps
surveys <- surveys %>% 
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight/1000,
         weight_kg2 = weight_kg*2)
str(surveys)

average_weight <- surveys %>%
  filter(!is.na(weight)) %>%
  mutate(mean_weight = mean(weight))
str(average_weight)


## Group_by: Performs operations by groups, works for columns with categorical data
## Summarize: Outputs a single row/column summarizing all observations in the input
surveys2 <- surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight))
surveys2

surveys3 <- surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight))
surveys3

surveys4 <- surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight))
surveys4

## Arrange: Organizes values by lowest to greatest, put "-" for reverse
surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight)) %>%
  arrange(mean_weight)
