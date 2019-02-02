#!/bin/bash

set -e

VERSION=${1:-3.4.1.p0.1}
DISTRIBUTION=${2:-centos}
TARGET_OS=${3:-centos7}
OS_VERSION=${4:-el7}
R_VERSION="3.5.1"
ARROW_VERSION="0.12.0"
TIME=$(date +%s)
CONTAINER=parcel-build-$TIME

echo "Create parcel: CONDAR-${VERSION}-${OS_VERSION}.parcel"

docker build --no-cache --build-arg VERSION=${VERSION} --build-arg OS_VERSION=${OS_VERSION} --build-arg R_VERSION=${R_VERSION} --build-arg ARROW_VERSION=${ARROW_VERSION} --build-arg TARGET_OS=${TARGET_OS} -t chezou/condar:${TARGET_OS} -f ${DISTRIBUTION}.Dockerfile .
docker run -d --name ${CONTAINER} -t chezou/condar:${TARGET_OS} /bin/bash
docker cp -L ${CONTAINER}:/data/CONDAR-${VERSION}-${OS_VERSION}.parcel ./target/
docker kill $CONTAINER
docker rm $CONTAINER

# validation
echo "Validation"
java -jar lib/validator.jar -f target/CONDAR-${VERSION}-${OS_VERSION}.parcel

echo "Success to create CONDAR-${VERSION}-${OS_VERSION}.parcel"
