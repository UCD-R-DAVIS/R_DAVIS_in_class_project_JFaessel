#Project Management

#Working Directory and File Paths ----- 
##setwd() is to change file path 
getwd()
setwd()

d <- read.csv("./data/tail_length.csv")

#Code and Data Organization ----- 
##Best Practices... 
# Treat raw data as read only
# Treat generated output as disposable
# dir.create("./lectures")
dir.create("./lectures.")

#How R Thinks About Data

#Vectors -----
#c is anytime you have more than 1 value
weight_g <- c(50, 60, 65, 82)
weight_one_value <- c(50)
animals <- c("mouse", "rat", "cat", "dog")
animals

#Inspection -----
length (weight_g)
str(weight_g)

#Change Vectors -----
weight_g <- c(weight_g, 90)
str(weight_g)

#Subsetting ----- 
animals <- c("mouse", "rat", "cat", "dog")
animals
animals[2]
animals[c(2,3)]
#Indexing: Take items from a vector and create a new combination of values

#Conditional Subsetting ----- 
weight_g <- c(21, 34, 39, 54, 55)
weight_g > 50
weight_g[weight_g > 50]

#Symbols ----
#%in% within a bucket
#== pairwise matching -- ORDER MATTERS

animals
#"mouse" "rat" "dog" "cat"
animals %in% c("rat", "cat", "dog", "duck", "goat")
animals == c("rat", "cat", "dog", "duck", "goat")


#Challenge!

num_char <- c(1, 2, 3, "a") 
num_logical <- c(1, 2, 3, TRUE) 
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")

num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
combined_logical <- c(num_logical, char_logical)

#NOTE: Every vector has to have all the same type of input. 
#num_char... Input treated as a character, chooses lowest common denominator
#num_logical... #Coerces values to be the same, eg. when TRUE is included it became a binary string
#char_logical... #Inputs treated as a character, even including TRUE.
#tricky... ()()()



