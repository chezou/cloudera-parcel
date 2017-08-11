#!/bin/bash
set -e

VERSION=3.4.1.p0.1

./extract_from_docker.sh $VERSION centos7 el7
./extract_from_docker.sh $VERSION centos6 el6

# Create manifest.json
echo "Create manifest.json"
python ./lib/make_manifest.py ./target

echo "Update index.html"
python ./lib/create_index.py ./target