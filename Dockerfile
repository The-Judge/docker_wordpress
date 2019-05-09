FROM wordpress:latest
LABEL maintainer="marc.richter@henkel.com"

COPY --chown=33:33 docker-entrypoint_hook.patch /tmp
RUN cd /usr/local/bin && patch < /tmp/docker-entrypoint_hook.patch
