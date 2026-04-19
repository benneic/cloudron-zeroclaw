## Welcome to ZeroClaw

Your app is available at **`$CLOUDRON-APP-ORIGIN`**.

### 1. Get the pairing code

The dashboard requires a **one-time pairing code** on first access:

```bash
cloudron logs <app-id> -f
```

Look for a **6-digit code** in the logs, then open the site and enter it. After pairing, use the **bearer token** the UI provides for API/WebSocket calls.

### 2. Set your LLM provider

Either:

- **Cloudron dashboard** → your ZeroClaw app → **Environment** — set e.g. `API_KEY`, `PROVIDER`, `ZEROCLAW_MODEL` (see upstream [`.env.example`](https://github.com/zeroclaw-labs/zeroclaw/blob/master/.env.example)), then **Restart**; or  
- Edit **`/app/data/.zeroclaw/config.toml`** via **File Manager** or **Web terminal**, then restart.

### 3. Hardening

- Run **`zeroclaw doctor`** inside the app (Web terminal / `cloudron exec`) after changes.
- Review **[SECURITY.md](https://github.com/zeroclaw-labs/zeroclaw/blob/master/SECURITY.md)** for DM pairing and channel policies.

### Package support

For **this Cloudron package** (Dockerfile, manifest, docs), open issues on the [packaging repository](https://github.com/benneic/cloudron-zeroclaw/issues). For **ZeroClaw itself**, use [upstream issues](https://github.com/zeroclaw-labs/zeroclaw/issues).
