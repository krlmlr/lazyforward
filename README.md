<!-- README.md is generated from README.Rmd. Please edit that file -->
lazyforward [![wercker status](https://app.wercker.com/status/36c110c0cc966dfb16c8a5ed88c0c62c/s/master "wercker status")](https://app.wercker.com/project/bykey/36c110c0cc966dfb16c8a5ed88c0c62c) [![codecov.io](https://codecov.io/github/krlmlr/lazyforward/coverage.svg?branch=master)](https://codecov.io/github/krlmlr/lazyforward?branch=master)
=======================================================================================================================================================================================================================================================================================================================================================

Simplify maintenance of NSE-SE pairs. Hypothetical `dplyr` example:

    #' @export
    #' @keywords internal
    mutate_ <- function (.data, ..., .dots) { UseMethod("mutate_") }

    #' @export
    #' @name mutate
    mutate <- lazyforward::lazyforward("mutate_")

The result:

``` r
lazyforward::lazyforward("mutate_", asNamespace("dplyr"))
#> function (.data, ...) 
#> {
#>     mutate_(.dots = lazyeval::lazy_dots(...), .data = .data)
#> }
#> <environment: namespace:dplyr>
dplyr::mutate
#> function(.data, ...) {
#>   mutate_(.data, .dots = lazyeval::lazy_dots(...))
#> }
#> <environment: namespace:dplyr>
```

The difference: You don't need to remember updating the interface and the forwarding logic if the interface of the SE version changes.

If the forwarding logic has been already written by hand, it may be simpler just to verify that it is correct:

``` r
testthat::with_reporter(
  "summary",
  testthat::test_that(
    "mutate forwarder is implemented correctly",
    lazyforward::expect_lazyforward("mutate", env = asNamespace("dplyr"))
  )
)
#> ...
#> DONE
```
