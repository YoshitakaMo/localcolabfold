#!/bin/bash -e

type wget 2>/dev/null || { echo "wget is not installed. Please install it using apt or yum." ; exit 1 ; }

CURRENTPATH=`pwd`
COLABFOLDDIR="${CURRENTPATH}/localcolabfold"

mkdir -p "${COLABFOLDDIR}"
cd "${COLABFOLDDIR}"
wget -q -P . https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash ./Mambaforge-Linux-x86_64.sh -b -p "${COLABFOLDDIR}/conda"
rm Mambaforge-Linux-x86_64.sh

source "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda update -n base conda -y
conda create -p "$COLABFOLDDIR/colabfold-conda" -c conda-forge -c bioconda \
    git python=3.10 openmm==7.7.0 pdbfixer \
    kalign2=2.04 hhsuite=3.3.0 mmseqs2=15.6f452 -y
conda activate "$COLABFOLDDIR/colabfold-conda"

# install ColabFold and Jaxlib
"$COLABFOLDDIR/colabfold-conda/bin/pip" install --no-warn-conflicts \
    "colabfold[alphafold-without-jax] @ git+https://github.com/sokrypton/ColabFold"
"$COLABFOLDDIR/colabfold-conda/bin/pip" install --upgrade "jax[cuda11_pip]" \
    -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# Download the updater
wget -qnc -O "$COLABFOLDDIR/update_linux.sh" \
    https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_linux.sh
chmod +x "$COLABFOLDDIR/update_linux.sh"

pushd "${COLABFOLDDIR}/colabfold-conda/lib/python3.10/site-packages/colabfold"
# Use 'Agg' for non-GUI backend
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
# modify the default params directory
sed -i -e "s#appdirs.user_cache_dir(__package__ or \"colabfold\")#\"${COLABFOLDDIR}/colabfold\"#g" download.py
# remove cache directory
rm -rf __pycache__
popd

# Download weights
"$COLABFOLDDIR/colabfold-conda/bin/python3" -m colabfold.download
echo "Download of alphafold2 weights finished."
echo "-----------------------------------------"
echo "Installation of ColabFold finished."
echo "Add ${COLABFOLDDIR}/colabfold-conda/bin to your PATH environment variable to run 'colabfold_batch'."
echo -e "i.e. for Bash:\n\texport PATH=\"${COLABFOLDDIR}/colabfold-conda/bin:\$PATH\""
echo "For more details, please run 'colabfold_batch --help'."
