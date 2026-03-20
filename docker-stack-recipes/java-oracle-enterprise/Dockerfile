# Dev environment: Eclipse Temurin JDK 21 + Maven + Node.js (Angular tooling) + OpenSSH.
# Oracle runs in the separate `database` service — this image is your dev workstation.
#
# Node is copied from the official Node image (same major as MERN/PERN) instead of curl|bash
# installers, for clearer supply-chain behaviour and reproducible layers.
FROM node:22-bookworm AS node22

FROM eclipse-temurin:21-jdk-noble

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        maven \
        openssh-server \
        procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=node22 /usr/local/include/node /usr/local/include/node
COPY --from=node22 /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node22 /usr/local/bin/node /usr/local/bin/node
COPY --from=node22 /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node22 /usr/local/bin/npx /usr/local/bin/npx
COPY --from=node22 /usr/local/bin/corepack /usr/local/bin/corepack

# Pin CLI major for reproducible `ng` behaviour; use the Node image’s bundled npm.
RUN npm install -g @angular/cli@19.2.0

RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A

COPY entrypoint.sh /usr/local/bin/java-oracle-dev-entrypoint.sh
RUN chmod +x /usr/local/bin/java-oracle-dev-entrypoint.sh

WORKDIR /workspace

EXPOSE 22
ENTRYPOINT ["/usr/local/bin/java-oracle-dev-entrypoint.sh"]
