#' Read a nested YAML
#'
#' If the YAML contains a "__merge__" key anywhere in the yaml,
#' the path specified in that YAML will be read and the two
#' lists will be merged. This is a recursive procedure.
#'
#' @param path Path to a YAML
#' @param project_path Path to the Viash project root
#' @return A list with the merged YAML
#'
#' @importFrom yaml read_yaml
#'
#' @export
#' @examples
#' \dontrun{
#' read_nested_yaml("src/path/to/config.vsh.yaml")
#' }
read_nested_yaml <- function(path, project_path = find_project_root(path)) {
  path <- normalizePath(path, mustWork = FALSE)
  data <- tryCatch(
    {
      suppressWarnings(yaml::read_yaml(path))
    },
    error = function(e) {
      stop("Could not read ", path, ". Error: ", e)
    }
  )
  process_nested_yaml(data, data, path, project_path)
}

#' Process the merge keys in a YAML
#'
#' This function will recursively process the merge keys in a YAML
#'
#' @param data The YAML data
#' @param root_data The root YAML data
#' @param path The path to the current YAML file
#' @param project_path The path to the root of the Viash project
#'
#' @importFrom openproblems.utils deep_merge is_named_list
#'
#' @noRd
process_nested_yaml <- function(data, root_data, path, project_path) { # nolint cyclocomp_linter
  if (is_named_list(data)) {
    # check whether children have `__merge__` entries
    processed_data <- lapply(data, function(dat) {
      process_nested_yaml(dat, root_data, path, project_path)
    })
    processed_data <- lapply(names(data), function(nm) {
      dat <- data[[nm]]
      process_nested_yaml(dat, root_data, path, project_path)
    })
    names(processed_data) <- names(data)

    # if current element has __merge__, read list2 yaml and combine with data
    new_data <-
      if ("__merge__" %in% names(processed_data) && !is_named_list(processed_data$`__merge__`)) {
        new_data_path <- resolve_path(
          path = processed_data$`__merge__`,
          project_path = project_path,
          parent_path = dirname(path)
        )
        read_nested_yaml(new_data_path, project_path)
      } else if ("$ref" %in% names(processed_data) && !is_named_list(processed_data$`$ref`)) {
        ref_parts <- strsplit(processed_data$`$ref`, "#")[[1]]

        # resolve the path in $ref
        x <-
          if (ref_parts[[1]] == "") {
            root_data
          } else {
            new_data_path <- resolve_path(
              path = ref_parts[[1]],
              project_path = project_path,
              parent_path = dirname(path)
            )
            new_data_path <- normalizePath(new_data_path, mustWork = FALSE)

            # read in the new data
            tryCatch(
              {
                suppressWarnings(yaml::read_yaml(new_data_path))
              },
              error = function(e) {
                stop("Could not read ", new_data_path, ". Error: ", e)
              }
            )
          }
        x_root <- x

        # Navigate the path and retrieve the referenced data
        ref_path_parts <- unlist(strsplit(ref_parts[[2]], "/"))
        for (part in ref_path_parts) {
          if (part == "") {
            next
          } else if (part %in% names(x)) {
            x <- x[[part]]
          } else {
            stop("Could not find ", processed_data$`$ref`, " in ", path)
          }
        }

        # postprocess the new data
        if (ref_parts[[1]] == "") {
          x
        } else {
          process_nested_yaml(x, x_root, new_data_path, project_path)
        }
      } else {
        list()
      }

    deep_merge(new_data, processed_data)
  } else if (is.list(data)) {
    lapply(data, function(dat) {
      process_nested_yaml(dat, root_data, path, project_path)
    })
  } else {
    data
  }
}
