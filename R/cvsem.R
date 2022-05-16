#' Do model comparison on SEM models using cross-validation
#'
#' @param x Data
#' @param Models A list of specified models in lavaan syntax
#' @param k The number of folds. Default is 5.
#'
#' @return A list with the prediction error for each model.
#' @export
#'
#' @examples
#'
#' example_data <- lavaan::HolzingerSwineford1939
#' colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
#' "visualPerception", "cubes", "lozenges", "comprehension",
#' "sentenceCompletion", "wordMeaning", "speededAddition",
#' "speededCounting", "speededDiscrimination")
#'
#' model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'

#' model2 <- 'comprehension ~ wordMeaning
#'            sentenceCompletion ~ wordMeaning
#'
#'            comprehension ~~ 0*wordMeaning'
#'

#' model_list <- list(model1, model2)
#'


cvsem <- function(x, Models, k = 5){

  model_number <- length(Models)
  model_cv <- data.frame(Model = rep(0, model_number),
                         Cross_Validation = rep(0, model_number))

  folds <- createFolds(x)

  if(is.null(names(Models)) != TRUE){

    model_names<- names(Models)

  }else{

    model_names <- paste0("Model_", seq( 1: model_number))}

  for(j in 1: model_number){

    model <- Models[[j]]
    cv_index <- NULL

    for(i in 1:k){

      train_data <- folds[[i]]$training
      model_results <- lavaan::sem(model = model, data = train_data)

      implied_sigma_lavaan <- lavaan::inspect(model_results, what = "cov.ov")

      implied_sigma <- matrix(data = 0, nrow = nrow(implied_sigma_lavaan), ncol = ncol(implied_sigma_lavaan))
      implied_sigma[lower.tri(implied_sigma)] <- implied_sigma_lavaan[lower.tri(implied_sigma_lavaan)]
      implied_sigma <- implied_sigma + t(implied_sigma)
      diag(implied_sigma) <- diag(implied_sigma_lavaan)

      test_S <- stats::cov(folds[[i]]$test[, colnames(lavaan::inspect(model_results, what = "data"))])

      cv_matrix <- log(implied_sigma) - log(test_S) + sum(diag(test_S %*% implied_sigma - 1)) - ncol(test_S)
      cv_index[i] <- cv_matrix[1,1]
    }

    model_cv[j,] <- data.frame(Model = model_names[j], Cross_Validation_Index = mean(cv_index))
  }

  return(model_cv)

  }




