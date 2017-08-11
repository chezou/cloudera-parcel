FROM ubuntu:16.04

RUN apt-get -qq update && \
    apt-get install -qq -y \
    bzip2 \
    curl && \
    curl -O https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    bash Miniconda2-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda2-latest-Linux-x86_64.sh && \
    export PATH=/opt/conda/bin:$PATH && \
    conda create -y -q --copy -n R_env r-essentials && \
    sed -i s,/opt/conda/envs/R_env,/opt/cloudera/parcels/CONDAR/lib/conda-R/lib/R, /opt/conda/envs/R_env/bin/R

CMD ['/bin/bash']