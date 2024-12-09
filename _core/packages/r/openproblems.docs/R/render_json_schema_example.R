#' Render an example of a JSON schema as a YAML string
#'
#' This function takes a JSON schema and renders an example YAML string.
#'
#' @param json_schema JSON schema as a list
#' @return YAML string
#'
#' @export
#'
#' @examples
#' library(openproblems)
#' example <- system.file("extdata", "example_schema.json", package = "openproblems.docs")
#'
#' json_schema <- read_nested_yaml(example)
#'
#' render_json_schema_example(json_schema)
render_json_schema_example <- function(json_schema) {
  if (!"properties" %in% names(json_schema)) {
    return("")
  }
  text <-
    unlist(lapply(names(json_schema$properties), function(prop_name) {
      out <- .render_json_schema_example__process_property(
        json_schema$properties[[prop_name]],
        prop_name,
        0
      )
      c(out, "\n")
    }))

  paste(text, collapse = "")
}

# Recursive function to process each property with indentation
# nolint start object_length_linter
.render_json_schema_example__process_property <- function(prop, prop_name = NULL, indent_level = 0) {
  # nolint end object_length_linter
  if (is.null(prop_name)) {
    prop_name <- ""
  }

  out <- c()

  # define helper variables
  indent_spaces <- strrep(" ", indent_level)
  next_indent_spaces <- strrep(" ", indent_level + 2)

  # add comment if available
  if ("description" %in% names(prop)) {
    comment <- gsub("\n", paste0("\n", indent_spaces, "# "), stringr::str_trim(prop$description))
    out <- c(out, indent_spaces, "# ", comment, "\n")
  }

  # add variable
  out <- c(out, indent_spaces, prop_name, ":")

  if (prop$type == "object" && "properties" %in% names(prop)) {
    # Handle object with properties
    prop_names <- setdiff(names(prop$properties), "additionalProperties")
    sub_props <- unlist(lapply(prop_names, function(sub_prop_name) {
      prop_out <- .render_json_schema_example__process_property(
        prop$properties[[sub_prop_name]],
        sub_prop_name,
        indent_level + 2
      )
      c(prop_out, "\n")
    }))
    c(out, "\n", sub_props[-length(sub_props)])
  } else if (prop$type == "array") {
    if (is.list(prop$items) && "properties" %in% names(prop$items)) {
      # Handle array of objects
      array_items_yaml <- unlist(lapply(names(prop$items$properties), function(item_prop_name) {
        prop_out <- .render_json_schema_example__process_property(
          prop$items$properties[[item_prop_name]],
          item_prop_name,
          indent_level + 4
        )
        c(prop_out, "\n")
      }))
      c(out, "\n", next_indent_spaces, "- ", array_items_yaml[-1])
    } else {
      # Handle simple array
      c(out, " [ ... ]")
    }
  } else {
    c(out, " ...")
  }
}
