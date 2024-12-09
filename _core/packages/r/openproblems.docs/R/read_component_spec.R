#' Read component spec
#'
#' This function reads a component spec from a yaml file.
#'
#' @param path Path to a component spec yaml, usually in `src/api/comp_*.yaml`
#' @return A list with compontent info and arguments
#'
#' @export
#' @examples
#' path <- system.file(
#'   "extdata", "example_project", "api", "comp_method.yaml",
#'   package = "openproblems.docs"
#' )
#'
#' read_component_spec(path)
read_component_spec <- function(path) {
  data <- openproblems::read_nested_yaml(path)

  tryCatch(
    {
      validate_object(data, obj_source = path, what = "api_component_spec")
    },
    error = function(e) {
      cli::cli_warn(paste0("Component spec validation failed: ", e$message))
    }
  )

  list(
    info = read_component_spec__process_info(data, path),
    args = read_component_spec__process_arguments(data, path)
  )
}

#' @importFrom openproblems.utils list_as_data_frame is_list_a_dataframe
read_component_spec__process_info <- function(data, path) { # nolint object_length_linter
  df <- data.frame(
    file_name = basename(path) |> str_replace_all("\\.yaml", "")
  )
  if (is_list_a_dataframe(data)) {
    df <- dplyr::bind_cols(df, list_as_data_frame(data))
  }
  if (is_list_a_dataframe(data$info)) {
    df <- dplyr::bind_cols(df, list_as_data_frame(data$info))
  }
  if (is_list_a_dataframe(data$info$type_info)) {
    df <- dplyr::bind_cols(df, list_as_data_frame(data$info$type_info))
  }
  as_tibble(df)
}

read_component_spec__process_arguments <- function(data, path) { # nolint object_length_linter
  arguments <- data$arguments
  for (arg_group in data$argument_groups) {
    arguments <- c(arguments, arg_group$arguments)
  }
  map_dfr(arguments, function(arg) {
    df <- data.frame(
      file_name = basename(path) |> str_replace_all("\\.yaml", "")
    )
    if (is_list_a_dataframe(arg)) {
      df <- dplyr::bind_cols(df, list_as_data_frame(arg))
    }
    if (is_list_a_dataframe(arg$info)) {
      df <- dplyr::bind_cols(df, list_as_data_frame(arg$info))
    }
    df$arg_name <- str_replace_all(arg$name, "^-*", "")
    df$direction <- df$direction %||% "input" %|% "input"
    df$parent <- df$`__merge__` %||% NA_character_ |>
      basename() |>
      str_replace_all("\\.yaml", "")
    df$required <- df$required %||% FALSE %|% FALSE
    df$default <- df$default %||% NA_character_ |> as.character()
    df$example <- df$example %||% NA_character_ |> as.character()
    df$description <- df$description %||% NA_character_ |> as.character()
    df$summary <- df$summary %||% NA_character_ |> as.character()
    as_tibble(df)
  })
}
