FROM alpine:3.8
LABEL maintainer "gijsbert.renswoude@nn-group.com"

RUN apk add --update --upgrade --no-cache jq bash curl git openssh python3-dev
RUN pip3 install --no-cache --upgrade pyyaml

ADD assets /opt/resource
ADD test /opt/test
RUN chmod +x /opt/resource/*

CMD ["/bin/sh"]
