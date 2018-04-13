FROM scratch

ENV BIND_ADDR 0.0.0.0:3123
EXPOSE 3123

COPY .deps/dapperdox /
COPY .deps/dapperdox-theme-gov-uk /assets/themes/gov-uk

COPY assets/ /assets
COPY swagger.yaml /spec/

USER 31337
ENTRYPOINT ["/dapperdox", "--spec-filename=swagger.yaml", "--theme=gov-uk", "--assets-dir", "assets"]
