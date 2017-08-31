FROM hypriot/rpi-alpine as build-stage

MAINTAINER Soeren Stelzer

ENV INFLUX_DB_VERSION 1.3.4
ENV INFLUX_DB_FILE influxdb-${INFLUX_DB_VERSION}_linux_armhf.tar.gz
ENV INFLUX_DB_URL https://dl.influxdata.com/influxdb/releases/${INFLUX_DB_FILE}
ENV COLLECTD_URL=https://github.com/collectd/collectd/raw/master/src/types.db

RUN set -xe \
    && apk add --no-cache --virtual .build-deps ca-certificates curl tar \
    && update-ca-certificates \
    && mkdir -p /usr/src \
    && curl -sSL ${INFLUX_DB_URL} | tar xz --strip 2 -C /usr/src \
    && curl -o /usr/src/usr/lib/influxdb/types.db ${COLLECTD_URL} \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

FROM hypriot/rpi-alpine

COPY --from=build-stage /usr/src /
COPY entrypoint.sh /entrypoint.sh

# HTTP API
EXPOSE 8086

ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
