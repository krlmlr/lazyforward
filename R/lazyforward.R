#' Create forwarders for NSE-SE pairs
#'
#' @export
lazyforward <- function(name, env = parent.frame(), .dots = ".dots") {
  se <- get(name, env)

  f_se <- formals(se)

  if (!all(c(.dots) %in% names(f_se))) {
    stop("The SE version needs to have a ", .dots, " argument.", call. = FALSE)
  }
  f_nse <- f_se[names(f_se) != .dots]
  if (all(names(f_nse) != "...")) {
    f_nse <- c(f_nse, alist(...=))
  }

  dot_fml <- list(.dots = quote(lazyeval::lazy_dots(...)))
  names(dot_fml) <- .dots
  forward_fml <- setdiff(names(f_nse), "...")
  forward_fml <- setNames(lapply(forward_fml, as.symbol), forward_fml)

  call_nse <- as.call(c(as.symbol(name), dot_fml, forward_fml))
  fun <- eval(bquote(function() {
    .(call_nse)
  }, as.environment(list(call_nse = call_nse))))
  formals(fun) <- f_nse
  environment(fun) <- env
  fun
}
