# LocalColabFold

個人用パソコンのCPUとGPUで動かす[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)。

## インストール方法

1. ターミナル上で`curl`と`wget`コマンドがすでにインストールされていることを確認します。存在しない場合は先にこれらをインストールしてください。Ubuntuの場合はtype `sudo apt -y install curl wget`でインストールできます。
2. このリポジトリにある`install_colabfold_linux.sh`をダウンロードし、これをインストールしたいディレクトリの上に置いた後、以下のコマンドを入力します:<pre>$ bash install_colabfold_linux.sh</pre>およそ5分後に`colabfold`ディレクトリができます。インストール後はこのディレクトリを移動させないでください。
3. `cd colabfold`を入力してこのディレクトリに入ります。
4. `runner.py`ファイル中の`sequence = 'PIAQIHILEGRSDEQKETLIREVSEAISRSLDAPLTSVRVIITEMAKGHFGIGGELASK'`や`jobname = "test"`などのパラメータを変更し、構造予測のために必要な情報を入力します。詳細な設定方法についてはオリジナルの[ColabFold / AlphaFold2_advanced](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/beta/AlphaFold2_advanced.ipynb)を参考にしてください。こちらで可能な設定はほとんど利用可能です（MSA_methods以外）。
5. 予測を行うには、`colabfold`ディレクトリ内で以下のコマンドをターミナルで入力してください：<pre>$ colabfold-conda/bin/python3.7 runner.py</pre>予測結果のファイルは`predition_<jobname>_<hash>`という形式で`colabfold`内に作成されます。予測が終了した後は、結果ファイルを`colabfold`ディレクトリの外に移動させたり結果ファイルのディレクトリの名前を変えてもOKです。

## LocalColabFoldを利用するメリット
- **お使いのパソコンにNvidia GPUとCUDAドライバがあれば、AlphaFold2による構造推論(Structure inference)と構造最適化(relax)が高速になります。**
- **Google Colabは90分アイドルにしていたり、12時間以上の利用でタイムアウトしますが、その制限がありません。また、GPUの使用についても当然制限がありません。**
- **データベースをダウンロードしてくる必要がないです**。

## FAQ
- インストールの事前準備は？
  - `curl`, `wget`コマンド以外は不要です
- データベースを用意する必要はありますか？
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
- Windows 10やmacOSの上でも利用することはできますか？
  - [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)を入れればWindows 10の上でも同様に動作させることができます。また原理的にはmacOSでも動かせそうなので、macOS用のインストーラーを現在作成中です。

## Tutorials & Presentations
- ColabFold Tutorial presented at the Boston Protein Design and Modeling Club. [[video]](https://www.youtube.com/watch?v=Rfw7thgGTwI) [[slides]](https://docs.google.com/presentation/d/1mnffk23ev2QMDzGZ5w1skXEadTe54l8-Uei6ACce8eI).

## Acknowledgments
- オリジナルのcolabfoldはSergey Ovchinnikov (@sokrypton), Milot Mirdita (@milot_mirdita) と Martin Steinegger (@thesteinegger)博士らによって作成されました。

## How do I reference this work?

Mirdita M, Ovchinnikov S and Steinegger M. ColabFold - Making protein folding accessible to all.
<br />
*bioRxiv*, doi: [10.1101/2021.08.15.456425](https://www.biorxiv.org/content/10.1101/2021.08.15.456425) (2021)

私の名前がこの論文中に掲載されています。

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.5123296.svg)](https://doi.org/10.5281/zenodo.5123296)
