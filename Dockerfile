FROM alpine:3.8
LABEL maintainer "gijsbert.renswoude@nn-group.com"

RUN apk add --update --upgrade --no-cache jq bash curl git openssh

ADD assets /opt/resource
ADD test /opt/test
RUN chmod +x /opt/resource/*

CMD ["/bin/sh"]
