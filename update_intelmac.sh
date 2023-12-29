#!/bin/bash -e

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

COLABFOLDDIR="$1"
if [ ! -d "$COLABFOLDDIR/colabfold-conda" ]; then
    echo "Error! colabfold-conda directory is not present in $COLABFOLDDIR."
    exit 1
fi

# activate conda in $COLABFOLDDIR/conda
source "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
conda activate "$COLABFOLDDIR/colabfold-conda"

# reinstall colabfold
"$COLABFOLDDIR/colabfold-conda/bin/pip" install --no-warn-conflicts --upgrade --force-reinstall \
    "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
