
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cvsem

<!-- badges: start -->

[![R](https://github.com/AnnaWysocki/cvsem/actions/workflows/r.yml/badge.svg?branch=cvsemTest)](https://github.com/AnnaWysocki/cvsem/actions/workflows/r.yml)
<!-- badges: end -->

The goal of cvsem is to …

## Installation

You can install the development version of cvsem from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("AnnaWysocki/cvsem")
```

## Example

Cross-validating the Holzingerswineford1939 dataset

Load package and read in data from the lavaan package:

``` r
library(cvsem)

example_data <- lavaan::HolzingerSwineford1939
```

Add column names

``` r
colnames(example_data) <- c("id", "sex", "ageyr", "agemo", 'school', "grade",
"visualPerception", "cubes", "lozenges", "comprehension",
"sentenceCompletion", "wordMeaning", "speededAddition",
"speededCounting", "speededDiscrimination")
```

## Define Models

Define some models to be compared with `cvsem` using `lavaan` notation:

``` r
model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'

model2 <- 'comprehension ~ wordMeaning
            sentenceCompletion ~ 0*wordMeaning
            comprehension ~~ 0*wordMeaning + speededAddition
# some latent vars
meaning =~ comprehension + wordMeaning + sentenceCompletion
speed =~ speededAddition + speededAddition + speededCounting
speed ~~ meaning'

model3 <- 'comprehension ~ wordMeaning + speededAddition'
```

## Model List

Gather models into a named list object with `cvgather`

``` r
models <- cvgather(model1, model2, model3)
```

## Cross-Validate with K-folds

Define number of folds `k` and call `cvsem` function. Here we use `k=10`
folds. CV is based on the distance between test sample covariance matrix
and the model implied matrix given the test data. The distance among
sample and implied matrix is defined in `distanceMetric`. Here we use
`KL-Divergence`.

``` r
fit <- cvsem( x = example_data, Models = models, k = 10, distanceMetric = "KL-Divergence")
#> [1] "Cross-Validating model: 1"
#> [1] "Cross-Validating model: 2"
#> [1] "Cross-Validating model: 3"
```

## Show Results

Print cv-object. Note, model with smallest (best) distance metric is
listed first.

``` r
fit
#> Cross-Validation Results of 3 models 
#> based on  k =  10 folds. 
#> 
#>    Model KL-Divergence   SD
#> 2 model2          0.83 0.30
#> 1 model1          0.90 0.45
#> 3 model3          1.78 0.33
```

<!-- What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so: -->

<!-- ```{r cars} -->

<!-- summary(cars) -->

<!-- ``` -->

<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. `devtools::build_readme()` is handy for this. You could also use GitHub Actions to re-render `README.Rmd` every time you push. An example workflow can be found here: <https://github.com/r-lib/actions/tree/v1/examples>. -->

<!-- You can also embed plots, for example: -->

<!-- ```{r pressure, echo = FALSE} -->

<!-- plot(pressure) -->

<!-- ``` -->

<!-- In that case, don't forget to commit and push the resulting figure files, so they display on GitHub and CRAN. -->
