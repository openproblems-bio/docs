#!/bin/bash

QUARTO_CHROMIUM_HEADLESS_MODE=new \
  /home/rcannood/.local/share/quarto-1.6.40/bin/quarto render \
  --profile evaluate_code

rm -r ../website-new/src/routes/documentation
cp -r _docs ../website-new/src/routes/documentation
