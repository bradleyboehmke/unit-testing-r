context("Require no code style errors")

# if just testing a directory
test_that("Scripts have no lintr errors", {

  # test all subdirectories (i.e. tests)
  # lint_test <- lintr::lint_dir(here::here(), relative_path = TRUE)

  # test only specific files
  files <- c("my_functions.R", "sample_script.R")
  file_paths <- file.path(here::here(), files)
  lint_test <- unlist(lapply(file_paths, lintr::lint))
  expect_equal(lint_test, NULL)
})
