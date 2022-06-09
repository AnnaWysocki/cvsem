## load all R functions
# devtools::load_all()
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

model2 <- 'comprehension ~ wordMeaning
            sentenceCompletion ~ 0*wordMeaning
            comprehension ~~ 0*wordMeaning + speededAddition
# some latent vars
meaning =~ comprehension + wordMeaning + sentenceCompletion
speed =~ speededAddition + speededAddition + speededCounting
speed ~~ meaning'

model3 <- 'comprehension ~ wordMeaning + speededAddition'


model_list <- list(model1, model2, model3)
class( model_list )


# devtools::load_all()


fit <- cvsem( x =  example_data, Models = model_list, k = 50, distanceMetric = "KL-Divergence")
fit

fit$model_cv


x <- example_data
Models <- model_list
distanceMetric = "KL-Divergence"
k = 5
lavaanFunction = "sem"


