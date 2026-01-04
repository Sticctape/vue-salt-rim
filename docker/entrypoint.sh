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

exec nginx -g "daemon off;"
