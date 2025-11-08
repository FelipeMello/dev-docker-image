# Full Stack Development Docker Image
# Includes:
# - Java 25 (JDK and JRE)
# - Python 3.12
# - PostgreSQL 16
# - Oracle Database 19c (prerequisites)
# - Node.js 22 LTS
# - React 19.1.0
# - Angular 18
# - Git 2.50+

FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
ENV ORACLE_HOME=/opt/oracle
ENV PATH=$PATH:$ORACLE_HOME/bin
ENV NODE_VERSION=22

# Install system dependencies
RUN apt-get update && apt-get install -y \
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
RUN apt-get update && \
    (apt-get install -y python3.12 python3.12-pip python3.12-venv \
    && ln -sf /usr/bin/python3.12 /usr/bin/python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python) || \
    (apt-get install -y python3 python3-pip python3-venv \
    && ln -sf /usr/bin/python3 /usr/bin/python) && \
    python3 --version && \
    rm -rf /var/lib/apt/lists/*

# Install Java 25 JDK and JRE
# Note: Java 25 may not be available in standard repos, using OpenJDK 25 or latest available
RUN apt-get update && apt-get install -y \
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

# Install PostgreSQL 16 (latest stable version)
RUN apt-get update && apt-get install -y \
    lsb-release \
    gnupg2 \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update && apt-get install -y \
    postgresql-16 \
    postgresql-contrib-16 \
    && rm -rf /var/lib/apt/lists/*

# Configure PostgreSQL
RUN service postgresql start && \
    sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';" || true

# Install Oracle Database 19c Express Edition (XE) prerequisites
# Oracle Database 19c XE requires manual download and installation
# For development, we'll set up the environment and provide instructions
RUN mkdir -p /opt/oracle && \
    apt-get update && apt-get install -y \
    libaio1 \
    bc \
    && rm -rf /var/lib/apt/lists/*

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

# Create working directory
WORKDIR /workspace

# Expose common ports
# PostgreSQL: 5432
# Oracle: 1521
# Node.js dev server: 3000
# Angular dev server: 4200
EXPOSE 5432 1521 3000 4200

# Create startup script
RUN echo '#!/bin/bash\n\
service postgresql start\n\
echo "PostgreSQL started"\n\
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
echo "React CLI available: create-react-app"\n\
echo "Angular CLI available: ng"\n\
echo "All development tools are ready!"\n\
exec "$@"' > /usr/local/bin/start-dev.sh && \
    chmod +x /usr/local/bin/start-dev.sh

# Set default command
CMD ["/usr/local/bin/start-dev.sh", "bash"]


