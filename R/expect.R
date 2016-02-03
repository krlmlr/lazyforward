#' Test NSE-SE function pairs
#'
#' Allows simple testing of hand-written NSE-SE pairs.
#'
#' @seealso \code{\link{lazyforward}}
#'
#' @export
expect_lazyforward <- function(nse, se = paste0(nse, "_"), env = parent.frame(), .dots = ".dots") {
  # Used in a closure, need to fix value beforehand
  force(env)

  formals <- function(name) {
    base::formals(get(name, env, mode = "function"))
  }

  lazyforward_orig <- lazyforward
  lazyforward <- function(se_name, .dots) {
    lazyforward_orig(se_name, env = env, .dots = .dots)
  }

  nse_fun_forwarded <- NULL
  eval(bquote(testthat::expect_error(
    nse_fun_forwarded <- lazyforward(.(se), .dots = .(.dots)),
    NA)))

  if (!is.null(nse_fun_forwarded)) {
    formals_se_forwarded <- base::formals(nse_fun_forwarded)
    names_formals_se_forwarded <- sort(names(formals_se_forwarded))
    eval(bquote(testthat::expect_identical(sort(names(formals(.(nse)))), .(names_formals_se_forwarded))))
    formals_se_forwarded_reordered <- as.pairlist(formals_se_forwarded[names(formals(nse))])
    eval(bquote(testthat::expect_identical(formals(.(nse)), .(formals_se_forwarded_reordered))))
  }
}
