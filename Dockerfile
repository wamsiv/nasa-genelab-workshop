FROM nvidia/cuda:9.2-devel-ubuntu16.04
MAINTAINER "Wamsi Viswanath [https://www.linkedin.com/in/wamsiv]"

USER root

# Common DLI installs/config
# Install nginx version with extras
RUN apt-get update && apt-get install -y wget && wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add - && apt-get -y install software-properties-common && add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" && apt-get update && apt-get install -y --no-install-recommends openresty supervisor curl wget git && rm -rf /var/lib/apt/lists/*
#add-apt-repository -y ppa:nginx/stable && apt-get -y update &&  apt-get install -y  --no-install-recommends nginx supervisor curl wget git && rm -rf /var/lib/apt/lists/*

RUN mkdir /dli
WORKDIR /dli

# DIGITS env vars, not used everywhere, but keep them here as common globals anyways
ENV DIGITS_URL_PREFIX=/digits
ENV DIGITS_JOBS_DIR=/dli/data/digits
ENV DIGITS_LOGFILE_FILENAME=$DIGITS_JOBS_DIR/digits.log

# Setup base environment
WORKDIR /opt/conda

RUN wget --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh -O /opt/conda/miniconda3.sh
RUN bash /opt/conda/miniconda3.sh -b -p /opt/conda/Miniconda3
ENV PATH=$PATH:/opt/conda/Miniconda3/bin

# Copy examples and task specific installations
RUN mkdir -p /dli/data/workshop-genelab
COPY . /dli/data/workshop-genelab
WORKDIR /dli/data/workshop-genelab

ENV MAPD_ML=workshop_env

# Install specific dependencies for workshop-genelab
# Create Environment
RUN conda update conda && conda env create -n $MAPD_ML -f /dli/data/workshop-genelab/env/workshop_py36.yml

RUN /bin/bash -c "source activate workshop_env && \
git clone https://github.com/omnisci/pymapd.git && \ 
cd pymapd && \ 
pip install -e . "

EXPOSE 8888

CMD bash ./utils/start_workshop_examples.sh
