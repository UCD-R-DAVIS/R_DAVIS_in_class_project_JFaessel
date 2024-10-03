#Week 2: Intro to R
#Run commands with ctrl+enter. 
#You can access help files with ?log
#Errors halt a task, Warnings will attempt to finish the task

#Challenge
elephant1_kg <- 3492
elephant2_lb <- 7757

elephant1_lb <- elephant1_kg * 2.2
elephant1_lb > elephant2_lb
myelephants <- c(elephant1_lb, elephant2_lb)
which(myelephants == max(myelephants))