dat1 <- "lm(Grades ~ ReadComp + EducLvl)"
dat2 <- "lm(Grades ~ ReadComp + Educlm*Age)"

##install.packages("tidyverse")
##install.packages("stringr")


library(tidyverse)
library(stringr)

##dat <- unlist(str_split(dat, " ~ ", n=3))
##dat <- str_split(dat, "+", n=3)
##data <- strsplit(dat, split = "[ +~*)(]")

##data1 <- unlist(strsplit(dat1, split = "[+~*)(]+"))
##data2 <- unlist(strsplit(strsplit(dat2, split = "[+~*)(]")))


strsplits <- function(x, splits, ...)
{
  for (split in splits)
  {
    x <- unlist(strsplit(x, split, ...))
  }
  return(x[!x == ""]) # Remove empty values
}

## This cuts all punctuation. Will probably need to narrow it down to
## those that can't appear in variables "_" "-" 

data3 <- strsplits(dat1, c("[ +~*)(]","[[:space:]]","lm"))
data4 <- strsplits(dat2, c("[[:punct:]]","[[:space:]]","lm"))

grepl("*",dat2) ## tells if a string contains a specific char

## Number of variables in model
length(data4)


## Compare number of variables .. Gives you T or F 
length(data3) == length(data3)
length(data3) == length(data4)


identical(data3,data4)
identical(data3,data3)

## Tells you which variable are the same in each model
data3[data3 %in% data4]
data4[data4 %in% data3]

## Opposite

'%notin%' <- Negate(`%in%`)

data3[data3 %notin% data4]
data4[data4 %notin% data3]


