test_that("is_list_a_dataframe works", {
  expect_false(is_list_a_dataframe(list()))
  expect_false(is_list_a_dataframe(NULL))
  expect_false(is_list_a_dataframe(c(1, 2, 3)))
  expect_false(is_list_a_dataframe(list(1, 2)))
  expect_true(is_list_a_dataframe(list(a = 1, b = 2)))
})
