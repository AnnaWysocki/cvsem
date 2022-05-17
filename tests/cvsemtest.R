## load functions
source(file = "../R/cvsem.R" )
source(file = "../R/createFolds.R" )

## Example form cvsem main function
example_data <- lavaan::HolzingerSwineford1939
colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
"visualPerception", "cubes", "lozenges", "comprehension",
"sentenceCompletion", "wordMeaning", "speededAddition",
"speededCounting", "speededDiscrimination")

model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'

model2 <- 'comprehension ~ wordMeaning
            sentenceCompletion ~ wordMeaning
            comprehension ~~ 0*wordMeaning'


model_list <- list(model1, model2)

cvsem( x =  example_data, Models = model_list )
