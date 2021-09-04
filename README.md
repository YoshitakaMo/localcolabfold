# LocalColabFold

[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb) on your local PC (or macOS)

## Installation

### For Linux

1. Make sure `curl` and `wget` commands are already installed on your PC. If not present, you need install them at first. For Ubuntu, type `sudo apt -y install curl wget`.
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
1. Install `wget` command using Homebrew:<pre>$ brew install wget</pre>
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

## Advantages of LocalColabFold
- **Structure inference and relaxation will be accelerated if your PC has Nvidia GPU and CUDA drivers.**
- **No Time out (90 minutes and 12 hours), No GPU limitations**.
- **You don't need prepare the large database required for native AlphaFold2**.

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
- Is this available on Windows 10?
  - You can run LocalColabFold on your Windows 10 with [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Tutorials & Presentations
- ColabFold Tutorial presented at the Boston Protein Design and Modeling Club. [[video]](https://www.youtube.com/watch?v=Rfw7thgGTwI) [[slides]](https://docs.google.com/presentation/d/1mnffk23ev2QMDzGZ5w1skXEadTe54l8-Uei6ACce8eI).

## Acknowledgments
- The original colabfold was created by Sergey Ovchinnikov ([@sokrypton](https://twitter.com/sokrypton)), Milot Mirdita ([@milot_mirdita](https://twitter.com/milot_mirdita)) and Martin Steinegger ([@thesteinegger](https://twitter.com/thesteinegger)).

## How do I reference this work?

- Mirdita M, Ovchinnikov S and Steinegger M. ColabFold - Making protein folding accessible to all. *bioRxiv*, doi: [10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425) (2021)<br>*I, Yoshitaka Moriwaki, am credited in the acknowlegment of the paper.*
- John Jumper, Richard Evans, Alexander Pritzel, et al. -  Highly accurate protein structure prediction with AlphaFold. *Nature*, 1–11, doi: [10.1038/s41586-021-03819-2](https://www.nature.com/articles/s41586-021-03819-2) (2021)



[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)