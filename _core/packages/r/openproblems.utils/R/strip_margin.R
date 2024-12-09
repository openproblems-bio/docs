#' Strip margin from a string
#'
#' @param text A character vector.
#' @param symbol The margin symbol to strip.
#' @return A character vector with the margin stripped.
#'
#' @export
#' @examples
#' strip_margin(
#'   "hello_world:
#'   |  this_is: \"a yaml\""
#' )
strip_margin <- function(text, symbol = "\\|") {
  gsub(paste0("(^|\n)[ \t]*", symbol), "\\1", text)
}
