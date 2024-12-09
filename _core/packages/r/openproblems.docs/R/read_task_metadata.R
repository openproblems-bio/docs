#' Read the api files in a task
#'
#' This function reads the api files in a task and returns a list with the api info
#'
#' @param path Path to the API directory of a task
#' @return A list with the api info
#'
#' @importFrom cli cli_inform cli_abort
#'
#' @export
#' @examples
#' path <- system.file("extdata", "example_project", "api", package = "openproblems.docs")
#'
#' task_metadata <- read_task_metadata(path)
#'
#' task_metadata
read_task_metadata <- function(path) {
  cli::cli_inform(paste0("Looking for project root in '", path, "'"))
  project_path <- openproblems::find_project_root(path)
  if (is.null(project_path)) {
    cli::cli_abort("No project root found")
  }

  cli::cli_inform(paste0("Project root found at '", project_path, "'"))
  proj_conf_file <- file.path(project_path, "_viash.yaml")
  if (!file.exists(proj_conf_file)) {
    cli::cli_abort("No project config file (_viash.yaml) found in project root directory")
  }

  cli::cli_inform("Reading project config")
  proj_conf <- read_task_config(proj_conf_file)

  cli::cli_inform("Reading component yamls")
  comp_yamls <- list.files(path, pattern = "comp_[a-zA-Z0-9_\\-]*\\.ya?ml", full.names = TRUE, recursive = TRUE)
  comps <- map(comp_yamls, read_component_spec)
  comp_info <- map_dfr(comps, "info")
  comp_args <- map_dfr(comps, "args")
  names(comps) <- comp_info$file_name

  cli::cli_inform("Reading file yamls")
  file_yamls <- list.files(path, pattern = "file_[a-zA-Z0-9_\\-]*\\.ya?ml", full.names = TRUE, recursive = TRUE)
  files <- map(file_yamls, read_file_format)
  file_info <- map_dfr(files, "info")
  file_expected_format <- map_dfr(files, "expected_format")
  names(files) <- file_info$file_name

  cli::cli_inform("Generating task graph")
  task_graph <- .task_graph_generate(file_info, comp_info, comp_args)
  task_graph_root <- .task_graph_get_root(task_graph)
  task_graph_order <- names(igraph::bfs(task_graph, task_graph_root)$order)

  list(
    proj_path = project_path,
    proj_conf = proj_conf,
    files = files,
    file_info = file_info,
    file_expected_format = file_expected_format,
    comps = comps,
    comp_info = comp_info,
    comp_args = comp_args,
    task_graph = task_graph,
    task_graph_root = task_graph_root,
    task_graph_order = task_graph_order
  )
}

.task_graph_generate <- function(file_info, comp_info, comp_args) {
  clean_id <- function(id) {
    gsub("graph", "graaf", id)
  }
  nodes <-
    bind_rows(
      file_info |>
        mutate(id = .data$file_name, is_comp = FALSE),
      comp_info |>
        mutate(id = .data$file_name, is_comp = TRUE)
    ) |>
    select("id", "label", everything()) |>
    mutate(str = paste0(
      "  ",
      clean_id(.data$id),
      ifelse(.data$is_comp, "[/\"", "(\""),
      .data$label,
      ifelse(.data$is_comp, "\"/]", "\")")
    ))

  edges <- bind_rows(
    comp_args |>
      filter(.data$type == "file", .data$direction == "input") |>
      mutate(
        from = .data$parent,
        to = .data$file_name,
        arrow = ifelse(.data$required, "---", "-.-")
      ),
    comp_args |>
      filter(.data$type == "file", .data$direction == "output") |>
      mutate(
        from = .data$file_name,
        to = .data$parent,
        arrow = ifelse(.data$required, "-->", "-.->")
      )
  ) |>
    select("from", "to", everything()) |>
    mutate(str = paste0("  ", clean_id(.data$from), .data$arrow, clean_id(.data$to))) |>
    filter(!is.na(.data$from), !is.na(.data$to))

  igraph::graph_from_data_frame(
    edges,
    vertices = nodes,
    directed = TRUE
  )
}

.task_graph_get_root <- function(task_graph) {
  root <- names(which(igraph::degree(task_graph, mode = "in") == 0))
  if (length(root) > 1) {
    cli::cli_warn(paste0(
      "There should probably only be one node with in-degree equal to 0.\n",
      "  Nodes with in-degree == 0: ", paste(root, collapse = ", ")
    ))
  }
  root[[1]]
}
