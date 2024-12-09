from __future__ import annotations

def read_nested_yaml(path: str, project_path: str | None = None) -> dict:
    """
    Read a nested YAML

    If the YAML contains a "__merge__" key anywhere in the yaml,
    the path specified in that YAML will be read and the two
    lists will be merged. This is a recursive procedure.

    Args:
        path (str): Path to a YAML
        project_path (str, optional): Path to the Viash project root

    Returns:
        dict: A list with the merged YAML
    """
    import os
    import yaml
    from . import find_project_root

    if project_path is None:
        project_path = find_project_root(path)

    path = os.path.normpath(path)

    try:
        with open(path, "r") as f:
            data = yaml.safe_load(f)
    except Exception as e:
        raise ValueError(f"Could not read {path}. Error: {e}")
    
    return process_nested_yaml(data, data, path, project_path)

def process_nested_yaml(data: any, root_data: dict, path: str, project_path: str) -> dict:
    """
    Process the merge keys in a YAML

    This function will recursively process the merge keys in a YAML

    Args:
        data (dict): The YAML data
        root_data (dict): The root YAML data
        path (str): The path to the current YAML file
        project_path (str): The path to the root of the Viash project

    Returns:
        dict: The processed YAML
    """
    import os
    import yaml
    from .resolve_path import resolve_path
    from ..utils.deep_merge import deep_merge

    if isinstance(data, dict):
        processed_data = {k: process_nested_yaml(v, root_data, path, project_path) for k, v in data.items()}

        new_data = {}
        if "__merge__" in processed_data and not isinstance(processed_data["__merge__"], dict):
            new_data_path = resolve_path(processed_data["__merge__"], project_path, os.path.dirname(path))
            new_data = read_nested_yaml(new_data_path, project_path)
        elif "$ref" in processed_data and not isinstance(processed_data["$ref"], dict):
            ref_parts = processed_data["$ref"].split("#")

            if ref_parts[0] == "":
                x = root_data
            else:
                new_data_path = resolve_path(ref_parts[0], project_path, os.path.dirname(path))
                new_data_path = os.path.normpath(new_data_path)

                try:
                    with open(new_data_path, "r") as f:
                        x = yaml.safe_load(f)
                except Exception as e:
                    raise ValueError(f"Could not read {new_data_path}. Error: {e}")
                
            x_root = x

            ref_path_parts = ref_parts[1].split("/")
            for part in ref_path_parts:
                if part == "":
                    continue
                elif part in x:
                    x = x[part]
                else:
                    raise ValueError(f"Could not find {processed_data['$ref']} in {path}")
                
            if ref_parts[0] == "":
                new_data = x
            else:
                new_data = process_nested_yaml(x, x_root, new_data_path, project_path)
        else:
            new_data = {}

        return deep_merge(new_data, processed_data)
    elif isinstance(data, list):
        return [process_nested_yaml(v, root_data, path, project_path) for v in data]
    else:
        return data
