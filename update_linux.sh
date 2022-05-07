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
# repatch batch.py
pushd ${COLABFOLDDIR}/colabfold-conda/lib/python3.7/site-packages/colabfold
sed -i -e "s#props_path = \"stereo_chemical_props.txt\"#props_path = \"${COLABFOLDDIR}/stereo_chemical_props.txt\"#" batch.py
popd
# use 'agg' for non-GUI backend
pushd ${COLABFOLDDIR}/colabfold-conda/lib/python3.7/site-packages/colabfold
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
popd
popd