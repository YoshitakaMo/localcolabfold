#!/bin/sh

# check whether `wget` and `curl` are installed
type wget || { echo "wget command is not installed. Please install it at first using apt or yum." ; exit 1 ; }
type curl || { echo "curl command is not installed. Please install it at first using apt or yum. " ; exit 1 ; }

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
(cd ${COLABFOLDDIR}; git checkout 1e216f93f06aa04aa699562f504db1d02c3b704c --quiet)

# colabfold patches
echo "Applying several patches to be Alphafold2_advanced..."
cd ${COLABFOLDDIR}
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/colabfold.py
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/pairmsa.py
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/protein.patch
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/config.patch
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/model.patch
wget -qnc https://raw.githubusercontent.com/sokrypton/ColabFold/main/beta/modules.patch
# GPU relaxation patch
wget -qnc https://gist.githubusercontent.com/YoshitakaMo/f844b5ccecd1f4717ea145ed10a25b88/raw/13c4966ee88576f4718c8ae52f085c9316d5b679/gpurelaxation.patch

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

# echo "installing HH-suite 3.3.0..."
# mkdir -p ${MSATOOLS}
# git clone --branch v3.3.0 https://github.com/soedinglab/hh-suite.git hh-suite-3.3.0
# (cd hh-suite-3.3.0 ; mkdir build ; cd build ; cmake -DCMAKE_INSTALL_PREFIX=${MSATOOLS}/hh-suite .. ; make -j4 ; make install)
# rm -rf hh-suite-3.3.0

# echo "installing HMMER 3.3.2..."
# wget http://eddylab.org/software/hmmer/hmmer-3.3.2.tar.gz
# (tar xzvf hmmer-3.3.2.tar.gz ; cd hmmer-3.3.2 ; ./configure --prefix=${MSATOOLS}/hmmer ; make -j4 ; make install)
# rm -rf hmmer-3.3.2.tar.gz hmmer-3.3.2

# Install Miniconda3 for Linux
echo "Installing Miniconda3 for Linux..."
cd ${COLABFOLDDIR}
wget -q -P . https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p ${COLABFOLDDIR}/conda
rm Miniconda3-latest-Linux-x86_64.sh
cd ..

echo "Creating conda environments with python3.7 as ${COLABFOLDDIR}/colabfold-conda"
. "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda create -p $COLABFOLDDIR/colabfold-conda python=3.7 -y
conda activate $COLABFOLDDIR/colabfold-conda
conda update -y conda

echo "Installing conda-forge packages"
conda install -c conda-forge python=3.7 cudnn==8.2.1.32 cudatoolkit==11.1.1 openmm==7.5.1 pdbfixer -y
echo "Installing alphafold dependencies by pip"
python3.7 -m pip install absl-py==0.13.0 biopython==1.79 chex==0.0.7 dm-haiku==0.0.4 dm-tree==0.1.6 immutabledict==2.0.0 jax==0.2.14 ml-collections==0.1.0 numpy==1.19.5 scipy==1.7.0 tensorflow-gpu==2.5.0
python3.7 -m pip install jupyter matplotlib py3Dmol tqdm
python3.7 -m pip install --upgrade jax jaxlib==0.1.69+cuda111 -f https://storage.googleapis.com/jax-releases/jax_releases.html

# Downloading stereo_chemical_props.txt from https://git.scicore.unibas.ch/schwede/openstructure
echo "Downloading stereo_chemical_props.txt..."
wget -q https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt
mkdir -p ${COLABFOLDDIR}/alphafold/common
mv stereo_chemical_props.txt ${COLABFOLDDIR}/alphafold/common

# Apply OpenMM patch.
echo "Applying OpenMM patch..."
(cd ${COLABFOLDDIR}/conda/lib/python3.7/site-packages/ && patch -p0 < ${COLABFOLDDIR}/docker/openmm.patch)

# Enable GPU-accelerated relaxation.
echo "Enable GPU-accelerated relaxation..."
(cd ${COLABFOLDDIR} && patch -u alphafold/relax/amber_minimize.py -i gpurelaxation.patch)

echo "Downloading runner.py"
(cd ${COLABFOLDDIR} && wget -q "https://gist.githubusercontent.com/YoshitakaMo/015d14b61788e0cdc945a8765a6dcd30/raw/6e80d81370cf423e8b619b7b1b700163d3c026bd/runner.py")

echo "Installation of Alphafold2_advanced finished."
