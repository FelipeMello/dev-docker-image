# MERN development stack

Compose starts **MongoDB** and a **Node 20** dev image: git, common npm globals (`typescript`, `ts-node`, `nodemon`), and **OpenSSH** (`sshd` on **port 22 inside the container**). Your projects live in bind-mounted [`workspace/`](workspace/).

```bash
docker compose up --build
docker compose exec dev bash
```

## SSH (remote / VS Code Remote-SSH)

- **Inside the stack**, SSH listens on the standard port **22** on the `dev` service.
- On the **host**, that is published as **`2222` → 22** by default so this recipe does not grab the host’s port 22 (often already used by the OS or CI).

```bash
# password auth (default root password is dev123 — change for anything beyond local dev)
ssh -p 2222 root@localhost
```

To use **host port 22** instead (only if nothing else is bound there):

```bash
MERN_SSH_PORT=22 docker compose up -d
```

**Key-based login** (recommended): from this directory with the stack running:

```bash
./setup-ssh.sh
ssh -p 2222 root@localhost
```

Optional: set **`SSH_ROOT_PASSWORD`** in `docker-compose.yml` (or in an env file) so the entrypoint updates `root`’s password on each start.

## Security

This image is for **local development**. Do not expose the SSH port to untrusted networks without hardening (keys only, strong password, fail2ban, non-root user, etc.).

MongoDB in this recipe has **no authentication** and port **27017** is published to the host—fine on a trusted machine, risky on a shared LAN or cloud VM. Remove or narrow the port mapping if you only need DB access from the `dev` container.
