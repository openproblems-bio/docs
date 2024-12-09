#' Deep merge two lists
#'
#' This function will merge two lists recursively. If both lists
#' are named lists, the keys will be merged. If both lists are
#' lists, they will be appended. Otherwise, the second list will
#' override the first list.
#'
#' @param obj1 The first object
#' @param obj2 The second object
#' @return The merged list
#'
#' @export
#' @examples
#' deep_merge(list(a = 1, b = 2), list(b = 3, c = 4))
#' # $a
#' # [1] 1
#' #
#' # $b
#' # [1] 3
#' #
#' # $c
#' # [1] 4
deep_merge <- function(obj1, obj2) {
  if (is_named_list(obj1) && is_named_list(obj2)) {
    # if list1 and list2 are objects, recursively merge
    keys <- unique(c(names(obj1), names(obj2)))
    out <- lapply(keys, function(key) {
      if (key %in% names(obj1)) {
        if (key %in% names(obj2)) {
          deep_merge(obj1[[key]], obj2[[key]])
        } else {
          obj1[[key]]
        }
      } else {
        obj2[[key]]
      }
    })
    names(out) <- keys
    out
  } else if (is.list(obj1) && is.list(obj2)) {
    # if list1 and list2 are both lists, append
    c(obj1, obj2)
  } else {
    # else override list1 with list2
    obj2
  }
}
