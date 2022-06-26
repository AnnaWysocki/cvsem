
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cvsem

<!-- badges: start -->

[![R-CMD-check](https://github.com/AnnaWysocki/cvsem/actions/workflows/r.yml/badge.svg)](https://github.com/AnnaWysocki/cvsem/actions/workflows/r.yml)
<!-- badges: end -->

The **cvsem** package provides cross-validation (CV) of structural
equation models (SEM) across a user-defined number of folds. CV is based
on computing the discrepancy among the held-out test sample covariance
and the model implied covariance from the training samples. This
approach of cross-validating SEM’s is described in Cudeck and Browne
([1983](#ref-Cudeck1983)) and Browne and Cudeck
([1992](#ref-BrowneCudeck1992)). The individual models are fitted via
the **lavaan** package (Rosseel [2012](#ref-Rosseel2012lavaan)) to
obtain the model implied covariance matrix. The discrepancy of the
implied matrix to the test sample covariance matrix is obtained via a
pre-specified metric (defaults to Kullback-Leibler divergence aka.
Maximum Likelihood discrepancy). The `cvsem` function returns the
average discrepancy together with a corresponding standard error for
each tested model.

Currently, the provided model code needs to follow one of **lavaan**’s
allowed specifications.

## Installation

You can install the development version of **cvsem** from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("AnnaWysocki/cvsem")
```

## Example

Cross-validating the Holzingerswineford1939 dataset

Load package and read in data from the **lavaan** package:

``` r
library(cvsem)

example_data <- lavaan::HolzingerSwineford1939
```

Add column names

``` r
colnames(example_data) <- c("id", "sex", "ageyr", "agemo", "school", "grade",
                            "visualPerception", "cubes", "lozenges", "comprehension",
                            "sentenceCompletion", "wordMeaning", "speededAddition",
                            "speededCounting", "speededDiscrimination")
```

## Define Models

Define some models to be compared with `cvsem` using `lavaan` notation:

``` r
model1 <- 'comprehension ~ sentenceCompletion + wordMeaning'

model2 <- 'comprehension ~ meaning

           ## Add some latent variables:

           meaning =~ wordMeaning + sentenceCompletion
           speed =~ speededAddition + speededDiscrimination + speededCounting
           speed ~~ meaning'

model3 <- 'comprehension ~ wordMeaning + speededAddition'
```

## Model List

Gather models into a named list object with `cvgather`. These could also
be fitted `lavaan` objects based on the same data.

``` r
models <- cvgather(model1, model2, model3)
```

## Cross-Validate with K-folds

Define number of folds `k` and call `cvsem` function. Here we use `k=10`
folds. CV is based on the discrepancy between test sample covariance
matrix and the model implied matrix from the training data. The
discrepancy among sample and implied matrix is defined in
`discrepancyMetric`. Currently three discrepancy metrics are available:
`KL-Divergence`, Generalized Least Squares `GLS`, and Frobenius Distance
`FD`. Here we use `KL-Divergence`.

``` r
fit <- cvsem( data = example_data, Models = models, k = 10, discrepancyMetric = "KL-Divergence")
#> [1] "Cross-Validating model: model1"
#> [1] "Cross-Validating model: model2"
#> [1] "Cross-Validating model: model3"
```

## Show Results

Print fitted `cvsem`-object. Note, the model with the smallest (best)
discrepancy is listed first. The metric reflects the average of the
discrepancy metric across all folds (aka. expected cross-validation
index (ECVI)) together with the associated standard error.

``` r
fit
#> Cross-Validation Results of 3 models 
#> based on  k =  10 folds. 
#> 
#>    Model E(KL-D)   SE
#> 1 model1    1.39 0.33
#> 3 model3    2.44 0.45
#> 2 model2    3.20 0.76
```

## References

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

<div id="refs" class="references">

<div id="ref-BrowneCudeck1992">

Browne, Michael W., and Robert Cudeck. 1992. “Alternative Ways of
Assessing Model Fit.” *Sociological Methods & Research* 21: 230–58.
<https://doi.org/10.1177/0049124192021002005>.

</div>

<div id="ref-Cudeck1983">

Cudeck, Robert, and Michael W. Browne. 1983. “Cross-Validation of
Covariance Structures.” *Multivariate Behavioral Research* 18: 147–67.
<https://doi.org/10.1207/s15327906mbr1802_2>.

</div>

<div id="ref-Rosseel2012lavaan">

Rosseel, Yves. 2012. “lavaan: An R Package for Structural Equation
Modeling.” *Journal of Statistical Software*.
<https://doi.org/10.18637/jss.v048.i02>.

</div>

</div>
