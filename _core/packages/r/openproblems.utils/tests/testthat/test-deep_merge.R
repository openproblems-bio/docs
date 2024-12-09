test_that("deep_merge works", {
  a <- list(a = 1, b = list(c = 2, d = 3))
  b <- list(b = list(d = 4, e = 5))
  c <- deep_merge(a, b)
  expect_equal(c, list(a = 1, b = list(c = 2, d = 4, e = 5)))
})
