We don't need to actually pull containers; the manifest commands run purely on manifests; we can delete the manifest with a manifest rm command then create and push a new one simply by referring to other tagged images on docker hub.

Nest is trash, one after is better:

```text

docker pull --platform=linux/amd64 ousefulcoursecontainers/ou-tm351:24j.0b7-amd64
docker pull --platform=linux/arm64 ousefulcoursecontainers/ou-tm351:24j.0b7-arm64

docker manifest create ousefulcoursecontainers/ou-tm351:24j \
    --amend ousefulcoursecontainers/ou-tm351:24j.0b7-amd64 \
    --amend ousefulcoursecontainers/ou-tm351:24j.0b7-arm64

docker manifest push ousefulcoursecontainers/ou-tm351:24j

docker manifest create ousefulcoursecontainers/ou-tm351:24j --amend ousefulcoursecontainers/ou-tm351:24j.0b7-amd64
docker manifest create ousefulcoursecontainers/ou-tm351:24j --amend ousefulcoursecontainers/ou-tm351:24j.0b7-arm64

docker manifest push ousefulcoursecontainers/ou-tm351:24j
```


This is better:

```text
docker manifest rm ousefulcoursecontainers/ou-tm351:24j

docker manifest create ousefulcoursecontainers/ou-tm351:24j --amend ousefulcoursecontainers/ou-tm351:24j.0b7-arm64
> Created manifest list docker.io/ousefulcoursecontainers/ou-tm351:24j

docker manifest create ousefulcoursecontainers/ou-tm351:24j --amend mmh352/tm351:24j
> Created manifest list docker.io/ousefulcoursecontainers/ou-tm351:24j

docker manifest push ousefulcoursecontainers/ou-tm351:24j

```
