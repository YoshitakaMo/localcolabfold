#!/bin/bash -e

COLABFOLDDIR="$1"

if [ ! -d "$COLABFOLDDIR/colabfold-conda" ]; then
    echo "Error! colabfold-conda directory is not present in $COLABFOLDDIR."
    exit 1
fi

# activate conda in $COLABFOLDDIR/conda
source "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
conda activate "$COLABFOLDDIR/colabfold-conda"

# reinstall colabfold and alphafold-colabfold
"$COLABFOLDDIR/colabfold-conda/bin/pip" install --no-warn-conflicts --upgrade --force-reinstall \
    "colabfold[alphafold-minus-jax] @ git+https://github.com/sokrypton/ColabFold"
"$COLABFOLDDIR/colabfold-conda/bin/pip" install --upgrade "jax[cuda11_pip]" \
    -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
"$COLABFOLDDIR/colabfold-conda/bin/pip" install "colabfold[alphafold]"
"$COLABFOLDDIR/colabfold-conda/bin/pip" install --upgrade tensorflow


# use 'agg' for non-GUI backend
cd "${COLABFOLDDIR}/colabfold-conda/lib/python3.10/site-packages/colabfold"
# Use 'Agg' for non-GUI backend
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
# modify the default params directory
sed -i -e "s#appdirs.user_cache_dir(__package__ or \"colabfold\")#\"${COLABFOLDDIR}/colabfold\"#g" download.py
# remove cache directory
rm -rf __pycache__
