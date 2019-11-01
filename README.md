
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Unit Testing in R

## Problem Statement

An important part of writing code is to ensure it functions as expected
and, as we make updates, the functionality doesn’t break. To help
minimize these risks we should always include unit testing in our code.
Moreover, unit testing should be incorporated and automated for not only
R packages but also individual scripts.

## Suggested Solution

TBD

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

This is not always necessary. For example, we can embed unit tests
directly in the source file for the function being tested or in analysis
scripts. This may have the benefit of aligning tests right next to the
functionality being tested; however, the above approach is the most
common and most organized structure.

## Testing Packages

Most people get exposed to code testing when first developing an R
package. An R package has very specific structure and documentation
requirements so testing is essential to ensure your package can be
submitted to CRAN or to even make sure it will operate correctly when
used.

### R CMD check

`R CMD check` is a key component of testing your package. `R CMD check`
is actually the name of the command you run from the terminal.
Historically, when building an R package, you would first create the
package, convert it to the .tar.gz file, run `R CMD check
pkgname.tar.gz`, and if everything passes you would submit to CRAN.

However, most people do not run it directly in the terminal. Rather they
run it interactively using `devtools::check()`. In some cases you may
need to run `R CMD check` programmatically and not in an interactive
session. To do so, you can use `rcmdcheck::rcmdcheck()`. This will
capture the results of `R CMD check` as an object which can then be
queried and investigated. In both cases ( `devtools::check()` and
`rcmdcheck::rcmdcheck()`), you do not need to build the .tar.gz file;
rather, you can just run the function on the root of the package and it
will build the .tar.gz and then run `R CMD check`.

Running `R CMD check` will actually perform over 50 individual checks
covering:

  - Package metadata (i.e. version number)
  - Package structure (i.e. directory layout, size, executable files)
  - DESCRIPTION file (i.e. meta-info, package dependencies)
  - Namespace (i.e. does it exist, is it parseable)
  - R code (i.e. syntax errors, function dependencies)
  - Data (i.e. if a data directory exists is it set up properly)
  - Documentation (i.e. function documentation, cross-references)
  - Compiled code (i.e. existance and functionality of C/C++, Fortran)
  - Tests (i.e. each file in a `test/` or `tests/` subdirectory is run)
  - Vignettes (i.e. build and check that vignettes run)

For more detailed information on what gets tested in each of these areas
see section [17.2](https://r-pkgs.org/r-cmd-check.html#check-checks) in
the [*R Packages*](https://r-pkgs.org/) book.

One thing to note, if you have tests developed in the `tests/` directory
of a package, then running `R CMD check` will run these tests and run
all the other checks on the package. However, as you will see shortly,
there are other ways to run the tests separately from `R CMD check` that
provides you more flexibility.

### Unit testing packages with testthat

As previously mentioned, when unit testing an R package, we typically
isolate unit tests into their own `tests/` subdirectory. The most common
way to unit test R packages is to use the
[testthat](https://testthat.r-lib.org/) package. When using testthat in
a package we set up our `tests/` directory as follows and we also need
to add testthat as a Suggests in the DESCRIPTION file. You can easily
set up this structure using `usethis::use_testthat()`.

    #> examplepkg/tests
    #> ├── testthat
    #> └── testthat.R

Within the `tests/` directory, you’ll see a `testthat.R` file and a
`testthat` directory. The `testthat.R` file is a file you will rarely
edit, but it needs to be there because this is what will get run when
you run `R CMD check`. You’ll see one function in this file
(`test_check("examplepkg")`), which directs `R CMD check` to run all the
tests in the `testthat` subdirectory.

If you are running tests interactively (from the console), then you can
just run `devtools::test()` and it will run and report test results.

So all the unit test magic will be contained in the `tests/testthat/`
subdirectory. If we look at this subdirectory we see what a typical
directory layout looks like.

    #> examplepkg/tests
    #> ├── testthat
    #> │   ├── helper.R
    #> │   ├── setup.R
    #> │   ├── teardown.R
    #> │   ├── test-01-header.R
    #> │   ├── test-02-filter.R
    #> │   ├── test-03-summarize.R
    #> │   ├── test-04-lint.R
    #> │   └── test-05-demo-failure.R
    #> └── testthat.R

You’ll notice 4 classes of .R files in this directory:

1.  Test files start with “test” and are executed in alphabetical order.
    This is where all your unit tests will reside. How you split up your
    tests across multiple scripts is up to you.
2.  Helper files start with “helper” and are executed before tests are
    run. If you have special custom functions that are used only during
    testing then you will want to place them here rather than in the
    package `R/` directory.
3.  Setup files start with “setup” and are executed before tests. If you
    have certain environment variables, data, or other items that will
    be used across all your tests then its best to place them here.
4.  Teardown files start with “teardown” and are executed after the
    tests are run. Often, if you are setting up a special environment in
    a “setup” file then you will likely want to close that environment
    down after testing.

You do not need all these types of files. In fact, in many packages you
will simply see the “test-xx.R” files. Within a “test-xx.R”, we
typically have the following structure:

![](images/test-structure.png)<!-- -->

where

  - `context()` defines a set of tests that test related functionality.
    Usually you will have one context per file, but you may have
    multiple contexts in a single file if you so choose. This is mainly
    useful when reporting test results as it allows you to see how many
    tests are run, and their results, for specific functionality being
    tested. If you do not include `context()` then the name of the test
    file will be used as the context.
  - `test_that()` encapsulates a series of expectations about small,
    self-contained set of functionality. Each test is contained in a
    context and can contain one or multiple expectations.
  - `expect_xxx()` are the actual unit tests being run. All expectations
    begin with `expect_` and you can even create your own [custom
    expectations](https://testthat.r-lib.org/articles/custom-expectation.html).

We can run these tests multiple ways. Most often we run them with
`devtools::test()` (assuming you are in the package root directory). We
can have the results reported in multiple ways. By default it will
report detailed results. Note that results can be “OK”, “F” for failure,
“W” for warning, and “S” for skipped.

``` r
> devtools::test()
Loading examplepkg
Testing examplepkg
✔ |  OK F W S | Context
✔ |   2       | header()
✔ |   2       | filter()
✔ |   2       | summarize()
✔ |   1       | Require no code style errors [1.0 s]
✖ |   0 1     | Demonstrate a test that fails
────────────────────────────────────────────────────────────────────
test-05-demo-failure.R:4: failure: dummy test to signal failure
FALSE isn't true.
────────────────────────────────────────────────────────────────────

══ Results ═════════════════════════════════════════════════════════
Duration: 1.0 s

OK:       7
Failed:   1
Warnings: 0
Skipped:  0
```

We can also adjust the reporting mechanism to get minimal results
reported:

``` r
> devtools::test(reporter = "minimal")
Loading examplepkg
Testing examplepkg
.......F
```

Run silently but gather the results to be reported elsewhere:

``` r
> devtools::test(reporter = "silent")
```

So other options with `?Reporter`.

### Unit testing packages with tinytest

### Package testing workflow

When building an R package, I typically:

1.  Set up the structure of the package and then run `R CMD check` to
    make sure the structure is right.

2.  As I build a new function or do bug fixes, I run the unit tests
    first until my code changes pass all unit tests and then I run `R
    CMD check` to ensure no other package requirements got overlooked.

3.  
## Testing for Non-packages

If you need to test a single

## Mocking

## Understanding Coverage
