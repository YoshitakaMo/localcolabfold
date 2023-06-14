#!/bin/bash

# check commands
type wget || { echo "wget command is not installed. Please install it at first using Homebrew." ; exit 1 ; }
type gsed || { echo "gnu-sed command is not installed. Please install it at first using Homebrew." ; exit 1 ; }

# check whether miniforge is present
test -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" || { echo "Install miniforge by using Homebrew before installation. \n 'brew install --cask miniforge'" ; exit 1 ; }

# check whether Apple Silicon (M1 mac) or Intel Mac
arch_name="$(uname -m)"

if [ "${arch_name}" = "x86_64" ]; then
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Running on Rosetta 2"
    else
        echo "Running on native Intel"
    fi
    echo "This installer is only for Apple Silicon. Use update_intelmac.sh to install on this Mac."
    exit 1
elif [ "${arch_name}" = "arm64" ]; then
    echo "Running on Apple Silicon (M1 mac)"
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
. "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
conda activate $COLABFOLDDIR/colabfold-conda
# reinstall colabfold
python3.10 -m pip uninstall "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" -y --no-color
python3.10 -m pip uninstall alphafold-colabfold -y --no-color
python3.10 -m pip install alphafold-colabfold --no-deps --no-color
python3.10 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold" --no-deps --no-color
popd

