#!/bin/bash

set -e

DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="docker_snapshot_${DATE}"

echo "Creating snapshot directory: ${BACKUP_DIR}"
mkdir -p ${BACKUP_DIR}

echo "Saving docker version..."
docker version > ${BACKUP_DIR}/docker_version.txt

echo "Saving docker info..."
docker info > ${BACKUP_DIR}/docker_info.txt

echo "Saving container list..."
docker ps -a > ${BACKUP_DIR}/docker_ps.txt

echo "Saving image list with digests..."
docker images --digests > ${BACKUP_DIR}/docker_images.txt

echo "Saving network list..."
docker network ls > ${BACKUP_DIR}/docker_network.txt

echo "Saving volume list..."
docker volume ls > ${BACKUP_DIR}/docker_volume.txt

echo "Saving detailed container inspect files..."
for c in $(docker ps -aq); do
    docker inspect $c > ${BACKUP_DIR}/container_${c}.json
done

echo "Saving detailed network inspect files..."
for n in $(docker network ls -q); do
    docker network inspect $n > ${BACKUP_DIR}/network_${n}.json
done

echo "Saving detailed volume inspect files..."
for v in $(docker volume ls -q); do
    docker volume inspect $v > ${BACKUP_DIR}/volume_${v}.json
done

echo "Snapshot complete: ${BACKUP_DIR}"