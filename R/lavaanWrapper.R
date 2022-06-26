lavaanWrapper <- function( data, Models ){

  if( is.list(Models) == FALSE ){
    stop( "Input for the Models arugment is not a list" )
  }

  ModelNumber <- length(Models)

  for( i in 1: length(ModelNumber) ){
    if( !inherits(Models[[i]],  what = 'lavaan' ) ){
      stop( paste("Model", i, "is not a lavaan object") )
    }
  }

  return("lavaan model matrix")
}
