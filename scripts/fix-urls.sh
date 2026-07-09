#!/bin/sh
# Fixes the domain stored in WordPress's DB (siteurl/home + serialized data
# in options, widgets, theme mods, post content, etc.) using wp-cli's
# search-replace, which correctly handles serialized PHP data.
set -e

: "${OLD_URL:?OLD_URL not set — put it in .env}"
: "${NEW_URL:?NEW_URL not set — put it in .env}"

# Check if either variable is empty, or if they are identical
if [ -z "$OLD_URL" ] || [ -z "$NEW_URL" ]; then
  echo "[fix-urls] Skipping: OLD_URL or NEW_URL is not set."
  exit 0
elif [ "$OLD_URL" = "$NEW_URL" ]; then
  echo "[fix-urls] Skipping: OLD_URL and NEW_URL are identical ($OLD_URL)."
  exit 0
fi

sleep 100
#echo "Waiting for database..."
#echo "${WORDPRESS_DB_NAME}"
#echo "${WORDPRESS_DB_HOST}"
#cat /var/www/html/wp-config.php
#until wp db check --allow-root --ssl=false # --path=/var/www/html >/dev/null 2>&1
#do
#    sleep 5
#done

echo "[fix-urls] Replacing $OLD_URL -> $NEW_URL"
wp search-replace "$OLD_URL" "$NEW_URL" --all-tables --allow-root # --path=/var/www/html
echo "[fix-urls] Done."
