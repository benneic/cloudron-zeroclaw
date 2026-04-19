# Smoke test (maintainers)

Requires Docker (daemon running) and optionally a Cloudron for full install checks.

## 1. Image build

```bash
docker build -t zeroclaw-cloudron:local .
```

The **`web-builder`** stage clones [zeroclaw-labs/zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) at **`ZEROCLAW_GIT_TAG`** and runs `npm run build`. If the clone or npm step fails, check network access, the tag name, and [upstream web/package.json](https://github.com/zeroclaw-labs/zeroclaw/tree/master/web).

## 2. Run container

```bash
docker run --rm -p 42617:42617 \
  -e API_KEY=your-test-key \
  -e PROVIDER=openrouter \
  zeroclaw-cloudron:local
```

## 3. Health

```bash
curl -sf http://127.0.0.1:42617/health | head
```

Expect HTTP **200** and JSON body.

## 4. Pairing code

Open the app URL (or `http://127.0.0.1:42617`) and watch **`docker logs`** for the **6-digit pairing code** on first use.

## 5. Cloudron CLI

```bash
cloudron build
cloudron install   # or cloudron update
cloudron logs -f
curl -sf "https://$CLOUDRON_APP_DOMAIN/health"
```

If `cloudron versions add` reports **No docker image found**, run **`cloudron build`** in this directory first so the CLI records the last built image.
