createFolds <- function(data, k){

  s <- nrow(data)/k

  folds <- list(NULL)



  if( all.equal(s, as.integer(s)) != TRUE ){
    s <- floor(s)
  }

  bank <- 1:nrow(data)
  sub_bank <- bank

  for(i in 1:k){

    if(i < k){

      test <- sample(sub_bank, size = s, replace = F)
      sub_bank <- sub_bank[-test]

      train <- bank[-test]

    } else{

      test <- sub_bank
      train <- bank[-test]

    }

    folds[[i]] <- list(test = data[test, ], training = data[train, ])

    }

  return(folds)
}
