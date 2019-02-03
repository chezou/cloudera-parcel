ARG TARGET_OS=centos7
FROM centos:${TARGET_OS}

ARG R_VERSION=3.5.1
ARG ARROW_VERSION=0.12.0
ARG PARCEL_VERSION=3.4.1.p0.1
ARG OS_VERSION=el7
ARG CONDA_URI=https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
ARG PARCEL_DIR=/opt/cloudera/parcels
ARG PARCEL_NAME=CONDAR


RUN yum install -y bzip2 && \
    mkdir -p $PARCEL_DIR && \
    CONDA_EXECUTABLE=$(basename ${CONDA_URI}) && \
    curl -O ${CONDA_URI} && \
    sh ${CONDA_EXECUTABLE} -b -p $PARCEL_DIR/$PARCEL_NAME-$PARCEL_VERSION && \
    rm -f ${CONDA_EXECUTABLE} && \
    yum clean all

ENV PATH $PARCEL_DIR/$PARCEL_NAME-$PARCEL_VERSION/bin:$PATH
RUN conda create -y -q --copy -c conda-forge -n r \
        r-essentials==${R_VERSION} \
        arrow-cpp==${ARROW_VERSION} \
        r-r.utils==2.7.0 \
        r-git2r==0.24.0
RUN . $PARCEL_DIR/$PARCEL_NAME-$PARCEL_VERSION/etc/profile.d/conda.sh && \
    conda activate r && \
    # Install R dependencies
    Rscript -e "install.packages('devtools', repos = 'http://cran.rstudio.com')" && \
    Rscript -e "devtools::install_github('apache/arrow', subdir = 'r', ref = 'apache-arrow-${ARROW_VERSION}')" && \
    conda clean -i -t -l -s -y && \
    conda deactivate

WORKDIR ${PARCEL_DIR}

RUN mkdir -p ${PARCEL_NAME}-${PARCEL_VERSION}/{lib,meta}
COPY source/meta/* ${PARCEL_NAME}-${PARCEL_VERSION}/meta/
RUN sed -i \
    -e "s/__OS_VERSION__/${OS_VERSION}/g" \
    -e "s/__PARCEL_VERSION__/${PARCEL_VERSION}/g" \
    -e "s/__PARCEL_NAME__/${PARCEL_NAME}/g" \
    ${PARCEL_NAME}-${PARCEL_VERSION}/meta/parcel.json && \
    sed -i \
    -e "s/__OS_VERSION__/${OS_VERSION}/g" \
    -e "s/__PARCEL_VERSION__/${PARCEL_VERSION}/g" \
    -e "s/__PARCEL_NAME__/${PARCEL_NAME}/g" \
    ${PARCEL_NAME}-${PARCEL_VERSION}/meta/R_env.sh && \
    tar czf ${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel ${PARCEL_NAME}-${PARCEL_VERSION} --owner=root --group=root && \
    rm -rf ${PARCEL_NAME}-${PARCEL_VERSION}

CMD ["/bin/bash"]
