# How R Thinks About Data
# Matrices are 2D, arrays are 3D
# Function is parentheses, data frame or object to modify is bracket


# Other Data --
## Lists
c(4, 6, "dog")
a <- list(4, 6, "dog")
class(a)
str(a) #displays the internal structure of an object

b <- list(4, letters, "dog")
str(b)
length(b)
length(b[[2]]) #gives you the length of a vector inside an object as a number
str(b[[2]]) #will do the same but with everything written out


##Data.frames
letters
data.frame(letters)
df <- data.frame(letters)
as.data.frame(t(df)) #transposes the dimensions of a data frame

length(df) # number of columns
dim(df) # dimensions AKA number of rows, columns
nrow(df)
ncol(df)


## factors: a combination of some string value with order
animals <- factor(c("duck", "duck", "pig", "goose"))

animals
class(animals)
levels(animals)
nlevels(animals)

animals <- factor(animals, levels = c("goose", "pig", "duck")) #assigns the levels AKA order
animals

year <- factor(c(1978, 1980, 1934, 1979))
year
class(year)
as.numeric(year)
as.character(year)
levels(year)


#--------------------------------------------------------#
#Spreadsheets ----- 

file_loc <- 'data/portal_data_joined.csv'
surveys <- read.csv(file_loc)

nrow(surveys)
ncol(surveys)
dim(surveys)
str(surveys)
summary(surveys)
summary(surveys$record_id)


colnames(surveys)
surveys[c('record_id', 'year', 'day')]
head(surveys, n = 10) #prints out top 10 rows
tail(surveys, n = 10) #prints out last 10 rows

surveys[1,5] # element from 1st row and 5th column
surveys[1,] # all elements in the 1st row
surveys[,1] # all elements in the 1st column

surveys[1:5] # all elements in the first 5 columns 
surveys[1:5,] # all elements in the first 5 rows
surveys[,1:5] # same as [1:5], returns all elements in first 5 columns
surveys[c(1,5,24, 3001),] #returns the elements in the selected rows <-L66 shows how for columns

surveys[,-1] #removes first column
surveys[-1,] #removes first row
surveys[-c(7:nrow(surveys))] #removes the 7th and following rows

surveys[1:5,1:5] # matrix of the first 5 columns and rows
surveys[c(1,4,10),c(2,4,6)] #matrix of specified columns and rows

# Note: You can replace the digits with names!
# Note: You can combine these commands with head/tail!
    #Example... head(surveys[c("genus","species")], n = 10)


surveys$plot_id # "$" allows you to access elements from an object by name
# Notes: Also allows you to extract, add, and delete elements and columns from an object


#--------------------------------------------------------#
## Tidyverse -- 
install.packages('tidyverse')
library(tidyverse)
?read_csv
t_surveys <- read_csv('data/portal_data_joined.csv')
class(t_surveys)
t_surveys

surveys[,1]
t_surveys[,1]
