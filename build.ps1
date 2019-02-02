$VERSION="3.5.1.p0.0.1"

Write-Output "Create target directory"
New-Item -force -type Directory target

# RHEL/CentOS
./extract_from_docker.ps1 $VERSION centos centos7 el7
./extract_from_docker.ps1 $VERSION centos centos6 el6
# Ubuntu
./extract_from_docker.ps1 $VERSION ubuntu xenial xenial

# Create manifest.json
Write-Output "Create manifest.json"
python ./lib/make_manifest.py ./target

Write-Output "Update index.html"
python ./lib/create_index.py ./target
