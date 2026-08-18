#!/bin/sh

set -eu

TARGET_DIR="/var/www/html"
TAR_FILE="/backups/wp_backup.tar.gz"
SQL_FILE="/backups/db_backup.sql"

if [ "$LOAD_BACKUP" != "true" ]; then
  echo "[restore] LOAD_BACKUP is not set to 'true'. Skipping WordPress restore."
  exit 0
fi

echo "[restore] Starting restore..."

#
# WordPress files
#

if [ -f "$TAR_FILE" ]; then
    echo "[restore] Restoring WordPress files from $TAR_FILE..."

    tar -xzf "$TAR_FILE" -C "$TARGET_DIR"

    # wordpress:* images run Apache/PHP as www-data (UID/GID 33)
    chown -R 33:33 "$TARGET_DIR"

    echo "[restore] WordPress files restored."
else
    echo "[restore] No WordPress backup found at $TAR_FILE."
    echo "[restore] Skipping WordPress file restore."
fi

#
# Database
#

if [ -f "$SQL_FILE" ]; then
    echo "[restore] Restoring database from $SQL_FILE..."

    mysql \
        --host=db \
        --user=root \
        --password="$DB_ROOT_PASSWORD" \
        "$DB_NAME" < "$SQL_FILE"

    echo "[restore] Database restored."
else
    echo "[restore] No database backup found at $SQL_FILE."
    echo "[restore] Skipping database restore."
fi

echo "[restore] Restore completed successfully."
