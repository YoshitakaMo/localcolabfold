FROM nvidia/cuda:11.8.0-base-ubuntu22.04
ADD . /localcolabfold/
RUN apt-get update && apt-get install -y curl git wget 
RUN rm -rf /localcolabfold/localcolabfold/
WORKDIR /localcolabfold/
RUN /localcolabfold/install_colabbatch_linux.sh
ENV PATH="/localcolabfold/localcolabfold/colabfold-conda/bin/:${PATH}"
