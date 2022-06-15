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
model_gather <- cvgather(model1, model2)

testobject1 = cvsem(example_data, model_gather)

test_that("function returns correct class",{
  expect_match(class(testobject1), "cvsem")
})

test_that(".lavaan_vars() returns a vector of length 3", {
  expect_length(.lavaan_vars(model_gather[[1]], example_data) , 3 )
})

test_that("cvgather returns named list",  {
  expect_identical( names(cvgather(model1,  model2 )), c("model1",  "model2") )
})

test_that("cvsem returns same nuber of cv models as in cvgather",  {
  expect_true( dim(testobject1$model_cv)[1] == length(model_gather) )
})

