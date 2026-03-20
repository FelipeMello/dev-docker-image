# Dev environment: Node + git + global npm CLIs + OpenSSH (sshd on port 22).
# No root password is set in the image; see entrypoint + .env.example.
FROM node:20-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        openssh-server \
        procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A

RUN npm install -g npm@latest typescript ts-node nodemon

COPY entrypoint.sh /usr/local/bin/mern-dev-entrypoint.sh
RUN chmod +x /usr/local/bin/mern-dev-entrypoint.sh

WORKDIR /workspace

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/mern-dev-entrypoint.sh"]
