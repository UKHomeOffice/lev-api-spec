FROM node:8-alpine

RUN apk add --no-cache curl jq \
 && apk upgrade --no-cache

WORKDIR /home/node

RUN mkdir -p ./bin/
COPY ./.deps/node_modules/ ./.deps/node_modules/
RUN ln -fs "../.deps/node_modules/.bin/dredd" "bin/dredd"
COPY ./test.entrypoint.sh ./entrypoint.sh
COPY ./swagger.yaml ./swagger.yaml
RUN chown -R "node:node" .

USER node
CMD ["./entrypoint.sh"]