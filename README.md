# docs

## Installation

Install R and Quarto (check the [github action](.github/workflows/quarto_render.yml) to see which version you need).

Install renv:

```bash
R -e 'install.packages(c("renv", "yaml"))'
```

Install R dependencies:

```bash
R -e 'renv::restore()'
```

If restoring the R dependencies consistently fails, we might need to re-initialise the renv lock file:

```bash
rm renv.lock
R -e 'renv::install()'
```

## Build

The documentation is currently being built by the CI and is published in the [`render/main`](https://github.com/openproblems-bio/docs/tree/render/main) branch.

You can also do a local build:

```bash
quarto render
```
