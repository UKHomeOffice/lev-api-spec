FROM node:9-alpine

RUN apk add --no-cache curl jq \
 && addgroup -S "app" \
 && adduser -Sh "/app" "app" "app"

USER app
WORKDIR /app

RUN mkdir -p ./bin/

COPY ./.deps/node_modules/ ./.deps/node_modules/
RUN ln -fs "../.deps/node_modules/.bin/dredd" "bin/dredd"
COPY ./test.entrypoint.sh ./entrypoint.sh
COPY ./swagger.yaml ./swagger.yaml

USER root
RUN chown -R "app:app" .

USER app
CMD ["./entrypoint.sh"]