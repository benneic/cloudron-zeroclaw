## Welcome to ZeroClaw

Your app is available at **`$CLOUDRON-APP-ORIGIN`**.

### 1. Get the pairing code

The dashboard requires a **one-time pairing code** on first access:

```bash
cloudron logs <app-id> -f
```

Look for a **6-digit code** in the logs, then open the site and enter it. After pairing, use the **bearer token** the UI provides for API/WebSocket calls.

### 2. Set your LLM provider

Edit **`/app/data/.zeroclaw/config.toml`** via **File Manager** or **Web terminal**, then restart.

### 3. Memory is on PostgreSQL

This package enables the Cloudron **`postgresql`** addon and wires it to ZeroClaw's memory layer (`[memory] backend = "postgres"`). Conversation turns are auto-saved to the addon database and restored across restarts. Both `/app/data` and the postgres database are included in Cloudron backups — no extra setup needed.

To switch to local SQLite memory instead, edit **`/app/data/.zeroclaw/config.toml`**, set `[memory] backend = "sqlite"`, and restart.

### 4. Hardening

- Run **`zeroclaw doctor`** inside the app (Web terminal / `cloudron exec`) after changes.
- Review **[SECURITY.md](https://github.com/zeroclaw-labs/zeroclaw/blob/master/SECURITY.md)** for DM pairing and channel policies.

### Package support

For **this Cloudron package** (Dockerfile, manifest, docs), open issues on the [packaging repository](https://github.com/benneic/cloudron-zeroclaw/issues). For **ZeroClaw itself**, use [upstream issues](https://github.com/zeroclaw-labs/zeroclaw/issues).
