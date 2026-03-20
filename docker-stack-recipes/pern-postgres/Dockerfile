# Dev environment: Node + git + psql client + global npm CLIs + OpenSSH (port 22).
# Node.js 22.x — current Maintenance LTS line (see https://nodejs.org/en/about/releases).
# No root password in the image; see entrypoint + .env.example.
FROM node:22-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        openssh-server \
        procps \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A

RUN npm install -g npm@latest typescript ts-node nodemon

COPY entrypoint.sh /usr/local/bin/pern-dev-entrypoint.sh
RUN chmod +x /usr/local/bin/pern-dev-entrypoint.sh

WORKDIR /workspace

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/pern-dev-entrypoint.sh"]
