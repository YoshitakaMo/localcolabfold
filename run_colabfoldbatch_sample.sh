#!/bin/bash

INPUTFILE="1BJP_1"
OUTPUTDIR="${INPUTFILE}"
RANDOMSEED=0

export PATH="/path/to/localcolabfold/.pixi/envs/default/bin:${PATH}"

colabfold_batch \
  --num-recycle 3 \
  --amber \
  --templates \
  --use-gpu-relax \
  --num-models 5 \
  --model-order 1,2,3,4,5 \
  --random-seed ${RANDOMSEED} \
  ${INPUTFILE}.fasta \
  ${OUTPUTDIR}
