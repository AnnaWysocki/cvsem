#' Compute Kullback Liebler (KL) Divergence on two covariance matrices. KL-Divergence corresponds to the
#' Maximum Wishart Likelihood (MWL) discrepancy described in \insertCite{Cudeck1983}{cvsem}.
#'
#' @param implied_sigma Model implied covariances matrix from training set
#' @param test_S Sample covariance matrix from test set
#' @return KL-Divergence index
#' @importFrom Rdpack reprompt
#' @references
#'    \insertAllCited()
#'
KL_divergence <- function(implied_sigma, test_S){

  p <- ncol(implied_sigma)

  KL <- (sum(diag(solve(test_S) %*% implied_sigma)) - p + log(det(test_S)/det(implied_sigma)) )
  return(KL)
}


##' Generalized Least Squares (GLS) Discrepancy as defined in \insertCite{Cudeck1983}{cvsem}.
##' @title Generalized Least Squares Discrepancy Function
##' @param implied_sigma Model implied covariances matrix from training set
##' @param test_S Sample covariance matrix from test set
##' @return GLS discrepancy
##' @references
##'    \insertAllCited()
gls <- function(implied_sigma, test_S) {
  gls <- .5 * sum(diag( solve(test_S)%*%(test_S - implied_sigma) ))^2
  return( gls )
}

##' Frobenius Distance as described in \insertCite{Biscay1997}{cvsem} or \insertCite{Amendola2015}{cvsem}.
##' @title Frobenius Matrix Discrepancy
##' @param implied_Sigma Model implied covariances matrix from training set
##' @param test_S Sample covariance matrix from test set
##' @return FD discrepancy
##' @references
##'    \insertAllCited()
fd <- function( implied_Sigma, test_S ) {

  fd <- sum((implied_Sigma - test_S)^2)

  return(fd)
}
