# OpenProblems core packages


This repository provides OpenProblems core helper packages in R and
Python.

## Installation

You can install the Python package with pip:

``` bash
pip install "git+https://github.com/openproblems-bio/core#subdirectory=packages/python/openproblems"
```

You can install the R package with devtools:

``` r
devtools::install_github("openproblems-bio/core/packages/r/openproblems")
```

## Install in a Viash component

For Python components:

``` yaml
engines:
  - type: docker
    image: python:3.10
    setup:
      - type: apt
        packages: git
      - type: python
        github: openproblems-bio/core#subdirectory=packages/python/openproblems
```

For R components:

``` yaml
engines:
  - type: docker
    image: rocker/r2u:22.04
    setup:
      - type: r
        github: openproblems-bio/core/packages/r/openproblems
```

## Example usage

``` bash
git clone https://github.com/openproblems-bio/task_perturbation_prediction
```

    Cloning into 'task_perturbation_prediction'...

### Python

``` python
import openproblems
```

#### Find project root

``` python
path = "task_perturbation_prediction/src/api/comp_method.yaml"

openproblems.project.find_project_root(path)
```

    'task_perturbation_prediction'

### Read nested yaml

``` python
comp_method = openproblems.io.read_nested_yaml(path)
```

<details>
<summary>
Contents of `comp_method`
</summary>

``` yaml
__merge__: wf_method.yaml
arguments:
- __merge__: file_de_train.yaml
  direction: input
  example: resources/datasets/neurips-2023-data/de_train.h5ad
  info:
    file_type: h5ad
    label: DE train
    slots:
      layers:
      - description: Log fold change of the differential expression test
        name: logFC
        required: true
        type: double
      - description: Average expression of the differential expression test
        name: AveExpr
        required: false
        type: double
      - description: T-statistic of the differential expression test
        name: t
        required: false
        type: double
      - description: P-value of the differential expression test
        name: P.Value
        required: true
        type: double
      - description: Adjusted P-value of the differential expression test
        name: adj.P.Value
        required: true
        type: double
      - description: B-statistic of the differential expression test
        name: B
        required: false
        type: double
      - description: Whether the gene is differentially expressed
        name: is_de
        required: true
        type: boolean
      - description: Whether the gene is differentially expressed after adjustment
        name: is_de_adj
        required: true
        type: boolean
      - description: 'Differential expression value (`-log10(p-value) * sign(LFC)`)
          for each gene.

          Here, LFC is the estimated log-fold change in expression between the treatment

          and control condition after shrinkage as calculated by Limma. Positive LFC
          means

          the gene goes up in the treatment condition relative to the control.

          '
        name: sign_log10_pval
        required: true
        type: double
      - description: 'A clipped version of the sign_log10_pval layer. Values are clipped
          to be between

          -4 and 4 (i.e. `-log10(0.0001)` and `-log10(0.0001)`).

          '
        name: clipped_sign_log10_pval
        required: true
        type: double
      obs:
      - description: The annotated cell type of each cell based on RNA expression.
        name: cell_type
        required: true
        type: string
      - description: "The primary name for the (parent) compound (in a standardized\
          \ representation)\nas chosen by LINCS. This is provided to map the data\
          \ in this experiment to \nthe LINCS Connectivity Map data.\n"
        name: sm_name
        required: true
        type: string
      - description: 'The global LINCS ID (parent) compound (in a standardized representation).

          This is provided to map the data in this experiment to the LINCS Connectivity

          Map data.

          '
        name: sm_lincs_id
        required: true
        type: string
      - description: 'Simplified molecular-input line-entry system (SMILES) representations
          of the

          compounds used in the experiment. This is a 1D representation of molecular

          structure. These SMILES are provided by Cellarity based on the specific

          compounds ordered for this experiment.

          '
        name: SMILES
        required: true
        type: string
      - description: Split. Must be one of 'control', 'train', 'public_test', or 'private_test'
        name: split
        required: true
        type: string
      - description: Boolean indicating whether this instance was used as a control.
        name: control
        required: true
        type: boolean
      uns:
      - description: A unique identifier for the dataset. This is different from the
          `obs.dataset_id` field, which is the identifier for the dataset from which
          the cell data is derived.
        name: dataset_id
        required: true
        type: string
      - description: A human-readable name for the dataset.
        name: dataset_name
        required: true
        type: string
      - description: Link to the original source of the dataset.
        name: dataset_url
        required: false
        type: string
      - description: Bibtex reference of the paper in which the dataset was published.
        multiple: true
        name: dataset_reference
        required: false
        type: string
      - description: Short description of the dataset.
        name: dataset_summary
        required: true
        type: string
      - description: Long description of the dataset.
        name: dataset_description
        required: true
        type: string
      - description: The organism of the sample in the dataset.
        multiple: true
        name: dataset_organism
        required: false
        type: string
      - description: 'A dataframe with the cell-level metadata for the training set.

          '
        name: single_cell_obs
        required: true
        type: dataframe
    summary: Differential expression results for training.
  name: --de_train_h5ad
  required: false
  type: file
- __merge__: file_id_map.yaml
  direction: input
  example: resources/datasets/neurips-2023-data/id_map.csv
  info:
    columns:
    - description: Index of the test observation
      name: id
      required: true
      type: integer
    - description: Cell type name
      name: cell_type
      required: true
      type: string
    - description: Small molecule name
      name: sm_name
      required: true
      type: string
    file_type: csv
    label: ID Map
    summary: File indicates the order of de_test, the cell types and the small molecule
      names.
  name: --id_map
  required: true
  type: file
- default: clipped_sign_log10_pval
  description: Which layer to use for prediction.
  direction: input
  name: --layer
  type: string
- __merge__: file_prediction.yaml
  direction: output
  example: resources/datasets/neurips-2023-data/prediction.h5ad
  info:
    file_type: h5ad
    label: Prediction
    slots:
      layers:
      - description: Predicted differential gene expression
        name: prediction
        required: true
        type: double
      uns:
      - description: A unique identifier for the dataset. This is different from the
          `obs.dataset_id` field, which is the identifier for the dataset from which
          the cell data is derived.
        name: dataset_id
        required: true
        type: string
      - description: A unique identifier for the method used to generate the prediction.
        name: method_id
        required: true
        type: string
    summary: Differential Gene Expression prediction
  name: --output
  required: true
  type: file
- __merge__: file_model.yaml
  direction: output
  example: resources/datasets/neurips-2023-data/model/
  info:
    file_type: directory
    label: Model
    summary: Optional model output. If no value is passed, the model will be removed
      at the end of the run.
  must_exist: false
  name: --output_model
  required: false
  type: file
info:
  type: method
  type_info:
    description: 'A method for predicting the perturbation response of small molecules
      on certain cell types.

      '
    label: Method
    summary: A perturbation prediction method
namespace: methods
test_resources:
- path: /common/component_tests/run_and_check_output.py
  type: python_script
- dest: resources/datasets/neurips-2023-data
  path: /resources/datasets/neurips-2023-data
```

</details>

### Strip margin

``` python
print(openproblems.utils.strip_margin("""
  |this_is:
  |  a_yaml: 'test'
  |"""))
```


    this_is:
      a_yaml: 'test'

### R

``` r
library(openproblems)
```

#### Find project root

``` r
path <- "task_perturbation_prediction/src/api/comp_method.yaml"

openproblems::find_project_root(path)
```

    [1] "/tmp/RtmplzAgkk/task_perturbation_prediction"

### Read nested yaml

``` r
comp_method <- openproblems::read_nested_yaml(path)
```

<details>
<summary>
Contents of `comp_method`
</summary>

``` yaml
namespace: methods
info:
  type: method
  type_info:
    label: Method
    summary: A perturbation prediction method
    description: |
      A method for predicting the perturbation response of small molecules on certain cell types.
arguments:
- type: file
  example: resources/datasets/neurips-2023-data/de_train.h5ad
  info:
    label: DE train
    summary: Differential expression results for training.
    file_type: h5ad
    slots:
      obs:
      - name: cell_type
        type: string
        description: The annotated cell type of each cell based on RNA expression.
        required: yes
      - name: sm_name
        type: string
        description: "The primary name for the (parent) compound (in a standardized
          representation)\nas chosen by LINCS. This is provided to map the data in
          this experiment to \nthe LINCS Connectivity Map data.\n"
        required: yes
      - name: sm_lincs_id
        type: string
        description: |
          The global LINCS ID (parent) compound (in a standardized representation).
          This is provided to map the data in this experiment to the LINCS Connectivity
          Map data.
        required: yes
      - name: SMILES
        type: string
        description: |
          Simplified molecular-input line-entry system (SMILES) representations of the
          compounds used in the experiment. This is a 1D representation of molecular
          structure. These SMILES are provided by Cellarity based on the specific
          compounds ordered for this experiment.
        required: yes
      - name: split
        type: string
        description: Split. Must be one of 'control', 'train', 'public_test', or 'private_test'
        required: yes
      - name: control
        type: boolean
        description: Boolean indicating whether this instance was used as a control.
        required: yes
      layers:
      - name: logFC
        type: double
        description: Log fold change of the differential expression test
        required: yes
      - name: AveExpr
        type: double
        description: Average expression of the differential expression test
        required: no
      - name: t
        type: double
        description: T-statistic of the differential expression test
        required: no
      - name: P.Value
        type: double
        description: P-value of the differential expression test
        required: yes
      - name: adj.P.Value
        type: double
        description: Adjusted P-value of the differential expression test
        required: yes
      - name: B
        type: double
        description: B-statistic of the differential expression test
        required: no
      - name: is_de
        type: boolean
        description: Whether the gene is differentially expressed
        required: yes
      - name: is_de_adj
        type: boolean
        description: Whether the gene is differentially expressed after adjustment
        required: yes
      - name: sign_log10_pval
        type: double
        description: |
          Differential expression value (`-log10(p-value) * sign(LFC)`) for each gene.
          Here, LFC is the estimated log-fold change in expression between the treatment
          and control condition after shrinkage as calculated by Limma. Positive LFC means
          the gene goes up in the treatment condition relative to the control.
        required: yes
      - name: clipped_sign_log10_pval
        type: double
        description: |
          A clipped version of the sign_log10_pval layer. Values are clipped to be between
          -4 and 4 (i.e. `-log10(0.0001)` and `-log10(0.0001)`).
        required: yes
      uns:
      - type: string
        name: dataset_id
        description: A unique identifier for the dataset. This is different from the
          `obs.dataset_id` field, which is the identifier for the dataset from which
          the cell data is derived.
        required: yes
      - name: dataset_name
        type: string
        description: A human-readable name for the dataset.
        required: yes
      - type: string
        name: dataset_url
        description: Link to the original source of the dataset.
        required: no
      - name: dataset_reference
        type: string
        description: Bibtex reference of the paper in which the dataset was published.
        required: no
        multiple: yes
      - name: dataset_summary
        type: string
        description: Short description of the dataset.
        required: yes
      - name: dataset_description
        type: string
        description: Long description of the dataset.
        required: yes
      - name: dataset_organism
        type: string
        description: The organism of the sample in the dataset.
        required: no
        multiple: yes
      - name: single_cell_obs
        type: dataframe
        description: |
          A dataframe with the cell-level metadata for the training set.
        required: yes
  name: --de_train_h5ad
  __merge__: file_de_train.yaml
  required: no
  direction: input
- type: file
  example: resources/datasets/neurips-2023-data/id_map.csv
  info:
    label: ID Map
    summary: File indicates the order of de_test, the cell types and the small molecule
      names.
    file_type: csv
    columns:
    - name: id
      type: integer
      description: Index of the test observation
      required: yes
    - name: cell_type
      type: string
      description: Cell type name
      required: yes
    - name: sm_name
      type: string
      description: Small molecule name
      required: yes
  name: --id_map
  __merge__: file_id_map.yaml
  required: yes
  direction: input
- name: --layer
  type: string
  direction: input
  default: clipped_sign_log10_pval
  description: Which layer to use for prediction.
- type: file
  example: resources/datasets/neurips-2023-data/prediction.h5ad
  info:
    label: Prediction
    summary: Differential Gene Expression prediction
    file_type: h5ad
    slots:
      layers:
      - name: prediction
        type: double
        description: Predicted differential gene expression
        required: yes
      uns:
      - type: string
        name: dataset_id
        description: A unique identifier for the dataset. This is different from the
          `obs.dataset_id` field, which is the identifier for the dataset from which
          the cell data is derived.
        required: yes
      - type: string
        name: method_id
        description: A unique identifier for the method used to generate the prediction.
        required: yes
  name: --output
  __merge__: file_prediction.yaml
  required: yes
  direction: output
- type: file
  example: resources/datasets/neurips-2023-data/model/
  info:
    label: Model
    summary: Optional model output. If no value is passed, the model will be removed
      at the end of the run.
    file_type: directory
  name: --output_model
  __merge__: file_model.yaml
  direction: output
  required: no
  must_exist: no
__merge__: wf_method.yaml
test_resources:
- type: python_script
  path: /common/component_tests/run_and_check_output.py
- path: /resources/datasets/neurips-2023-data
  dest: resources/datasets/neurips-2023-data
```

</details>

### Strip margin

``` r
cat(openproblems::strip_margin("
  |this_is:
  |  a_yaml: 'test'
  |"))
```


    this_is:
      a_yaml: 'test'
