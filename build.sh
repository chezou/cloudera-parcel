#!/bin/bash
set -e

VERSION="3.4.1.p0.1"
TARGET_OS="centos7"
OS_VERSION="el7"

mkdir -p ./target/CONDAR-${VERSION}/lib
cp -r ./source/meta ./target/CONDAR-${VERSION}/
# sed -i s/el7/${OS_VERSION}/g ./target/CONDAR-${VERSION}/meta/parcel.json
docker build -t chezou/condar:${TARGET_OS} -f ${TARGET_OS}.Dockerfile .
docker run -d --name parcel_build -t chezou/condar:${TARGET_OS} /bin/bash
docker cp -L parcel_build:/opt/conda/envs/R_env ./target/CONDAR-${VERSION}/lib/conda-R
DOCKER_PID=$(docker ps -a -q --filter="name=parcel_build")
docker stop $DOCKER_PID

pushd target
tar cvzf CONDAR-${VERSION}-${OS_VERSION}.parcel CONDAR-${VERSION} --owner=root --group=root
popd 

# validation
echo "Validation"
java -jar lib/validator.jar -f target/CONDAR-${VERSION}-${OS_VERSION}.parcel

rm -rf ./target/CONDAR-${VERSION}

# Create manifest.json
echo "Create manifest.json"
python ./lib/make_manifest.py ./target

echo "Update index.html"
python ./lib/create_index.py ./target