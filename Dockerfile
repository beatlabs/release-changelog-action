FROM alpine:latest
LABEL maintainer="markos@chandras.me"

RUN apk add --no-cache bash git

COPY release-changelog /usr/bin/release-changelog

ENTRYPOINT ["/usr/bin/release-changelog"]
