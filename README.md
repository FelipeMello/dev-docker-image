# Docker stack recipes

This repository is a **monorepo** of Docker Compose **development stacks** (databases + language runtimes + tooling) and a **legacy** all-in-one image. Each recipe is a separate Compose **project name** and folder, so `docker compose up` in one folder does not touch another stack’s containers or volumes.

## Choosing a stack

| Good fit | Recipe | Notes |
|----------|--------|--------|
| Rapid product builds, JS-first teams, flexible schema | [**MERN** (`mern-mongodb`)](docker-stack-recipes/mern-mongodb/) | MongoDB + Node 20 dev container with common npm globals; **you create** Express / Vite apps in `workspace/`. |
| Relational data, SQL, stricter schemas | `pern-postgres` | Planned (Postgres + Node). |
| Enterprise Java / Oracle landscapes | `java-oracle-*` | Planned. |

“Startup vs enterprise” here is a **rough menu**: MERN is typical for fast iteration; PERN and Java/Oracle patterns often match teams already standardized on those databases.

## MERN (MongoDB + Node dev environment)

Not a pre-built demo app. The recipe starts **MongoDB** and a **Node 20** container with git plus global CLIs (`typescript`, `ts-node`, `nodemon`). You develop in the mounted **`workspace/`** directory on your machine.

```bash
cd docker-stack-recipes/mern-mongodb && docker compose up --build
```

Helper (forwards extra args to Compose):

```bash
./scripts/mern-compose-up.sh
```

Then open a shell in the dev container and scaffold your API/UI (see [`workspace/README.md`](docker-stack-recipes/mern-mongodb/workspace/README.md)).

- **MongoDB:** `localhost:27017` from the host; hostname **`database`** from inside the `dev` service.
- **Dev server ports:** `3000`, `5173` (Vite), `5000` are published for whatever you run inside `dev`.
- **SSH:** `sshd` listens on **port 22 inside `dev`**. By default the host maps **`2222 → 22`** (override with `MERN_SSH_PORT`). See the recipe [`README.md`](docker-stack-recipes/mern-mongodb/README.md) for passwords, `./setup-ssh.sh`, and VS Code Remote-SSH.
- **Compose project name:** `mern-mongodb` (in the Compose file). A future `pern-postgres` folder would use its own `name:` and stay isolated.

### Publishing this dev image to GHCR (optional)

Local tag: `mern-mongodb-dev:local`. For GitHub Container Registry, use a single registry component, e.g. `ghcr.io/<owner>/mern-mongodb-dev:latest` (this repo’s CI does not push it by default).

## Legacy full-stack image

The original single Ubuntu image (Java, Python, Node, PostgreSQL, SSH, etc.) lives under [`legacy/full-stack/`](legacy/full-stack/):

```bash
docker build -f legacy/full-stack/Dockerfile -t fullstack-dev:local .
```

See [`legacy/README.md`](legacy/README.md) for the SSH helper.

## CI/CD

- **`docker-publish.yml`** — builds and publishes the **legacy** image from `legacy/full-stack/Dockerfile`.
- **`mern-recipe.yml`** — on changes under `docker-stack-recipes/mern-mongodb/`, builds the dev image, runs a short Compose smoke test, and an **informational** Trivy scan on `mern-mongodb-dev:local`.

## Contributing

Keep changes scoped to the recipe folder so path-filtered workflows stay accurate.
