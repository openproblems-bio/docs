test_that("find_project_root works", {
  # create a temporary directory with a _viash.yaml file
  # project/
  # ├── src/
  # |   ├── config.vsh.yaml
  # |   └── script.R
  # └── _viash.yaml

  temp_dir <- fs::path_temp()

  # remove on test end
  on.exit(fs::dir_delete(temp_dir))

  # Create project structure
  proj_dir <- fs::path(temp_dir, "project")
  fs::dir_create(fs::path(temp_dir, "project"))

  src_dir <- fs::path(temp_dir, "project", "src")
  fs::dir_create(src_dir)

  # Create files
  proj_config <- fs::path(temp_dir, "project", "_viash.yaml")
  fs::file_create(proj_config)

  comp_config <- fs::path(temp_dir, "project", "src", "config.vsh.yaml")
  fs::file_create(comp_config)

  comp_script <- fs::path(temp_dir, "project", "src", "script.R")
  fs::file_create(comp_script)

  # Perform assertions
  expected_dir <- as.character(proj_dir)
  expect_equal(
    find_project_root(comp_script),
    expected_dir
  )
  expect_equal(
    find_project_root(comp_config),
    expected_dir
  )
  expect_equal(
    find_project_root(proj_config),
    expected_dir
  )
  expect_equal(
    find_project_root(src_dir),
    expected_dir
  )
  expect_equal(
    find_project_root(proj_dir),
    expected_dir
  )
  expect_null(
    find_project_root(temp_dir)
  )
})
