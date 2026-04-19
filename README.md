# ZeroClaw — Cloudron package

Unofficial Cloudron packaging for **[ZeroClaw](https://github.com/zeroclaw-labs/zeroclaw)** (personal AI assistant / gateway / web dashboard). The **`zeroclaw`** binary is copied from **`ghcr.io/zeroclaw-labs/zeroclaw:debian`**. The web dashboard is **built inside the Dockerfile** from a shallow git clone of [zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) at **`ARG ZEROCLAW_GIT_TAG`** (default **`v0.7.3`**, kept in sync with **`CloudronManifest.json`** / **`scripts/bump-version.sh`**). Published upstream images no longer include a loose `web/dist` tree to copy. Everything runs on **`cloudron/base:5.0.0`**; app data lives under **`/app/data`**.

| | |
|---|---|
| **Upstream** | [zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) · [zeroclawlabs.ai](https://zeroclawlabs.ai) |
| **This repo** | Packaging only (Dockerfile, manifest, docs). App issues → upstream; **package** issues → [here](https://github.com/benneic/cloudron-zeroclaw/issues). |

## Requirements

- [Cloudron](https://www.cloudron.io/) box with CLI configured (`cloudron login …`).
- **Docker** (for `cloudron build`) **or** a configured [remote build service](https://docs.cloudron.io/packages/docker-builder/).
- A **container registry** you can push to (Docker Hub, GHCR, etc.) — required for publishing via `CloudronVersions.json` (on-server-only installs cannot publish a versions catalog).

## Install (from this repo)

```bash
git clone https://github.com/benneic/cloudron-zeroclaw.git
cd cloudron-zeroclaw
# Optional: pin the UI to another upstream tag (must match your binary expectations)
# cloudron build --build-arg ZEROCLAW_GIT_TAG=v0.7.3
cloudron build          # first run: set image repo, e.g. ghcr.io/you/zeroclaw-cloudron
cloudron install        # pick domain, complete install
```

After install, follow **[POSTINSTALL.md](POSTINSTALL.md)** (pairing code, provider keys).

### Install from hosted `CloudronVersions.json`

After you have built once and run `cloudron versions add` (see [Publish](#publish)), host `CloudronVersions.json` (e.g. raw GitHub URL) and on another Cloudron:

```bash
cloudron install --versions-url 'https://raw.githubusercontent.com/benneic/cloudron-zeroclaw/main/CloudronVersions.json'
```

Or add that URL under **Dashboard → Community apps**.

## First-run pairing (security)

The gateway is exposed with **`require_pairing = true`**. On first dashboard visit you need the **6-digit pairing code** printed in logs:

```bash
cloudron logs -f
```

After pairing, the UI issues **bearer tokens**; keep them secret. Pairing brute-force lockout is handled upstream (see upstream security docs).

## Configure LLM provider & keys

- **Environment variables** (Cloudron app → **Environment**): e.g. `API_KEY`, `PROVIDER`, provider-specific keys — see upstream [`.env.example`](https://github.com/zeroclaw-labs/zeroclaw/blob/master/.env.example).
- **Config file**: `/app/data/.zeroclaw/config.toml` (File Manager / web terminal). Restart the app after changes.

## Channels (Telegram, Discord, Slack, …)

Configure channels in **`config.toml`** per upstream docs ([channels reference](https://github.com/zeroclaw-labs/zeroclaw/blob/master/docs/reference/api/channels-reference.md)). Restart:

```bash
cloudron restart <app-id>
```

Treat inbound DMs as untrusted; use upstream **[SECURITY.md](https://github.com/zeroclaw-labs/zeroclaw/blob/master/SECURITY.md)** pairing defaults.

## Backups & restore

The **`localstorage`** addon backs up **`/app/data`** (workspace, `config.toml`, auth profiles, secrets). Use Cloudron’s normal backup/restore flow.

## Updates

1. Bump **`version`** / **`upstreamVersion`** in **`CloudronManifest.json`** (or merge the [upstream tracker PR](#upstream-release-tracking)).
2. **`cloudron build`** then **`cloudron update`** on your box, **or** republish the catalog:

   ```bash
   cloudron build
   cloudron versions add
   git add CloudronVersions.json && git commit -m "release x.y.z" && git push
   ```

Subscribers who added your **`CloudronVersions.json`** URL get update notifications in the dashboard when the file changes.

## Upstream release tracking

A daily GitHub Action compares [latest upstream release](https://github.com/zeroclaw-labs/zeroclaw/releases/latest) to **`CloudronManifest.json`** and opens a PR that bumps the version and **CHANGELOG** when a new tag appears. Merge it, then run **`cloudron build`**, **`cloudron versions add`**, and push.

## Cloudron limitations

| Topic | Note |
|--------|------|
| **Filesystem** | App code is read-only; only **`/app/data`** (and `/tmp`, `/run`) are writable. |
| **Hardware / USB / firmware** | Not available (no host devices in the container). |
| **`runtime.kind = "docker"`** | Not applicable on Cloudron; use default **native** runtime in config. |
| **WASM plugins** | In-process only; state under `/app/data` — compatible with Cloudron. |

## Troubleshooting

```bash
cloudron logs -f <app-id>
cloudron exec --app <app-id> -- bash -lc 'zeroclaw status; zeroclaw doctor'
```

Health endpoint: **`GET /health`** (used as **`healthCheckPath`** in the manifest).

## Verify build (maintainers)

See **[docs/SMOKE_TEST.md](docs/SMOKE_TEST.md)** for a full checklist (Docker + optional Cloudron). Quick local check:

```bash
docker build -t zeroclaw-cloudron:local .
docker run --rm -p 42617:42617 -e API_KEY=test zeroclaw-cloudron:local
# Other shell: curl -sf http://127.0.0.1:42617/health | head
```

Pairing output appears in **`docker logs`** on first connection.

## Publish `CloudronVersions.json`

`CloudronVersions.json` is created with **`cloudron versions init`**. After **`cloudron build`**:

```bash
cloudron versions add    # appends current manifest version + built image
```

Commit the updated **`CloudronVersions.json`** and push so your public URL updates.

**Forking this repo:** replace **`benneic/cloudron-zeroclaw`** in **`CloudronManifest.json`** (`iconUrl`, `documentationUrl`, links in docs) with your fork.

## License

Packaging files in this repository are provided under the same **[LICENSE](LICENSE)** as the repo root. **ZeroClaw** itself is dual-licensed **MIT OR Apache-2.0** — see upstream.
