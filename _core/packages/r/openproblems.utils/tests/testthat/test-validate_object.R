test_that("validate_object works", {
  task_config <- list(
    viash_version = "0.8.0",
    name = "task_example",
    organization = "openproblems",
    license = "MIT",
    label = "Example task",
    keywords = c("example", "task"),
    summary = "An example task",
    description = "A longer description of the example task",
    authors = list(),
    links = list(
      repository = "foo"
    ),
    info = list(
      image = "image.svg"
    )
  )
  out <- validate_object(task_config, what = "task_config")
  expect_true(out)
})

test_that("validate_object returns error on invalid object", {
  partial_config <- list(
    viash_version = "0.8.0",
    name = "task_example",
    organization = "openproblems",
    license = "MIT"
  )
  expect_error(validate_object(partial_config, what = "task_config"))
})
