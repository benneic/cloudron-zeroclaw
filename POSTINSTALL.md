## Welcome to ZeroClaw

Your app is available at **`$CLOUDRON-APP-ORIGIN`**.

### 1. Sign in, then pair

This package puts Cloudron's user authentication wall (the **`proxyauth`** addon) in front of ZeroClaw, so the dashboard is only reachable by Cloudron users you have granted access to (Dashboard → **Apps → ZeroClaw → Access Control**).

After you sign in via Cloudron, the ZeroClaw pairing modal appears with a **12-character code already auto-filled** (fetched from the gateway over your authenticated session). Click **Pair** — the dashboard saves the resulting **bearer token** in your browser's `localStorage` and uses it for all subsequent API / WebSocket calls.

Why both walls? ZeroClaw's `GET /pair/code` endpoint is public by upstream design (the dashboard auto-fills from it so Docker / remote installs work without log-scraping). Without `proxyauth`, anyone who could reach the URL would be handed a valid pairing code. With `proxyauth` you can only reach `/pair/code` after Cloudron sign-in, so only your Cloudron users can pair.

To revoke a paired client (e.g. a lost device): edit `/app/data/.zeroclaw/config.toml`, remove the relevant entry from `gateway.paired_tokens`, and restart the app.

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
