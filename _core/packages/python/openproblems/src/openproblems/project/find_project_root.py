from __future__ import annotations

def find_project_root(path: str = ".") -> str | None:
    """
    Find the root of a Viash project

    This function will recursively search for a `_viash.yaml` file
    in the parent directories of the given path.

    Args:
        path (str): Path to a file or directory

    Returns:
        str: The path to the root of the Viash project, or None if not found
    """

    import os
    
    path = os.path.abspath(path) 

    while path != "/" and not os.path.exists(os.path.join(path, "_viash.yaml")):
        path = os.path.dirname(path)

    if path == "/":
        return None

    return path