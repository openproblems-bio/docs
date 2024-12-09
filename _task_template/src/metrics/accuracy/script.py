import anndata as ad
import numpy as np
import sklearn.preprocessing

## VIASH START
# Note: this section is auto-generated by viash at runtime. To edit it, make changes
# in config.vsh.yaml and then run `viash config inject config.vsh.yaml`.
par = {
  'input_solution': 'resources_test/task_template/cxg_mouse_pancreas_atlas/solution.h5ad',
  'input_prediction': 'resources_test/task_template/cxg_mouse_pancreas_atlas/prediction.h5ad',
  'output': 'output.h5ad'
}
meta = {
  'name': 'accuracy'
}
## VIASH END

print('Reading input files', flush=True)
input_solution = ad.read_h5ad(par['input_solution'])
input_prediction = ad.read_h5ad(par['input_prediction'])

assert (input_prediction.obs_names == input_solution.obs_names).all(), "obs_names not the same in prediction and solution inputs"

print("Encode labels", flush=True)
cats = list(input_solution.obs["label"].dtype.categories) + list(input_prediction.obs["label_pred"].dtype.categories)
encoder = sklearn.preprocessing.LabelEncoder().fit(cats)
input_solution.obs["label"] = encoder.transform(input_solution.obs["label"])
input_prediction.obs["label_pred"] = encoder.transform(input_prediction.obs["label_pred"])


print('Compute metrics', flush=True)
# metric_ids and metric_values can have length > 1
# but should be of equal length
uns_metric_ids = [ 'accuracy' ]
uns_metric_values = np.mean(input_solution.obs["label"] == input_prediction.obs["label_pred"])

print("Write output AnnData to file", flush=True)
output = ad.AnnData(
  uns={
    'dataset_id': input_prediction.uns['dataset_id'],
    'normalization_id': input_prediction.uns['normalization_id'],
    'method_id': input_prediction.uns['method_id'],
    'metric_ids': uns_metric_ids,
    'metric_values': uns_metric_values
  }
)
output.write_h5ad(par['output'], compression='gzip')