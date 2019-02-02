#!/bin/bash
set -e

VERSION=3.5.1.p0.0.1

echo "Create target directory"
mkdir -p ./target

# RHEL/CentOS
./extract_from_docker.sh $VERSION centos centos7 el7
./extract_from_docker.sh $VERSION centos centos6 el6
# Ubuntu
./extract_from_docker.sh $VERSION ubuntu xenial xenial

# Create manifest.json
echo "Create manifest.json"
python ./lib/make_manifest.py ./target

echo "Update index.html"
python ./lib/create_index.py ./target
