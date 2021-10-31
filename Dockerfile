# OpenVPN client + SOCKS proxy
# Usage:
# Create configuration (.ovpn), mount it in a volume
# docker run --volume=something.ovpn:/ovpn.conf:ro --device=/dev/net/tun --cap-add=NET_ADMIN
# Connect to (container):1080
# Note that the config must have embedded certs
# See `start` in same repo for more ideas

FROM alpine:latest
LABEL maintainer=edgd1er

#http pac
EXPOSE 80
#dante
EXPOSE 1080

RUN apk add --no-cache --update bash tzdata dante-server openvpn openresolv nginx netcat-openbsd runit busybox-extras\
    # Install envsubst command for replacing config files in system startup
        # - it needs libintl package
        # - only weights 100KB combined with it's libraries
    gettext libintl \
    && find /usr -iname envsubst \
    && cp /usr/bin/envsubst /usr/local/bin/envsubst \
    && rm /etc/nginx/conf.d/default.conf \
    && sed -i "/}/i \\\tapplication/x-ns-proxy-autoconfig\\t    pac;\n    application/x-ns-proxy-autoconfig\\t    dat;\n    application/x-ns-proxy-autoconfig\\t    da;" /etc/nginx/mime.types
# Cleanup
RUN apk del gettext \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*
COPY config /config
COPY app /etc/service/
RUN find /etc/service/ -type f -exec chmod a+x {} \;

WORKDIR /etc/service/

HEALTHCHECK --interval=5m --timeout=20s --start-period=1m \
  CMD if test $(/etc/service/healthcheck.sh ) -eq 0 ; then exit 0; else exit 1; fi

CMD ["runsvdir", "/etc/service/"]