# Your PERN projects

Mounted at `/workspace` in the `dev` container. Create apps here; files stay on your host.

## From a shell in the container

```bash
docker compose exec dev bash
cd /workspace
npm create vite@latest my-ui -- --template react
cd my-ui && npm install && npm run dev -- --host 0.0.0.0
```

```bash
mkdir -p my-api && cd my-api && npm init -y
npm install pg express
# use process.env.DATABASE_URL (set in compose) or individual POSTGRES_* vars
```

Check connectivity:

```bash
pg_isready -h database -U "${POSTGRES_USER:-pern}"
psql "$DATABASE_URL" -c 'SELECT 1'
```

Postgres from the **host** (GUI clients): **`localhost`** and **`PERN_PG_PORT`** from `.env` (default **5432**).

## SSH

Default host port **2223** → container **22**. Parent [`README.md`](../README.md) covers keys, **`.env`**, and **`PERN_SSH_PORT`**.
