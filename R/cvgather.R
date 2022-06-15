##' Gather `lavaan` model objects to be compared via CV. Function returns a named list.
##' @title Gather `lavan` model objects into a list
##' @param ... Names of `lavaan` model objects 
##' @return Named list
##' @author philippe
##' @importFrom stats setNames
##' @export
##'
##' @examples
##'
##' example_data <- lavaan::HolzingerSwineford1939
##' colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
##' "visualPerception", "cubes", "lozenges", "comprehension",
##' "sentenceCompletion", "wordMeaning", "speededAddition",
##' "speededCounting", "speededDiscrimination")
##'
##' model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'
##'
##' model2 <- 'comprehension ~ wordMeaning
##'            sentenceCompletion ~ wordMeaning
##'
##'            comprehension ~~ 0.5*wordMeaning'
##'
##' model_list <- cvgather(model1, model2)
##'
cvgather <- function(...) {
    L <- list(...)
    snm <- sapply(substitute(list(...)),deparse)[-1]
    if (is.null(nm <- names(L))) nm <- snm
    if (any(nonames <- nm=="")) nm[nonames] <- snm[nonames]
    out <- setNames(L,nm)
    attr(out,  "class") <- "cvgather"
    return(out)
}
## This is Ben Bolker's solution:
## https://stackoverflow.com/questions/16951080/can-lists-be-created-that-name-themselves-based-on-input-object-names

