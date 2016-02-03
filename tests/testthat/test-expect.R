context("expect")

test_that("functionality", {
  no_args_ <- function(.dots) NULL
  one_arg_before_ <- function(a, .dots) NULL
  one_arg_def_before_ <- function(a = 0, .dots) NULL
  one_arg_after_ <- function(.dots, a) NULL
  one_arg_def_after_ <- function(.dots, a = 0) NULL
  dots_before_ <- function(..., .dots) NULL
  dots_after_ <- function(..., .dots) NULL
  one_arg_before_after_ <- function(a, .dots, b) NULL
  one_arg_def_before_after_ <- function(a = 0, .dots, b = 0) NULL

  env <- environment()
  lapply(ls(pattern = "_$"), function(se, env) {
    nse <- gsub("_$", "", se)
    assign(nse, lazyforward(se), env)
  }, env = env)

  lapply(ls(pattern = "_$"), function(se, env) {
    nse <- gsub("_$", "", se)
    expect_lazyforward(nse, env = env)
  }, env = env)
})
