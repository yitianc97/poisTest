test_that("'x' and 'T' have incompatible length", {
  expect_error(pois.test(10, c(1, 2)))
  expect_error(pois.test(c(10,11), c(1,2,3)))
})

test_that("'x' must be finite, nonnegative, and integer", {
  expect_error(pois.test(12.5))
  expect_error(pois.test(-2))
  expect_error(pois.test(""))
})

test_that("'T' must be nonnegative", {
  expect_error(pois.test(10, -20))
  expect_error(pois.test(10, -2))
})

test_that("'r' must be a single positive number", {
  expect_error(pois.test(10, 2, c(1, 2)))
  expect_error(pois.test(10, r=-2))
})

test_that("'conf.level' must be a single number between 0 and 1", {
  expect_error(pois.test(10, conf.level = 2))
  expect_error(pois.test(10, conf.level = -1.5))
})

test_that("statistics are the same", {
  x = 100
  T = 25
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$statistic, result_me$statistic)

  x = c(10, 25)
  T = c(500, 1200)
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$statistic, result_me$statistic)
})

test_that("parameters are the same", {
  x = 20
  T = 5
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$parameter, result_me$parameter)

  x = c(8, 15)
  T = c(120, 500)
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$parameter, result_me$parameter)
})

test_that("p.values are the same", {
  x = 80
  T = 20
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$p.value, result_me$p.value)

  x = c(10, 20)
  T = c(600, 1234)
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$p.value, result_me$p.value)
})

test_that("conf.ints are the same", {
  x = 45
  T = 18
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$conf.int, result_me$conf.int)

  x = c(20, 35)
  T = c(500, 2000)
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$conf.int, result_me$conf.int)
})

test_that("estimates are the same", {
  x = 55
  T = 27
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$estimate, result_me$estimate)

  x = c(28, 36)
  T = c(502, 2801)
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$estimate, result_me$estimate)
})

test_that("null.values are the same", {
  x = 129
  T = 13
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$null.value, result_me$null.value)

  x = c(300, 360)
  T = c(1820, 5001)
  result_poisson = poisson.test(x, T)
  result_me = pois.test(x, T)
  expect_equal(result_poisson$null.value, result_me$null.value)
})
