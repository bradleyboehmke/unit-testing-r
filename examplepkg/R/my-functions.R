#' Print header
#'
#' @param name Character string for name of user
#' @export
header <- function(name) {
  paste0("Hello ", name, ", starting your analysis!")
}

#' Filter data
#'
#' @param df Data frame to filter
#' @param condition Conditional statement filter by
#' @export
filter <- function(df, condition) {
  condition_call <- substitute(condition)
  r <- eval(condition_call, df)
  df[r, ]
}

#' Summarize data
#'
#' @param df Data frame to summarize
#' @param col Column to summarize
#' @param summary Function to summarize with
#' @export
summarize <- function(df, col, summary) {
  df_summary <- eval(call(summary, df[[col]]))
  return(df_summary)
}
