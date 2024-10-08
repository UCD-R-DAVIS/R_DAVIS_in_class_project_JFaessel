## Set Up -----

set.seed(15)
# set.seed is a random number generator that outputs reproducible results 
# ... based on a seed integer. 

hw2 <- runif(50, 4, 50)
# runif sets the number of values generated and the minimum and maximum range
# (n, min, max)

hw2 <- replace(hw2, c(4,12,22,27), NA)
# replaces the 4th, 12th, 22nd, and 27th numbers in the original "hw2" vector with NA.

hw2


## Question 1 -----
## Take your hw2 vector and removed all the NAs then select all the numbers 
## ... between 14 and 38 inclusive, call this vector prob1.

prob1 <- na.omit(hw2)
# prob1 is a new vector modified from the "hw2" vector.
# na.omit removes the NA values in a vector. It removed 4 NAs, leaving 46/50 values. 

prob1 <- prob1[c(prob1 >= 14 & prob1 <= 38)]
#[] subsets the vector "prob1" to only contain values between 14 and 38. 

prob1


## Question 2 -----
## Multiply each number in the prob1 vector by 3 to create a new vector called times3.
## Then add 10 to each number in your times3 vector to create a new vector called plus10.

times3 <- prob1 * 3 #multiplies vector values by 3.
times3

plus10 <- times3 + 10 #adds 10 to each vector value.
plus10

## Question 3 ---- 
## Select every other number in your plus10 vector by selecting the first number,
## ... not the second, the third, not the fourth, etc.

final <- plus10[c(TRUE, FALSE)]
# The c(TRUE, FALSE) logical vector selects the first value as true and the second as false. 
# The conditions are recycled throughout the entirety of the vector. 

final
