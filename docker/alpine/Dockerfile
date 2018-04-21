#-*-coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
# ex: set fenc=utf-8 sts=4 ts=4 sw=4 et nomod:

# Set the base image to Alpine
FROM alpine:3.7

RUN    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk --no-cache upgrade \
    && apk add --no-cache cloudi

# Use a modified CloudI configuration file based on cloudi_minimal.conf
COPY conf/cloudi.conf /etc/cloudi/cloudi.conf

# Add the entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh

# Allow the HTTP Server port for CloudI
EXPOSE 6464

# Allow the Erlang Port Mapper Daemon port
EXPOSE 4369

# Allow the distributed Erlang ports (inet_dist_listen)
EXPOSE 4374-4474

ENTRYPOINT ["/entrypoint.sh"]

