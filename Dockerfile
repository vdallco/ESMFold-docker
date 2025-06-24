FROM nvidia/cuda:11.6.2-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/workspace/anaconda3
ENV PATH=${CONDA_DIR}/bin:${PATH}
ENV PORT=8080

RUN apt-get update && apt-get install -y \
    wget \
    nano \
    git \
    libxml2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh && \
    bash Anaconda3-2022.05-Linux-x86_64.sh -b -p ${CONDA_DIR} && \
    rm Anaconda3-2022.05-Linux-x86_64.sh

RUN eval "$(/workspace/anaconda3/bin/conda shell.bash hook)"

COPY conda_environment.yml /workspace/conda_environment.yml
RUN conda env create -f conda_environment.yml

COPY pip_requirements.txt /workspace/pip_requirements.txt

RUN /bin/bash -c "source ${CONDA_DIR}/etc/profile.d/conda.sh && \
    conda activate esmfold && \
    pip install -r pip_requirements.txt"

RUN /bin/bash -c "source ${CONDA_DIR}/etc/profile.d/conda.sh && \
    conda activate esmfold && \
    pip install 'dllogger @ git+https://github.com/NVIDIA/dllogger.git' && \
    pip install 'openfold @ git+https://github.com/aqlaboratory/openfold.git@4b41059694619831a7db195b7e0988fc4ff3a307'"

RUN /bin/bash -c "source ${CONDA_DIR}/etc/profile.d/conda.sh && \
    conda activate esmfold && \
    pip install fastapi uvicorn"

COPY app.py /workspace/app.py

EXPOSE 8080

COPY start.sh /workspace/start.sh
RUN chmod +x /workspace/start.sh
CMD ["/workspace/start.sh"]
