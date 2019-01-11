#!/usr/bin/env bash
set -e

cd /dli/data/workshop-genelab/notebooks
source activate $MAPD_ML
jupyter notebook --ip 0.0.0.0 --allow-root
