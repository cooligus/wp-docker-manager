#!/bin/bash

set -e

# Load .env if it exists
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

if [ -z "${DOCKER_VOLUME_PATH:-}" ]; then
    echo "ERROR: DOCKER_VOLUME_PATH is not configured."
    echo "Please set DOCKER_VOLUME_PATH before running the backup."
    echo "Example:"
    echo "  export DOCKER_VOLUME_PATH=/var/lib/docker/volumes/wps_wordpress/_data"
    exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="backups/$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

echo "Creating WordPress files backup..."
echo "Source: $DOCKER_VOLUME_PATH"

sudo tar -czvf "$BACKUP_DIR/wp_backup.tar.gz" \
    -C "$DOCKER_VOLUME_PATH" .

echo "Creating database backup..."

docker compose exec -T db mysqldump \
    -u exampleuser \
    --no-tablespaces \
    -pexamplepass \
    exampledb > "$BACKUP_DIR/db_backup.sql"

echo "Backup completed: $BACKUP_DIR"