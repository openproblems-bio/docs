# nolint start indentation_linter
test_that("strip_margin works", {
  str <- strip_margin(
    "Hello
    |  World"
  )
  expect_equal(str, "Hello\n  World")

  str <- strip_margin(
    "Hello
    §  World",
    symbol = "§"
  )
  expect_equal(str, "Hello\n  World")
})
# nolint end indentation_linter
