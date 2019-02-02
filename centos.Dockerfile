ARG TARGET_OS=centos7
FROM centos:${TARGET_OS}

ARG R_VERSION=3.5.1
ARG ARROW_VERSION=0.12.0
ARG VERSION=3.4.1.p0.1
ARG OS_VERSION=el7

RUN yum install -y bzip2 && \
    curl -O https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && \
    sh Miniconda2-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm -f Miniconda2-latest-Linux-x86_64.sh

ENV PATH /opt/conda/bin:$PATH
RUN /opt/conda/bin/conda create -y -q --copy -c conda-forge -n R_env \
        r-essentials==${R_VERSION} \
        arrow-cpp==${ARROW_VERSION} \
        r-r.utils==2.7.0 \
        r-git2r==0.24.0
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate R_env && \
    # Install R dependencies
    Rscript -e "install.packages('devtools', repos = 'http://cran.rstudio.com')" && \
    Rscript -e "devtools::install_github('apache/arrow', subdir = 'r', ref = 'apache-arrow-${ARROW_VERSION}')" && \
    conda clean --all -y && \
    conda deactivate && \
    sed -i s,/opt/conda/envs/R_env,/opt/cloudera/parcels/CONDAR/lib/conda-R, /opt/conda/envs/R_env/bin/R

RUN mkdir -p /data/CONDAR-$VERSION/{lib,meta}
WORKDIR /data

RUN mv /opt/conda/envs/R_env /data/CONDAR-$VERSION/lib/conda-R

COPY source/meta/* CONDAR-$VERSION/meta/
RUN sed -i \
    -e "s/el7/${OS_VERSION}/g" \
    -e "s/3.4.1/${VERSION}/g" \
    CONDAR-${VERSION}/meta/parcel.json && \
    tar czf CONDAR-${VERSION}-${OS_VERSION}.parcel CONDAR-${VERSION} --owner=root --group=root && \
    rm -rf CONDAR-${VERSION}

CMD ["/bin/bash"]
