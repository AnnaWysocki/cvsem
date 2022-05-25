## load all R functions
#devtools::load_all()
options(width = 250 )

## Example form cvsem main function
example_data <- lavaan::HolzingerSwineford1939


colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
"visualPerception", "cubes", "lozenges", "comprehension",
"sentenceCompletion", "wordMeaning", "speededAddition",
"speededCounting", "speededDiscrimination")

model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'

model2 <- 'comprehension ~ wordMeaning
            sentenceCompletion ~ 0*wordMeaning
            comprehension ~~ 0*wordMeaning + speededAddition'


model_list <- list(model1, model2)
model_list

## max number of variables in model list
##

model_equal <- '
# measurement model
ind60 =~ x1 + x2 + x3
dem60 =~ y1 + d1*y2 + d2*y3 + d3*y4
dem65 =~ y5 + d1*y6 + d2*y7 + d3*y8
# regressions
dem60 ~ ind60
dem65 ~ ind60 + dem60
# Latent vars
f1 =~ x1 + .5*x2 + x3
f2 =~ y1 + y2 + y3
f1 ~~ f2
# residual covariances
y1  ~~ y5
y2  ~~ y4 + y6
y3  ~~ y7
y4  ~~ y8
y6  ~~ y8
'


obj <-  lavaan::lavaanify(model = model_equal )
lavaan::parTable
obj


#devtools::load_all()

fit <- cvsem( x =  example_data, Models = model_list, k = 60)
fit

print.cvsem(fit )


fld <- createFolds(example_data, k = 75)
nrow(example_data )/50
str(fld)

nrow(example_data )/4

fld[[1]]$test[, c( 'comprehension','sentenceCompletion','wordMeaning')]

## number of rows need to be > than columns for covariance to be invertible.
solve(cov(fld[[1]]$test[, c( 'comprehension','sentenceCompletion','wordMeaning')]))


out$Model



x <- example_data
Models <- model_list
distanceMetric = "KL-Divergence"
k = 5
lavaanFunction = "sem"

