# syntax=docker/dockerfile:1.7
# Binary from upstream Debian image; dashboard is built from the matching git tag.
# Upstream images no longer ship a loose /zeroclaw-data/web tree, so we build web/dist here.
#
# Override at build time: docker build --build-arg ZEROCLAW_GIT_TAG=v0.7.4 .
ARG ZEROCLAW_GIT_TAG=v0.7.3

FROM node:22-alpine AS web-builder
ARG ZEROCLAW_GIT_TAG
RUN apk add --no-cache git
WORKDIR /src
RUN git clone --depth 1 --branch "${ZEROCLAW_GIT_TAG}" https://github.com/zeroclaw-labs/zeroclaw.git .
WORKDIR /src/web
RUN npm ci --ignore-scripts 2>/dev/null || npm install --ignore-scripts
RUN npm run build

FROM ghcr.io/zeroclaw-labs/zeroclaw:debian AS upstream-bin

FROM cloudron/base:5.0.0@sha256:04fd70dbd8ad6149c19de39e35718e024417c3e01dc9c6637eaf4a41ec4e596c

RUN mkdir -p /app/code /app/data
WORKDIR /app/code

COPY --from=upstream-bin /usr/local/bin/zeroclaw /app/code/zeroclaw
COPY --from=web-builder /src/web/dist /app/code/web/dist

COPY config.template.toml /app/code/config.template.toml
COPY start.sh /app/code/start.sh
RUN chmod +x /app/code/start.sh /app/code/zeroclaw

ENV LANG=C.UTF-8 \
    HOME=/app/data \
    ZEROCLAW_WORKSPACE=/app/data/workspace \
    ZEROCLAW_GATEWAY_PORT=42617 \
    ZEROCLAW_ALLOW_PUBLIC_BIND=true

CMD [ "/app/code/start.sh" ]
