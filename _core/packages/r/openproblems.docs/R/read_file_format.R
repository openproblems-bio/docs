#' Read file format
#'
#' This function reads a file format spec from a yaml file.
#'
#' @param path Path to a file format yaml, usually in `src/api/file_*.yaml`
#' @return A list with file format info and expected_format
#'
#' @export
#' @examples
#' path <- system.file(
#'   "extdata", "example_project", "api", "file_train_h5ad.yaml",
#'   package = "openproblems.docs"
#' )
#'
#' read_file_format(path)
read_file_format <- function(path) {
  data <- openproblems::read_nested_yaml(path)

  tryCatch(
    {
      validate_object(data, obj_source = path, what = "api_file_format")
    },
    error = function(e) {
      cli::cli_warn(paste0("File format validation failed: ", e$message))
    }
  )

  out <- list(
    info = read_file_format__process_info(data, path)
  )

  # detect format types
  format_type <- data$info$format$type

  if (!is.null(format_type)) {
    expected_format <-
      if (format_type == "h5ad") {
        read_file_format__process_h5ad(data, path)
      } else if (format_type %in% c("tabular", "csv", "tsv")) {
        read_file_format__process_tabular(data, path)
      }
    expected_format$data_type <- format_type
    out$expected_format <- expected_format
  }

  out
}

#' @importFrom openproblems.utils list_as_data_frame is_list_a_dataframe
read_file_format__process_info <- function(data, path) {
  df <- data.frame(
    file_name = basename(path) |> str_replace_all("\\.yaml", "")
  )
  if (is_list_a_dataframe(data)) {
    df <- dplyr::bind_cols(df, list_as_data_frame(data))
  }

  # make sure some fields are always present
  df$file_type <- data$info$format$type %||% NA_character_ |> as.character()
  df$description <- df$description %||% NA_character_ |> as.character()
  df$summary <- df$summary %||% NA_character_ |> as.character()

  as_tibble(df)
}

read_file_format__process_h5ad <- function(data, path) {
  map_dfr(
    anndata_struct_names,
    function(struct_name) {
      fields <- data$info$format[[struct_name]]
      if (is.null(fields)) {
        return(NULL)
      }
      df <- map_dfr(fields, as.data.frame)

      # make sure some fields are always present
      df$struct <- struct_name
      df$file_name <- basename(path) |> str_replace_all("\\.yaml", "")
      df$required <- df$required %||% TRUE %|% TRUE
      df$multiple <- df$multiple %||% FALSE %|% FALSE
      df$description <- df$description %||% NA_character_ |> as.character()
      df$summary <- df$summary %||% NA_character_ |> as.character()

      as_tibble(df)
    }
  )
}

read_file_format__process_tabular <- function(spec, path) { # nolint object_length_linter
  map_dfr(
    spec$info$columns,
    function(column) {
      df <- data.frame(
        file_name = basename(path) |> str_replace_all("\\.yaml", "")
      )
      if (is_list_a_dataframe(column)) {
        df <- dplyr::bind_cols(df, list_as_data_frame(column))
      }

      # make sure some fields are always present
      df$required <- df$required %||% TRUE %|% TRUE
      df$multiple <- df$multiple %||% FALSE %|% FALSE
      df$description <- df$description %||% NA_character_ |> as.character()
      df$summary <- df$summary %||% NA_character_ |> as.character()

      as_tibble(df)
    }
  )
}
