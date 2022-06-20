## load all R functions
## devtools::load_all()
options(width = 250 )
#usethis::use_readme_rmd()
#devtools::build_readme( )
## Example form cvsem main function
example_data <- lavaan::HolzingerSwineford1939


colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
"visualPerception", "cubes", "lozenges", "comprehension",
"sentenceCompletion", "wordMeaning", "speededAddition",
"speededCounting", "speededDiscrimination")

model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'

out <- lavaan::sem(model1, example_data)
lavaan::parameterEstimates(out)
lavaan::summary(out)

model2 <- 'comprehension ~ wordMeaning
            sentenceCompletion ~ 0*wordMeaning
            comprehension ~~ 0*wordMeaning + speededAddition
# some latent vars
meaning =~ comprehension + wordMeaning + sentenceCompletion
speed =~ speededAddition + speededAddition + speededCounting
speed ~~ meaning'

model3 <- 'comprehension ~ wordMeaning + speededAddition'

model4 <- 'comprehension ~ wordMeaning + 0.5*speededAddition'


model_list <- cvgather( model1, model4, model2, model3 )
class( model_list )


## devtools::load_all()


fit <- cvsem( x =  example_data, Models = model_list, k = 10,
             discrepancyMetric = "GLS")

fit
fit$discrepancyMetric

fit$model_cv


x <- example_data
Models <- model_list
distanceMetric = "KL-Divergence"
k = 5
lavaanFunction = "sem"
echo <- TRUE
j <- 1
i <- 1

implied_sigma <- diag(4 )
mns <- rep(10,  4)
test_S <- cov( MASS::mvrnorm(10, mns, implied_sigma  ) )
p <-  4
(sum(diag(solve(test_S) %*% implied_sigma)) - p + log(det(test_S)/det(implied_sigma)) )
(t(mns)%*%solve(test_S)%*%mns)
(sum(diag(solve(test_S) %*% implied_sigma)) - p + (t(mns)%*%solve(test_S)%*%mns) + log(det(test_S)/det(implied_sigma)) )
