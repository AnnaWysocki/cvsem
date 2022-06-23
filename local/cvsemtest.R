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

fit <- lavaan::sem(model1, example_data)
lavaan::parameterEstimates(out)
lavaan::summary(out)

implied_sigma <- fit@implied[["cov"]][[1]]
test_S <- fit@SampleStats@cov[[1]]
sum((implied_sigma- (2*test_S))^2)

X = matrix(rnorm(4000),ncol=4)
S <- diag(4)
H <- cov(X )
sum((S-H)^2)

sum(diag(t(S-H)%*%(S-H)))

sum(diag(S%*%solve(H )-diag(4)))^2



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
             discrepancyMetric = "gls")

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




pd <- lavaan::PoliticalDemocracy

model <- '
   # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8
   # regressions
     dem60 ~ ind60
     dem65 ~ ind60 + dem60
   # residual covariances
     y1 ~~ y5
     y2 ~~ y4 + y6
     y3 ~~ y7
     y4 ~~ y8
     y6 ~~ y8
'

model2 <- '
   # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 
     dem65 =~ y5 + y6 + y7 + y8
   # regressions
     dem60 ~ ind60
     dem65 ~ ind60 + dem60
   # residual covariances
     y1 ~~ y5
     y2 ~~ y4 + y6
     y3 ~~ y7
     y4 ~~ y8
     y6 ~~ y8
'


fit <- lavaan::sem(model, data = pd)
fit2 <- lavaan::sem(model2, data = pd)


cvg <- cvgather(fit,  fit2 )

cv <- cvsem(data = pd,
            Models = cvg,
            discrepancyMetric = "KL-Divergence")
cv 
