<!-- README.md is generated from README.Rmd. Please edit that file -->
lazyforward
===========

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
#> function (.data, ...) 
#> {
#>     mutate_(.data, .dots = lazyeval::lazy_dots(...))
#> }
#> <environment: namespace:dplyr>
```

The difference: You don't need to remember updating the interface and the forwarding logic if the interface of the SE version changes.
