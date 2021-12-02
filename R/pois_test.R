#'Exact Poisson tests
#'
#'This function is used to perform an exact test of a simple null hypothesis about the
#'rate parameter in Poisson distribution, or for the ratio between two rate parameters.
#'
#'@param x A vector of length one or two representing the number of events.
#'@param T A vector of length one or two representing the time base for event count.
#'@param r A single positive number representing the hypothesized rate or rate ratio.
#'@param alternative A string indicating the alternative hypothesis and must be one of "two.sided", "greater" or "less".
#'@param conf.level A number indicating the confidence level for the returned confidence interval.
#'
#'@return A list of attributes of the exact Poisson test.
#'
#'
#'@examples
#'pois.test(100, 25)
#'pois.test(c(11,20),c(800, 3000))
#'
#'@export
#'

pois.test <- function(x, T = 1, r = 1, alternative =
                           c("two.sided", "less", "greater"),
                         conf.level = 0.95)
{

  DNAME <- deparse(substitute(x))
  DNAME <- paste(DNAME, "time base:", deparse(substitute(T)))
  if ((l <- length(x)) != length(T))
    if (length(T) == 1L)
      T <- rep(T, l)
  else
    stop("'x' and 'T' have incompatible length")
  xr <- round(x)

  if(any(!is.finite(x) | (x < 0)) || max(abs(x-xr)) > 1e-7)
    stop("'x' must be finite, nonnegative, and integer")
  x <- xr

  if(any(is.na(T) | (T < 0)))
    stop("'T' must be nonnegative")


  if ((k <- length(x)) < 1L)
    stop("not enough data")

  if (k > 2L)
    stop("the case k > 2 is unimplemented")

  if(!missing(r) && (length(r) > 1 || is.na(r) || r < 0 ))
    stop ("'r' must be a single positive number")
  alternative <- match.arg(alternative)

  if(!((length(conf.level) == 1L) && is.finite(conf.level) &&
       (conf.level > 0) && (conf.level < 1)))
    stop("'conf.level' must be a single number between 0 and 1")

  if (k == 2) {

    x0 <- x
    n <- sum(x)
    p <- r * T[1L]/(r * T[1L] + T[2L])
    x <- x[1L]

    PVAL <- switch(alternative,
                   less = pbinom(x, n, p),
                   greater = pbinom(x - 1, n, p, lower.tail = FALSE),
                   two.sided = {
                     if(p == 0)
                       (x == 0)
                     else if(p == 1)
                       (x == n)
                     else {
                       relErr <- 1 + 1e-7
                       d <- dbinom(x, n, p)
                       m <- n * p
                       if (x == m)
                         1
                       else if (x < m) {
                         i <- seq.int(from = ceiling(m), to = n)
                         y <- sum(dbinom(i, n, p) <= d * relErr)
                         pbinom(x, n, p) +
                           pbinom(n - y, n, p, lower.tail = FALSE)
                       } else {
                         i <- seq.int(from = 0, to = floor(m))
                         y <- sum(dbinom(i, n, p) <= d * relErr)
                         pbinom(y - 1, n, p) +
                           pbinom(x - 1, n, p, lower.tail = FALSE)
                       }
                     }
                   })
    ## Determine p s.t. Prob(B(n,p) >= x) = alpha.
    ## Use that for x > 0,
    ## Prob(B(n,p) >= x) = pbeta(p, x, n - x + 1).
    p.L <- function(x, alpha) {
      if(x == 0)
        0
      else
        qbeta(alpha, x, n - x + 1)
    }
    ## Determine p s.t. Prob(B(n,p) <= x) = alpha.
    ## Use that for x < n,
    ## Prob(B(n,p) <= x) = 1 - pbeta(p, x + 1, n - x).
    p.U <- function(x, alpha) {
      if(x == n)
        1
      else
        qbeta(1 - alpha, x + 1, n - x)
    }
    CINT <- switch(alternative,
                   less = c(0, p.U(x, 1 - conf.level)),
                   greater = c(p.L(x, 1 - conf.level), 1),
                   two.sided = {
                     alpha <- (1 - conf.level) / 2
                     c(p.L(x, alpha), p.U(x, alpha))
                   })
    attr(CINT, "conf.level") <- conf.level

    structure(list(statistic = c(count1 = x0[1L]),
                   parameter = c("expected count1" = n * r * T[1L]/sum(T * c(1, r))),
                   p.value = PVAL,
                   conf.int = CINT/(1 - CINT)*T[2L]/T[1L],
                   estimate = c("rate ratio" = (x0[1L]/T[1L])/(x0[2L]/T[2L])),
                   null.value = c("rate ratio" = r),
                   alternative = alternative,
                   method = "Comparison of Poisson rates",
                   data.name = DNAME),
              class = "htest")

  } else {
    m <- r * T
    PVAL <- switch(alternative,
                   less = ppois(x, m),
                   greater = ppois(x - 1, m, lower.tail = FALSE),
                   two.sided = {
                     if(m == 0)
                       (x == 0)
                     else {
                       relErr <- 1 + 1e-7
                       d <- dpois(x, r * T)
                       if (x == m)
                         1
                       else if (x < m) {
                         N <- ceiling(2 * m - x)
                         while (dpois(N, m) > d)
                           N <- 2 * N
                         i <- seq.int(from = ceiling(m), to = N)
                         y <- sum(dpois(i, m) <= d * relErr)
                         ppois(x, m) +
                           ppois(N - y, m, lower.tail = FALSE)
                       } else {
                         i <- seq.int(from = 0, to = floor(m))
                         y <- sum(dpois(i, m) <= d * relErr)
                         ppois(y - 1, m) +
                           ppois(x - 1, m, lower.tail = FALSE)
                       }
                     }
                   })
    ## Determine m s.t. Prob(Pois(m) >= x) = alpha.
    ## Use that for x > 0,
    ##   Prob(Pois >= x) = pgamma(m, x).
    p.L <- function(x, alpha) {
      if(x == 0)
        0
      else
        qgamma(alpha, x)
    }
    ## Determine p s.t. Prob(B(n,p) <= x) = alpha.
    ## Use that for x < n,
    ## Prob(Pois(m) <= x) = 1 - pgamma(m, x + 1).
    p.U <- function(x, alpha)
      qgamma(1 - alpha, x + 1)

    CINT <- switch(alternative,
                   less = c(0, p.U(x, 1 - conf.level)),
                   greater = c(p.L(x, 1 - conf.level), Inf),
                   two.sided = {
                     alpha <- (1 - conf.level) / 2
                     c(p.L(x, alpha), p.U(x, alpha))
                   }) / T
    attr(CINT, "conf.level") <- conf.level

    ESTIMATE <- x / T

    names(x) <- "number of events"
    names(T) <- "time base"
    names(ESTIMATE) <-
    names(r) <- "event rate"

    structure(list(statistic = x,
                   parameter = T,
                   p.value = PVAL,
                   conf.int = CINT,
                   estimate = ESTIMATE,
                   null.value = r,
                   alternative = alternative,
                   method = "Exact Poisson test",
                   data.name = DNAME),
              class = "htest")

  }
}
