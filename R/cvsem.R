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
#' data <- c(1, 2, 3)
#' Models <- "xx"
#' cvsem(x = data, Models = Models)

cvsem <- function(x, Models, k = 5){
  print("Place holder for cv function")
}



