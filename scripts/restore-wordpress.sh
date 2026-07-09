#!/bin/sh
# Extracts /backups/wp_backup.tar.gz into /var/www/html (the wp_data volume).
set -e

TAR_FILE="/backups/wp_backup.tar.gz"
TARGET_DIR="/var/www/html"

if [ "$LOAD_BACKUP" != "true" ]; then
  echo "[restore] LOAD_BACKUP is not set to 'true'. Skipping WordPress restore."
  exit 0
fi

# if [ -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
#   echo "[restore] $TARGET_DIR is not empty, skipping WordPress restore."
#   exit 0
# fi

if [ ! -f "$TAR_FILE" ]; then
  echo "[restore] No archive found at $TAR_FILE, skipping."
  exit 0
fi

echo "[restore] Extracting $TAR_FILE directly into $TARGET_DIR..."
tar -xzf "$TAR_FILE" -C "$TARGET_DIR"

# wordpress:*-apache images run as www-data (uid/gid 33 on Debian-based images)
chown -R 33:33 "$TARGET_DIR"

echo "[restore] Done. $(find "$TARGET_DIR" -maxdepth 1 | wc -l) top-level items restored."
