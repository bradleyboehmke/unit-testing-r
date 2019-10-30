header <- function(name) {
  paste0("Hello ", name, ", starting your analysis!")
}

filter <- function(df, condition) {
  condition_call <- substitute(condition)
  r <- eval(condition_call, df)
  df[r, ]
}

summarize <- function(df, col, summary) {
  df_summary <- eval(call(summary, df[[col]]))
  return(df_summary)
}
