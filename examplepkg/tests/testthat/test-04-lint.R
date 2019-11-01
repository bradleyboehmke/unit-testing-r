context("Require no code style errors")

# if testing a package
test_that("Package has no lintr errors", {
  lintr::expect_lint_free()
})
