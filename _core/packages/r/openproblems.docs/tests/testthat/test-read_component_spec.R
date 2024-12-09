test_that("read_component_spec works", {
  path <- system.file("extdata", "example_project", "api", "comp_method.yaml", package = "openproblems.docs")
  spec <- read_component_spec(path)
  expect_type(spec, "list")
  expect_s3_class(spec$info, "tbl")
  expect_s3_class(spec$args, "tbl")
  expect_in(
    c("namespace", "type", "label", "summary", "description", "file_name"),
    names(spec$info)
  )
  expect_in(
    c(
      "type", "example", "label", "summary", "description", "name", "required",
      "direction", "file_name", "arg_name"
    ),
    names(spec$args)
  )
})
