#' Check if this list could be a data frame
#'
#' @param li list
#' @return whether the list could be a data frame
#'
#' @export
#' @examples
#' df <- list(
#'   a = c(1, 2, 3),
#'   b = c("a", "b", "c")
#' )
#' is_list_a_dataframe(df)
is_list_a_dataframe <- function(li) {
  is_named_list(li) && any(sapply(li, is.atomic))
}
