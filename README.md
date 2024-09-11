# vce-cross-build-notes
Notes on cross building for VCE


## For Mac arm64

The `containers_dist.sh` script will:

- build am arm64 docker container on Mac arm64;
- pull an amd64 image built for OU OCL hosted VCE;
- create a joint amd64/arm64 manifest and push to DockerHub

```bash
#USAGE:
chmod +x containers_dist.sh
OCBC_VERSION=24j.0b5 OCBC_MODULE=tm351 OCBC_PRESENTATION=24j ./containers_dist.sh
```
