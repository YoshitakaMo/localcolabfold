# LocalColabFold

[ColabFold](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/AlphaFold2.ipynb) on your local PC (or macOS). See also [ColabFold repository](https://github.com/sokrypton/ColabFold).

## What is LocalColabFold?

LocalColabFold is an installer script designed to make ColabFold functionality available on users' local machines. It supports wide range of operating systems, such as Windows 10 or later (using Windows Subsystem for Linux 2), macOS, and Linux.

**If you only want to predict a small number of naturally occuring proteins, I recommend using [ColabFold notebook](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/AlphaFold2.ipynb) or download the structures from [AlphaFold Protein Structure Database](https://alphafold.ebi.ac.uk/) or [UniProt](https://www.uniprot.org/). Localcolabfold is suitable for more advanced applications such as batch processing of structure predictions for non-natural proteins and complexes, or predictions with manually specified MSAs / templates.**

## Advantages of LocalColabFold

- **Structure inference and relaxation will be accelerated if your PC has Nvidia GPU and CUDA drivers.**
- **No Time out (90 minutes and 12 hours)**
- **No GPU limitations**
- **NOT necessary to prepare the large database required for native AlphaFold2**.

## Note (Feb 5, 2023)

ColabFold now upgrade to 1.5.0 (compatible with AlphaFold 2.3.1). I recommend to install Localcolabfold freshly.
See also Change log: https://github.com/sokrypton/ColabFold/wiki/v1.5.0

## New Updates

- 30APr2023, Updated to use python 3.10 for compatibility with Google Colaboratory.
- 09Mar2023, version 1.5.1 released. The base directory has been changed to `localcolabfold` from `colabfold_batch` to distinguish it from the execution command.
- 09Mar2023, version 1.5.0 released. See [Release v1.5.0](https://github.com/YoshitakaMo/localcolabfold/releases/tag/v1.5.0)
- 05Feb2023, version 1.5.0-pre released.
- 16Jun2022, version 1.4.0 released. See [Release v1.4.0](https://github.com/YoshitakaMo/localcolabfold/releases/tag/v1.4.0)
- 07May2022, **Updated `update_linux.sh`.** See also [How to update](#how-to-update). Please use a new option `--use-gpu-relax` if GPU relaxation is required (recommended).
- 12Apr2022, version 1.3.0 released. See [Release v1.3.0](https://github.com/YoshitakaMo/localcolabfold/releases/tag/v1.3.0)
- 09Dec2021, version 1.2.0-beta released. easy-to-use updater scripts added. See [How to update](#how-to-update).
- 04Dec2021, LocalColabFold is now compatible with the latest [pip installable ColabFold](https://github.com/sokrypton/ColabFold#running-locally). In this repository, I will provide a script to install ColabFold with some external parameter files to perform relaxation with AMBER. The weight parameters of AlphaFold and AlphaFold-Multimer will be downloaded automatically at your first run.

## Installation

### For Linux

1. Make sure `curl`, `git`, and `wget` commands are already installed on your PC. If not present, you need install them at first. For Ubuntu, type `sudo apt -y install curl git wget`.
2. Make sure your Cuda compiler driver is **11.1 or later** (If you don't have a GPU or don't plan to use a GPU, you can skip this section) :<pre>$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2020 NVIDIA Corporation
Built on Mon_Oct_12_20:09:46_PDT_2020
Cuda compilation tools, release 11.1, V11.1.105
Build cuda_11.1.TC455_06.29190527_0
</pre>DO NOT use `nvidia-smi` to check the version.<br>See [NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) if you haven't installed it.
3. Make sure your GNU compiler version is **4.9 or later** because `GLIBCXX_3.4.20` is required:<pre>$ gcc --version
gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
</pre>If the version is 4.8.5 or older (e.g. CentOS 7), install a new one and add `PATH` to it.
4. Download `install_colabbatch_linux.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_linux.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabbatch_linux.sh</pre>About 5 minutes later, `colabfold_batch` directory will be created. Do not move this directory after the installation.

    Keep the network unblocked. And **check the log** output to see if there are any errors.

    If you find errors in the output log, the easiest way is to check the network and delete the colabfold_batch directory, then re-run the installation script.

5. Add environment variable PATH:<pre># For bash or zsh<br># e.g. export PATH="/home/moriwaki/Desktop/localcolabfold/colabfold-conda/bin:\$PATH"<br>export PATH="/path/to/your/localcolabfold/colabfold-conda/bin:\$PATH"</pre>
It is recommended to add this export command to `~/.bashrc` and restart bash (`~/.bashrc` will be executed every time bash is started)

6. To run the prediction, type <pre>colabfold_batch input outputdir/</pre>The result files will be created in the `outputdir`. This command will execute the prediction without templates and relaxation (energy minimization). If you want to use templates and relaxation, add `--templates` and `--amber` flags, respectively. For example,

    <pre>colabfold_batch --templates --amber input outputdir/</pre>

    To run the AlphaFold2-multimer with the versioned AF2-multimer weights, add `--model-type alphafold2_multimer_v3` in the arguments. e.g. <pre>colabfold_batch --templates --amber --model-type alphafold2_multimer_v3 input outputdir/</pre>`alphafold2_multimer_v1, alphafold2_multimer_v2` are also available. Default is `auto` (use `alphafold2_ptm` for monomers and `alphafold2_multimer_v3` for complexes.)

For more details, see [Flags](#flags) and `colabfold_batch --help`.

#### For WSL2 (in windows)

Before running the prediction:

```
export TF_FORCE_UNIFIED_MEMORY="1"
export XLA_PYTHON_CLIENT_MEM_FRACTION="4.0"
export XLA_PYTHON_CLIENT_ALLOCATOR="platform"
export TF_FORCE_GPU_ALLOW_GROWTH="true"
```

It is recommended to add these export commands to `~/.bashrc` and restart bash (`~/.bashrc` will be executed every time bash is started)

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
2. Install several commands using Homebrew (Now kalign 3.3.2 is available!):<pre>$ brew install wget cmake gnu-sed<br>$ brew install brewsci/bio/hh-suite<br>$ brew install brewsci/bio/kalign</pre>
3. Install `miniforge` command using Homebrew:<pre>$ brew install --cask miniforge</pre>
4. Download `install_colabbatch_M1mac.sh` from this repository:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_M1mac.sh</pre> and run it in the directory where you want to install:<pre>$ bash install_colabbatch_M1mac.sh</pre>About 5 minutes later, `colabfold_batch` directory will be created. Do not move this directory after the installation. **You can ignore the installation errors that appear along the way**.
5. The rest procedure is the same as "For Linux".

A Warning message appeared when you run the prediction:
```
You are using an experimental build of OpenMM v7.5.1.
This is NOT SUITABLE for production!
It has not been properly tested on this platform and we cannot guarantee it provides accurate results.
```

This message is due to Apple Silicon, but I think we can ignore it.

### Input Examples

ColabFold can accept multiple file formats or directory.

```
positional arguments:
  input                 Can be one of the following: Directory with fasta/a3m
                        files, a csv/tsv file, a fasta file or an a3m file
  results               Directory to write the results to
```

#### fasta format

It is recommended that the header line starting with `>` be short since the description will be the prefix of the output file. It is acceptable to insert line breaks in the amino acid sequence.

```:P61823.fasta
>sp|P61823
MALKSLVLLSLLVLVLLLVRVQPSLGKETAAAKFERQHMDSSTSAASSSNYCNQMMKSRN
LTKDRCKPVNTFVHESLADVQAVCSQKNVACKNGQTNCYQSYSTMSITDCRETGSSKYPN
CAYKTTQANKHIIVACEGNPYVPVHFDASV
```

**For prediction of multimers, insert `:` between the protein sequences.**

```
>1BJP_homohexamer
PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASKVRR:
PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASKVRR:
PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASKVRR:
PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASKVRR:
PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASKVRR:
PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASKVRR
```

```
>3KUD_RasRaf_complex
MTEYKLVVVGAGGVGKSALTIQLIQNHFVDEYDPTIEDSYRKQVVIDGETCLLDILDTAGQEEYSAMRDQ
YMRTGEGFLCVFAINNTKSFEDIHQYREQIKRVKDSDDVPMVLVGNKCDLAARTVESRQAQDLARSYGIP
YIETSAKTRQGVEDAFYTLVREIRQH:
PSKTSNTIRVFLPNKQRTVVNVRNGMSLHDCLMKALKVRGLQPECCAVFRLLHEHKGKKARLDWNTDAAS
LIGEELQVDFL
```

Multiple `>` header lines with sequences in a FASTA format file yield multiple predictions at once in the specified output directory.

#### csv format

In a csv format, `id` and `sequence` should be separated by `,`.

```:test.csv
id,sequence
5AWL_1,YYDPETGTWY
3G5O_A_3G5O_B,MRILPISTIKGKLNEFVDAVSSTQDQITITKNGAPAAVLVGADEWESLQETLYWLAQPGIRESIAEADADIASGRTYGEDEIRAEFGVPRRPH:MPYTVRFTTTARRDLHKLPPRILAAVVEFAFGDLSREPLRVGKPLRRELAGTFSARRGTYRLLYRIDDEHTTVVILRVDHRADIYRR
```

#### a3m format

You can input your a3m format MSA file. For multimer predictions, the a3m file should be compatible with colabfold format.

### Flags

These flags are useful for the predictions.

- **`--amber`** : Use amber for structure refinement (relaxation / energy minimization). To control number of top ranked structures are relaxed set `--num-relax`.
- **`--templates`** : Use templates from pdb.
- **`--use-gpu-relax`** : Run amber on NVidia GPU instead of CPU. This feature is only available on a machine with Nvidia GPUs.
- **`--num-recycle <int>`** : Number of prediction recycles. Increasing recycles can improve the quality but slows down the prediction. Default is `3`. (e.g. `--num-recycle 10`)
- `--custom-template-path <directory>` : Restrict template files used for `--template` to only those contained in the specified directory. This flag enables us to use non-public pdb files for the prediction. See also https://github.com/sokrypton/ColabFold/issues/177 .
- `--random-seed <int>` **Changing the seed for the random number generator can result in different structure predictions.** (e.g. `--random-seed 42`)
- `--num-seeds <int>` Number of seeds to try. Will iterate from range(random_seed, random_seed+num_seeds). (e.g. `--num-seed 5`)
- `--max-msa` : Defines: `max-seq:max-extra-seq` number of sequences to use (e.g. `--max-msa 512:1024`). `--max-seq` and `--max-extra-seq` arguments are also available if you want to specify separately. This is a reimplementation of the paper of [Sampling alternative conformational states of transporters and receptors with AlphaFold2](https://elifesciences.org/articles/75751) demonstrated by del Alamo *et al*.
- `--use-dropout` : activate dropouts during inference to sample from uncertainity of the models.
- `--overwrite-existing-results` : Overwrite the result files.
- For more information, `colabfold_batch --help`.

## How to update

Since [ColabFold](https://github.com/sokrypton/ColabFold) is still a work in progress, your localcolabfold should be also updated frequently to use the latest features. An easy-to-use update script is provided for this purpose.

To update your localcolabfold, simply type in the `colabfold_batch` directory:

```bash
# set your OS. Select one of the following variables {linux,intelmac,M1mac}
$ OS=linux # if Linux
# get the latest updater
$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_${OS}.sh -O update_${OS}.sh
$ chmod +x update_${OS}.sh
# execute it.
$ ./update_${OS}.sh .
```

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
  *Nature Methods* (2022) doi: [10.1038/s41592-022-01488-1](https://www.nature.com/articles/s41592-022-01488-1)
- If you’re using **AlphaFold**, please also cite: <br />
  Jumper et al. "Highly accurate protein structure prediction with AlphaFold." <br />
  *Nature* (2021) doi: [10.1038/s41586-021-03819-2](https://doi.org/10.1038/s41586-021-03819-2)
- If you’re using **AlphaFold-multimer**, please also cite: <br />
  Evans et al. "Protein complex prediction with AlphaFold-Multimer." <br />
  *BioRxiv* (2022) doi: [10.1101/2021.10.04.463034v2](https://www.biorxiv.org/content/10.1101/2021.10.04.463034v2)
