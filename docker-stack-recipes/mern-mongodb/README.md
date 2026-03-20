# MERN development stack

Compose project **`mern-mongodb`**: two containers—**`database`** (MongoDB 7 + persistent volume) and **`dev`** (Node 20, git, TypeScript/ts-node/nodemon globally, OpenSSH). Host folder [`workspace/`](workspace/) is mounted at **`/workspace`** in `dev`; Mongo is reached at hostname **`database`**.

For **architecture, when/why to use this, and project fit**, see the root [README.md](../../README.md#mern-development-stack).

```bash
docker compose up --build
docker compose exec dev bash
```

## SSH (remote / VS Code Remote-SSH)

- **Inside the stack**, SSH listens on port **22** on the `dev` service.
- On the **host**, that is published as **`2222` → 22** by default. Override with **`MERN_SSH_PORT`** in `.env` (see [`.env.example`](.env.example)).

There is **no root password inside the image**. Choose either **keys** (recommended) or **set a password at runtime** using the steps below.

### Default: key-based SSH (no password file needed)

From **`docker-stack-recipes/mern-mongodb/`** with the stack running:

```bash
./setup-ssh.sh
ssh -p 2222 root@localhost
```

Or use **`docker compose exec dev bash`** and skip SSH.

### Setting the root password for SSH (optional)

The password is applied when the **`dev`** container **starts**. It must be supplied via environment variable **`SSH_ROOT_PASSWORD`** — **never** put the real value in `docker-compose.yml` or any committed file.

**Option A — `.env` file (persists across restarts)**

1. Go to the recipe directory:
   ```bash
   cd docker-stack-recipes/mern-mongodb
   ```
2. Copy the example env file (safe to commit; contains no secrets):
   ```bash
   cp .env.example .env
   ```
3. Edit **`.env`** and set your password (this file is **gitignored**):
   ```bash
   SSH_ROOT_PASSWORD=your-strong-secret-here
   ```
   If the password contains **`#`**, **`$`**, spaces, or other special characters, wrap the value in **single quotes** in `.env`:
   ```bash
   SSH_ROOT_PASSWORD='my$complex#secret'
   ```
4. (Re)start **`dev`** so the entrypoint runs with the new value:
   ```bash
   docker compose up -d --build --force-recreate dev
   ```
5. SSH with password (default host port **2222**):
   ```bash
   ssh -p 2222 root@localhost
   ```

Compose **automatically** reads **`.env`** in the same directory as `docker-compose.yml` for variable substitution, so `SSH_ROOT_PASSWORD` reaches the container without listing it in YAML.

**Option B — one shell session only (nothing on disk)**

```bash
cd docker-stack-recipes/mern-mongodb
export SSH_ROOT_PASSWORD='your-strong-secret-here'
docker compose up -d --force-recreate dev
ssh -p 2222 root@localhost
```

Use **single quotes** around the password in `export` if it contains special characters.

**Changing or removing the password**

- Update **`.env`** (or unset **`SSH_ROOT_PASSWORD`**) and run **`docker compose up -d --force-recreate dev`** again.
- If **`SSH_ROOT_PASSWORD`** is unset or empty, the container **disables password login** and **locks** the root password; use **`./setup-ssh.sh`** or **`docker compose exec`** instead.

**Host port 22 instead of 2222** (only if nothing else uses host port 22):

```bash
MERN_SSH_PORT=22 docker compose up -d
```

(or set **`MERN_SSH_PORT=22`** in **`.env`**)

## Security

This image is for **local development**. Do not expose the SSH port to untrusted networks without hardening (keys only, strong password if you enable one, fail2ban, non-root user, etc.).

MongoDB in this recipe has **no authentication** and port **27017** is published to the host—fine on a trusted machine, risky on a shared LAN or cloud VM. Remove or narrow the port mapping if you only need DB access from the `dev` container.
