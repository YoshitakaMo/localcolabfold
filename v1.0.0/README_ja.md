# LocalColabFold

個人用パソコンのCPUとGPUで動かす[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)。

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
3. このリポジトリにある`install_colabfold_linux.sh`をダウンロードします。<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_linux.sh</pre>これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabfold_linux.sh</pre>およそ5分後に`colabfold`ディレクトリができます。インストール後はこのディレクトリを移動させないでください。
4. `cd colabfold`を入力してこのディレクトリに入ります。
5. `runner.py`ファイル中の`sequence = 'PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASK'`や`jobname = "test"`などのパラメータを変更し、構造予測のために必要な情報を入力します。詳細な設定方法についてはオリジナルの[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)を参考にしてください。こちらで可能な設定はほとんど利用可能です（MSA_methods以外）。
6. 予測を行うには、`colabfold`ディレクトリ内で以下のコマンドをターミナルで入力してください：<pre>$ colabfold-conda/bin/python3.7 runner.py</pre>予測結果のファイルは`predition_<jobname>_<hash>`という形式で`colabfold`内に作成されます。予測が終了した後は、結果ファイルを`colabfold`ディレクトリの外に移動させたり結果ファイルのディレクトリの名前を変えてもOKです。

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
2. Homebrewで`wget`コマンドをインストールします:<pre>$ brew install wget</pre>
3. `install_colabfold_intelmac.sh`をこのリポジトリからダウンロードします:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_intelmac.sh</pre>これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabfold_intelmac.sh</pre>およそ5分後に`colabfold`ディレクトリができます。インストール後はこのディレクトリを移動させないでください。
4. 残りの手順は"Linux+GPUの場合"と同様です.

#### Apple Silicon (M1 chip)のMacの場合

**Note: 依存するPythonパッケージのほとんどがまだApple Silicon Macで十分にテストされていないため、このインストーラーによる動作は試験的なものです。**

1. [Homebrew](https://qiita.com/zaburo/items/29fe23c1ceb6056109fd)をインストールします:<pre>$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"</pre>
1. Homebrweで`wget`と`cmake`コマンドをインストールします:<pre>$ brew install wget cmake</pre>
1. `miniforge`をHomebrewでインストールします:<pre>$ brew install --cask miniforge</pre>
1. インストーラー`install_colabfold_M1mac.sh`をこのリポジトリからダウンロードします:<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_M1mac.sh</pre> これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabfold_M1mac.sh</pre>およそ5分後に`colabfold`ディレクトリができます。途中色々WarningsやErrorが出るかもしれません。インストール後はこのディレクトリを移動させないでください。
1. `cd colabfold`を入力してこのディレクトリに入ります。
1. `runner.py`ファイル中の`sequence = 'PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASK'`や`jobname = "test"`などのパラメータを変更し、構造予測のために必要な情報を入力します。詳細な設定方法についてはオリジナルの[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)を参考にしてください。こちらで可能な設定はほとんど利用可能です（MSA_methods以外）。
1. 予測を行うには、`colabfold`ディレクトリ内で以下のコマンドをターミナルで入力してください：<pre>$ colabfold-conda/bin/python3.8 runner.py</pre>予測結果のファイルは`predition_<jobname>_<hash>`という形式で`colabfold`内に作成されます。予測が終了した後は、結果ファイルを`colabfold`ディレクトリの外に移動させたり結果ファイルのディレクトリの名前を変えてもOKです。

予測を行っているときに以下のようなメッセージが現れます:

```
You are using an experimental build of OpenMM v7.5.1.
This is NOT SUITABLE for production!
It has not been properly tested on this platform and we cannot guarantee it provides accurate results.
```

このメッセージはApple Silicon上で動作させる時のみ現れますが、たぶん無視して大丈夫です。

## `colabfold`コマンドの使い方（Linux向け）

`colabfold`は`runner.py`の代わりにコマンドライン引数を取ることのできる実行可能シェルスクリプトです。こちらは共用計算機上に一度インストールするだけで済み、複数のユーザーがlocalcolabfoldを使ってより多くの配列を予測したい場合に有用です。

1. 予測したいアミノ酸配列が含まれるFASTA形式のファイルを同ディレクトリに用意します。例として`6x9z.fasta`とします。<pre>>6X9Z_1|Chain A|Transmembrane beta-barrels|synthetic construct (32630)
MEQKPGTLMVYVVVGYNTDNTVDVVGGAQYAVSPYLFLDVGYGWNNSSLNFLEVGGGVSYKVSPDLEPYVKAGFEYNTDNTIKPTAGAGALYRVSPNLALMVEYGWNNSSLQKVAIGIAYKVKD</pre>
1. `export PATH="/path/to/colabfold/bin:$PATH"`と打つことで環境変数PATHにこのcolabfoldシェルスクリプトのファイルパスを設定します。例えばLocalColabFoldを`/home/foo/bar/colabfold`にインストールした場合は、`export PATH="/home/foo/bar/colabfold/bin:$PATH"`と入力します。
1. 入力のアミノ酸配列ファイルを`--input`の引数に指定し、`colabfold`コマンドを実行します。例えばこんな感じ<pre>$ colabfold --input 6x9z.fasta \\
   --output_dir 6x9z \\
   --max_recycle 18 \\
   --use_ptm \\
   --use_turbo \\
   --num_relax Top5</pre>上記コマンドは*de novo*タンパク質構造[PDB: 6X9Z](https://www.rcsb.org/structure/6x9z)を予想するときに、'recycling'回数を最大18回まで引き上げています。この回数の引き上げは*de novo*タンパク質構造を予測する時には効果的であることが示されています（通常のタンパク質は3回で十分なことがほとんどです）。<br>他の入力例として, [PDB: 3KUD](https://www.rcsb.org/structure/3KUD)の**複合体予測**を行おうとするときは<pre>$ colabfold --input 3kud_complex.fasta \\
   --output_dir 3kud \\
   --homooligomer 1:1 \\
   --use_ptm \\
   --use_turbo \\
   --max_recycle 3 \\
   --num_relax Top5</pre>ここで入力配列`3kud_complex.fasta`は以下の通りです。<pre>>3KUD_complex
   MTEYKLVVVGAGGVGKSALTIQLIQNHFVDEYDPTIEDSYRKQVVIDGETCLLDILDTAGQEEYSAMRDQYMRTGEGFLCVFAINNTKSFEDIHQYREQIKRVKDSDDVPMVLVGNKCDLAARTVESRQAQDLARSYGIPYIETSAKTRQGVEDAFYTLVREIRQH:
   PSKTSNTIRVFLPNKQRTVVNVRNGMSLHDCLMKALKVRGLQPECCAVFRLLHEHKGKKARLDWNTDAASLIGEELQVDFL
   </pre>`:`記号でアミノ酸配列を隔てることで複合体予測をすることができます。この場合はヘテロ複合体予測になっています。ホモオリゴマー予測を行いたいときなど、他の設定については`colabfold --help`で設定方法を読むか、オリジナルの[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)にある説明を読んでください。

## LocalColabFoldを利用するメリット

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
  - はい、可能です。配列の入力方法はGoogle Colabのやり方と同じです。
- jackhmmerによるMSA作成は可能ですか？
  - **現在のところ対応していません**。
- Google Colabのようにセルごとに実行したい。
  - VSCodeとPythonプラグインを使えば同様のことができます。See https://code.visualstudio.com/docs/python/jupyter-support-py .
- 複数のGPUを利用して計算を行いたい。
  - 実行前に環境変数`TF_FORCE_UNIFIED_MEMORY`,`XLA_PYTHON_CLIENT_MEM_FRACTION`を設定する必要があります。[こちらのissue](https://github.com/YoshitakaMo/localcolabfold/issues/7#issuecomment-923027641)を読んでください。
- 長いアミノ酸を予測しようとしたときに`ResourceExhausted`というエラーが発生するのを解決したい。
  - 上と同じissueを読んでください。
- `CUDA_ERROR_ILLEGAL_ADDRESS: an illegal memory access was encountered`というエラーメッセージが出る
  - CUDA 11.1以降にアップデートされていない可能性があります。`nvcc --version`コマンドでCuda compilerのバージョンを確認してみてください。
- Windows 10の上でも利用することはできますか？
  - [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)を入れればWindows 10の上でも同様に動作させることができます。

## Tutorials & Presentations

- ColabFold Tutorial presented at the Boston Protein Design and Modeling Club. [[video]](https://www.youtube.com/watch?v=Rfw7thgGTwI) [[slides]](https://docs.google.com/presentation/d/1mnffk23ev2QMDzGZ5w1skXEadTe54l8-Uei6ACce8eI).

## Acknowledgments

- The original colabfold was first created by Sergey Ovchinnikov ([@sokrypton](https://twitter.com/sokrypton)), Milot Mirdita ([@milot_mirdita](https://twitter.com/milot_mirdita)) and Martin Steinegger ([@thesteinegger](https://twitter.com/thesteinegger)).

## How do I reference this work?

- Mirdita M, Schuetze K, Moriwaki Y, Heo L, Ovchinnikov S and Steinegger M. ColabFold - Making protein folding accessible to all. *bioRxiv*, doi: [10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425v2) (2021)
- John Jumper, Richard Evans, Alexander Pritzel, et al. -  Highly accurate protein structure prediction with AlphaFold. *Nature*, 1–11, doi: [10.1038/s41586-021-03819-2](https://www.nature.com/articles/s41586-021-03819-2) (2021)


[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)
