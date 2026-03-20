# Kind + Kubernetes (local dev)

Opinionated **local Kubernetes** using [Kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker). Unlike the MERN/PERN recipes, there is **no app database** and **no `docker-compose.yml`**: Docker runs Kind node containers; you use **`kubectl`** and **Helm 3** on the **host** (or any machine that shares the kubeconfig).

## Prerequisites

- **Docker** (running)
- **[Kind](https://github.com/kubernetes-sigs/kind/releases)** — use a version compatible with your desired Kubernetes minor (see [Kind release notes](https://github.com/kubernetes-sigs/kind/releases))
- **`kubectl`** — within [version skew](https://kubernetes.io/releases/version-skew-policy/) of the cluster (Kind pins a Kubernetes version per Kind release)
- **Helm 3** only — [install](https://helm.sh/docs/intro/install/) and verify with `helm version`

## Layout

| File | Purpose |
|------|---------|
| `kind-config.yaml` | Default: **1 control-plane + 2 workers**; control-plane has **ingress-ready** label and **80/443** `extraPortMappings` for local ingress. |
| `kind-config-ci.yaml` | **1 control-plane + 1 worker** — used by CI; faster/less brittle than full multinode on runners. |
| `kind-config-ha-control-plane.yaml` | **Optional / heavy**: **3 control-planes + 2 workers**. High RAM/CPU; for advanced testing only. |
| `ingress-nginx-kind-values.yaml` | Helm values for **ingress-nginx** on Kind (used by `scripts/install-ingress.sh`). |
| `scripts/cluster-up.sh` | Create cluster (idempotent if name already exists). |
| `scripts/cluster-down.sh` | `kind delete cluster`. |
| `scripts/install-ingress.sh` | Helm install **ingress-nginx** (pinned chart version; override with `INGRESS_NGINX_CHART_VERSION`). |

## Create and delete cluster

Default cluster name: **`dev-local`**. Override with **`KIND_CLUSTER_NAME`**.

```bash
cd docker-stack-recipes/kind-kubernetes
chmod +x scripts/*.sh   # once, if needed
./scripts/cluster-up.sh
```

- **Recreate** (delete then create): `./scripts/cluster-up.sh --recreate`
- **Custom config**: `KIND_CONFIG="$PWD/kind-config-ha-control-plane.yaml" ./scripts/cluster-up.sh`

Context name: **`kind-<cluster-name>`** (e.g. `kind-dev-local`).

```bash
kubectl config use-context kind-dev-local
kubectl get nodes
```

You should see **three** nodes with `kind-config.yaml` (one control-plane, two workers).

**Teardown:**

```bash
./scripts/cluster-down.sh
```

Or: `kind delete cluster --name dev-local`

### HA-style multi–control-plane (optional)

For **`kind-config-ha-control-plane.yaml`**: expect **much** higher resource use and slower startup. Only use when you need to exercise multiple control planes locally.

```bash
export KIND_CONFIG="$PWD/kind-config-ha-control-plane.yaml"
./scripts/cluster-up.sh --recreate
```

## Ingress + Helm bootstrap

This recipe’s default **`kind-config.yaml`** maps **host 80/443** to the control-plane so **ingress-nginx** can serve HTTP(S) from your machine.

### Option A — helper script (Helm, pinned chart)

```bash
cd docker-stack-recipes/kind-kubernetes
./scripts/install-ingress.sh
```

Override chart version: `INGRESS_NGINX_CHART_VERSION=4.11.3 ./scripts/install-ingress.sh`

### Option B — copy-paste (Helm 3)

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --version 4.11.3 \
  --values docker-stack-recipes/kind-kubernetes/ingress-nginx-kind-values.yaml \
  --wait --timeout 10m
```

### Option C — upstream Kind ingress doc

The [Kind ingress guide](https://kind.sigs.k8s.io/docs/user/ingress/) documents **`extraPortMappings`**, **ingress-nginx**, and verification steps; align your cluster config with that page if you deviate from this folder’s YAML.

### metrics-server (optional)

Many charts assume metrics; for a quick install (Helm):

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --set args={--kubelet-insecure-tls} \
  --wait --timeout 5m
```

## Cleanup and disk space

- **`kind delete cluster --name <name>`** removes the cluster and its containers.
- **`docker system prune`** can reclaim space but may remove **unused** images/containers you still want — use deliberately.

## From repository root

```bash
./scripts/kind-cluster-up.sh
```

See the root [README](../../README.md) for how this recipe fits next to Compose-based stacks.
