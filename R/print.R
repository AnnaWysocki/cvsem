##' @title Print cvsem object
##' @param x cvsem object
##' @param ... not used
##' @return Formatted cvsem object
print.cvsem <- function(x,  ... ) {
  cat('Cross-Validation Results\n')
  cat('Based on ', 'k = ', x$k, 'folds. \n\n' )
  table <- as.data.frame( x$model_cv )
  colnames(table)[2] <- x$distanceMetric
  print(table)
}
