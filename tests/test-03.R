context("summarize()")

filtered_df <- filter(iris, Species == "setosa")
summarized_df <- summarize(filtered_df, "Sepal.Length", "mean")

test_that("summarize() results in a double", {
  expect_type(summarized_df, "double")
})

test_that("summarize() outputs proper dimensions", {
  expect_equal(length(summarized_df), 1)
})

test_that("dummy test to signal failure", {
  expect_true(FALSE)
})
