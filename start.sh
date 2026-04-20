#!/bin/bash
set -eu

mkdir -p /app/data/.zeroclaw /app/data/workspace

if [[ ! -f /app/data/.zeroclaw/config.toml ]]; then
    cp /app/code/config.template.toml /app/data/.zeroclaw/config.toml
fi

# Bridge Cloudron's PostgreSQL addon into ZeroClaw's storage layer.
# ZeroClaw resolves connection strings in the order:
#   ZEROCLAW_POSTGRES_URL > ZEROCLAW_DB_URL > DATABASE_URL > config.toml
# CLOUDRON_POSTGRESQL_URL is injected by the postgresql addon at runtime.
if [[ -n "${CLOUDRON_POSTGRESQL_URL:-}" ]]; then
    export ZEROCLAW_POSTGRES_URL="${CLOUDRON_POSTGRESQL_URL}"
fi

chown -R cloudron:cloudron /app/data

exec gosu cloudron:cloudron /app/code/zeroclaw daemon
