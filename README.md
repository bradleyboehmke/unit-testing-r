
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Unit Testing in R

## Problem Statement

An important part of writing code is to ensure it functions as expected
and, as we make updates, the functionality doesn’t break. To help
minimize these risks we should always include unit testing in our code.
Moreover, unit testing should be incorporated and automated for not only
R packages but also individual scripts.

## Suggested Solution

## Available Packages

There are several packages and functions that provide various
capabilities in the unit testing toolchain. The following provides a
synopsis of the most commonly used and the sections that follow discuss
how and when to implement them:

  - R CMD check:  
  - testthat:
  - tinytest:
  - lintr:
  - mockery:
  - covr:

## Directory Layout

The most common approach, whether you are testing an R package,
individual scripts or a directory of scripts, is to have unit tests
separated into their own subdirectory from the root of the project
directory. For example, if you have a set of functions
(`my_functions.R`) and a script that does analysis (`sample_script.R`)
you would include any unit tests in a subdirectory.

    #> .
    #> ├── my_functions.R
    #> ├── sample_script.R
    #> └── tests

Likewise, when unit testing an R package, we typically isolate tests
into their own subdirectory as illustrated below:

    #> examplepkg
    #> ├── DESCRIPTION
    #> ├── LICENSE.md
    #> ├── NAMESPACE
    #> ├── R
    #> ├── man
    #> └── tests

## Testing Files & Directories

## Testing Packages

## Mocking

## Understanding Coverage
