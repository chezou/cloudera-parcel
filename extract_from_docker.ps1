Param(
    [String]$VERSION = "3.4.1.p0.1",
    [String]$DISTRIBUTION = "centos",
    [String]$TARGET_OS = "centos7",
    [String]$OS_VERSION = "el7",
    [String]$R_VERSION = "3.5.1",
    [String]$ARROW_VERSION = "0.12.0"
)

$TIME= [int][double]::Parse((Get-Date -UFormat "%s"))
$CONTAINER="parcel-build-${TIME}"

Write-Output "Create parcel: CONDAR-${VERSION}-${OS_VERSION}.parcel"

docker build --no-cache --build-arg VERSION="${VERSION}" --build-arg OS_VERSION="${OS_VERSION}" --build-arg TARGET_OS="${TARGET_OS}" --build-arg R_VERSION="${R_VERSION}" --build-arg ARROW_VERSION="${ARROW_VERSION}" -t chezou/condar:"${TARGET_OS}" -f "${DISTRIBUTION}.Dockerfile" .
docker run -d --name "${CONTAINER}" -t chezou/condar:"${TARGET_OS}" /bin/bash
docker cp -L "${CONTAINER}:/data/CONDAR-${VERSION}-${OS_VERSION}.parcel" ./target/
docker kill $CONTAINER
docker rm $CONTAINER

# validation
Write-Output "Validation"
java -jar lib/validator.jar -f "target/CONDAR-${VERSION}-${OS_VERSION}.parcel"

Write-Output "Success to create CONDAR-${VERSION}-${OS_VERSION}.parcel"
