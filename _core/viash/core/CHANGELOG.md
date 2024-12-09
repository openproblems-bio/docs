# common-resources 0.1.0

Initial release of the common resources. Initial components:

* `h5ad`:
  - `extract_uns_metadata`: Extract uns metadata from an h5ad file (PR #14).

* `project`:
  - `create_component`: Create a new component
  - `create_task_readme`: Render the task README
  - `sync_resources`: Component to sync resources from AWS s3.

* `schema`:
  - `verify_file_structure`: Checks a file against a schema (PR #14).
