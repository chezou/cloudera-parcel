# R-PARCEL

This repository is aim to create R parcel.

## Preparation

Prepare R environment using miniconda.

```
$ mkdir -p ./target/CONDAR-3.4.1/lib
$ cp -r ./source/meta ./target/CONDAR-3.4.1/
$ docker pull continuumio/miniconda
$ docker run continuumio/miniconda /bin/bash -c "conda create -y -q --copy -n R_env r-essentials"
$ docker run -it continuumio/miniconda /bin/bash
# Open another terminal and find your container.
$ docker ps 
$ docker cp <containerId>:/opt/conda/envs/R_env ./target/CONDAR-3.4.1/lib/conda-R
# Terminate docker process
```

## Modify meta data

In current version, you should modify version info in json.

## Tar your Parcel

```
$ cd target
$ tar cvzf  CONDAR-3.4.1-el7.parcel CONDAR-3.4.1 --owner=root --group=root
```

## validate, create metadata.json

I borrowed validator.jar and make_manifest.py from [cm_ext repo](https://github.com/cloudera/cm_ext).

### How to validate json and parcel
See also: [How to use validator.jar](https://github.com/cloudera/cm_ext/wiki/Building-a-parcel#validation)

```
$ java -jar lib/validator.jar <args>`
```

### How to create manifest.json

```
$ python ./lib/make_manifest.py ./target
```
