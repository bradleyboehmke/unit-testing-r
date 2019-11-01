context("header()")

test_that("header() provides string output", {
  expect_type(header("Brad"), "character")
  expect_equal(header("Brad"), "Hello Brad, starting your analysis!")
})
