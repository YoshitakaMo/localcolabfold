#!/bin/bash

type wget || { echo "wget command is not installed. Please install it at first using apt or yum." ; exit 1 ; }
type curl || { echo "curl command is not installed. Please install it at first using apt or yum. " ; exit 1 ; }

CURRENTPATH=`pwd`
COLABFOLDDIR="${CURRENTPATH}/colabfold_batch"

mkdir -p ${COLABFOLDDIR}
cd ${COLABFOLDDIR}
wget -q -P . https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p ${COLABFOLDDIR}/conda
rm Miniconda3-latest-Linux-x86_64.sh
. "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
export PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
conda create -p $COLABFOLDDIR/colabfold-conda python=3.7 -y
conda activate $COLABFOLDDIR/colabfold-conda
conda update -n base conda -y
conda install -c conda-forge python=3.7 cudnn==8.2.1.32 cudatoolkit==11.1.1 openmm==7.5.1 pdbfixer -y
# Download the updater
wget -qnc https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_linux.sh --no-check-certificate
chmod +x update_linux.sh
# install alignment tools
conda install -c conda-forge -c bioconda kalign3=3.2.2 hhsuite=3.3.0 -y
# install ColabFold and Jaxlib
colabfold-conda/bin/python3.7 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
colabfold-conda/bin/python3.7 -m pip install https://storage.googleapis.com/jax-releases/cuda11/jaxlib-0.3.10+cuda11.cudnn82-cp37-none-manylinux2014_x86_64.whl
colabfold-conda/bin/python3.7 -m pip install jax==0.3.13
# bin directory to run
mkdir -p $COLABFOLDDIR/bin
cd $COLABFOLDDIR/bin
cat << EOF > colabfold_batch
#!/bin/sh
export TF_FORCE_UNIFIED_MEMORY="1"
export XLA_PYTHON_CLIENT_MEM_FRACTION="4.0"
export COLABFOLDDIR=$COLABFOLDDIR
export XDG_CACHE_HOME="\${COLABFOLDDIR}"
export PATH="\${COLABFOLDDIR}/colabfold-conda/bin:\$PATH"
\$COLABFOLDDIR/colabfold-conda/bin/colabfold_batch \$@
EOF
chmod +x colabfold_batch

# Use 'Agg' for non-GUI backend
cd ${COLABFOLDDIR}/colabfold-conda/lib/python3.7/site-packages/colabfold
sed -i -e "s#from matplotlib import pyplot as plt#import matplotlib\nmatplotlib.use('Agg')\nimport matplotlib.pyplot as plt#g" plot.py

echo "-----------------------------------------"
echo "Installation of colabfold_batch finished."
echo "Note: AlphaFold2 weight parameters will be downloaded at ${COLABFOLDDIR}/colabfold/params directory in the first run."
echo "Add ${COLABFOLDDIR}/bin to your environment variable PATH to run 'colabfold_batch'."
echo "i.e. For Bash, export PATH=\"${COLABFOLDDIR}/bin:\$PATH\""
echo "For more details, please type 'colabfold_batch --help'."