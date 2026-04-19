# ZeroClaw on Cloudron

**ZeroClaw** is a lean, Rust-based personal AI assistant: gateway (HTTP/WebSocket), web dashboard, multi-channel inbox, tools, and memory — packaged for [Cloudron](https://www.cloudron.io/).

This package rebases the upstream [`ghcr.io/zeroclaw-labs/zeroclaw:debian`](https://github.com/zeroclaw-labs/zeroclaw/pkgs/container/zeroclaw) image onto `cloudron/base`, persists data under `/app/data`, and exposes the gateway on port **42617** (HTTP behind Cloudron’s TLS).

## Highlights

- **Upstream parity**: same `zeroclaw` binary as the official Debian image; dashboard `web/dist` is built from the matching upstream git tag in the Docker build.
- **Internet-safe defaults**: gateway **pairing** enabled (`require_pairing = true`); bearer tokens after pairing.
- **Backups**: workspace, config, and secrets live under `/app/data` (Cloudron `localstorage` addon).

## What this is not

- Not an official ZeroClaw Labs release channel — track upstream at [github.com/zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw).
- **Hardware / USB / firmware** features are not available in Cloudron containers (no host device access).

## Learn more

- Upstream site: [zeroclawlabs.ai](https://zeroclawlabs.ai)
- Package docs: [README.md](https://github.com/benneic/cloudron-zeroclaw/blob/main/README.md)
