# R-PARCEL

This repository is aim to create R parcel.

## Preparation

Prepare R environment using miniconda.

```
$ mkdir -p ./target/CONDAR-3.4.1/lib
$ cp -r ./source/meta ./target/CONDAR-3.4.1/
# (Option) Modify meta/parcel.json if needed
# $ sed -i s/el7/el6/g ./target/CONDAR-3.4.1/meta/parcel.json
$ docker build -t chezou/condar:centos7 -f centos7.Dockerfile .  
# Open another terminal and find your container.
$ docker run -it -t chezou/condar:centos7 /bin/bash
$ docker ps
$ docker cp -L <containerId>:/opt/conda/envs/R_env ./target/CONDAR-3.4.1/lib/conda-R
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
$ java -jar lib/validator.jar <args>
```

At least, you should pass parcel test:

```
$ java -jar lib/validator.jar -f target/CONDAR-3.4.1-el7.parcel
```

### How to create manifest.json

Run following command, then you'll get `./target/manifest.json`.

```
$ python ./lib/make_manifest.py ./target
```

## Put the Parcels into your http server

Upload every `./target/*.parcel` and `./target/manifest.json` to the same directory on http server.

You can put Parcels on S3. It doesn't need to have index.html for directory listing.