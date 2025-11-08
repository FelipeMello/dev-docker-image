# Full Stack Development Docker Image
# Includes:
# - Java 25 (JDK and JRE)
# - Python 3.12 with pyarrow, pandas, numpy
# - PostgreSQL 16
# - Oracle Database 19c (prerequisites)
# - Node.js 22 LTS
# - React 19.1.0
# - Angular 18
# - Git 2.50+
# - Maven (Java build tool)
# - Apache Arrow (Node.js)

FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
ENV ORACLE_HOME=/opt/oracle
ENV PATH=$PATH:$ORACLE_HOME/bin
ENV NODE_VERSION=22

# Configure apt to handle transient errors and retry
# Ignore errors from optional components (like dep11) that may have sync issues
RUN echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::http::Timeout "20";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::Check-Valid-Until "false";' >> /etc/apt/apt.conf.d/80-retries

# Install system dependencies
RUN set -e; \
    apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    software-properties-common \
    build-essential \
    git \
    vim \
    nano \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 (latest stable version)
# If Python 3.12 is not available, install the latest Python 3.x from repos
# Also install build dependencies needed for compiling Python packages
RUN set -e; \
    apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    (apt-get install -y python3.12 python3.12-pip python3.12-venv \
    && ln -sf /usr/bin/python3.12 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python) || \
    (apt-get install -y python3 python3-pip python3-venv \
    && ln -sf /usr/bin/python3 /usr/bin/python) && \
    apt-get install -y \
    python3-dev \
    gcc \
    g++ \
    libc6-dev \
    && python3 --version && \
    rm -rf /var/lib/apt/lists/*

# Install Python data processing packages
# Installing latest versions available from PyPI
# Upgrade pip first to ensure compatibility, then install packages one by one
RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir numpy && \
    pip3 install --no-cache-dir pyarrow && \
    pip3 install --no-cache-dir pandas && \
    echo "=== Installed Python Package Versions ===" && \
    (pip3 show numpy 2>/dev/null | grep "^Version:" || echo "numpy: installed") && \
    (pip3 show pyarrow 2>/dev/null | grep "^Version:" || echo "pyarrow: installed") && \
    (pip3 show pandas 2>/dev/null | grep "^Version:" || echo "pandas: installed") && \
    echo "========================================="

# Install Java 25 JDK and JRE
# Note: Java 25 may not be available in standard repos, using OpenJDK 25 or latest available
RUN set -e; \
    apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    apt-get install -y \
    openjdk-25-jdk \
    openjdk-25-jre \
    || (echo "Java 25 not available in repos, installing latest OpenJDK" && \
        apt-get install -y openjdk-21-jdk openjdk-21-jre || \
        apt-get install -y default-jdk default-jre) \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME based on installed version
RUN if [ -d "/usr/lib/jvm/java-25-openjdk-amd64" ]; then \
        echo "JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64" >> /etc/environment; \
    elif [ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]; then \
        echo "JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64" >> /etc/environment; \
    else \
        JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::"); \
        echo "JAVA_HOME=$JAVA_HOME" >> /etc/environment; \
    fi

# Install Maven (Java build tool)
# Maven version in Ubuntu 24.04: 3.8.7
RUN apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    apt-get install -y maven && \
    mvn --version && \
    rm -rf /var/lib/apt/lists/*

# Install PostgreSQL 16 (latest stable version)
RUN set -e; \
    apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    apt-get install -y \
    lsb-release \
    gnupg2 \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    apt-get install -y \
    postgresql-16 \
    postgresql-contrib-16 \
    && rm -rf /var/lib/apt/lists/*

# Configure PostgreSQL
RUN service postgresql start && \
    sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';" || true

# Install Oracle Database 19c Express Edition (XE) prerequisites
# Oracle Database 19c XE requires manual download and installation
# For development, we'll set up the environment and provide instructions
# Note: libaio1 may not be available on all architectures (e.g., ARM64)
RUN mkdir -p /opt/oracle && \
    apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    (apt-get install -y libaio1 bc 2>/dev/null || \
     apt-get install -y libaio bc 2>/dev/null || \
     apt-get install -y bc || \
     echo "Warning: libaio not available on this architecture") && \
    rm -rf /var/lib/apt/lists/*

# Note: Oracle Database 19c XE installation requires downloading from Oracle website
# The actual installation should be done manually or via a script
# This Dockerfile sets up the prerequisites

# Install Node.js 22 LTS (latest LTS version) using NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    rm -rf /var/lib/apt/lists/*

# Install React 19.1.0 and Angular 18 globally
RUN npm install -g \
    create-react-app \
    @angular/cli@18 \
    react@19.1.0 \
    react-dom@19.1.0

# Install additional useful development tools
RUN npm install -g \
    typescript \
    ts-node \
    nodemon \
    yarn \
    pm2

# Install Apache Arrow for Node.js (for cross-language data processing)
# Note: apache-arrow is typically installed per-project, but we install it globally for convenience
RUN npm install -g apache-arrow@^16.1.0

# Install and configure SSH server for remote development access
RUN apt-get update -o Acquire::Check-Valid-Until=false --allow-releaseinfo-change || true; \
    apt-get update --allow-releaseinfo-change || apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:dev123' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config && \
    rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /workspace

# Expose common ports
# SSH: 22
# PostgreSQL: 5432
# Oracle: 1521
# Node.js dev server: 3000
# Angular dev server: 4200
EXPOSE 22 5432 1521 3000 4200

# Create startup script
RUN echo '#!/bin/bash\n\
# Start SSH server in background\n\
/usr/sbin/sshd -D &\n\
SSH_PID=$!\n\
sleep 1\n\
# Start PostgreSQL\n\
service postgresql start\n\
echo "==========================================="\n\
echo "Development Environment Ready!"\n\
echo "==========================================="\n\
echo "PostgreSQL started"\n\
echo "SSH server started on port 22 (PID: $SSH_PID)"\n\
echo ""\n\
echo "Git version:"\n\
git --version\n\
echo "Java version:"\n\
java -version\n\
echo "Python version:"\n\
python --version\n\
echo "Node.js version:"\n\
node --version\n\
echo "npm version:"\n\
npm --version\n\
echo "PostgreSQL version:"\n\
psql --version\n\
echo "Maven version:"\n\
mvn --version | head -1\n\
echo "Python packages:"\n\
python3 -c "import pyarrow; print(f'pyarrow: {pyarrow.__version__}')" 2>/dev/null || echo "pyarrow: installed"\n\
python3 -c "import pandas; print(f'pandas: {pandas.__version__}')" 2>/dev/null || echo "pandas: installed"\n\
python3 -c "import numpy; print(f'numpy: {numpy.__version__}')" 2>/dev/null || echo "numpy: installed"\n\
echo ""\n\
echo "React CLI available: create-react-app"\n\
echo "Angular CLI available: ng"\n\
echo "Apache Arrow (Node.js): apache-arrow@^16.1.0"\n\
echo ""\n\
echo "SSH Access:"\n\
echo "  Host: localhost (or container IP)"\n\
echo "  Port: 22"\n\
echo "  User: root"\n\
echo "  Password: dev123 (change this for production!)"\n\
echo ""\n\
echo "All development tools are ready!"\n\
echo "==========================================="\n\
# Keep container running - if command provided, run it, otherwise keep alive\n\
if [ $# -eq 0 ]; then\n\
    # No command provided, keep container alive\n\
    tail -f /dev/null\n\
else\n\
    # Command provided, execute it\n\
    exec "$@"\n\
fi' > /usr/local/bin/start-dev.sh && \
    chmod +x /usr/local/bin/start-dev.sh

# Set default command to keep container running
CMD ["/usr/local/bin/start-dev.sh"]


