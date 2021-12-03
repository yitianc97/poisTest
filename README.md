# poisTest
<!-- badges: start -->
  
[![Travis build status](https://travis-ci.com/yitianc97/poisTest.svg?branch=main)](https://travis-ci.com/yitianc97/poisTest)
[![R-CMD-check](https://github.com/yitianc97/poisTest/workflows/R-CMD-check/badge.svg)](https://github.com/yitianc97/poisTest/actions)
[![Codecov test coverage](https://codecov.io/gh/yitianc97/poisTest/branch/main/graph/badge.svg)](https://app.codecov.io/gh/yitianc97/poisTest?branch=main)
<!-- badges: end -->

## Overview

`pois.test` is an improved version of R function poisson.test(), whic is used to perform an exact test of a simple null hypothesis about the rate parameter in Poisson distribution, or for the ratio between two rate parameters. It is improved especially in the condition when there are two rate parameters. 

It currently has one function:
- `pois.test()` reads number of events `x`, time base for event count `T`, hypothesized rate or rate ratio 'r', alternative hypothesis `alternative`, confidence level for the returned confidence interval `conf.level`, and calculate a list of parameters of the exact poisson test. It also returns a summary of conclusion of the test.

View the "pois_test_tutorial" R-markdown vignette for more information about the accuracy of the each parameter produced by the `pois.test` compared to the default `poisson.test` function. Also explained in the vignette is the efficiency of the `pois.test` at generating the list of parameters compared to that of the `poisson.test` function.

## Installation
```r
# install useing devtools from GitHub website:
devtools::install_github("yitianc97/poisTest")

# if you want to browse vignitte, install with:
devtools::install_github("yitianc97/poisTest", build_vignettes = T)

# then load the package
library(pois.exact.test)
```
## Function:

### pois.test
The `pois.test` function is used in the following way: `pois.test(x, T = 1, r = 1, alternative = c("two.sided", "less", "greater"), conf.level = 0.95)`
  - `x` is a vector of length one or two representing the number of events.
  - `T` is a vector of length one or two representing the time base for event count.
  - `r` is a single positive number representing the hypothesized rate or rate ratio.
  - `alternative` is a string indicating the alternative hypothesis and must be one of "two.sided", "greater" or "less".
  - `conf.level` is a number indicating the confidence level for the returned confidence interval.

The list object returned by this function includes:
  - `statistic`: the number of events (in the first sample if there are two).
  - `parameter`: the corresponding expected count.
  - `p.value`: the p-value of the test.
  - `conf.int`: a confidence interval for the rate or rate ratio.
  - `estimate`: the estimated rate or rate ratio.
  - `null.value`: the rate or rate ratio under the null.
  - `alternative`: the alternative hypothesis.

## Use
```r
library(pois.exact.test)

# create test data:
x = 100
T = 25

# perform exact poisson test:
result_pois = pois.test(x, T)

# check the results:
#> Exact Poisson test
#> 
#> data:  x time base: T
#> number of events = 100, time base = 25, p-value <
#> 2.2e-16
#> alternative hypothesis: true event rate is not equal to 1
#> 95 percent confidence interval:
#>  3.254560 4.865072
#> sample estimates:
#> event rate 
#>          4
```
```r
library(pois.exact.test)

# create test data:
x = c(10, 25)
T = c(500, 1200)

# perform exact poisson test:
result_pois = pois.test(x, T)

# check the results:
#> Comparison of Poisson rates
#> 
#> data:  x time base: T
#> count1 = 10, expected count1 = 10.294, p-value = 1
#> alternative hypothesis: true rate ratio is not equal to 1
#> 95 percent confidence interval:
#>  0.4114723 2.0696453
#> sample estimates:
#> rate ratio 
#>       0.96 
```

