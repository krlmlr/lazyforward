<!-- README.md is generated from README.Rmd. Please edit that file -->
lazyforward
===========

Simplify maintenance of NSE-SE pairs. Hypothetical `dplyr` example:

    #' @export
    #' @name mutate
    lazyforward::def("mutate")

    #' @export
    #' @keywords internal
    mutate_ <- function (.data, ..., .dots) { UseMethod("mutate_") }

The result:

``` r
lazyforward::lazyforward("mutate_", asNamespace("dplyr"))
#> function (.data, ...) 
#> {
#>     mutate_(.dots = lazyeval::lazy_dots(...), .data = .data)
#> }
#> <environment: namespace:dplyr>
```
