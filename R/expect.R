#' Test NSE-SE function pairs
#'
#' Allows simple testing of hand-written NSE-SE pairs.
#'
#' @param nse_name Name of the NSE version of the function, usually not ending
#'   in an underscore.
#' @param se_name Name of the SE version, by default the NSE name with
#'   underscore appended.
#' @inheritParams lazyforward
#'
#' @seealso \code{\link{lazyforward}}
#'
#' @export
expect_lazyforward <- function(nse_name, se_name = paste0(nse_name, "_"),
                               env = parent.frame(), .dots = ".dots") {
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
    nse_fun_forwarded <- lazyforward(.(se_name), .dots = .(.dots)),
    NA)))

  if (!is.null(nse_fun_forwarded)) {
    formals_se_forwarded <- base::formals(nse_fun_forwarded)
    names_formals_se_forwarded <- sort(names(formals_se_forwarded))
    eval(bquote(testthat::expect_identical(sort(names(formals(.(nse_name)))), .(names_formals_se_forwarded))))
    formals_se_forwarded_reordered <- as.pairlist(formals_se_forwarded[names(formals(nse_name))])
    eval(bquote(testthat::expect_identical(formals(.(nse_name)), .(formals_se_forwarded_reordered))))
  }
}
