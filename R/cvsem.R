##' Internal function to extract variable names for each tested model
##' This is used to find largest umber of folds K
##' @param X lavaan model
##' @param data Data
##' @return list of variable names
##' @author philippe
##' @keywords internal
.lavaan_vars <- function(X, data) {
  ## Check what is in the cvgather list; either model specification or a fitted lavaan model
  if(class(X)[1] == "character" ) {
    obj <- lavaan::lavaanify(model = X)
    unique_names <- unique( c( obj$lhs, obj$rhs ) )
  } else if (class(X)[1] == "lavaan" ) {
    unique_names <- lavaan::lavNames(X)
  }
  given_names <- colnames( data )
  unique_names[unique_names %in% given_names]
}


#' Do model comparison on SEM models using cross-validation as described
#' in \insertCite{Cudeck1983}{cvsem} and  \insertCite{BrowneCudeck1992}{cvsem}.
#' Cross-validation is based on the discrepancy between the sample covariance matrix and
#' the model implied matrix. Currently, `cvsem` supports 'Kullback Liebler Divergence', Frobenius Distance
#' and Generalized Least Squares 'GLS' as discrepancy metrics.
#'
#' @title Cross-Validation of Structural Equation Models
#' @param data Data
#' @param Models A collection of models, specified in lavaan syntax. Provide Models with the `cvgather()` function.
#' @param discrepancyMetric Specify which discrepancy metric to use (one of 'KL-Divergence', 'FD', 'GLS'). Default is KL Divergence.
#' @param k The number of folds. Default is 5.
#' @param lavaanFunction Specify which `lavaan` function to use. Default is "sem". Other options are "lavaan" and "cfa"
#' @param echo Provide feedback on progress to user, defaults to `TRUE`. Set to `FALSE` to suppress.
#' @param ... Not used
#' @return A list with the prediction error for each model.
#' @importFrom stats cov
#' @importFrom Rdpack reprompt
#' @references
#'    \insertAllCited()
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
#' model1 <- 'comprehension ~ meaning
#'
#'            ## Add some latent variables:
#'         meaning =~ wordMeaning + sentenceCompletion
#'         speed =~ speededAddition + speededDiscrimination + speededCounting
#'         speed ~~ meaning'
#'
#' model2 <- 'comprehension ~ wordMeaning + speededAddition'
#' model3 <- 'comprehension ~ wordMeaning + speededAddition'
#'
#' models <- cvgather(model1, model2, model3)
#'
#' fit <- cvsem( data = example_data, Models = models, k = 10, discrepancyMetric = "KL-Divergence")
#'
cvsem <- function(data = NULL, Models, discrepancyMetric = "KL-Divergence", k = 5, lavaanFunction = "sem", echo = TRUE, ...){

  stopifnot("`k` must be numeric " = is.numeric(k))
  if(is.null(data)) stop("Provide data in `data`")

  match.arg(arg = tolower(lavaanFunction), choices = c("sem", "lavaan", "cfa"))
  match.arg(arg = tolower(discrepancyMetric), choices = c("kl-divergence", "kl-d", "kl", "mwl", "gls", "fd"))

  if ( !inherits(Models,  what = 'cvgather' ) ) stop("Use `cvgather` to collect the models for the `Models` argument.")

    model_number <- length(Models)
    model_cv <- data.frame(Model = rep(0, model_number),
                           Cross_Validation = rep(0, model_number),
                           SE = rep(0, model_number),
                           Model_Warnings= rep(0, model_number))


    ## Check for K; it can not be so large to generate test sets that are high-dimensional
    ## i.e., nrow > ncol of test data to be able to invert covariance matrix
    ## First: Obtain model with maximal amount of variables - this defines the max(K) that is allowed
    ##
    ## Extract observed variable names for model
    model_vars <- lapply( Models, FUN = .lavaan_vars, data = data )

    ## Find number of unique variables across all models. Since we want to compare
    ## covariance matrices that are the same size, we will augment each of the
    ## model-implied covariance matrices to have the same variables across the models
    ## we want to compare

    all_var_labels <- unique( unlist( model_vars ) )

    ## TODO: If we use max_vars in the creation of the cov-mat it might create
    ## very large sparse matrices - may need to be revisited and replaced
    ## with max_vars_model.
    ## This finds the single largest model:
    max_vars_model = max( sapply( model_vars, FUN = length ) )
    ## This finds the longest combination of variables across all models:
    max_vars <- length(all_var_labels)

    ## Check user provided k and check against highest possible K. Stop and warn if
    ## K is too large. Round to next lower integer with floor()
    ## Max k is for nrows/(vars + 1)
    max_k <- floor( nrow(data)/( max_vars_model + 1 ) )

    if( k > max_k ) stop('\n Covariance matrix cannot be inverted. \n At least one of your test folds has fewer rows than columns of data. \n Decrease k to at least: ', max_k)

    folds <- createFolds(data, k = k)

    if(is.null(names(Models)) != TRUE){

      model_names<- names(Models)

    }else{

      model_names <- paste0("Model_", seq( 1: model_number))

    }

    ## Loop through list of models and compute discrepancyMetric
    ## discrepancyMetric needs to be computed on matrix that comprises
    ## all possible variables, as KL contain penalty for size of matrix.
    ## Augment impled variance to match that larger matrix.
    for(j in 1:model_number ){

      model <- Models[[j]]
      cv_index <- NULL

      ## Give some feedback
      if( echo ) {
        print(paste0( 'Cross-Validating model: ', model_names[j] ) )
      }

      model_warning <- rep(0, k)
      ## CV:
      for(i in 1:k){

        ## extract training data:
        train_data <- folds[[i]]$training

        ## Fit model on traingin data:
        if(lavaanFunction == "sem"){
          model_results <- lavaan::sem(model = model, data = train_data)
        } else if (lavaanFunction == "lavaan"){
          model_results <- lavaan::lavaan(model = model, data = train_data)
        } else{
          model_results <- lavaan::cfa(model = model, data = train_data)}

         model_warning[i] <- lavaan::inspect(model_results, what = "post.check")


        ## Obtain test sample covariance matrix
        test_data <- folds[[i]]$test

        test_S <- cov(test_data[, all_var_labels])

        if( any(is.na(test_S)) == TRUE ) stop('NAs have been returned for a test covariance matrix. Inspect your data for missing values.')

        ## Obtain training model-implied covariance matrix

        ## First extract model-implied covariance matrix of observed variables.
        ## lavaan returns lower.tri so we have to make the matrix symmetric manually

        implied_sigma_lavaan <- lavaan::inspect(model_results, what = "cov.ov")

        implied_sigma <- matrix(data = 0, nrow = nrow(implied_sigma_lavaan),
                                ncol = ncol(implied_sigma_lavaan))
        implied_sigma[lower.tri(implied_sigma)] <- implied_sigma_lavaan[lower.tri(implied_sigma_lavaan)]
        implied_sigma <- implied_sigma + t(implied_sigma)
        diag(implied_sigma) <- diag(implied_sigma_lavaan)

        colnames(implied_sigma) <- rownames(implied_sigma) <- colnames(implied_sigma_lavaan)

                                        # Next, augment the covariance matrix (if needed) so that the test covariance matrix has same
                                        # variables as test_S

        if( !setequal( colnames( implied_sigma ), colnames( test_S ))){

          aug_implied_sigma <- matrix(0, nrow = max_vars, ncol = max_vars)
          colnames(aug_implied_sigma) <- rownames(aug_implied_sigma) <- colnames(test_S)

          for(c in 1:max_vars){

            columnname <- all_var_labels[c]

            for(r in 1:max_vars){

              rowname <- all_var_labels[r]

              ## Call try() with silent to avoid error message in console
              try(aug_implied_sigma[rowname, columnname] <- implied_sigma[rowname, columnname],
                  silent = TRUE)
            }
          }

          ## Add sample variances to 0 diagonals
          add_variances <-  which( diag(aug_implied_sigma) == 0)

          for(v in 1:length(add_variances)){

            aug_implied_sigma[add_variances[v], add_variances[v]] <-
              test_S[add_variances[v], add_variances[v]]

          }

          implied_sigma <- aug_implied_sigma
        }

        if( tolower(discrepancyMetric) == "kl-divergence" |
            tolower(discrepancyMetric) == "mwl" |
            tolower(discrepancyMetric) == "kl" |
            tolower(discrepancyMetric) == "kl-d"){

          distance <- KL_divergence(test_S, implied_sigma)

        } else if ( tolower(discrepancyMetric) == "gls") {

          distance <- gls(implied_sigma , test_S)

        } else if ( tolower(discrepancyMetric) == "fd") {

          distance <- fd(implied_sigma , test_S)

        }

        if(is.na(distance) == TRUE){
          stop("Cross validation index cannot be computed. Try decreasing the number of folds.")
        }

        ## collect discrepancy metrics for each fold
        cv_index[i] <- distance
      }

      model_cv[j,] <- data.frame(Model = model_names[j],
                                 Cross_Validation_Index = mean(cv_index),
                                 SE = stats::sd(cv_index),
                                 Warning = any(model_warning == 0))
      colnames(model_cv) <- c("Model", paste0(discrepancyMetric, "_Index"), "SE",
                              "Model_Warnings")
    }

    out = list(model_cv = model_cv,
               k = k,
               discrepancyMetric = discrepancyMetric)

    class(out) = "cvsem"
    out
  }
