# Data Manipulation 2a: Conditional Statements
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)

## Conditional Statements
## ifelse: Runs a test, what to do if yes/true, what to do if no/false
## runs on base R and can handle NAs

surveys$hindfoot_cat <- ifelse(surveys$hindfoot_length < mean(surveys$hindfoot_length, na.rm = TRUE), yes = "small", no = "big")
head(surveys$hindfoot_cat)
head(surveys$hindfoot_length)

unique(surveys$hindfoot_cat) # gives you a summary of categorical data names

## case_when: Runs multiple if_else statements, great for (re)classifying data
## runs on tidyverse, cannot handle NAs so be specific about what to do with them 
#"~" reclassifies the data, next line is the "else" part

surveys %>%
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 31.5 ~ "big",
    hindfoot_length > 29 ~ "medium",
    is.na(hindfoot_length) ~ NA_character_,
    TRUE ~ "small")) %>%
  select(hindfoot_length, hindfoot_cat) %>%
  head(100)
View()

surveys %>%
  mutate(favorites = case_when(
    year < 1990 & hindfoot_length > 29.29 ~ "number1", 
    species_id %in% c("NL", "DM", "PF", "PE") ~ "number2",
    month == 4 ~ "number3",
    TRUE ~ "other")) %>%
  group_by(favorites) %>%
  tally()


# Data Manipulation 2b: Joins and Pivots
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
tail <- read_csv('data/tail_length.csv')
dim(surveys)
dim(tail)

tail <- tail[sample(1:nrow(tail), 15e3),]

# Join -----
# join_function(data frame a, data frame b, how to join)
# NOTE: You should use dim when you are joining 

## Inner_join: (data frame x, data frame y, common id). Only keeps records that are in BOTH data frames
surveys_inner <- inner_join(x = surveys, y = tail)
dim(surveys_inner)

## Left_join: Takes dataframe x and dataframe y and it keeps EVERYTHING in x and only MATCHES in y
surveys_left <- left_join(x = surveys, y = tail)
dim(surveys_left)

## Right_join: Takes dataframe x and dataframe y and it keeps EVERYTHING in y and only MATCHES in x. You can also do left_join(y= , x= )
surveys_right <- left_join(y = surveys, x = tail)
dim(surveys_right)

## Full_join: Keeps EVERYTHING
surveys_full_joined <- full_join( x = surveys, y = tail)
dim(surveys_full_joined)

?cross_join
left_join(surveys, tail %>%
      rename(record_id2 = record_id), 
      by = c('record_id' = 'record_id2'))


# Pivot -----

surveys_mz <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(genus, plot_id) %>% 
  summarize(mean_weight = mean(weight))
surveys_mz

## Pivot_wider makes data with more columns

surveys_mz %>% 
  pivot_wider(id_cols = 'genus',
              names_from = 'plot_id', values_from = 'mean_weight' )

## pivot_longer makes data with more rows
surveys_long <- wide_survey %>% 
  pivot_longer(-genus, 
  names_to = 'plot_id', values_to = 'mean_weight')
surveys_long