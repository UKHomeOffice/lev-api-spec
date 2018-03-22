FROM scratch
COPY docs.group /etc/group
COPY docs.passwd /etc/passwd

ENV BIND_ADDR 0.0.0.0:3123
EXPOSE 3123

COPY .deps/dapperdox /
COPY .deps/dapperdox-theme-gov-uk /assets/themes/gov-uk

COPY assets/ /assets
COPY swagger.yaml /spec/

USER notroot
CMD ["/dapperdox", "--spec-filename=swagger.yaml", "--theme=gov-uk"]
