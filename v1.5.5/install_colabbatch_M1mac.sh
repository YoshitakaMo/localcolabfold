#!/bin/bash -e

# check commands
type wget 2>/dev/null || { echo "Please install wget using Homebrew:\n\tbrew install wget" ; exit 1 ; }
type hhsearch 2>/dev/null || { echo -e "Please install hh-suite using Homebrew:\n\tbrew install brewsci/bio/hh-suite" ; exit 1 ; }
type kalign 2>/dev/null || { echo -e "Please install kalign using Homebrew:\n\tbrew install kalign" ; exit 1 ; }
type mmseqs 2>/dev/null || { echo -e "Please install mmseqs2 using Homebrew:\n\tbrew install mmseqs2" ; exit 1 ; }

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

# Maybe required for Apple Silicon (M1 mac) when installing mambaforge
ulimit -n 99999

CURRENTPATH="$(pwd)"
COLABFOLDDIR="${CURRENTPATH}/localcolabfold"

mkdir -p "${COLABFOLDDIR}"
cd "${COLABFOLDDIR}"
wget -q -P . https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh
bash ./Miniforge3-MacOSX-arm64.sh -b -p "${COLABFOLDDIR}/conda"
rm Miniforge3-MacOSX-arm64.sh

source "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda update -n base conda -y
conda create -p "$COLABFOLDDIR/colabfold-conda" -c conda-forge \
    git python=3.10 openmm==8.0.0 pdbfixer==1.9 -y
conda activate "$COLABFOLDDIR/colabfold-conda"

# install colabfold
"$COLABFOLDDIR/colabfold-conda/bin/pip" install --no-warn-conflicts \
    "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
"$COLABFOLDDIR/colabfold-conda/bin/pip" install jax==0.4.23 jaxlib==0.4.23
"$COLABFOLDDIR/colabfold-conda/bin/pip" install "colabfold[alphafold]"
"$COLABFOLDDIR/colabfold-conda/bin/pip" install silence_tensorflow

# Download the updater
wget -qnc -O "$COLABFOLDDIR/update_M1mac.sh" \
    https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_M1mac.sh
chmod +x "$COLABFOLDDIR/update_M1mac.sh"

# Download weights
"$COLABFOLDDIR/colabfold-conda/bin/python3" -m colabfold.download
echo "Download of alphafold2 weights finished."
echo "-----------------------------------------"
echo "Installation of ColabFold finished."
echo "Add ${COLABFOLDDIR}/colabfold-conda/bin to your environment variable PATH to run 'colabfold_batch'."
echo -e "i.e. for Bash:\n\texport PATH=\"${COLABFOLDDIR}/colabfold-conda/bin:\$PATH\""
echo "For more details, please run 'colabfold_batch --help'."
