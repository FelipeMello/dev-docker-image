# Your MERN projects

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
npm install express mongoose cors
# use process.env.MONGO_URI (set in compose) for mongoose.connect()
```

MongoDB from `dev`: host **`database`**, port **27017**.

## SSH instead of `docker compose exec`

`sshd` runs on **port 22** inside `dev`. From your machine (default host mapping **2222**):

```bash
ssh -p 2222 root@localhost
cd /workspace
```

See the parent [`README.md`](../README.md#setting-the-root-password-for-ssh-optional) for **how to set the root SSH password** (`.env` / `export`), keys via `./setup-ssh.sh`, and `MERN_SSH_PORT`.
