#!/bin/bash

set -e

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="backups/$TIMESTAMP"

mkdir -p "$BACKUP_DIR"

echo "Creating WordPress files backup..."
sudo tar -czvf "$BACKUP_DIR/wp_backup.tar.gz" -C /var/lib/docker/volumes/wps_wordpress/_data .
#sudo tar -czvf "$BACKUP_DIR/wp_backup.tar.gz" -C /var/lib/docker/volumes/wps_wordpress/_data/wp-content .

echo "Creating database backup..."
docker compose exec -T db mysqldump \
    -u exampleuser \
    --no-tablespaces \
    -pexamplepass \
    exampledb > "$BACKUP_DIR/db_backup.sql"

echo "Backup completed: $BACKUP_DIR"
