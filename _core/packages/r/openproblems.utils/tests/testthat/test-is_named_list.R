test_that("is_named_list works", {
  expect_true(is_named_list(list(a = 1, b = 2)))
  expect_false(is_named_list(list(1, 2)))
  expect_true(is_named_list(NULL))
  expect_true(is_named_list(list()))
  expect_false(is_named_list(c(1, 2, 3)))
})
