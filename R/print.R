##' Return the ordered list of models where the model with the smallest distance metric is listed first. 
##' @title Print cvsem object
##' @param x cvsem object
##' @param digits Round to (default 2) digits.  
##' @param ... not used
##' @return Formatted cvsem object
##' @export
print.cvsem <- function(x,  digits = 2, ... ) {

  ## order by distance metric
  unord_result <- x$model_cv
  ord_result <- unord_result[order(unord_result[,2] ),]
  ord_result[,2:3] <- round( ord_result[,2:3],  digits = digits ) 
  
  ## Report
  cat('Cross-Validation Results of', nrow(ord_result) ,'models \n')
  cat('based on ', 'k = ', x$k, 'folds. \n\n' )
  colnames(ord_result)[2] <- x$distanceMetric
  print( ord_result )
}
