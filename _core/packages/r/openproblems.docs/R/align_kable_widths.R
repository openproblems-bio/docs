align_kable_widths <- function(x, widths) {
  replacement <- paste0(
    paste(
      "|:",
      strrep("-", widths),
      collapse = "",
      sep = ""
    ),
    "|"
  )
  str_replace_all(x, "^\\|:--[\\|:-]*", replacement)
}
