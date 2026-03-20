# dev-docker-image

Docker recipes and a legacy full-stack dev image. Repository owner on GitHub: **`felipeMello`**. Published images use **`ghcr.io/felipeMello/...`** (see below).

---

## What’s in this repo

| Item | What it is |
|------|------------|
| [**`mern-mongodb`**](docker-stack-recipes/mern-mongodb/) | Compose stack: MongoDB + Node 20 dev container (SSH, git, npm globals). You write code in `workspace/`. |
| **`legacy/full-stack`** | One big Ubuntu image: Java, Python, Node, PostgreSQL, SSH, etc. |
| **`pern-postgres`**, **`java-oracle-*`** | Not added yet (planned). |

Each recipe folder is its own Compose **project** (`name:` in the file), so stacks do not share containers or volumes.

---

## MERN stack — quick start

```bash
cd docker-stack-recipes/mern-mongodb
docker compose up --build
```

Or from the repo root:

```bash
./scripts/mern-compose-up.sh
```

Details (SSH port **2222 → 22**, Mongo, passwords): [`docker-stack-recipes/mern-mongodb/README.md`](docker-stack-recipes/mern-mongodb/README.md). Project scaffolding: [`docker-stack-recipes/mern-mongodb/workspace/README.md`](docker-stack-recipes/mern-mongodb/workspace/README.md).

---

## Pull pre-built images (GitHub Container Registry)

Log in once (use a [GitHub PAT](https://github.com/settings/tokens) with `read:packages`, or `GITHUB_TOKEN` in CI):

```bash
docker login ghcr.io -u felipeMello
```

**Legacy full-stack image** (built by `docker-publish.yml`):

```bash
docker pull ghcr.io/felipeMello/dev-docker-image:latest
```

**MERN dev image** — not pushed by CI today. You build it locally (`mern-mongodb-dev:local`). If you publish it yourself under this account, a typical name would be:

```text
ghcr.io/felipeMello/mern-mongodb-dev:latest
```

---

## Build the legacy image locally

```bash
docker build -f legacy/full-stack/Dockerfile -t fullstack-dev:local .
```

SSH helper: [`legacy/README.md`](legacy/README.md).

---

## CI (GitHub Actions)

| Workflow | Purpose |
|----------|---------|
| `docker-publish.yml` | Build and push **`ghcr.io/felipeMello/dev-docker-image`** from `legacy/full-stack/Dockerfile`. |
| `mern-recipe.yml` | On changes under `docker-stack-recipes/mern-mongodb/`, Compose build + smoke test + informational Trivy on `mern-mongodb-dev:local`. |

---

## Contributing

Change only the recipe or workflow you care about so path-based CI stays fast.
