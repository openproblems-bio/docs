def deep_merge(obj1: any, obj2: any) -> dict:
    """Recursively merge two dictionaries or lists.

    Args:
        obj1 (any): The first dictionary or list.
        obj2 (any): The second dictionary or list.

    Returns:
        dict: The merged dictionary.
    """
    if isinstance(obj1, dict) and isinstance(obj2, dict):
        keys = set(list(obj1.keys()) + list(obj2.keys()))
        out = {}
        for key in keys:
            if key in obj1:
                if key in obj2:
                    out[key] = deep_merge(obj1[key], obj2[key])
                else:
                    out[key] = obj1[key]
            else:
                out[key] = obj2[key]
        return out
    elif isinstance(obj1, list) and isinstance(obj2, list):
        return obj1 + obj2
    else:
        return obj2
