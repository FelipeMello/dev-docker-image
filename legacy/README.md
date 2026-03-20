# Legacy images

## Full-stack development monolith

Single Ubuntu-based image with Java, Python, Node, PostgreSQL, SSH, and related tooling (see `full-stack/Dockerfile` for details).

Build from the **repository root** (context must include paths the Dockerfile expects; today it uses no `COPY` from the repo, but this keeps a stable convention):

```bash
docker build -f legacy/full-stack/Dockerfile -t fullstack-dev:local .
```

### SSH helper

`full-stack/setup-ssh.sh` copies your host public key into a running container for passwordless SSH (same behavior as before it lived under `legacy/`).

```bash
chmod +x legacy/full-stack/setup-ssh.sh
./legacy/full-stack/setup-ssh.sh my-dev-env
```
