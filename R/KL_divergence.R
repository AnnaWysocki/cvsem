#' Compute KL-Divergence on two covariance matrices
#'
#' @param S0 Model implied covariances matrix from training set
#' @param S1 Sample covariance matrix from test set
#' @return KL-Divergence index
#' @export
#'
#' @examples
#'
#' library(lavaan)
#'model<- 'X3~X2+X1'
#'data<-simulateData(model)
#'fit<- lavaan::sem(model, data=data)
#'implied<-fit@implied[["cov"]][[1]]
#'sample<-fit@SampleStats@cov[[1]]

#'KL_divergence(sample,implied)

KL_divergence <- function(S0, S1){

  K = ncol(S0)
  kl<- log(det(S1)/det(S0)) - sum(diag((S1-solve(S0)))) + K
  return(kl)
}
