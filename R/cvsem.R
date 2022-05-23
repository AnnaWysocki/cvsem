#' Do model comparison on SEM models using cross-validation
#'
#' @param x Data
#' @param Models A list of specified models in lavaan syntax
#' @param distanceMetric Specify which distance metric to use. Default is KL Divergence. Other option is the Maximum Wishart Likelihood (MWL)
#' @param k The number of folds. Default is 5.
#' @param lavaan_function Specify which lavaan function to use. Default is "sem". Other options are "lavaan" and "cfa"
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


cvsem <- function(x, Models, distanceMetric = "KL-Divergence", k = 5, lavaanFunction = "sem"){

  stopifnot("`k` must be numeric " = is.numeric(k))

  match.arg(arg = lavaanFunction, choices = c("sem", "lavaan", "cfa"))
  match.arg(arg = distanceMetric, choices = c("KL-Divergence", "MWL"))


  model_number <- length(Models)
  model_cv <- data.frame(Model = rep(0, model_number),
                         Cross_Validation = rep(0, model_number))

  folds <- createFolds(x, k = k)

  if( nrow(folds[[1]]$test) < 2 ) stop('Covariance matrix cannot be computed because at least one of your test folds has fewer than two rows of data.')

  if(is.null(names(Models)) != TRUE){

    model_names<- names(Models)

  }else{

    model_names <- paste0("Model_", seq( 1: model_number))}

  for(j in seq_len(model_number) ){

    model <- Models[[j]]
    cv_index <- NULL

    for(i in 1:k){

      train_data <- folds[[i]]$training

      if(lavaanFunction == "sem"){
        model_results <- lavaan::sem(model = model, data = train_data)
      } else if (lavaanFunction == "lavaan"){
        model_results <- lavaan::lavaan(model = model, data = train_data)
      } else{
        model_results <- lavaan::cfa(model = model, data = train_data)}


      implied_sigma_lavaan <- lavaan::inspect(model_results, what = "cov.ov")

      implied_sigma <- matrix(data = 0, nrow = nrow(implied_sigma_lavaan), ncol = ncol(implied_sigma_lavaan))
      implied_sigma[lower.tri(implied_sigma)] <- implied_sigma_lavaan[lower.tri(implied_sigma_lavaan)]
      implied_sigma <- implied_sigma + t(implied_sigma)
      diag(implied_sigma) <- diag(implied_sigma_lavaan)

      test_S <- stats::cov(folds[[i]]$test[, colnames(lavaan::inspect(model_results, what = "data"))])

      if( any(is.na(test_S)) == TRUE ) stop('NAs have been returned for a test covariance matrix.
                                            Try decreasing the number of folds.')

      if(distanceMetric == "KL-Divergence"){

        distance <- KL_divergence(implied_sigma , test_S)

      } else(

        distance <- MWL(implied_sigma , test_S)
      )


      if(is.na(distance) == TRUE){
        stop("Cross validation index cannot be computed. Try decreasing the number of folds.")
      }

      ## collect distance metrics for each fold
      cv_index[i] <- distance
    }

    model_cv[j,] <- data.frame(Model = model_names[j], Cross_Validation_Index = mean(cv_index))
    colnames(model_cv) <- c("Model", paste0(distanceMetric, "_Index"))
  }

  return(model_cv)

  }
