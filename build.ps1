$VERSION="3.5.1.p0.0.1"

Write-Output "Create target directory"
New-Item -force -type Directory target

# RHEL/CentOS
./extract_from_docker.ps1 -VERSION $VERSION -DISTRIBUTION centos -TARGET_OS centos7 -OS_VERSION el7
./extract_from_docker.ps1 -VERSION $VERSION -DISTRIBUTION centos -TARGET_OS centos6 -OS_VERSION el6
# Ubuntu
./extract_from_docker.ps1 -VERSION $VERSION -DISTRIBUTION ubuntu -TARGET_OS xenial -OS_VERSION xenial

# Create manifest.json
Write-Output "Create manifest.json"
python ./lib/make_manifest.py ./target

Write-Output "Update index.html"
python ./lib/create_index.py ./target
