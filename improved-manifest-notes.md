We don't need to actually pull containers; the amnisfest commands run purely on maifests; we can delete the manifest wit a manifest rm command then create and puysh a new one simply by referring to other tagged images on docker hub.


docker pull --platform=linux/amd64 ousefulcoursecontainers/ou-tm351:24j.0b7-amd64
docker pull --platform=linux/arm64 ousefulcoursecontainers/ou-tm351:24j.0b7-arm64

docker manifest create ousefulcoursecontainers/ou-tm351:24j \
    --amend ousefulcoursecontainers/ou-tm351:24j.0b7-amd64 \
    --amend ousefulcoursecontainers/ou-tm351:24j.0b7-arm64

docker manifest push ousefulcoursecontainers/ou-tm351:24j

docker manifest create ousefulcoursecontainers/ou-tm351:24j --amend ousefulcoursecontainers/ou-tm351:24j.0b7-amd64
docker manifest create ousefulcoursecontainers/ou-tm351:24j --amend ousefulcoursecontainers/ou-tm351:24j.0b7-arm64

docker manifest push ousefulcoursecontainers/ou-tm351:24j
