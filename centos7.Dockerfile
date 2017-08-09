FROM centos:7

RUN yum install -y bzip2 && \
    curl -O https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    sh Miniconda2-latest-Linux-x86_64.sh -b -p /opt/conda && \
    export PATH=/opt/conda/bin:$PATH && \
    conda create -y -q --copy -n R_env r-essentials && \
    sed -i s,/opt/conda/envs/R_env,/opt/cloudera/parcels/CONDAR, /opt/conda/envs/R_env/bin/R

CMD ['/bin/bash']