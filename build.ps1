$VERSION="3.4.1.p0.1.2"

echo "Create target directory"
New-Item -force -type Directory target

# RHEL/CentOS
./extract_from_docker.ps1 $VERSION centos centos7 el7
./extract_from_docker.ps1 $VERSION centos centos6 el6
# Ubuntu
./extract_from_docker.ps1 $VERSION ubuntu trusty trusty
./extract_from_docker.ps1 $VERSION ubuntu xenial xenial
# Debian
./extract_from_docker.ps1 $VERSION debian jessie jessie
./extract_from_docker.ps1 $VERSION debian wheezy wheezy

# Create manifest.json
echo "Create manifest.json"
python ./lib/make_manifest.py ./target

echo "Update index.html"
python ./lib/create_index.py ./target
