Param(
    [String]$PARCEL_VERSION = "3.4.1.p0.1",
    [String]$DISTRIBUTION = "centos",
    [String]$TARGET_OS = "centos7",
    [String]$OS_VERSION = "el7",
    [String]$R_VERSION = "3.5.1",
    [String]$ARROW_VERSION = "0.12.0",
    [String]$CONDA_URI = "https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh",
    [String]$PARCEL_NAME= "CONDAR",
    [String]$PARCEL_DIR = "/opt/cloudera/parcels"
)

$TIME= [int][double]::Parse((Get-Date -UFormat "%s"))
$CONTAINER="parcel-build-${TIME}"

$IMAGE_NAME=${PARCEL_NAME}.ToLower()

Write-Output "Create parcel: ${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel"

docker build --no-cache --build-arg PARCEL_NAME="${PARCEL_NAME}" --build-arg PARCEL_VERSION="${PARCEL_VERSION}" `
        --build-arg PARCEL_DIR="${PARCEL_DIR}" --build-arg CONDA_URI="${CONDA_URI}" `
        --build-arg OS_VERSION="${OS_VERSION}" --build-arg TARGET_OS="${TARGET_OS}" `
        --build-arg R_VERSION="${R_VERSION}" --build-arg ARROW_VERSION="${ARROW_VERSION}" `
        -t "${IMAGE_NAME}:${TARGET_OS}" -f "${DISTRIBUTION}.Dockerfile" .
docker run -d --name "${CONTAINER}" -t "${IMAGE_NAME}:${TARGET_OS}" /bin/bash
docker cp -L "${CONTAINER}:${PARCEL_DIR}/${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel" ./target/
docker kill $CONTAINER
docker rm $CONTAINER

# validation
Write-Output "Validation"
java -jar lib/validator.jar -f "target/${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel"

Write-Output "Success to create ${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel"
