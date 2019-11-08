context("Using lint_package")
test_that("Using lint_package", {
  error_exists <- tryCatch(
    suppressMessages(lintr::lint_package(exclusions = list("R/zzz.R"))),
    warning = function(w) TRUE
  )
  expect_false(isTRUE(error_exists))
})

context("Using expect_lint_free")
test_that("Using expect_lint_free", {
  lintr::expect_lint_free(
    exclusions = list(
      rprojroot::find_package_root_file("R/zzz.R")
    ))
})
