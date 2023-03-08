# LocalColabFold

個人用パソコンまたはmacOSで動かす[ColabFold](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/AlphaFold2.ipynb)。

## アップデート情報

- 2023年2月5日, version 1.5.0-preリリース。
- 2022年6月18日, version 1.4.0 リリース。[Release v1.4.0](https://github.com/YoshitakaMo/localcolabfold/releases/tag/v1.4.0)
- 2021年12月9日, β版。簡単に使えるアップデートスクリプトを追加。[アップデートのやり方](#アップデートのやり方)を参照。
- 2021年12月4日, LocalColabFoldは最新版の[pipでインストール可能なColabFold](https://github.com/sokrypton/ColabFold#running-locally)に対応しました。このリポジトリではrelax（構造最適化）処理を行うために必要な他のパラメータファイルとともにColabFoldをインストールするためのスクリプトを提供しています。AlphaFoldとAlphaFold-Multimerの重みパラメータは初回の実行時に自動的にダウンロードされます。

## インストール方法

### Linux+GPUの場合

1. ターミナル上で`curl`, `git`と`wget`コマンドがすでにインストールされていることを確認します。存在しない場合は先にこれらをインストールしてください。Ubuntuの場合はtype `sudo apt -y install curl git wget`でインストールできます。
2. **Cuda compilerのバージョンが11.1以降であることを確認します。**<pre>$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2020 NVIDIA Corporation
Built on Mon_Oct_12_20:09:46_PDT_2020
Cuda compilation tools, release 11.1, V11.1.105
Build cuda_11.1.TC455_06.29190527_0
</pre>バージョンチェックの時に`nvidia-smi`コマンドを使わないでください。こちらでは不正確です。<br>まだCUDA Compilerをインストールしていない場合は、[NVIDIA CUDA Installation Guide for Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)を参照してください。
3. **GNU compilerのバージョンが4.9以降であることを確認します。** 動作上、`GLIBCXX_3.4.20`が必要になるためです。<pre>$ gcc --version
gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
</pre>もしバージョンが4.8.5以前の場合は(CentOS 7だとよくありがち)、新しいGCCをインストールしてそれにPATHを通してください。スパコンの場合はEnvironment moduleの`module avail`の中にあるかもしれません。
1. このリポジトリにある`install_colabbatch_linux.sh`をダウンロードします。<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_linux.sh</pre>これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabbatch_linux.sh</pre>およそ5分後に`colabfold_batch`ディレクトリができます。インストール後はこのディレクトリを移動させないでください。
2. `cd colabfold_batch`を入力してこのディレクトリに入ります。
3. 環境変数`PATH`を追加します。<pre># For bash or zsh<br># e.g. export PATH="/home/moriwaki/Desktop/colabfold_batch/bin:\$PATH"<br>export PATH="<COLABFOLDBATCH_DIR>/bin:\$PATH"</pre>この1行を`~/.bashrc`または`~/.zshrc`に追記しておくと便利です。
4. 以下のコマンドでColabFoldを実行します。<pre>colabfold_batch --amber --templates --num-recycle 3 inputfile outputdir/ </pre>結果のファイルは`outputdir`に生成されます. 詳細な使い方は`colabfold_batch --help`コマンドで確認してください。

### macOSの場合

**注意: macOSではNvidia GPUとCUDAドライバがないため、構造推論部分がLinux+GPU環境に比べて5〜10倍ほど遅くなります**。テスト用のアミノ酸配列(58アミノ酸)ではおよそ30分ほど計算に時間がかかります。ただ、Linux+GPU環境を準備する前にこれで遊んでみるのはありかもしれません。

また、自身の持っているMacがIntel CPUのものか、M1 chip入りのもの（Apple Silicon）かを先に確認してください。ターミナルで`uname -m`の結果でどちらかが判明します。

```bash
$ uname -m
x86_64 # Intel
arm64  # Apple Silicon
```

（Apple SiliconでRosetta2を使っている場合はApple Siliconでもx86_64って表示されますけれど……今のところこれには対応していません。）

以上の結果を踏まえて適切なインストーラーを選択してください。

#### Intel CPUのMacの場合

1. [Homebrew](https://qiita.com/zaburo/items/29fe23c1ceb6056109fd)をインストールします:<pre>$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"</pre>
2. Homebrewで`wget`, `gnu-sed`, [HH-suite](https://github.com/soedinglab/hh-suite)と[kalign](https://github.com/TimoLassmann/kalign)をインストールします<pre>$ brew install wget gnu-sed<br>\$ brew install brewsci/bio/hh-suite brewsci/bio/kalign</pre>
3. `install_colabbatch_intelmac.sh`をこのリポジトリからダウンロードします:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_intelmac.sh</pre>これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabbatch_intelmac.sh</pre>およそ5分後に`colabfold_batch`ディレクトリができます。インストール後はこのディレクトリを移動させないでください。
4. 残りの手順は"Linux+GPUの場合"と同様です.

#### Apple Silicon (M1 chip)のMacの場合

**Note: 依存するPythonパッケージのほとんどがまだApple Silicon Macで十分にテストされていないため、このインストーラーによる動作は試験的なものです。**

1. [Homebrew](https://qiita.com/zaburo/items/29fe23c1ceb6056109fd)をインストールします:<pre>$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"</pre>
1. いくつかのコマンドをHomebrewでインストールします。(現在kalignはM1 macでインストールすることはできないみたいですが、問題ありません):<pre>$ brew install wget cmake gnu-sed<br>$ brew install brewsci/bio/hh-suite</pre>
2. `miniforge`をHomebrewでインストールします:<pre>$ brew install --cask miniforge</pre>
3. インストーラー`install_colabbatch_M1mac.sh`をこのリポジトリからダウンロードします:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_M1mac.sh</pre> これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabbatch_M1mac.sh</pre>およそ5分後に`colabfold_batch`ディレクトリができます。途中色々WarningsやErrorが出るかもしれませんが大丈夫です。インストール後はこのディレクトリを移動させないでください。
4. 残りの手順は"Linux+GPUの場合"と同様です.

予測を行っているときに以下のようなメッセージが現れます:

```
You are using an experimental build of OpenMM v7.5.1.
This is NOT SUITABLE for production!
It has not been properly tested on this platform and we cannot guarantee it provides accurate results.
```

このメッセージはApple Silicon上で動作させる時のみ現れますが、たぶん無視して大丈夫です。

## アップデートのやり方

[ColabFold](https://github.com/sokrypton/ColabFold)はいまだ開発途中であるため、最新の機能を利用するためにはこのlocalcolabfoldも頻繁にアップデートする必要があります。そこでお手軽にアップデートするためのスクリプトを用意しました。

アップデートは`colabfold_batch`ディレクトリで以下のように入力するだけです。

```bash
$ ./update_linux.sh . # if Linux
$ ./update_intelmac.sh . # if Intel Mac
$ ./update_M1mac.sh . # if M1 Mac
```

また、もしすでに1.2.0-beta以前からlocalcolabfoldをインストールしていた場合は、まずこれらのアップデートスクリプトをダウンロードしてきてから実行してください。例として以下のような感じです。

```bash
# set your OS. Select one of the following variables {linux,intelmac,M1mac}
$ OS=linux # if Linux
$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_${OS}.sh
$ chmod +x update_${OS}.sh
$ ./update_${OS}.sh /path/to/your/colabfold_batch
```

## LocalColabFoldを利用する利点

- **お使いのパソコンにNvidia GPUとCUDAドライバがあれば、AlphaFold2による構造推論(Structure inference)と構造最適化(relax)が高速になります。**
- **Google Colabは90分アイドルにしていたり、12時間以上の利用でタイムアウトしますが、その制限がありません。また、GPUの使用についても当然制限がありません。**
- **データベースをダウンロードしてくる必要がないです**。

## FAQ
- インストールの事前準備は？
  - `curl`, `wget`コマンド以外は不要です
- BFD, Mgnify, PDB70, Uniclust30などの巨大なデータベースを用意する必要はありますか？
  - **必要ないです**。
- AlphaFold2の最初の動作に必要なMSA作成はどのように行っていますか？
  - MSA作成はColabFoldと同様にMMseqs2のウェブサーバーによって行われています。
- ColabFoldで表示されるようなpLDDTスコアやPAEの図も生成されますか？
  - はい、生成されます。
- ホモ多量体予測、複合体予測も可能ですか？
  - はい、可能です。配列の入力方法は[ColabFold: AlphaFold2 using MMseqs2](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/AlphaFold2.ipynb)のやり方と同じです。
- jackhmmerによるMSA作成は可能ですか？
  - **現在のところ対応していません**。
- 複数のGPUを利用して計算を行いたい。
  - **AlphaFold, ColabFoldは複数GPUを利用した構造予測はできないようです**。1つのGPUでしか計算できません。
- 長いアミノ酸を予測しようとしたときに`ResourceExhausted`というエラーが発生するのを解決したい。
  - 上と同じissueを読んでください。
- `CUDA_ERROR_ILLEGAL_ADDRESS: an illegal memory access was encountered`というエラーメッセージが出る
  - CUDA 11.1以降にアップデートされていない可能性があります。`nvcc --version`コマンドでCuda compilerのバージョンを確認してみてください。
- Windows 10の上でも利用することはできますか？
  - [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)を入れればWindows 10の上でも同様に動作させることができます。
- (New!) 自作したA3Mファイルを利用して構造予測を行いたい。
  - **現在ColabFoldはFASTAファイル以外にも様々な入力を受け取ることが可能です**。詳細な使い方はヘルプメッセージを読んでください。手持ちのA3Mフォーマットファイル、FASTAフォーマットで入力された複数のアミノ酸配列を含む1つのfastaファイル、さらにはディレクトリ自体をインプットに指定する事が可能です。

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
  *BioRxiv* (2021) doi: [10.1101/2021.10.04.463034v1](https://www.biorxiv.org/content/10.1101/2021.10.04.463034v1)
- If you are using **RoseTTAFold**, please also cite: <br />
  Minkyung et al. "Accurate prediction of protein structures and interactions using a three-track neural network." <br />
  *Science* (2021) doi: [10.1126/science.abj8754](https://doi.org/10.1126/science.abj8754)

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)