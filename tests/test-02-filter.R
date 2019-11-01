context("filter()")

filtered_df <- filter(iris, Species == "setosa")

test_that("filter() outputs a data frame object", {
  expect_s3_class(filtered_df, "data.frame")
})

test_that("filter() outputs proper dimensions", {
  expect_equal(dim(filtered_df), c(50, 5))
})
