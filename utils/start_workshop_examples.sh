#!/usr/bin/env bash
set -e

cd /dli/data/workshop-genelab/notebooks
source activate rapids
jupyter lab --ip 0.0.0.0 --allow-root
