#!/usr/bin/env bash
set -e

  # Description: Acts as a reverse proxy for all of the sourcegraph-frontend instances
  #
  # Disk: 1GB / persistent SSD
  # Ports exposed to other Sourcegraph services: none
  # Ports exposed to the public internet: 80 (HTTP) and 443 (HTTPS)
  #
  # Sourcegraph ships with a few builtin templates that cover common HTTP/HTTPS configurations:
  # - HTTP only (default)
  # - HTTPS with Let's Encrypt
  # - HTTPS with custom certificates
  #
  # Follow the directions in the comments below to swap between these configurations.
  #
  # If none of these built-in configurations suit your needs, then you can create your own Caddyfile, see:
  # https://caddyserver.com/docs/caddyfile
echo "WHO THE ARE YOU"
whoami
echo "WHERE THE AM I"
pwd
echo "WHAT THE I GOT"
ls -la
VOLUME="$HOME/sourcegraph-docker/caddy-storage"
./ensure-volume.sh $VOLUME 100
docker run --detach \
    --privileged \
    --name=caddy \
    --network=sourcegraph \
    --restart=always \
    --cpus="2" \
    --memory=4g \
    -e XDG_DATA_HOME="/caddy-storage/data" \
    -e XDG_CONFIG_HOME="/caddy-storage/config" \
    -e SRC_FRONTEND_ADDRESSES="sourcegraph-frontend-0:3080" \
    -p 0.0.0.0:80:80 \
    -p 0.0.0.0:443:443 \
    -v $VOLUME:/caddy-storage \
    --mount type=bind,source=$HOME/nvim_base/deploy-sourcegraph-docker/caddy/builtins, target=/etc/caddy \
    index.docker.io/caddy:2.7-alpine@sha256:57942bf7e71d78bc866cbc6c45f0563dbbea73efedac5e731b4b2cffa75e45b4

