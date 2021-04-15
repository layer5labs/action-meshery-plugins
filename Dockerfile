FROM alpine:latest

RUN	apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  wget \
  jq

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]