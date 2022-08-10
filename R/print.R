##' Return the ordered list of models where the model with the smallest discrepancy metric is listed first.
##' @title Print `cvsem` object
##' @param x `cvsem` object
##' @param digits Round to (default 2) digits.
##' @param ... not used
##' @return Formatted `cvsem` object
##' @export
print.cvsem <- function(x,  digits = 2, ... ) {

  ## order by discrepancy metric
  unord_result <- x$model_cv
  ord_result <- unord_result[order(unord_result[,2] ),]
  ord_result[,2:3] <- round( ord_result[,2:3],  digits = digits )

  ## Print model warnings only when there are some:
  if( sum(x$model_cv$Model_Warnings) == 0 ) {
    ord_result <- ord_result[,-4]
    } else if ( sum(x$model_cv$Model_Warnings) != 0 ) {
      ord_result$Model_Warnings <- ifelse( ord_result$Model_Warnings > 0, " Yes: Check `warnings()`", "No" )
      names( ord_result )[4] <- "Warnings"
    }


    ## Report
    cat('Cross-Validation Results of', nrow(ord_result) ,'models \n')
    cat('based on ', 'k = ', x$k, 'folds. \n\n' )
    colnames(ord_result)[2] <- paste0("E(", abbreviate(x$discrepancyMetric), ")")
    print( ord_result )
  }
