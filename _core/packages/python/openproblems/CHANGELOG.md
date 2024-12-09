# openproblems core Python v0.1.1

## NEW FUNCTIONALITY

* Add support for python 3.9 (PR #17).


# openproblems core Python v0.1.0

Initial release

## NEW FUNCTIONALITY

* `project`:
  - `find_project_root`: Find the root of a Viash project.
  - `read_nested_yaml`: Read a nested YAML file.
  - `read_viash_config`: Read a viash configuration file (PR #8).

* `utils`:
  - `strip_margin`: Strip margin from a string
  - `deep_merge`: Merge two dictionaries recursively

## MAJOR CHANGES

* Bump minimum Python version to 3.10 (PR #11).

## MINOR CHANGES

* Add dependencies to project toml file (PR #1).

* Clean up project toml file (PR #8).

## BUG FIXES

* Fix recursion bug in `find_project_root` (PR #11).

## TESTING

* Add tests for `find_project_root` (PR #11).
