# LocalColabFold

[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb) on your local PC (or macOS)

## Installation

### For Linux

1. Make sure `curl`, `git`, and `wget` commands are already installed on your PC. If not present, you need install them at first. For Ubuntu, type `sudo apt -y install curl git wget`.
2. Make sure your Cuda compiler driver is **11.1 or later**:<pre>$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2020 NVIDIA Corporation
Built on Mon_Oct_12_20:09:46_PDT_2020
Cuda compilation tools, release 11.1, V11.1.105
Build cuda_11.1.TC455_06.29190527_0
</pre>DO NOT use `nvidia-smi` for checking the version.<br>See [NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) if you haven't installed it.
1. Download `install_colabfold_linux.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_linux.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabfold_linux.sh</pre>About 5 minutes later, `colabfold` directory will be created. Do not move this directory after the installation.
1. Type `cd colabfold` to enter the directory.
1. Modify the variables such as `sequence = 'PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASK'`, `jobname = "test"`, and etc. in `runner.py` for your prediction. For more information, please refer to the original [ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb).
1. To run the prediction, type <pre>$ colabfold-conda/bin/python3.7 runner.py</pre>in the `colabfold` directory. The result files will be created in the `predition_<jobname>_<hash>` in the `colabfold` directory. After the prediction finished, you may move the results from the `colabfold` directory.

### For macOS

**Caution: Due to the lack of Nvidia GPU/CUDA driver, the structure prediction on macOS are 5-10 times slower than on Linux+GPU**. For the test sequence (58 a.a.), it may take 30 minutes. However, it may be useful to play with it before preparing Linux+GPU environment.

You can check whether your Mac is Intel or Apple Silicon by typing `uname -m` on Terminal.

```bash
$ uname -m
x86_64 # Intel
arm64  # Apple Silicon
```

Please use the correct installer for your Mac.

#### For Mac with Intel CPU

1. Install [Homebrew](https://brew.sh/index_ja) if not present:<pre>$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"</pre>
1. Install `wget` command using Homebrew:<pre>$ brew install wget</pre>
1. Download `install_colabfold_intelmac.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_intelmac.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabfold_intelmac.sh</pre>About 5 minutes later, `colabfold` directory will be created. Do not move this directory after the installation.
1. The rest procedure is the same as "For Linux".

#### For Mac with Apple Silicon (M1 chip)

**Note: This installer is experimental because most of the dependent packages are not fully tested on Apple Silicon Mac.**

1. Install [Homebrew](https://brew.sh/index_ja) if not present:<pre>$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"</pre>
1. Install `wget` and `cmake` commands using Homebrew:<pre>$ brew install wget cmake</pre>
1. Install `miniforge` command using Homebrew:<pre>$ brew install --cask miniforge</pre>
1. Download `install_colabfold_M1mac.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_M1mac.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabfold_M1mac.sh</pre>About 5 minutes later, `colabfold` directory will be created. Do not move this directory after the installation.
1. Type `cd colabfold` to enter the directory.
1. Modify the variables such as `sequence = 'PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASK'`, `jobname = "test"`, and etc. in `runner.py` for your prediction. For more information, please refer to the original [ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb).
1. To run the prediction, type <pre>$ colabfold-conda/bin/python3.8 runner.py</pre>in the `colabfold` directory. The result files will be created in the `predition_<jobname>_<hash>` in the `colabfold` directory. After the prediction finished, you may move the results from the `colabfold` directory.

A Warning message appeared when you run the prediction:
```
You are using an experimental build of OpenMM v7.5.1.
This is NOT SUITABLE for production!
It has not been properly tested on this platform and we cannot guarantee it provides accurate results.
```

This message is due to Apple Silicon, but I think we can ignore it.

## Usage of `colabfold` shell script (Linux)

An executable `colabfold` shell script is installed in `/path/to/colabfold/bin` directory. This is more helpful for installation on a shared computer and users who want to predict many sequences.

1. Prepare a FASTA file containing the amino acid sequence for which you want to predict the structure (e.g. `6x9z.fasta`).<pre>>6X9Z_1|Chain A|Transmembrane beta-barrels|synthetic construct (32630)
MEQKPGTLMVYVVVGYNTDNTVDVVGGAQYAVSPYLFLDVGYGWNNSSLNFLEVGGGVSYKVSPDLEPYVKAGFEYNTDNTIKPTAGAGALYRVSPNLALMVEYGWNNSSLQKVAIGIAYKVKD</pre>
2. Type `export PATH="/path/to/colabfold/bin:$PATH"` to add a path to the PATH environment variable. For example, `export PATH="/home/foo/bar/colabfold/bin:$PATH"` if you installed localcolabfold on `/home/foo/bar/colabfold`.
3. Run colabfold command with your FASTA file. For example,<pre>$ colabfold --input 6x9z.fasta \\
   --output_dir 6x9z \\
   --max_recycle 18 \\
   --use_ptm \\
   --use_turbo \\
   --num_relax Top5</pre>This will predict a protein structure [6x9z](https://www.rcsb.org/structure/6x9z) with increasing the number of 'recycling' to 18. This may be effective for *de novo* structure prediction. For another example, [PDB: 3KUD](https://www.rcsb.org/structure/3KUD), <pre>$ colabfold --input 3kud_complex.fasta \\
   --output_dir 3kud \\
   --homooligomer 1:1 \\
   --use_ptm \\
   --use_turbo \\
   --max_recycle 3 \\
   --num_relax Top5</pre>where the input sequence `3kud_complex.fasta` is<pre>>3KUD_complex
   MTEYKLVVVGAGGVGKSALTIQLIQNHFVDEYDPTIEDSYRKQVVIDGETCLLDILDTAGQEEYSAMRDQYMRTGEGFLCVFAINNTKSFEDIHQYREQIKRVKDSDDVPMVLVGNKCDLAARTVESRQAQDLARSYGIPYIETSAKTRQGVEDAFYTLVREIRQH:
   PSKTSNTIRVFLPNKQRTVVNVRNGMSLHDCLMKALKVRGLQPECCAVFRLLHEHKGKKARLDWNTDAASLIGEELQVDFL</pre>This will predict a heterooligomer. For more information about the options, type `colabfold --help` or refer to the original [ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb).

## Advantages of LocalColabFold
- **Structure inference and relaxation will be accelerated if your PC has Nvidia GPU and CUDA drivers.**
- **No Time out (90 minutes and 12 hours)**
- **No GPU limitations**
- **NOT necessary to prepare the large database required for native AlphaFold2**.

## FAQ
- What else do I need to do before installation? Do I need sudo privileges?
  - No, except for installation of `curl` and `wget` commands.
- Do I need to prepare the large database such as PDB70, BFD, Uniclust30, MGnify...?
  - **No. it is not necessary.** Generation of MSA is performed by the MMseqs2 web server, just as implemented in ColabFold.
- Are the pLDDT score and PAE figures available?
  - Yes, they will be generated just like the ColabFold.
- Is it possible to predict homooligomers and complexes?
  - Yes, the sequence input is the same as ColabFold. See [ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb).
- Is it possible to create MSA by jackhmmer?
  - **No, it is not currently supported**.
- I want to run the predictions step-by-step like Google Colab.
  - You can use VSCode and Python plugin to do the same. See https://code.visualstudio.com/docs/python/jupyter-support-py.
- I want to use multiple GPUs to perform the prediction.
  - You need to set the environment variables `TF_FORCE_UNIFIED_MEMORY`,`XLA_PYTHON_CLIENT_MEM_FRACTION` before execution. See [this discussion](https://github.com/YoshitakaMo/localcolabfold/issues/7#issuecomment-923027641).
- I want to solve the `ResourceExhausted` error when trying to predict for a sequence with > 1000 residues.
  - See the same discussion as above.
- I got an error message `CUDA_ERROR_ILLEGAL_ADDRESS: an illegal memory access was encountered`.
  - You may not have updated to CUDA 11.1 or later. Please check the version of Cuda compiler with `nvcc --version` command, not `nvidia-smi`.
- Is this available on Windows 10?
  - You can run LocalColabFold on your Windows 10 with [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Tutorials & Presentations

- ColabFold Tutorial presented at the Boston Protein Design and Modeling Club. [[video]](https://www.youtube.com/watch?v=Rfw7thgGTwI) [[slides]](https://docs.google.com/presentation/d/1mnffk23ev2QMDzGZ5w1skXEadTe54l8-Uei6ACce8eI).

## Acknowledgments

- The original colabfold was first created by Sergey Ovchinnikov ([@sokrypton](https://twitter.com/sokrypton)), Milot Mirdita ([@milot_mirdita](https://twitter.com/milot_mirdita)) and Martin Steinegger ([@thesteinegger](https://twitter.com/thesteinegger)).

## How do I reference this work?

- Mirdita M, Schuetze K, Moriwaki Y, Heo L, Ovchinnikov S and Steinegger M. ColabFold - Making protein folding accessible to all. *bioRxiv*, doi: [10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425v2) (2021)
- John Jumper, Richard Evans, Alexander Pritzel, et al. -  Highly accurate protein structure prediction with AlphaFold. *Nature*, 1–11, doi: [10.1038/s41586-021-03819-2](https://www.nature.com/articles/s41586-021-03819-2) (2021)

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)
