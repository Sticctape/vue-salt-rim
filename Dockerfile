FROM node:current-alpine3.20 AS build

ARG BUILD_VERSION
ENV BUILD_VERSION=${BUILD_VERSION:-develop}

WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .

RUN sed -i "s/{{VERSION}}/$BUILD_VERSION/g" ./docker/config.js

RUN npm run build

FROM docker.io/nginxinc/nginx-unprivileged:stable AS prod

LABEL org.opencontainers.image.source="https://github.com/karlomikus/vue-salt-rim"

# `docker/entrypoint.sh` uses `envsubst` to render `/config.js` from a template.
# The nginx-unprivileged base image doesn't guarantee `envsubst` is present.
USER root
RUN if command -v apk >/dev/null 2>&1; then \
		apk add --no-cache gettext; \
	else \
		apt-get update && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*; \
	fi

COPY --from=build --chown=www-data:www-data /app/dist /var/www/html

COPY --from=build --chown=www-data:www-data /app/docker/config.js /var/www/html/config.js.template
COPY --chown=www-data:www-data --chmod=0644 ./docker/entrypoint.sh /usr/local/bin/entrypoint

# Make sure the entrypoint is runnable even if it was edited on Windows
# (strip CRLF + UTF-8 BOM if present).
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint \
	&& awk 'NR==1{sub(/^\357\273\277/,"")} {print}' /usr/local/bin/entrypoint > /tmp/entrypoint \
	&& mv /tmp/entrypoint /usr/local/bin/entrypoint

RUN rm /etc/nginx/conf.d/default.conf
COPY --chown=www-data:www-data ./docker/default.conf /etc/nginx/conf.d/default.conf

USER www-data

EXPOSE 8080

# Run through sh so we don't depend on the execute bit.
CMD [ "/bin/sh", "/usr/local/bin/entrypoint" ]

FROM node:latest AS dev

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 5173

CMD ["npm", "run", "dev"]
