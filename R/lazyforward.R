#' Create forwarders for NSE-SE pairs
#'
#' For an SE function (looked up by name in an environment), this function
#' creates the corresponding NSE pair.
#'
#' @param se_name Name of the SE version of the function, ends with an
#'   underscore
#' @param env The environment in which to look for the SE version
#' @param .dots The name of the \code{.dots} argument, default: \code{".dots"}
#'
#' @export
#' @examples
#' amazing_ <- function(input, args, .dots) {
#'   amaze_me(.dots, input, args)
#' }
#' lazyforward("amazing_")
lazyforward <- function(se_name, env = parent.frame(), .dots = ".dots") {
  se <- get(se_name, env)

  f_se <- formals(se)

  if (!all(c(.dots) %in% names(f_se))) {
    stop("The SE version needs to have a ", .dots, " argument.", call. = FALSE)
  }
  f_nse <- f_se[names(f_se) != .dots]
  if (all(names(f_nse) != "...")) {
    f_nse <- c(f_nse, alist(...=))
  }

  # Set .dots to lazyeval::lazy_dots(...)
  # Necessary to avoid bogus warning from R CMD check
  dot_fml <- list(.dots = as.call(list(
    call("::", quote(lazyeval), quote(lazy_dots)), quote(...))))
  names(dot_fml) <- .dots
  forward_fml <- setdiff(names(f_nse), "...")
  forward_fml <- setNames(lapply(forward_fml, as.symbol), forward_fml)

  call_nse <- as.call(c(as.symbol(se_name), dot_fml, forward_fml))
  fun <- eval(bquote(function() {
    .(call_nse)
  }, as.environment(list(call_nse = call_nse))))
  formals(fun) <- f_nse
  environment(fun) <- env
  fun
}
