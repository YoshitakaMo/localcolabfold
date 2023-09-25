#!/bin/bash

# check commands
type wget || { echo "wget command is not installed. Please install it at first using Homebrew." ; exit 1 ; }
type gsed || { echo "gnu-sed command is not installed. Please install it at first using Homebrew." ; exit 1 ; }
type hhsearch || { echo "hhsearch command is not installed. Please install it at first using Homebrew." ; exit 1 ; }
type kalign || { echo "kalign command is not installed. Please install it at first using Homebrew." ; exit 1 ; }

# check whether Apple Silicon (M1 mac) or Intel Mac
arch_name="$(uname -m)"

if [ "${arch_name}" = "x86_64" ]; then
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Running on Rosetta 2"
    else
        echo "Running on native Intel"
    fi
    echo "This installer is only for Apple Silicon. Use install_colabfold_intelmac.sh to install on this Mac."
    exit 1
elif [ "${arch_name}" = "arm64" ]; then
    echo "Running on Apple Silicon (M1 mac)"
else
    echo "Unknown architecture: ${arch_name}"
    exit 1
fi

CURRENTPATH=`pwd`
COLABFOLDDIR="${CURRENTPATH}/localcolabfold"

wget -q -P . https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-MacOSX-arm64.sh
bash ./Mambaforge-MacOSX-arm64.sh -b -p ${COLABFOLDDIR}/conda
rm Mambaforge-MacOSX-arm64.sh
conda create -p $COLABFOLDDIR/colabfold-conda python=3.10 -y
conda activate $COLABFOLDDIR/colabfold-conda
conda update -n base conda -y

conda install -y -c conda-forge python=3.10 openmm==8.0.0 pdbfixer==1.9 jupyter matplotlib py3Dmol tqdm biopython==1.79 immutabledict==2.0.0
conda install -y -c apple tensorflow-deps
# Download the updater
wget -qnc https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_M1mac.sh --no-check-certificate
chmod +x update_M1mac.sh
# install ColabFold and Jaxlib
colabfold-conda/bin/python3.10 -m pip install tensorflow-macos
colabfold-conda/bin/python3.10 -m pip install git+https://github.com/deepmind/tree.git
colabfold-conda/bin/python3.10 -m pip install git+https://github.com/google/ml_collections.git
colabfold-conda/bin/python3.10 -m pip install dm-haiku appdirs pandas absl-py docker
colabfold-conda/bin/python3.10 -m pip install alphafold-colabfold --no-deps --no-color
colabfold-conda/bin/python3.10 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" --no-deps --no-color
colabfold-conda/bin/python3.10 -m pip install jaxlib==0.3.25 --no-deps --no-color
colabfold-conda/bin/python3.10 -m pip install jax==0.3.25 chex scipy toolz --no-deps --no-color

# start downloading weights
cd ${COLABFOLDDIR}
colabfold-conda/bin/python3.10 -m colabfold.download
cd ${CURRENTPATH}

echo "Download of alphafold2 weights finished."

echo "-----------------------------------------"
echo "Installation of colabfold_batch finished."
echo "Add ${COLABFOLDDIR}/colabfold-conda/bin to your environment variable PATH to run 'colabfold_batch'."
echo "i.e. For Bash, export PATH=\"${COLABFOLDDIR}/colabfold-conda/bin:\$PATH\""
echo "For more details, please type 'colabfold_batch --help'."
