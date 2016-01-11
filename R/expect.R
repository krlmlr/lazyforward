#' Test NSE-SE function pairs
#'
#' Allows simple testing of hand-written NSE-SE pairs.
#'
#' @seealso \code{\link{lazyforward}}
#'
#' @export
expect_lazyforward <- function(se, nse) {
  formals_se_forwarded <- formals(lazyforward(se, env = environment(se)))

  eval(bquote(testthat::expect_identical(formals(nse), .(formals_se_forwarded))))
}
