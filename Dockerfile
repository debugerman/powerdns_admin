Dockerfile
root@VM-1-8-debian:/data/padmin# cat Dockerfile
FROM alpine:3.5

MAINTAINER Yan Chan

RUN apk update && \
    apk add --no-cache git && \
    apk add --update \
    python \
    python-dev \
    py-pip \
    libffi-dev \
    openldap-dev \
    build-base \
    mariadb-dev && \
    pip install -U pip && \
    rm -rf /var/cache/apk/*

RUN pip install virtualenv

RUN git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git /src

WORKDIR /src

RUN virtualenv flask && \
  source ./flask/bin/activate && \
  pip install MySQL-python && \
  pip install -r requirements.txt && \
  cp config_template.py config.py && \
  sed -i "s|LOG_FILE = 'logfile.log'|LOG_FILE = ''|g" /src/config.py; \
  sed -i "s|PDNS_VERSION = '3.4.7'|PDNS_VERSION = '4.0.4'|g" /src/config.py;

EXPOSE 9393

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /
ENTRYPOINT ["docker-entrypoint.sh"]
