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
python3.7 -m pip uninstall "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" -y
python3.7 -m pip uninstall alphafold-colabfold -y
python3.7 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"

# fix jax.tree_(un)flatten warnings (ad hoc)
sed -i -e "s/jax.tree_flatten/jax.tree_util.tree_flatten/g" ${COLABFOLDDIR}/colabfold-conda/lib/python3.7/site-packages/alphafold/model/mapping.py
sed -i -e "s/jax.tree_unflatten/jax.tree_util.tree_unflatten/g" ${COLABFOLDDIR}/colabfold-conda/lib/python3.7/site-packages/alphafold/model/mapping.py
# use 'agg' for non-GUI backend
pushd ${COLABFOLDDIR}/colabfold-conda/lib/python3.7/site-packages/colabfold
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
popd
popd