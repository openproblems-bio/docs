test_that("render_json_schema_example works", {
  path <- system.file("extdata", "example_schema.json", package = "openproblems.docs")
  schema <- openproblems::read_nested_yaml(path)
  out <- render_json_schema_example(schema)
  expect_type(out, "character")
})

test_that("render_json_schema_example with a simple example", {
  schema <- list(
    type = "object",
    properties = list(
      a = list(
        type = "string",
        example = "custom_example"
      ),
      b = list(
        type = "integer"
      ),
      c = list(
        type = "array",
        items = list(
          type = "string"
        )
      ),
      d = list(
        type = "object",
        properties = list(
          e = list(
            type = "string"
          )
        )
      )
    )
  )
  out <- render_json_schema_example(schema)

  expected_string <- strip_margin(
    "a: ...
    |b: ...
    |c: [ ... ]
    |d:
    |  e: ...
    |"
  )
  expect_type(out, "character")
  expect_equal(out, expected_string)
})
