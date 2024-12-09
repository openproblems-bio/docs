test_that("render_component_spec works", {
  path <- system.file("extdata", "example_project", "api", "comp_method.yaml", package = "openproblems.docs")
  spec <- read_component_spec(path)
  out <- render_component_spec(spec)
  expect_type(out, "character")
})
