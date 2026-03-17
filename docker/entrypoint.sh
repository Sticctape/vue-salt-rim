#!/bin/sh

set -eu

TEMPLATE_PATH=/var/www/html/config.js.template
OUTPUT_PATH=/var/www/html/config.js

if command -v envsubst >/dev/null 2>&1; then
	envsubst < "$TEMPLATE_PATH" > "$OUTPUT_PATH"
else
	echo "[entrypoint] WARNING: envsubst not found; copying template as-is" >&2
	cp "$TEMPLATE_PATH" "$OUTPUT_PATH"
fi

# Generate a cache buster based on the config file's content hash
CONFIG_HASH=$(md5sum /var/www/html/config.js | cut -d' ' -f1)

# Update the HTML to include the cache buster query parameter
sed -i "s|<script src=\"/config.js\"></script>|<script src=\"/config.js?v=${CONFIG_HASH}\"></script>|g" /var/www/html/index.html

exec nginx -g "daemon off;"
