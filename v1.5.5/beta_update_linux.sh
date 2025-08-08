#!/bin/bash

COLABFOLDDIR=$1

if [ ! -d $COLABFOLDDIR/colabfold-conda ]; then
    echo "Error! colabfold-conda directory is not present in $COLABFOLDDIR."
    exit 1
fi

pushd $COLABFOLDDIR || { echo "${COLABFOLDDIR} is not present." ; exit 1 ; }

# get absolute path of COLABFOLDDIR
COLABFOLDDIR=$(cd $(dirname colabfold_batch); pwd)
# activate conda in $COLABFOLDDIR/conda
. ${COLABFOLDDIR}/conda/etc/profile.d/conda.sh
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda activate $COLABFOLDDIR/colabfold-conda
# reinstall colabfold and alphafold-colabfold
python3.8 -m pip uninstall -q "colabfold[alphafold-minus-jax] @ git+https://github.com/sokrypton/ColabFold@beta" -y
python3.8 -m pip uninstall alphafold-colabfold -y
python3.8 -m pip install --no-warn-conflicts "colabfold[alphafold-minus-jax] @ git+https://github.com/sokrypton/ColabFold@beta"

# use 'agg' for non-GUI backend
pushd ${COLABFOLDDIR}/colabfold-conda/lib/python3.9/site-packages/colabfold
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
sed -i -e "s#appdirs.user_cache_dir(__package__ or \"colabfold\")#\"${COLABFOLDDIR}/colabfold\"#g" download.py
popd
popd