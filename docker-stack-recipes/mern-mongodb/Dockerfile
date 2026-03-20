# Dev environment: Node + git + global npm CLIs + OpenSSH (sshd on port 22).
FROM node:20-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        openssh-server \
        procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Dev-only default; override at runtime with SSH_ROOT_PASSWORD (see entrypoint).
RUN echo 'root:dev123' | chpasswd

RUN npm install -g npm@latest typescript ts-node nodemon

COPY entrypoint.sh /usr/local/bin/mern-dev-entrypoint.sh
RUN chmod +x /usr/local/bin/mern-dev-entrypoint.sh

WORKDIR /workspace

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/mern-dev-entrypoint.sh"]
