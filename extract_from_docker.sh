#!/bin/bash

set -e

PARCEL_VERSION=${1:-3.4.1.p0.1}
DISTRIBUTION=${2:-centos}
TARGET_OS=${3:-centos7}
OS_VERSION=${4:-el7}
R_VERSION=${5:-3.5.1}
ARROW_VERSION=${6:-0.12.0}
CONDA_URI=${7:-https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh}
PARCEL_NAME=${8:-CONDAR}
PARCEL_DIR=${9:-/opt/cloudera/parcels}

TIME=$(date +%s)
CONTAINER=parcel-build-$TIME

IMAGE_NAME=$(echo $PARCEL_NAME | tr '[:upper:]' '[:lower:]')

echo "Create parcel: ${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel"

docker build --no-cache  --build-arg PARCEL_NAME=${PARCEL_NAME} --build-arg PARCEL_VERSION=${PARCEL_VERSION} \
            --build-arg PARCEL_DIR=${PARCEL_DIR} --build-arg CONDA_URI=${CONDA_URI} \
            --build-arg R_VERSION=${R_VERSION} --build-arg ARROW_VERSION=${ARROW_VERSION} \
            --build-arg TARGET_OS=${TARGET_OS} --build-arg OS_VERSION=${OS_VERSION} \
            -t ${IMAGE_NAME}:${TARGET_OS} -f ${DISTRIBUTION}.Dockerfile .
echo "Finish docker image. Extract parcel"
docker run -d --name ${CONTAINER} -t ${IMAGE_NAME}:${TARGET_OS} /bin/bash
docker cp -L ${CONTAINER}:${PARCEL_DIR}/${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel ./target/
docker kill $CONTAINER
docker rm $CONTAINER

# validation
echo "Validation"
java -jar lib/validator.jar -f target/${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel

echo "Success to create PARCEL_NAME-${PARCEL_VERSION}-${OS_VERSION}.parcel"
