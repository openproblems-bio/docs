# openproblems R v0.1.0

Initial release

## NEW FUNCTIONALITY

* Project:
  - `find_project_root`: Find the root of a Viash project
  - `read_nested_yaml`: Read a nested YAML file
  - `read_viash_config`: Read a viash configuration file (PR #8).

## MAJOR CHANGES

* Moved helper functions to `openproblems.utils` package (PR #XXX).

## MINOR CHANGES

* Add dependencies to DESCRIPTION file (PR #8).

* `find_project_root`: simplify implementation (PR #11).

* Clean up code formatting with `styler::style_pkg()` (PR #13).

## TESTING

* Add tests for `find_project_root` (PR #11).
