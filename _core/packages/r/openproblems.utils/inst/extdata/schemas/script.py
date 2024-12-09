import os
import yaml
import json

input_yaml_dir = "schemas"
output_json_dir = "packages/r/openproblems.utils/inst/extdata/schemas"

def process_data(x):
    if isinstance(x, list):
        return [process_data(item) for item in x]
    if isinstance(x, dict):
      if "$ref" in x:
        x["$ref"] = x["$ref"].replace(".yaml#", ".json#")
      return {key: process_data(value) for key, value in x.items()}
    return x

# Create output directory
os.makedirs(output_json_dir, exist_ok=True)

# Delete previous JSON files
for file in os.listdir(output_json_dir):
    if file.endswith(".json"):
        os.remove(os.path.join(output_json_dir, file))

# Read YAML and write as JSON, substituting "$ref"
for file in os.listdir(input_yaml_dir):
    if file.endswith(".yaml"):
        yaml_file = os.path.join(input_yaml_dir, file)
        json_file = os.path.join(output_json_dir, file.replace(".yaml", ".json"))
        with open(yaml_file, 'r') as f:
            yaml_data = yaml.safe_load(f)
        json_data = process_data(yaml_data)
        with open(json_file, 'w') as f:
            json_str = json.dumps(json_data, indent=2)
            f.write(json_str + "\n")
