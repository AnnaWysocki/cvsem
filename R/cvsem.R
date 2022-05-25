##' Internal function to extract variable names for each tested model
##' This is used to find largest umber of folds K
##' @param X 
##' @param data 
##' @return list of variable names
##' @author philippe
##' @keywords internal
.lavaan_vars <- function(X, data) {
  obj <- lavaan::lavaanify(model = X)
  unique_names <- unique( c( obj$lhs, obj$rhs ) )
  given_names <- names( data )
  unique_names[unique_names %in% given_names]
}


#' Do model comparison on SEM models using cross-validation
#'
#' @param x Data
#' @param Models A list of specified models in lavaan syntax
#' @param distanceMetric Specify which distance metric to use. Default is KL Divergence. Other option is the Maximum Wishart Likelihood (MWL)
#' @param k The number of folds. Default is 5.
#' @param lavaanFunction Specify which lavaan function to use. Default is "sem". Other options are "lavaan" and "cfa"
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
  
  
  ## Check for K; it can not be so large to generate test sets that are high-dimensional
  ## i.e., nrow > ncol of test data to be able to invert covariance matrix
  ## First: Obtain model with maximal amount of variables - this defines the max(K) that is allowed
  ##
  ## Extract observed variable names for model 
  model_vars = lapply(Models, FUN = .lavaan_vars,  data = x )

  ## Find highes number of models across all models:
  max_vars = max( sapply( model_vars, FUN = length ) )

  ## Check user provided k and check against highest possible K. Stop and warn if
  ## K is too large. Round to next lower integer with floor()
  ## Max k is for nrows/(vars + 1) 
  max_k = floor( nrow(x)/( max_vars + 1 ) )

  if( k > max_k ) stop('\n Covariance matrix cannot be inverted. \n At least one of your test folds has fewer rows than columns of data. \n Decrease k to at least: ', max_k)

  folds <- createFolds(x, k = k)
    
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

  out = list(model_cv = model_cv,
             k = k,
             distanceMetric = distanceMetric)
  
  class(out) = "cvsem"
  out
}
