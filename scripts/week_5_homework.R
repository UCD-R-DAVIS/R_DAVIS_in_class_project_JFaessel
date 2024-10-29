## Question 1 ----- 
## Create a tibble named surveys from the portal_data_joined.csv file.
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)

## Manipulate surveys to create a new dataframe called "surveys_wide" with a column for genus and a column named after every plot type, with each of these columns containing the mean hindfoot length of animals in that plot type and genus.The dataframe should be sorted by values in the Control plot type column.
surveys_wide <- surveys %>%
  filter(!is.na(hindfoot_length)) %>%
  group_by(genus, plot_type) %>%
  summarise(mean_hindfoot_length = mean(hindfoot_length)) %>%
  pivot_wider(names_from = plot_type, values_from = mean_hindfoot_length) %>%
  arrange(Control)
surveys_wide

## Question 2 ----- 
## Using the original surveys dataframe, calculate a new weight category variable called weight_cat. For this variable, define the rodent weight into three categories, where “small” is less than or equal to the 1st quartile of weight distribution, “medium” is between (but not inclusive) the 1st and 3rd quartile, and “large” is any weight greater than or equal to the 3rd quartile. 

# case_when()
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)

surveys <- surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_cat = case_when(
    weight <= quantile(weight, probs = 0.25) ~ "small",
    weight > quantile(weight, probs = 0.25) & weight < quantile(weight, probs = 0.75) ~ "medium",
    weight >= quantile(weight, probs = 0.75) ~ "large"
  ))
surveys


# ifelse()
surveys1 <- surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_cat = ifelse(weight <= quantile(weight, probs = 0.25), "small",
                             ifelse ( weight > quantile(weight, probs = 0.25) & weight < quantile(weight, probs = 0.75), "medium", "large")))
surveys1

## NOTES:
## case_when() allows us to not use an "else" argument and just specify the final argument, while ifelse() does not allow you to leave out a final else argument.
## case_when includes NAs unless specified otherwise, while th "else" argument in ifelse() does not include NAs.


## BONUS: How might you soft code the values (i.e. not type them in manually) of the 1st and 3rd quartile into your conditional statements in question 2?
## Completed in Question 2 already, but alternative is:

summ <- summary(surveys$weight)
summ
summ[[1]]
summ[[2]]
summ[[3]]

surveys3 <- surveys %>% 
  mutate(weight_cat = case_when(
    weight >= summ[[2]] ~ "small",
    weight > summ[[2]] & weight < summ[[5]] ~ "medium",
    weight >= summ[[5]] ~ "large"
  ))
surveys3