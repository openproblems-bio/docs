#' Convert a list to a data frame
#'
#' This function converts a list to a data frame. It is a wrapper around
#' \code{\link{as.data.frame}} that only converts atomic vectors.
#'
#' @param li A list
#'
#' @return A data frame
#'
#' @export
#'
#' @examples
#' li <- list(
#'   a = c(1, 2, 3),
#'   b = c("a", "b", "c")
#' )
list_as_data_frame <- function(li) {
  as.data.frame(li[sapply(li, is.atomic)], check.names = FALSE)
}
