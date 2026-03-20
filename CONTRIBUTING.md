# Contributing

## Scope and CI

- Prefer **small, path-scoped changes** so [path-filtered workflows](.github/workflows/) only run what they must.
- Adding a new stack recipe? Mirror **MERN / PERN / Java–Oracle**: `docker-compose.yml` with explicit `name:`, healthchecks, `.env.example`, `setup-ssh.sh`, recipe `README.md`, optional `scripts/<recipe>-compose-up.sh`, and a workflow under `.github/workflows/` that lists the recipe path in `on.push.paths` / `on.pull_request.paths`.
- **Non-Compose recipes** (e.g. **Kind / local Kubernetes** under `docker-stack-recipes/kind-kubernetes/`): no requirement for `docker-compose.yml`. Ship **declarative config** (e.g. `kind-config.yaml`), **automation scripts**, and a **recipe README** (prereqs, create/delete, cleanup). In CI, tear down with **`kind delete cluster`** (or equivalent) in a step with **`if: always()`** so failed smokes do not leave **Kind node containers** on the runner. Pin third-party actions (e.g. **[`helm/kind-action`](https://github.com/helm/kind-action)**) to a **release tag**, not `@main`. Update the [root README](README.md) when you add such a recipe.

## GitHub Actions

- **Pin third-party actions to a release tag** (not `@main` / `@master`). Match the repo workflows (currently **`aquasecurity/trivy-action@v0.35.0`** in all scan jobs, **`helm/kind-action@v1.14.0`** and **`azure/setup-helm@v4.3.1`** in the Kind recipe workflow); bump deliberately when you need a newer engine (see [trivy-action releases](https://github.com/aquasecurity/trivy-action/releases), [kind-action releases](https://github.com/helm/kind-action/releases)), and update this sentence if you change the pin.
- Recipe jobs use **least privilege**: `permissions: contents: read` unless a step needs more.
- Smoke tests: start stacks with **`docker compose up -d --wait`** so services with `healthcheck` are ready before `exec`, and run **`docker compose down`** in a step with **`if: always()`** so CI does not leave containers/volumes behind when a check fails. For **Kind**, run **`kind delete cluster --name …`** (or your recipe’s wrapper) with **`if: always()`** after **`kubectl`/Helm** checks.

## Docker images

- Prefer **reproducible base tags** and avoid **`curl | bash`** installers in Dockerfiles when a **multi-stage copy** from an official image is enough (see `java-oracle-enterprise` Dockerfile for Node alongside Temurin).
- Document **non-root / SSH / secrets** behaviour in each recipe README; never commit real `.env` files (they are gitignored).

## Docs

- Update the [root README](README.md) “What’s in this repo” table and any CI overview tables when you add recipes or workflows.
