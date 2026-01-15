#!/bin/bash

type wget || { echo "wget command is not installed. Please install it at first using apt or yum." ; exit 1 ; }
type curl || { echo "curl command is not installed. Please install it at first using apt or yum. " ; exit 1 ; }

CURRENTPATH=`pwd`
COLABFOLDDIR="${CURRENTPATH}/localcolabfold"

mkdir -p ${COLABFOLDDIR}
cd ${COLABFOLDDIR}
wget -q -P . https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash ./Mambaforge-Linux-x86_64.sh -b -p ${COLABFOLDDIR}/conda
rm Mambaforge-Linux-x86_64.sh
. "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda create -p $COLABFOLDDIR/colabfold-conda python=3.9 -y
conda activate $COLABFOLDDIR/colabfold-conda
conda update -n base conda -y
conda install -c conda-forge python=3.9 cudnn==8.2.1.32 cudatoolkit==11.1.1 openmm==7.5.1 pdbfixer -y
# Download the updater
wget -qnc https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_linux.sh --no-check-certificate
chmod +x update_linux.sh
# install alignment tools
conda install -c conda-forge -c bioconda kalign2=2.04 hhsuite=3.3.0 mmseqs2=14.7e284 -y
# install ColabFold and Jaxlib
# colabfold-conda/bin/python3.9 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
colabfold-conda/bin/python3.9 -m pip install -q --no-warn-conflicts "colabfold[alphafold-minus-jax] @ git+https://github.com/sokrypton/ColabFold@beta"
colabfold-conda/bin/python3.9 -m pip install https://storage.googleapis.com/jax-releases/cuda11/jaxlib-0.3.25+cuda11.cudnn82-cp39-cp39-manylinux2014_x86_64.whl
colabfold-conda/bin/python3.9 -m pip install jax==0.3.25 biopython==1.79

# Use 'Agg' for non-GUI backend
cd ${COLABFOLDDIR}/colabfold-conda/lib/python3.9/site-packages/colabfold
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py
# modify the default params directory
sed -i -e "s#appdirs.user_cache_dir(__package__ or \"colabfold\")#\"${COLABFOLDDIR}/colabfold\"#g" download.py

# start downloading weights
cd ${COLABFOLDDIR}
colabfold-conda/bin/python3.9 -m colabfold.download
cd ${CURRENTPATH}

echo "Download of alphafold2 weights finished."
echo "-----------------------------------------"
echo "Installation of colabfold_batch finished."
echo "Add ${COLABFOLDDIR}/colabfold-conda/bin to your environment variable PATH to run 'colabfold_batch'."
echo "i.e. For Bash, export PATH=\"${COLABFOLDDIR}/colabfold-conda/bin:\$PATH\""
echo "For more details, please type 'colabfold_batch --help'."