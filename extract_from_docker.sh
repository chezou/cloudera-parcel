#!/bin/bash

set -e

VERSION=${1:-3.4.1.p0.1}
TARGET_OS=${2:-centos7}
OS_VERSION=${3:-el7}
TIME=$(date +%s)
CONTAINER=parcel-build-$TIME

echo "Create parcel: CONDAR-${VERSION}-${OS_VERSION}.parcel"

docker build --no-cache --build-arg VERSION=${VERSION} --build-arg OS_VERSION=${OS_VERSION} -t chezou/condar:${TARGET_OS} -f ${TARGET_OS}.Dockerfile .
docker run -d --name ${CONTAINER} -t chezou/condar:${TARGET_OS} /bin/bash
docker cp -L ${CONTAINER}:/data/CONDAR-${VERSION}-${OS_VERSION}.parcel ./target/
docker kill $CONTAINER
docker rm $CONTAINER

# validation
echo "Validation"
java -jar lib/validator.jar -f target/CONDAR-${VERSION}-${OS_VERSION}.parcel

echo "Success to create CONDAR-${VERSION}-${OS_VERSION}.parcel"
