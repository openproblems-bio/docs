#' Resolve a path relative to a parent path or project path
#'
#' This function will resolve a path to an absolute path. If
#' the path is relative, it will be resolved relative to the
#' parent path. If the path is absolute, it will be resolved
#' relative to the project path.
#'
#' @param path The path to resolve
#' @param project_path The path to the root of the Viash project
#' @param parent_path The path to the parent directory
#' @return The resolved path
#'
#' @importFrom fs path_abs
#'
#' @noRd
#' @examples
#' project_path <- "/path/to/project"
#' parent_path <- "/path/to/project/subdir"
#'
#' resolve_path("./file.yaml", project_path, parent_path)
#' # "/path/to/project/subdir/file.yaml"
#'
#' resolve_path("/file.yaml", project_path, parent_path)
#' # "/path/to/project/file.yaml"
resolve_path <- function(path, project_path, parent_path) {
  ifelse(
    grepl("^/", path),
    paste0(project_path, path),
    fs::path_abs(path, parent_path)
  )
}
