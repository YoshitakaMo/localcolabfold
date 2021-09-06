# LocalColabFold

個人用パソコンのCPUとGPUで動かす[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)。

## インストール方法

### Linux+GPUの場合

1. ターミナル上で`curl`と`wget`コマンドがすでにインストールされていることを確認します。存在しない場合は先にこれらをインストールしてください。Ubuntuの場合はtype `sudo apt -y install curl wget`でインストールできます。
2. このリポジトリにある`install_colabfold_linux.sh`をダウンロードします。<pre>$ wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_linux.sh</pre>これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabfold_linux.sh</pre>およそ5分後に`colabfold`ディレクトリができます。インストール後はこのディレクトリを移動させないでください。
3. `cd colabfold`を入力してこのディレクトリに入ります。
4. `runner.py`ファイル中の`sequence = 'PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASK'`や`jobname = "test"`などのパラメータを変更し、構造予測のために必要な情報を入力します。詳細な設定方法についてはオリジナルの[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)を参考にしてください。こちらで可能な設定はほとんど利用可能です（MSA_methods以外）。
5. 予測を行うには、`colabfold`ディレクトリ内で以下のコマンドをターミナルで入力してください：<pre>$ colabfold-conda/bin/python3.7 runner.py</pre>予測結果のファイルは`predition_<jobname>_<hash>`という形式で`colabfold`内に作成されます。予測が終了した後は、結果ファイルを`colabfold`ディレクトリの外に移動させたり結果ファイルのディレクトリの名前を変えてもOKです。

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
2. Homebrweで`wget`コマンドをインストールします:<pre>$ brew install wget</pre>
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
- Windows 10の上でも利用することはできますか？
  - [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)を入れればWindows 10の上でも同様に動作させることができます。

## Tutorials & Presentations
- ColabFold Tutorial presented at the Boston Protein Design and Modeling Club. [[video]](https://www.youtube.com/watch?v=Rfw7thgGTwI) [[slides]](https://docs.google.com/presentation/d/1mnffk23ev2QMDzGZ5w1skXEadTe54l8-Uei6ACce8eI).

## Acknowledgments
- The original colabfold was created by Sergey Ovchinnikov ([@sokrypton](https://twitter.com/sokrypton)), Milot Mirdita ([@milot_mirdita](https://twitter.com/milot_mirdita)) and Martin Steinegger ([@thesteinegger](https://twitter.com/thesteinegger)).

## How do I reference this work?

- Mirdita M, Ovchinnikov S and Steinegger M. ColabFold - Making protein folding accessible to all. *bioRxiv*, doi: [10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425) (2021)<br>*I, Yoshitaka Moriwaki, am credited in the acknowlegment of the paper.*
- John Jumper, Richard Evans, Alexander Pritzel, et al. -  Highly accurate protein structure prediction with AlphaFold. *Nature*, 1–11, doi: [10.1038/s41586-021-03819-2](https://www.nature.com/articles/s41586-021-03819-2) (2021)


[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)
