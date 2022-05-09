
testobject= cvsem(5)

test_that("function returns text",{
  expect_match(testobject, "Place")
})

