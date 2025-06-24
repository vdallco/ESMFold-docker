#!/bin/bash
source /workspace/anaconda3/etc/profile.d/conda.sh
conda activate esmfold
exec uvicorn app:app --host 0.0.0.0 --port 8080 --log-level debug
