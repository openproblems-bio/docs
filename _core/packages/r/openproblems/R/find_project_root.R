#' Find the root of a Viash project
#'
#' This function will recursively search for a `_viash.yaml` file
#' in the parent directories of the given path.
#'
#' @param path Path to a file or directory
#' @return The path to the root of the Viash project, or NULL if not found
#'
#' @importFrom fs path_abs path_dir path file_exists path_norm
#' @export
#' @examples
#' \dontrun{
#' find_project_root("/path/to/project/subdir")
#' }
find_project_root <- function(path = ".") {
  path <- fs::path_abs(fs::path_norm(path))

  while (path != "/" && !fs::file_exists(fs::path(path, "_viash.yaml"))) {
    path <- fs::path_dir(path)
  }

  if (path == "/") {
    return(NULL)
  }

  as.character(path)
}
