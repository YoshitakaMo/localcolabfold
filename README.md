# LocalColabFold

[ColabFold](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/AlphaFold2.ipynb) on your local PC (or macOS). See also [ColabFold repository](https://github.com/sokrypton/ColabFold).

## New Updates

- 09Dec2021, version 1.2.0-beta released. easy-to-use updater scripts added. See [How to update](#how-to-update).
- 04Dec2021, LocalColabFold is now compatible with the latest [pip installable ColabFold](https://github.com/sokrypton/ColabFold#running-locally). In this repository, I will provide a script to install ColabFold with some external parameter files to perform relaxation with AMBER. The weight parameters of AlphaFold and AlphaFold-Multimer will be downloaded automatically at your first run.

## Installation

### For Linux

1. Make sure `curl`, `git`, and `wget` commands are already installed on your PC. If not present, you need install them at first. For Ubuntu, type `sudo apt -y install curl git wget`.
2. Make sure your Cuda compiler driver is **11.1 or later**:<pre>$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2020 NVIDIA Corporation
Built on Mon_Oct_12_20:09:46_PDT_2020
Cuda compilation tools, release 11.1, V11.1.105
Build cuda_11.1.TC455_06.29190527_0
</pre>DO NOT use `nvidia-smi` to check the version.<br>See [NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) if you haven't installed it.
1. Make sure your GNU compiler version is **4.9 or later** because `GLIBCXX_3.4.20` is required:<pre>$ gcc --version
gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
</pre>If the version is 4.8.5 or older (e.g. CentOS 7), install a new one and add `PATH` to it.
1. Download `install_colabbatch_linux.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_linux.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabbatch_linux.sh</pre>About 5 minutes later, `colabfold_batch` directory will be created. Do not move this directory after the installation.
2. Add environment variable PATH:<pre># For bash or zsh<br># e.g. export PATH="/home/moriwaki/Desktop/colabfold_batch/bin:\$PATH"<br>export PATH="<COLABFOLDBATCH_DIR>/bin:\$PATH"</pre>
3. To run the prediction, type <pre>colabfold_batch --amber --templates --num-recycle 3 inputfile outputdir/ </pre>The result files will be created in the `outputdir`. For more details, see `colabfold_batch --help`.

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
2. Install `wget`, `gnu-sed`, [HH-suite](https://github.com/soedinglab/hh-suite) and [kalign](https://github.com/TimoLassmann/kalign) using Homebrew:<pre>$ brew install wget gnu-sed<br>\$ brew install brewsci/bio/hh-suite brewsci/bio/kalign</pre>
3. Download `install_colabbatch_intelmac.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_intelmac.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabbatch_intelmac.sh</pre>About 5 minutes later, `colabfold_batch` directory will be created. Do not move this directory after the installation.
4. The rest procedure is the same as "For Linux".

#### For Mac with Apple Silicon (M1 chip)

**Note: This installer is experimental because most of the dependent packages are not fully tested on Apple Silicon Mac.**

1. Install [Homebrew](https://brew.sh/index_ja) if not present:<pre>$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"</pre>
1. Install several commands using Homebrew (currently kalign can't be installed, but no effects):<pre>$ brew install wget cmake gnu-sed<br>$ brew install brewsci/bio/hh-suite</pre>
1. Install `miniforge` command using Homebrew:<pre>$ brew install --cask miniforge</pre>
1. Download `install_colabbatch_M1mac.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_M1mac.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabbatch_M1mac.sh</pre>About 5 minutes later, `colabfold_batch` directory will be created. Do not move this directory after the installation. **You can ignore the installation errors that appear along the way**.
2. The rest procedure is the same as "For Linux".

A Warning message appeared when you run the prediction:
```
You are using an experimental build of OpenMM v7.5.1.
This is NOT SUITABLE for production!
It has not been properly tested on this platform and we cannot guarantee it provides accurate results.
```

This message is due to Apple Silicon, but I think we can ignore it.

## How to update

Because [ColabFold](https://github.com/sokrypton/ColabFold) is still a work in progress, the localcolabfold should be also updated frequently to use the latest features. I will provide an easy-to-use update script.

To update your localcolabfold, simply type in the `colabfold_batch` directory:

```bash
$ ./update_linux.sh . # if Linux
$ ./update_intelmac.sh . # if Intel Mac
$ ./update_M1mac.sh . # if M1 Mac
```

Or, if you have already installed localcolabfold before, please download the updater from this repository and execute it.

```bash
# set your OS. Select one of the following variables {linux,intelmac,M1mac}
$ OS=linux # if Linux
$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_${OS}.sh
$ chmod +x update_${OS}.sh
$ ./update_${OS}.sh /path/to/your/colabfold_batch
```

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
  - Yes, the format of input sequence is the same as ColabFold. See `query_sequence:` and its use of [ColabFold: AlphaFold2 using MMseqs2](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/AlphaFold2.ipynb).
- Is it possible to create MSA by jackhmmer?
  - **No, it is not currently supported**.
- I want to use multiple GPUs to perform the prediction.
  - **AlphaFold and ColabFold does not support multiple GPUs**. Only One GPU can model your protein.
- I got an error message `CUDA_ERROR_ILLEGAL_ADDRESS: an illegal memory access was encountered`.
  - You may not have updated to CUDA 11.1 or later. Please check the version of Cuda compiler with `nvcc --version` command, not `nvidia-smi`.
- Is this available on Windows 10?
  - You can run LocalColabFold on your Windows 10 with [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
- (New!)I want to use a custom MSA file in the format of a3m.
  - **ColabFold can accept various input files now**. See the help messsage. You can set your own A3M file, a fasta file that contains multiple sequences (in FASTA format), or a directory that contains multiple fasta files.


## Tutorials & Presentations

- ColabFold Tutorial presented at the Boston Protein Design and Modeling Club. [[video]](https://www.youtube.com/watch?v=Rfw7thgGTwI) [[slides]](https://docs.google.com/presentation/d/1mnffk23ev2QMDzGZ5w1skXEadTe54l8-Uei6ACce8eI).

## Acknowledgments

- The original colabfold was first created by Sergey Ovchinnikov ([@sokrypton](https://twitter.com/sokrypton)), Milot Mirdita ([@milot_mirdita](https://twitter.com/milot_mirdita)) and Martin Steinegger ([@thesteinegger](https://twitter.com/thesteinegger)).

## How do I reference this work?

- Mirdita M, Schütze K, Moriwaki Y, Heo L, Ovchinnikov S and Steinegger M. ColabFold - Making protein folding accessible to all. <br />
  bioRxiv (2021) doi: [10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425v2)
- If you’re using **AlphaFold**, please also cite: <br />
  Jumper et al. "Highly accurate protein structure prediction with AlphaFold." <br />
  Nature (2021) doi: [10.1038/s41586-021-03819-2](https://doi.org/10.1038/s41586-021-03819-2)
- If you’re using **AlphaFold-multimer**, please also cite: <br />
  Evans et al. "Protein complex prediction with AlphaFold-Multimer." <br />
  biorxiv (2021) doi: [10.1101/2021.10.04.463034v1](https://www.biorxiv.org/content/10.1101/2021.10.04.463034v1)
- If you are using **RoseTTAFold**, please also cite: <br />
  Minkyung et al. "Accurate prediction of protein structures and interactions using a three-track neural network." <br />
  Science (2021) doi: [10.1126/science.abj8754](https://doi.org/10.1126/science.abj8754)

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)
