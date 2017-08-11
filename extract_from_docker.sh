#!/bin/bash

set -e

VERSION=${1:-3.4.1.p0.1}
TARGET_OS=${2:-centos7}
OS_VERSION=${3:-el7}

mkdir -p ./target/CONDAR-${VERSION}/lib
cp -r ./source/meta ./target/CONDAR-${VERSION}/
sed -i s/el7/${OS_VERSION}/g ./target/CONDAR-${VERSION}/meta/parcel.json
sed -i s/3.4.1/${VERSION}/g ./target/CONDAR-${VERSION}/meta/parcel.json
docker build -t chezou/condar:${TARGET_OS} -f ${TARGET_OS}.Dockerfile .
docker run -d --name parcel_build -t chezou/condar:${TARGET_OS} /bin/bash
docker cp -L parcel_build:/opt/conda/envs/R_env ./target/CONDAR-${VERSION}/lib/
mv ./target/CONDAR-${VERSION}/lib/R_env ./target/CONDAR-${VERSION}/lib/conda-R 
DOCKER_PID=$(docker ps -a -q --filter="name=parcel_build")
docker kill $DOCKER_PID
docker rm $DOCKER_PID

pushd target
tar cvzf CONDAR-${VERSION}-${OS_VERSION}.parcel CONDAR-${VERSION} --owner=root --group=root
popd 

# validation
echo "Validation"
java -jar lib/validator.jar -f target/CONDAR-${VERSION}-${OS_VERSION}.parcel

echo "Success to create CONDAR-${VERSION}-${OS_VERSION}.parcel"
echo ""
echo "Clean up"
rm -rf ./target/CONDAR-${VERSION}
