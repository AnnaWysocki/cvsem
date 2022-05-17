createFolds <- function(data, k){

  s <- nrow(data)/k

  folds <- list(NULL)



  if( all.equal(s, as.integer(s)) != TRUE ){
    s <- floor(s)
  }

  for( i in 0:(k-1) ) {

    rowstart <- 1 + (i * s)

    if( (i + 1) < k) {

      rowstop <- (i + 1) * s

    }else{

      rowstop <- nrow(data)
    }

    subsetrows <- rowstart:rowstop

    test <- data[subsetrows, ]
    training <- data[-subsetrows,]

    folds[[i + 1]] <- list(test = test, training = training)

  }
  return(folds)
}
