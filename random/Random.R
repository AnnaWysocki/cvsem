data <- rbinom(100,15,.5)

n <- length(data)

x <- sample(data,n,replace = F, prob = NULL)

