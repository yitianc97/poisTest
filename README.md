# poisTest
<!-- badges: start -->
  
[![Travis build status](https://travis-ci.com/yitianc97/poisTest.svg?branch=main)](https://travis-ci.com/yitianc97/poisTest)
[![R-CMD-check](https://github.com/yitianc97/poisTest/workflows/R-CMD-check/badge.svg)](https://github.com/yitianc97/poisTest/actions)
[![Codecov test coverage](https://codecov.io/gh/yitianc97/poisTest/branch/main/graph/badge.svg)](https://app.codecov.io/gh/yitianc97/poisTest?branch=main)
<!-- badges: end -->

## Overview

`pois.test` is an improved version of R function poisson.test(), whic is used to perform an exact test of a simple null hypothesis about the rate parameter in Poisson distribution, or for the ratio between two rate parameters. It is improved especially in the condition when there are two rate parameters. 

It currently has one function:
- `pois.test()` reads number of events `x`, time base for event count `T`, hypothesized rate or rate ratio 'r', alternative hypothesis `alternative`, confidence level for the returned confidence interval `conf.level`, and calculate a list of parameters of the poisson exact test. It also returns a summary of conclusion of the test.

View the "pois_test_tutorial" R-markdown vignette for more information about the accuracy of the each parameter produced by the `pois.test` compared to the default `poisson.test` function. Also explained in the vignette is the efficiency of the `pois.test` at generating the list of parameters compared to that of the `poisson.test` function.

## Installation
```r
# install useing devtools from GitHub website:
devtools::install_github("yitianc97/poisTest")

# if you want to browse vignitte, install with:
devtools::install_github("yitianc97/poisTest", build_vignettes = T)
```

## Use
```r
library(pois.exact.test)

# create test data:
x = 100
T = 25

# perform poisson exact test:
result_pois = pois.test(x, T)

# check the results:
#> Exact Poisson test
#> 
#> data:  x time base: T
#> number of events = 100, time base = 25, p-value <
#> 2.2e-16
#> alternative hypothesis: true event rate is not equal #> to 1
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

# perform poisson exact test:
result_pois = pois.test(x, T)

# check the results:
#> Comparison of Poisson rates
#> 
#> data:  x time base: T
#> count1 = 10, expected count1 = 10.294, p-value = 1
#> alternative hypothesis: true rate ratio is not equal #> to 1
#> 95 percent confidence interval:
#>  0.4114723 2.0696453
#> sample estimates:
#> rate ratio 
#>       0.96 
```

