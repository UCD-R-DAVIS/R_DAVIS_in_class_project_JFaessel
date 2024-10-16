## Question 1 -----
## Load your survey data frame with the read.csv() function.
file_loc <- 'data/portal_data_joined.csv'
surveys <- read.csv(file_loc)

## Create a new data frame called "surveys_base" with only the species_id, weight, and  plot_type columns.
survey_base <- surveys[1:5000, c("species_id", "weight", "plot_type")]

## Convert both species_id and plot_type to factors. 
survey_base$species_id <- factor(survey_base$species_id)
class(survey_base$species_id)
survey_base$plot_type <- factor(survey_base$plot_type)
class(survey_base$plot_type)

## Remove all rows where there is an NA in the weight column.
survey_base <- survey_base[complete.cases(survey_base$weight),]
survey_base
# Personal Note: na. omit() removes all rows with any NA values from the object, 
# ... while complete.cases() identifies these rows and allows you to keep or discard specific portions of your dataset.


## Explain why a factor is different from a character. 
# A factor represents categorical data with limited/defined set of values and are stored as integers. 
# In contrast, characters do not hold specific meaning and are stored as strings. 

## Why might we want to use factors? Can you think of any examples?
# Factors are especially useful when you are managing large volumes of data that you
# ... wish to reorder and modify. For example, factors can be used to build forest
# ... cover models with different vegetation types. 



## Challenge! -----
## Create a second data frame called challenge_base that only consists of individuals
##... from your surveys_base data frame with weights greater than 150g.
challenge_base <- survey_base[survey_base$weight>150,]
challenge_base