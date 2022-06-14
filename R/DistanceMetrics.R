#' Compute KL-Divergence on two covariance matrices
#'
#' @param implied_sigma Model implied covariances matrix from training set
#' @param test_S Sample covariance matrix from test set
#' @return KL-Divergence index
#' @export
#'
#' @examples
#'
#' example_data <- lavaan::HolzingerSwineford1939
#' colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
#'                            "visualPerception", "cubes", "lozenges", "comprehension",
#'                            "sentenceCompletion", "wordMeaning", "speededAddition",
#'                            "speededCounting", "speededDiscrimination")
#'
#' model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'
#'
#'fit<- lavaan::sem(model1, data = example_data)
#'
#'implied_sigma <- fit@implied[["cov"]][[1]]
#'test_S <- fit@SampleStats@cov[[1]]

#' KL_divergence(implied_sigma , test_S)

KL_divergence <- function(implied_sigma, test_S){

  p <- ncol(implied_sigma)

  KL <- (sum(diag(solve(test_S) %*% implied_sigma)) - p + log(det(test_S)/det(implied_sigma)) )
  return(KL)
}


#' Compute Maximum Wishart Likelihood (MWL) on two covariance matrices
#'
#' @param implied_sigma Model implied covariances matrix from training set
#' @param test_S Sample covariance matrix from test set
#' @return MWL index
#' @export
#'
#' @examples
#'
#' example_data <- lavaan::HolzingerSwineford1939
#' colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
#'                            "visualPerception", "cubes", "lozenges", "comprehension",
#'                            "sentenceCompletion", "wordMeaning", "speededAddition",
#'                            "speededCounting", "speededDiscrimination")
#'
#' model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'
#'
#'fit<- lavaan::sem(model1, data = example_data)
#'
#'implied_sigma <- fit@implied[["cov"]][[1]]
#'test_S <- fit@SampleStats@cov[[1]]

#' MWL(implied_sigma , test_S)

MWL <- function(implied_sigma, test_S){

  p <- ncol(implied_sigma)
  mwl <-
    log( det(test_S) ) - log( det(implied_sigma) ) + sum(diag( implied_sigma %*% solve(test_S) ) ) - p
  return(mwl)
}







