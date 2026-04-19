#!/bin/bash
set -eu

mkdir -p /app/data/.zeroclaw /app/data/workspace

if [[ ! -f /app/data/.zeroclaw/config.toml ]]; then
    cp /app/code/config.template.toml /app/data/.zeroclaw/config.toml
fi

chown -R cloudron:cloudron /app/data

exec gosu cloudron:cloudron /app/code/zeroclaw daemon
