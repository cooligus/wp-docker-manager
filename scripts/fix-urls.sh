#!/bin/sh

# Fixes the domain stored in WordPress's DB.
#
# wp-cli search-replace understands serialized PHP data, so it safely
# updates URLs in options, widgets, theme mods, post content, etc.

set -eu

: "${OLD_URL:?OLD_URL not set — put it in .env}"
: "${NEW_URL:?NEW_URL not set — put it in .env}"
: "${LOAD_BACKUP:=false}"

if [ "$LOAD_BACKUP" != "true" ]; then
    echo "[fix-urls] LOAD_BACKUP is not 'true'. Skipping URL replacement."
    exit 0
fi

if [ -z "$OLD_URL" ] || [ -z "$NEW_URL" ]; then
    echo "[fix-urls] OLD_URL or NEW_URL is empty. Skipping."
    exit 0
fi

if [ "$OLD_URL" = "$NEW_URL" ]; then
    echo "[fix-urls] OLD_URL and NEW_URL are identical ($OLD_URL). Skipping."
    exit 0
fi

echo "[fix-urls] Waiting for WordPress database..."

# until wp db check --allow-root --ssl-mode=DISABLED >/dev/null 2>&1; do
#     echo "[fix-urls] Database not ready yet. Retrying in 3 seconds..."
#     sleep 3
# done

echo "[fix-urls] Database is ready."
echo "[fix-urls] Replacing $OLD_URL -> $NEW_URL"

wp search-replace \
    "$OLD_URL" \
    "$NEW_URL" \
    --all-tables \
    --allow-root

echo "[fix-urls] URL replacement completed successfully."