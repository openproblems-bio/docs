#' Check if an object is a named list
#'
#' @param obj An object
#' @return TRUE if the object is a named list, FALSE otherwise
#'
#' @export
#'
#' @examples
#' is_named_list(list(a = 1, b = 2)) # TRUE
#' is_named_list(list(1, 2)) # FALSE
#' is_named_list(NULL) # TRUE
#' is_named_list(list()) # TRUE
#' is_named_list(c(1, 2, 3)) # FALSE
is_named_list <- function(obj) {
  is.null(obj) || (is.list(obj) && (length(obj) == 0 || !is.null(names(obj))))
}
