#' Validate an object against a schema
#'
#' @param obj Object to validate
#' @param what Type of schema to validate against
#' @param obj_source Source of the object (e.g. the path to the config)
#' @param engine Validation engine to use. Currently supported are "imjv" and "ajv".
#' @param error Whether to throw an error if validation fails
#'
#' @importFrom jsonlite toJSON
#' @importFrom jsonvalidate json_validate
#'
#' @export
#'
#' @examples
#' task_config <- list(
#'   viash_version = "0.8.0",
#'   name = "task_example",
#'   organization = "openproblems",
#'   license = "MIT",
#'   label = "Example task",
#'   keywords = c("example", "task"),
#'   summary = "An example task",
#'   description = "A longer description of the example task",
#'   authors = list(),
#'   links = list(
#'     repository = "foo"
#'   ),
#'   info = list(
#'     image = "image.svg"
#'   )
#' )
#' validate_object(task_config, what = "task_config")
validate_object <- function(
    obj,
    what = c(
      "api_component_spec",
      "api_file_format",
      "task_config",
      "task_control_method",
      "task_method",
      "task_metric"
    ),
    obj_source = NULL,
    engine = c("ajv", "imjv"),
    error = TRUE) {
  what <- match.arg(what)
  engine <- match.arg(engine)

  schema_file <- system.file(
    "extdata",
    "schemas",
    paste0(what, ".json"),
    package = "openproblems.utils"
  )
  if (!file.exists(schema_file)) {
    stop("Schema file not found: ", schema_file)
  }

  obj_js <- jsonlite::toJSON(obj, auto_unbox = TRUE)

  out <- tryCatch(
    suppressMessages(
      jsonvalidate::json_validate(
        obj_js,
        schema_file,
        engine = engine,
        verbose = TRUE,
        error = error
      )
    ),
    error = function(e) {
      source_str <-
        if (!is.null(obj_source)) paste0(" from source ", obj_source) else ""
      desired_message <- paste0(
        "validating ", what, " object", source_str, ":"
      )
      e$message <- gsub("validating json:", desired_message, e$message)
      stop(e)
    }
  )

  invisible(out)
}
