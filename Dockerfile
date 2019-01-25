FROM nvcr.io/nvidia/rapidsai/rapidsai:cuda9.2_ubuntu16.04
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

# Set startup
ENTRYPOINT ./utils/start_workshop_examples.sh

# Install assessment harness services & Jupyter
RUN apt-get update && apt-get install --upgrade -y --no-install-recommends \
        python3-venv \
        redis-server && \
    python3 -m venv /usr/local/assessment && \
    /usr/local/assessment/bin/pip install --upgrade pip && \
    /usr/local/assessment/bin/pip install celery flask redis jupyter

# Install Jupyter, etc.
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

ENV PYTHONPATH=$PYTHONPATH:/opt/lib/python3.5/site-packages/
RUN python3  -m pip install -U pip==8.0.1 && pip install -U pip
RUN pip install --ignore-installed ipython jupyter

# Copy examples and task specific installations
RUN mkdir -p /dli/data/workshop-genelab
COPY . /dli/data/workshop-genelab
WORKDIR /dli/data/workshop-genelab

# Install specific dependencies for workshop-genelab
RUN /bin/bash -c "source activate rapids && \
conda install -c conda-forge jupyterlab && \
git clone https://github.com/omnisci/pymapd.git && \ 
cd pymapd && \ 
pip install -e . && \
pip install -U graphistry xgboost sklearn altair git+https://github.com/Quansight/jupyterlab-omnisci.git git+https://github.com/Quansight/ibis.git@omnisci-sample"

EXPOSE 8888
