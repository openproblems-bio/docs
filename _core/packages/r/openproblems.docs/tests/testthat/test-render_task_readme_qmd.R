test_that("render_task_readme_qmd works", {
  path <- system.file("extdata", "example_project", "api", package = "openproblems.docs")
  task_metadata <- suppressWarnings(read_task_metadata(path))
  out <- render_task_readme_qmd(task_metadata)
  expect_type(out, "character")
})
