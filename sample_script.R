file <- here::here("my_functions.R")
source(file)

header("Brad")

my_setosa <- filter(iris, Species == "setosa")
mean_sepal_length <- summarize(my_setosa, "Sepal.Length", "mean")
