# Publishing amd64/arm64 images

# Script for use on Mac for native arm64 container build

#- use hosted VCE image for amd64 build (eg https://hub.docker.com/r/mmh352/m348/tags)
#- build on local Mac (arm64) for arm64 image

#USAGE:
#chmod +x containers_dist.sh
#OCBC_VERSION=24j.0b5 OCBC_MODULE=tm351 OCBC_PRESENTATION=24j ./containers_dist.sh

#- build arm64 natively on Mac m*


# Use ou-container-builder directory

# Version
# The :- sets the env var if passed, else uses the default, eg 24j.0b5, m348, 24j
OCBC_VERSION=${OCBC_VERSION:-24j.0b7}
OCBC_MODULE=${OCBC_MODULE:-tm351}
OCBC_PRESENTATION=${OCBC_PRESENTATION:-24j}
OCBC_DOCKER_PATH=${OCBC_DOCKER_PATH:-mmh352}

# Echo the environment variables for confirmation
echo "Using the following configuration:"
echo "OCBC_VERSION: $OCBC_VERSION"
echo "OCBC_MODULE: $OCBC_MODULE"
echo "OCBC_PRESENTATION: $OCBC_PRESENTATION"
echo "OCBC_DOCKER_PATH: $OCBC_DOCKER_PATH"

echo "\nUsing VCE hosted amd64 image:\ndocker pull --platform=linux/amd64 $OCBC_DOCKER_PATH/$OCBC_MODULE:$OCBC_VERSION"
echo "\nReleased version will be:\nousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_PRESENTATION\n"

# Prompt the user for confirmation
read -p "Are these values correct? (y/n): " confirm

# Check if user agreed; if not, stop the script
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborting..."
    exit 1
fi

# If confirmed, continue with the script
echo "Proceeding with the generation..."


# Generate Dockerfile
#pip install ou-container-builder
ocb generate

# Build in local dir
echo "\nBuilding: docker build . --tag local_${OCBC_MODULE}_image:$OCBC_VERSION\n"
docker build . --tag local_${OCBC_MODULE}_image:$OCBC_VERSION

# Pull existing images and retag locally
echo "Pull amd64 image from docker\n"
docker pull --platform=linux/amd64 $OCBC_DOCKER_PATH/$OCBC_MODULE:$OCBC_VERSION
docker tag $OCBC_DOCKER_PATH/$OCBC_MODULE:$OCBC_VERSION ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-amd64

# Local image
docker tag local_${OCBC_MODULE}_image:$OCBC_VERSION ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-arm64

# Push the tagged images to your repository
docker push ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-amd64
docker push ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-arm64

# Create and push a manifest list
docker manifest create ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION \
    --amend ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-amd64 \
    --amend ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-arm64

docker manifest push ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION

docker manifest create ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_PRESENTATION \
    --amend ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-amd64 \
    --amend ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_VERSION-arm64

docker manifest push ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_PRESENTATION

echo "\nPull released version with:\ndocker pull ousefulcoursecontainers/ou-$OCBC_MODULE:$OCBC_PRESENTATION\n"
