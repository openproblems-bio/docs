test_that("list_as_data_frame works", {
  li <- list(
    a = c(1, 2, 3),
    b = c("a", "b", "c")
  )
  expect_s3_class(list_as_data_frame(li), "data.frame")
  expect_equal(list_as_data_frame(li), data.frame(a = c(1, 2, 3), b = c("a", "b", "c")))
  li <- list(
    a = c(1, 2, 3),
    b = c("a", "b", "c"),
    c = list(1, 2, 3)
  )
  expect_s3_class(list_as_data_frame(li), "data.frame")
  expect_equal(list_as_data_frame(li), data.frame(a = c(1, 2, 3), b = c("a", "b", "c")))
  li <- list(
    a = c(1, 2, 3),
    b = c("a", "b", "c"),
    c = list(1, 2, 3),
    d = list(1, 2, 3)
  )
  expect_s3_class(list_as_data_frame(li), "data.frame")
  expect_equal(list_as_data_frame(li), data.frame(a = c(1, 2, 3), b = c("a", "b", "c")))
  li <- list(
    a = c(1, 2, 3),
    b = c("a", "b", "c"),
    c = list(1, 2, 3),
    d = list(1, 2, 3),
    e = list(1, 2, 3)
  )
  expect_s3_class(list_as_data_frame(li), "data.frame")
  expect_equal(list_as_data_frame(li), data.frame(a = c(1, 2, 3), b = c("a", "b", "c")))
  li <- list(
    a = c(1, 2, 3),
    b = c("a", "b", "c"),
    c = list(1, 2, 3),
    d = list(1, 2, 3),
    e = list(1, 2, 3),
    f = list(1, 2, 3)
  )
  expect_s3_class(list_as_data_frame(li), "data.frame")
  expect_equal(list_as_data_frame(li), data.frame(a = c(1, 2, 3), b = c("a", "b", "c")))
})
