#' Render file section
#'
#' @param spec file spec
#' @return string
#'
#' @export
#' @examples
#' path <- system.file(
#'   "extdata", "example_project", "api", "file_train_h5ad.yaml",
#'   package = "openproblems.docs"
#' )
#'
#' spec <- read_file_format(path)
#'
#' render_file_format(spec)
render_file_format <- function(spec) {
  if (is.character(spec)) {
    spec <- read_file_format(spec)
  }

  if (!"label" %in% names(spec$info)) {
    spec$info$label <- basename(spec$info$example)
  }

  example <-
    if (is.null(spec$info$example) || is.na(spec$info$example)) {
      ""
    } else {
      paste0("Example file: `", spec$info$example, "`")
    }

  description <-
    if (is.null(spec$info$description) || is.na(spec$info$description)) {
      ""
    } else {
      paste0("Description:\n\n", spec$info$description)
    }

  expected_format_str <-
    if (is.null(spec$expected_format)) {
      ""
    } else {
      strip_margin(glue(
        "Format:
        |
        |:::{{.small}}
        |{paste(.render_file_format__example(spec), collapse = '\n')}
        |:::
        |
        |Data structure:
        |
        |:::{{.small}}
        |{paste(.render_file_format__table(spec), collapse = '\n')}
        |:::
        |"
      ))
    }

  strip_margin(glue("
    |## File format: {spec$info$label}
    |
    |{spec$info$summary %||% ''}
    |
    |{example}
    |
    |{description}
    |
    |{expected_format_str}
    |"), symbol = "\\|")
}

.render_file_format__example <- function(spec) {
  format_type <- spec$info$file_type
  if (is.null(format_type)) {
    ""
  } else if (format_type == "h5ad") {
    example_strs <- spec$expected_format |>
      group_by(.data$struct) |>
      summarise(
        str = paste0(unique(.data$struct), ": ", paste0("'", .data$name, "'", collapse = ", "))
      ) |>
      arrange(match(.data$struct, anndata_struct_names))

    c("    AnnData object", paste0("     ", example_strs$str))
  } else if (format_type %in% c("csv", "tsv", "parquet")) {
    example_strs <- spec$expected_format |>
      summarise(
        str = paste0("'", .data$name, "'", collapse = ", ")
      )

    c("    Tabular data", paste0("     ", example_strs$str))
  } else {
    ""
  }
}

.render_file_format__table <- function(spec) {
  format_type <- spec$info$file_type
  if (is.null(format_type)) {
    ""
  } else if (format_type == "h5ad") {
    spec$expected_format |>
      mutate(
        tag_str = map_chr(.data$required, function(required) {
          out <- c()
          if (!required) {
            out <- c(out, "Optional")
          }
          if (length(out) == 0) {
            ""
          } else {
            paste0("(_", paste(out, collapse = ", "), "_) ")
          }
        })
      ) |>
      transmute(
        Slot = paste0("`", .data$struct, "[\"", .data$name, "\"]`"),
        Type = paste0("`", .data$type, "`"),
        Description = paste0(
          .data$tag_str,
          .data$description |> str_replace_all(" *\n *", " ") |> str_replace_all("\\. *$", ""),
          "."
        )
      ) |>
      knitr::kable() |>
      align_kable_widths(c(25, 8, 60))
  } else if (format_type %in% c("csv", "tsv", "parquet")) {
    spec$expected_format |>
      mutate(
        tag_str = map_chr(.data$required, function(required) {
          out <- c()
          if (!required) {
            out <- c(out, "Optional")
          }
          if (length(out) == 0) {
            ""
          } else {
            paste0("(_", paste(out, collapse = ", "), "_) ")
          }
        })
      ) |>
      transmute(
        Column = paste0("`", .data$name, "`"),
        Type = paste0("`", .data$type, "`"),
        Description = paste0(
          .data$tag_str,
          .data$description |> str_replace_all(" *\n *", " ") |> str_replace_all("\\. *$", ""),
          "."
        )
      ) |>
      knitr::kable() |>
      align_kable_widths(c(25, 8, 60))
  } else {
    ""
  }
}
