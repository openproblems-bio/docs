#!/bin/bash

set -e

QUARTO_CHROMIUM_HEADLESS_MODE=new \
  quarto render \
  --profile evaluate_code

rm -r ../website-new/src/routes/documentation
cp -r _docs ../website-new/src/routes/documentation


# note: see https://github.com/quarto-dev/quarto-cli/tree/v1.6.40/src/resources/filters/customnodes