#' Render component section
#'
#' @param spec file spec
#' @return string
#'
#' @export
#' @examples
#' path <- system.file(
#'   "extdata", "example_project", "api", "comp_method.yaml",
#'   package = "openproblems.docs"
#' )
#'
#' spec <- read_component_spec(path)
#'
#' render_component_spec(spec)
render_component_spec <- function(spec) {
  if (is.character(spec)) {
    spec <- read_component_spec(spec)
  }

  # TODO: determine path
  path <- ""
  # prev:
  # Path: [`src/{spec$info$namespace}`]
  # (https://github.com/openproblems-bio/openproblems-v2/tree/main/src/{spec$info$namespace})

  strip_margin(glue("
    |## Component type: {spec$info$label}
    |
    |{path}
    |
    |{spec$info$summary}
    |
    |Arguments:
    |
    |:::{{.small}}
    |{paste(render_component_spec__format_arguments(spec), collapse = '\n')}
    |:::
    |
    |"), symbol = "\\|")
}

render_component_spec__format_arguments <- function(spec) { # nolint object_length_linter
  if (nrow(spec$args) == 0) {
    return("")
  }
  spec$args |>
    mutate(
      tag_str = map2_chr(.data$required, .data$direction, function(required, direction) {
        out <- c()
        if (!required) {
          out <- c(out, "Optional")
        }
        if (direction == "output") {
          out <- c(out, "Output")
        }
        if (length(out) == 0) {
          ""
        } else {
          paste0("(_", paste(out, collapse = ", "), "_) ")
        }
      })
    ) |>
    transmute(
      Name = paste0("`--", .data$arg_name, "`"),
      Type = paste0("`", .data$type, "`"),
      Description = paste0(
        .data$tag_str,
        .data$summary |> str_replace_all(" *\n *", " ") |> str_replace_all("\\. *$", ""),
        ".",
        ifelse(!is.na(.data$default), paste0(" Default: `", .data$default, "`."), "")
      )
    ) |>
    knitr::kable() |>
    align_kable_widths(c(25, 8, 60))
}
