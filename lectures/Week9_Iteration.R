# Iteration

# Learning Objectives: 
## Understand when and why to iterate code
## Be able to start with a single use and build up to iteration
## Use for loops, apply functions, and purrr to iterate
## Be able to write functions to cleanly iterate code

library(tidyverse)
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")
head(iris)
head(mtcars)

# Refresher: Subsetting... 
# Column of data
head(iris[1]) # first column
head(iris %>% select(Sepal.Length))

# Vector of data
iris[[1]] # first column in a vector
iris[,1]
head(iris$Sepal.Length)

# Specific values
iris[1,1]
iris$Sepal.Length[1]


## For Loops -----
## Takes an index value and runs it through your function, "for(i in ...)"
# Useful because it stores the last value that went through the loop unlike functions, which doesn't save. Can do multiple things at once
for(i in 1:10){
  print(iris$Sepal.Length[i])
}
head(iris$Sepal.Length, n = 10)

for(i in 1:10){
  print(iris$Sepal.Length[i])
  print(mtcars$mpg[i])
}

## Storing the Output -----
results <- rep(NA, nrow(mtcars))
results #goes from NAs...

for(i in 1:nrow(mtcars)){
  results[i] <- mtcars$wt[i]*100
}
results #to calculated outcome



#Examples
## Vector example:
## 1. What do I want my output to be?
# We want an empty vector to fill up with values from our function
results <- rep(NA, nrow(mtcars)) 
## 2. What is the task I want my for loop to do?
mtcars$wt*100
## 3. What values do I want to loop through the task?
for(i in 1:nrow(mtcars)){
  results[i] <- mtcars$wt[i]*100
}

## Dataframe example:
for(i in unique(gapminder$country)){
  country_df <- gapminder[gapminder$country == i, ]
  df <- country_df %>%
    summarize(meanGDP = mean(gdpPercap, na.rm = TRUE))
  return(df)
  }
df
# how do we know for sure that the for loop is evaluating every country?
for(i in unique(gapminder$country)){
  country_df <- gapminder[gapminder$country == i, ]
  df <- country_df %>%
    summarize(meanGDP = mean(gdpPercap, na.rm = TRUE))
  print(df)
}
#??? How would I summarize so that the gdpPercap is averaged per country ???
gapminder |>
  group_by(country) |>
  summarize(meanGDP = mean(gdpPercap, na.rm = TRUE))


## Map Family of Functions -----
## Map functions are useful when you want to do something across multiple columns

## Two arguments: The Data & The Function
library(tidyverse)
map(iris, mean) # warning of NA for species, default is that the output is a list
map_df(iris, mean) # df in, df out, anything that follows the function is the desired output
map_df(iris[1:4], mean) # use subset to be a little more specific & select just columns with continuous data

print_mpg <- function(x, y){
  paste(x, "gets", y, "miles per gallon")
}
map2_chr(rownames(mtcars), mtcars$mpg, print_mpg)

# Embed "anonymous" function
map2_chr(rownames(mtcars), mtcars$mpg, function(x, y) paste(x, "gets", y, "miles per gallon"))