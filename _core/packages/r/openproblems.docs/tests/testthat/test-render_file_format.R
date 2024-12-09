test_that("render_file_format works", {
  path <- system.file("extdata", "example_project", "api", "file_train_h5ad.yaml", package = "openproblems.docs")
  spec <- read_file_format(path)
  out <- render_file_format(spec)
  expect_type(out, "character")
})
