##' This is function generates folds
##' @title 
##' @param data 
##' @param K 
##' @param ... 
##' @return 
##' @author philippe
cv <- function(data, K = 10, ...) {
    cv_dat <- caret::createFolds(y =  data, k =  K)
    return( cv_dat )
}


data <- data.frame(replicate(5, rnorm(100)))
data


testIndices <- caret::createFolds(y =  data
num_folds <- length(testIndices )

test <- data[testIndices[[1]]]
train <- data[-testIndices[[1]]]
train


