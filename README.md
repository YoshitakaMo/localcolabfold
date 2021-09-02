# LocalColabFold

[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb) on your local PC

## Installation

1. Make sure `curl` and `wget` commands are already installed on your PC. If not present, you need install them at first. For Ubuntu, type `sudo apt -y install curl wget`.
2. Download `install_colabfold_linux.sh` from this repository and run it in the directory where you want to install:<pre>$ bash install_colabfold_linux.sh</pre>About 5 minutes later, `colabfold` directory will be created. Do not move this directory after the installation.
3. Type `cd colabfold` to enter the directory.
4. Modify the variables such as `sequence = 'PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASK'`, `jobname = "test"`, and etc. in `runner.py` for your prediction. For more information, please refer to the original [ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb).
5. To run the prediction, type <pre>$ colabfold-conda/bin/python3.7 runner.py</pre>in the `colabfold` directory. The result files will be created in the `predition_<jobname>_<hash>` in the `colabfold` directory. After the prediction finished, you may move the results from the `colabfold` directory.

## Advantages of LocalColabFold
- **Structure inference and relaxation will be accelerated if your PC has Nvidia GPU and CUDA drivers.**
- **No Time out (90 minutes and 12 hours), No GPU limits**.

## FAQ
- What else do I need to do before installation? Do I need sudo privileges?
  - No, except for installation of `curl` and `wget` commands.
- Do I need to prepare the large database such as PDB70, BFD, Uniclust30, MGnify...?
  - **No. it is not necessary.** Generation of MSA is performed by the MMseqs2 web server, just as implemented in ColabFold.
- Are the pLDDT score and PAE figures available?
  - Yes, they will be generated just like the ColabFold.
- Is it possible to predict homooligomeres and complexes?
  - Yes, the sequence input is the same as ColabFold. See [ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb).
- Is it possible to create MSA by jackhmmer?
  - **No, it is not currently supported**.
- I want to run the predictions step-by-step like Google Colab.
  - You can use VSCode and Python plugin to do the same. See https://code.visualstudio.com/docs/python/jupyter-support-py.
- Is this available on Windows 10 or macOS?
  - You can run LocalColabFold on your Windows 10 with [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10). Also this may work on macOS. The installer is under development.

## Tutorials & Presentations
- ColabFold Tutorial presented at the Boston Protein Design and Modeling Club. [[video]](https://www.youtube.com/watch?v=Rfw7thgGTwI) [[slides]](https://docs.google.com/presentation/d/1mnffk23ev2QMDzGZ5w1skXEadTe54l8-Uei6ACce8eI).

## Acknowledgments
- The original colabfold was created by Sergey Ovchinnikov (@sokrypton), Milot Mirdita (@milot_mirdita) and Martin Steinegger (@thesteinegger).

## How do I reference this work?

Mirdita M, Ovchinnikov S and Steinegger M. ColabFold - Making protein folding accessible to all.
<br />
*bioRxiv*, doi: [10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425) (2021)

I, Yoshitaka Moriwaki, am credited in the acknowlegment of the paper.

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)