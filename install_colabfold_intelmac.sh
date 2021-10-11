#!/bin/sh

# check whether `wget` are installed
type wget || { echo "wget command is not installed. Please install it at first using Homebrew." ; exit 1 ; }

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
    echo "This installer is only for intel Mac. Use install_colabfold_M1mac.sh to install on this Mac."
    exit 1
else
    echo "Unknown architecture: ${arch_name}"
    exit 1
fi

GIT_REPO="https://github.com/deepmind/alphafold"
SOURCE_URL="https://storage.googleapis.com/alphafold/alphafold_params_2021-07-14.tar"
CURRENTPATH=`pwd`
COLABFOLDDIR="${CURRENTPATH}/colabfold"
PARAMS_DIR="${COLABFOLDDIR}/alphafold/data/params"
MSATOOLS="${COLABFOLDDIR}/tools"

# download the original alphafold as "${COLABFOLDDIR}"
echo "downloading the original alphafold as ${COLABFOLDDIR}..."
rm -rf ${COLABFOLDDIR}
git clone ${GIT_REPO} ${COLABFOLDDIR}
(cd ${COLABFOLDDIR}; git checkout 1d43aaff941c84dc56311076b58795797e49107b --quiet)

# colabfold patches
echo "Applying several patches to be Alphafold2_advanced..."
cd ${COLABFOLDDIR}
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/colabfold.py
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/colabfold_alphafold.py
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/pairmsa.py
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/protein.patch
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/config.patch
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/model.patch
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/modules.patch
# GPU relaxation patch
# wget -qnc https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/gpurelaxation.patch -O gpurelaxation.patch

# donwload reformat.pl from hh-suite
wget -qnc https://raw.githubusercontent.com/soedinglab/hh-suite/master/scripts/reformat.pl
# Apply multi-chain patch from Lim Heo @huhlim
patch -u alphafold/common/protein.py -i protein.patch
patch -u alphafold/model/model.py -i model.patch
patch -u alphafold/model/modules.py -i modules.patch
patch -u alphafold/model/config.py -i config.patch
cd ..

# Downloading parameter files
echo "Downloading AlphaFold2 trained parameters..."
mkdir -p ${PARAMS_DIR}
curl -fL ${SOURCE_URL} | tar x -C ${PARAMS_DIR}

# Downloading stereo_chemical_props.txt from https://git.scicore.unibas.ch/schwede/openstructure
echo "Downloading stereo_chemical_props.txt..."
wget -q https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt
mkdir -p ${COLABFOLDDIR}/alphafold/common
mv stereo_chemical_props.txt ${COLABFOLDDIR}/alphafold/common

# Install Miniconda3 for Linux
echo "Installing Miniconda3 for macOS..."
cd ${COLABFOLDDIR}
wget -q -P . https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
bash ./Miniconda3-latest-MacOSX-x86_64.sh -b -p ${COLABFOLDDIR}/conda
rm Miniconda3-latest-MacOSX-x86_64.sh
cd ..

echo "Creating conda environments with python3.7 as ${COLABFOLDDIR}/colabfold-conda"
. "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda create -p $COLABFOLDDIR/colabfold-conda python=3.7 -y
conda activate $COLABFOLDDIR/colabfold-conda
conda update -y conda

echo "Installing conda-forge packages"
conda install -c conda-forge python=3.7 openmm==7.5.1 pdbfixer -y
conda install -c bioconda hmmer==3.3.2 hhsuite==3.3.0 -y
echo "Installing alphafold dependencies by pip"
python3.7 -m pip install absl-py==0.13.0 biopython==1.79 chex==0.0.7 dm-haiku==0.0.4 dm-tree==0.1.6 immutabledict==2.0.0 jax==0.2.14 jaxlib==0.1.69 ml-collections==0.1.0 numpy==1.19.5 scipy==1.7.0 tensorflow==2.5.0
python3.7 -m pip install jupyter matplotlib py3Dmol tqdm

# Apply OpenMM patch.
echo "Applying OpenMM patch..."
(cd ${COLABFOLDDIR}/colabfold-conda/lib/python3.7/site-packages/ && patch -p0 < ${COLABFOLDDIR}/docker/openmm.patch)

# Enable GPU-accelerated relaxation.
# echo "Enable GPU-accelerated relaxation..."
# (cd ${COLABFOLDDIR} && patch -u alphafold/relax/amber_minimize.py -i gpurelaxation.patch)

echo "Downloading runner.py"
(cd ${COLABFOLDDIR} && wget -q "https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/runner.py")

echo "Installation of Alphafold2_advanced finished."
