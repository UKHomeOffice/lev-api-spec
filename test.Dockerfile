FROM node:8-alpine

RUN apk add -q --no-cache bash curl jq \
 && apk upgrade -q --no-cache

WORKDIR /home/node

RUN mkdir -p ./bin/
COPY ./.deps/node_modules/ ./.deps/node_modules/
RUN ln -fs "../.deps/node_modules/.bin/dredd" "bin/dredd"
COPY ./test.entrypoint.sh ./entrypoint.sh
COPY ./swagger.yaml ./swagger.yaml
RUN chown -R "node:node" .

USER node
CMD ["./entrypoint.sh"]