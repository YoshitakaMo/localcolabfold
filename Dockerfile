FROM nvidia/cuda:12.0.1-devel-ubuntu22.04

COPY ./install_colabbatch_linux.sh /

RUN apt update \
&& apt -y install gcc curl git wget gnutls-bin \
&& git config --global http.sslVerify false \
&& git config --global http.postBuffer 1048576000 \
&& bash /install_colabbatch_linux.sh

ENV PATH="/localcolabfold/conda/bin:/localcolabfold/conda/condabin:/localcolabfold/bin:$PATH"
RUN echo "source activate /localcolabfold/colabfold-conda" > ~/.bashrc

CMD /bin/bash