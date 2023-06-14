#!/bin/bash

# check commands
type wget || { echo "wget command is not installed. Please install it at first using Homebrew." ; exit 1 ; }
type gsed || { echo "gnu-sed command is not installed. Please install it at first using Homebrew." ; exit 1 ; }

# check whether Apple Silicon (M1 mac) or Intel Mac
arch_name="$(uname -m)"

if [ "${arch_name}" = "x86_64" ]; then
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Running on Rosetta 2"
    else
        echo "Running on native Intel"
    fi
elif [ "${arch_name}" = "arm64" ]; then
    echo "Running on Apple Silicon (M1 mac)"
    echo "This installer is only for intel Mac."
    exit 1
else
    echo "Unknown architecture: ${arch_name}"
    exit 1
fi

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
# reinstall colabfold
python3.10 -m pip uninstall "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" -y
python3.10 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
# repatch batch.py
pushd ${COLABFOLDDIR}/colabfold-conda/lib/python3.10/site-packages/colabfold
popd
popd

