# Full Stack Development Docker Image

A comprehensive Docker image for full-stack development and experimentation, providing a secure, isolated development environment with all the essential tools pre-installed.

## 📋 What is This Image For?

This Docker image is designed to provide a **complete, isolated development environment** for full-stack development. It includes all the necessary tools and technologies to build modern applications without cluttering your local machine or risking conflicts between different project requirements.

### Included Technologies

This image includes the following technologies with their specific versions:

| Technology | Version | Release Date | Notes |
|------------|---------|--------------|-------|
| **Java** | 25 | September 2025 | JDK and JRE included |
| **Maven** | 3.8.7 | - | Java build tool and dependency management (from Ubuntu 24.04 repos) |
| **Python** | 3.12 | May 2024 | Latest stable version |
| **Python Packages** | Latest (min versions) | - | pyarrow (>=18.0.0), pandas (>=2.2.0), numpy (>=2.0.0) - pip installs latest available versions meeting requirements |
| **PostgreSQL** | 16 | May 2024 | Latest stable version |
| **Oracle Database** | 19c | 2019 | Prerequisites installed (full installation requires manual setup) |
| **Node.js** | 22 LTS | 2024 | Long-Term Support version |
| **Apache Arrow** | ^16.1.0 | - | Cross-language data processing (Node.js) |
| **React** | 19.1.0 | March 2025 | Latest stable version |
| **Angular** | 18 | 2025 | Latest stable version |
| **Git** | 2.50+ | 2025 | Version control system |

**Additional Tools**: TypeScript, Yarn, PM2, Nodemon, and more development utilities.

> **Note**: Version information is current as of November 2025. Check the Dockerfile for the exact versions installed. Some versions may fall back to alternatives if the specified version is not available in repositories.

## 🎯 Why Use This Image?

### Security & Isolation
- **Isolated Environment**: Keep your host machine clean and secure by running all development tools inside a container
- **No System Pollution**: Avoid installing multiple versions of Node.js, Java, Python, and databases directly on your machine
- **Easy Cleanup**: Remove the container when done - no leftover files or configurations
- **Consistent Environment**: Same environment across different machines and team members

### Convenience
- **One-Stop Solution**: All development tools in a single image
- **Quick Setup**: No need to install and configure each tool individually
- **Portable**: Works the same way on Windows, macOS, and Linux
- **Version Management**: Easy to maintain specific versions of tools

### Development Benefits
- **Experimentation**: Safe space to try new technologies without affecting your main system
- **Multiple Projects**: Run different projects with different requirements simultaneously
- **Team Consistency**: Share the same development environment with your team
- **CI/CD Ready**: Use the same environment locally and in CI/CD pipelines

## 🕐 When to Use This Image

Use this Docker image when you:

- ✅ Need a **secure, isolated development environment** on your local machine
- ✅ Want to **experiment** with full-stack technologies without installing them locally
- ✅ Work on **multiple projects** with different technology requirements
- ✅ Need a **consistent development environment** across team members
- ✅ Want to **protect your host system** from development tool installations
- ✅ Are learning new technologies and want a **safe sandbox environment**
- ✅ Need to quickly **spin up a development environment** for demos or testing
- ✅ Want to **avoid conflicts** between different versions of tools on your system

## 🚀 How to Use This Image

### Prerequisites

Before you begin, ensure you have:
- **Docker** installed on your machine ([Download Docker](https://www.docker.com/get-started))
- Basic knowledge of Docker commands
- At least 10GB of free disk space (for the image and containers)

### Option 1: Use Pre-built Image from GitHub Packages (Recommended)

The easiest way is to use the pre-built image from GitHub Packages:

```bash
# Login to GitHub Container Registry (first time only)
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
# Or use: docker login ghcr.io -u YOUR_GITHUB_USERNAME

# Pull the pre-built image
docker pull ghcr.io/felipeMello/dev-docker-image:latest

# Tag it for easier use (optional)
docker tag ghcr.io/felipeMello/dev-docker-image:latest fullstack-dev:latest
```

**Note**: Replace `felipeMello` with your GitHub username. The image is automatically built and published on every push to the main branch.

### Option 2: Build the Docker Image Locally

If you prefer to build the image yourself:

```bash
# Navigate to the project directory
cd dev-docker-image

# Build the Docker image
docker build -t fullstack-dev:latest .
```

**Note**: The build process may take 10-20 minutes depending on your internet connection, as it downloads and installs all the required tools.

### Step 2: Verify the Image

Check that the image was built successfully:

```bash
docker images | grep fullstack-dev
```

You should see your image listed with the tag `fullstack-dev:latest`.

### Step 3: Run the Container

Start a container from the image:

```bash
docker run -it --name my-dev-env \
  -p 22:22 \
  -p 3000:3000 \
  -p 4200:4200 \
  -p 5432:5432 \
  -p 1521:1521 \
  -v $(pwd)/workspace:/workspace \
  fullstack-dev:latest
```

**Explanation of flags:**
- `-it`: Interactive terminal mode
- `--name my-dev-env`: Name your container for easy reference
- `-p 22:22`: Map port 22 (SSH for remote access)
- `-p 3000:3000`: Map port 3000 (React/Node.js dev server)
- `-p 4200:4200`: Map port 4200 (Angular dev server)
- `-p 5432:5432`: Map port 5432 (PostgreSQL)
- `-p 1521:1521`: Map port 1521 (Oracle Database)
- `-v $(pwd)/workspace:/workspace`: Mount a local directory to `/workspace` in the container

### Step 4: Verify Installation

Once the container starts, you'll see version information for all installed tools. You can also manually verify:

```bash
# Check Java
java -version

# Check Python
python --version

# Check Node.js
node --version
npm --version

# Check Git
git --version

# Check PostgreSQL
psql --version

# Check Maven version
mvn --version

# Check Python packages (shows actual installed versions)
pip3 show pyarrow pandas numpy | grep -E "^Name:|^Version:"
# Or check programmatically:
python3 -c "import pyarrow; print(f'pyarrow: {pyarrow.__version__}')"
python3 -c "import pandas; print(f'pandas: {pandas.__version__}')"
python3 -c "import numpy; print(f'numpy: {numpy.__version__}')"

# Check Apache Arrow (Node.js)
node -e "console.log('apache-arrow:', require('apache-arrow').version || 'installed')"

# Check React CLI
create-react-app --version

# Check Angular CLI
ng version
```

### Step 5: Start Development

#### Working with Node.js/React Projects

```bash
# Create a new React app
cd /workspace
create-react-app my-react-app
cd my-react-app
npm start
```

#### Working with Angular Projects

```bash
# Create a new Angular app
cd /workspace
ng new my-angular-app
cd my-angular-app
ng serve
```

#### Working with Python Projects

```bash
# Create a Python virtual environment
cd /workspace
python -m venv my-python-env
source my-python-env/bin/activate
pip install <your-packages>
```

#### Working with PostgreSQL

```bash
# Start PostgreSQL service (if not already running)
service postgresql start

# Connect to PostgreSQL
sudo -u postgres psql

# Or create a new database
sudo -u postgres createdb mydb
```

#### Working with Java Projects

```bash
# Compile Java files
javac MyClass.java

# Run Java programs
java MyClass

# Using Maven for project builds
cd /workspace/my-java-project
mvn clean install
mvn spring-boot:run  # For Spring Boot projects
```

#### Working with Python Data Processing

```bash
# Python data processing packages are pre-installed
python3 -c "import pyarrow; print(pyarrow.__version__)"
python3 -c "import pandas; print(pandas.__version__)"
python3 -c "import numpy; print(numpy.__version__)"

# Create a Python script using these packages
cd /workspace
python3 my_data_script.py
```

#### Working with Apache Arrow (Cross-Language Data Processing)

```bash
# Apache Arrow is installed globally for Node.js
node -e "const arrow = require('apache-arrow'); console.log('Apache Arrow loaded')"

# For Python, pyarrow is already installed
python3 -c "import pyarrow as pa; print('Apache Arrow for Python ready')"

# For Java, add Apache Arrow dependencies to your pom.xml
# The libraries are available via Maven Central
```

### Step 6: Access Your Projects

- **React App**: Open `http://localhost:3000` in your browser
- **Angular App**: Open `http://localhost:4200` in your browser
- **PostgreSQL**: Connect using `localhost:5432` with user `postgres` and password `postgres`

### Step 6.5: Remote Development Access (SSH)

The container includes an SSH server for remote development access. This allows you to connect from:
- VS Code Remote SSH extension
- Other IDEs with SSH support (IntelliJ, PyCharm, etc.)
- Remote machines on your network
- CI/CD pipelines
- Any SSH client

#### Starting Container for Remote Access

For remote development, start the container in **detached mode** so it runs in the background:

```bash
docker run -d --name my-dev-env \
  -p 22:22 \
  -p 3000:3000 \
  -p 4200:4200 \
  -p 5432:5432 \
  -p 1521:1521 \
  -v $(pwd)/workspace:/workspace \
  fullstack-dev:latest
```

The container will automatically:
- Start SSH server on port 22
- Start PostgreSQL database
- Keep running in the background
- Display all tool versions on startup

#### Connect via SSH

**Option 1: Password Authentication (Quick Start)**
```bash
ssh root@localhost -p 22
# Password: dev123
```

**Option 2: SSH Key Authentication (Recommended - More Secure)**

**Using the helper script (easiest):**
```bash
# Make sure the script is executable
chmod +x setup-ssh.sh

# Run the setup script
./setup-ssh.sh my-dev-env

# Now connect without password
ssh root@localhost -p 22
```

**Manual setup:**
```bash
# Generate SSH key if you don't have one
ssh-keygen -t rsa -b 4096

# Copy your public key to the container
docker exec my-dev-env mkdir -p /root/.ssh
docker cp ~/.ssh/id_rsa.pub my-dev-env:/tmp/id_rsa.pub
docker exec my-dev-env sh -c "cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys && chmod 700 /root/.ssh && rm /tmp/id_rsa.pub"

# Now connect without password
ssh root@localhost -p 22
```

**From a remote machine:**
```bash
# First, find your Docker host IP
ifconfig | grep "inet " | grep -v 127.0.0.1
# Or on Windows: ipconfig

# Then connect (replace with your actual IP)
ssh root@<your-docker-host-ip> -p 22
# Password: dev123 (or use SSH key)
```

#### VS Code Remote Development

1. **Install Extension**: Install the **Remote - SSH** extension in VS Code
2. **Connect**: Press `F1` (or `Cmd+Shift+P` on Mac) and select "Remote-SSH: Connect to Host"
3. **Enter Host**: Type `root@localhost:22` (or `root@<your-docker-host-ip>:22` for remote access)
4. **Authenticate**: 
   - If using SSH key: It will use your key automatically
   - If using password: Enter `dev123` when prompted
5. **Open Folder**: Once connected, open the `/workspace` folder in VS Code
6. **Start Coding**: You now have full access to all development tools in the container!

**VS Code SSH Config (Optional):**
Add to `~/.ssh/config` for easier connection:
```
Host dev-container
    HostName localhost
    Port 22
    User root
    IdentityFile ~/.ssh/id_rsa
```

Then connect with: `ssh dev-container` or select "dev-container" in VS Code.

#### Find Container IP Address

If you need the container's IP address for remote access:

```bash
# Get container IP
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-dev-env

# Or get all network info
docker inspect my-dev-env | grep IPAddress
```

#### Verify SSH Connection

Test your SSH connection:
```bash
# Test connection and run a command
ssh root@localhost -p 22 "echo 'Connection successful!' && node --version && python --version"

# Or connect interactively
ssh root@localhost -p 22
```

#### Container Management for Remote Access

```bash
# Check if container is running
docker ps --filter "name=my-dev-env"

# View container logs
docker logs my-dev-env

# Stop the container
docker stop my-dev-env

# Start the container again
docker start my-dev-env

# Restart the container
docker restart my-dev-env
```

**Security Note**: 
- The default password is `dev123` for development purposes. **Change it for production use!**
- For production, use SSH key authentication only and disable password authentication
- Consider creating a non-root user for better security

### Step 7: Stop and Start the Container

When you're done working:

```bash
# Exit the container (or use Ctrl+D)
exit

# Stop the container
docker stop my-dev-env

# Start it again later
docker start -ai my-dev-env
```

### Step 8: Remove the Container (Optional)

If you want to completely remove the container:

```bash
# Stop the container first
docker stop my-dev-env

# Remove the container
docker rm my-dev-env
```

**Note**: Removing the container does NOT delete the image. You can always create a new container from the same image.

## 📁 Working with Your Files

### Mounting Local Directories

To work with files on your host machine, mount directories when running the container:

```bash
docker run -it --name my-dev-env \
  -v /path/to/your/projects:/workspace \
  -p 3000:3000 -p 4200:4200 \
  fullstack-dev:latest
```

### Persisting Data

Database data and installed packages are stored in the container. To persist data:

```bash
# Create a named volume for PostgreSQL data
docker volume create postgres-data

# Run container with volume
docker run -it --name my-dev-env \
  -v postgres-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  fullstack-dev:latest
```

## 🔧 Common Use Cases

### Use Case 1: Quick Project Setup

```bash
# Start container
docker run -it --name quick-dev \
  -v $(pwd):/workspace \
  -p 3000:3000 \
  fullstack-dev:latest

# Inside container: Create and run React app
cd /workspace
create-react-app my-app
cd my-app
npm start
```

### Use Case 2: Multiple Projects

```bash
# Project 1 - React
docker run -it --name react-project \
  -v $(pwd)/react-app:/workspace \
  -p 3000:3000 \
  fullstack-dev:latest

# Project 2 - Angular (in another terminal)
docker run -it --name angular-project \
  -v $(pwd)/angular-app:/workspace \
  -p 4201:4200 \
  fullstack-dev:latest
```

### Use Case 3: Database Development

```bash
# Start container with PostgreSQL
docker run -it --name db-dev \
  -p 5432:5432 \
  fullstack-dev:latest

# Inside container
service postgresql start
sudo -u postgres psql
```

## 🛠️ Troubleshooting

### Port Already in Use

If you get a port conflict error:

```bash
# Use different ports
docker run -it --name my-dev-env \
  -p 3001:3000 \
  -p 4201:4200 \
  fullstack-dev:latest
```

### Container Won't Start

```bash
# Check container logs
docker logs my-dev-env

# Remove and recreate
docker rm my-dev-env
docker run -it --name my-dev-env fullstack-dev:latest
```

### Permission Issues

If you encounter permission issues with mounted volumes:

```bash
# On Linux/macOS, ensure directory permissions
chmod -R 755 /path/to/your/projects
```

## 🔒 Security Best Practices

1. **Don't Run as Root**: Consider creating a non-root user in the container for production use
2. **Limit Port Exposure**: Only expose ports you actually need
3. **Use Secrets Management**: Don't hardcode passwords or API keys
4. **Regular Updates**: Rebuild the image periodically to get security updates
5. **Isolate Networks**: Use Docker networks to isolate containers

## 📝 Notes

### Version Information

- **Java 25**: If Java 25 is not available in Ubuntu repositories, the image will fall back to the latest available OpenJDK version (typically Java 21).
- **Maven 3.8.7**: Installed from Ubuntu 24.04 repositories. Used for Java project builds and dependency management. Version 3.8.7 is the latest available in Ubuntu 24.04 repos.
- **Python 3.12**: Installed from Ubuntu repositories. If 3.12 is not available, the latest Python 3.x version will be installed.
- **Python Packages**: 
  - **pyarrow** (>=18.0.0): Apache Arrow Python bindings - pip installs the latest version meeting this minimum requirement
  - **pandas** (>=2.2.0): Data analysis library - pip installs the latest version meeting this minimum requirement
  - **numpy** (>=2.0.0): Numerical computing - pip installs the latest version meeting this minimum requirement
  - Note: Exact versions installed depend on what's available in PyPI at build time. Check with `pip3 show <package>` to see actual installed versions.
- **PostgreSQL 16**: Installed from official PostgreSQL APT repository. If unavailable, the default PostgreSQL version from Ubuntu repos will be used.
- **Node.js 22 LTS**: Installed from NodeSource repository. This is the current Long-Term Support version.
- **Apache Arrow**: Installed globally for Node.js (^16.1.0) for cross-language data processing. Python version (pyarrow) is also included.
- **React 19.1.0**: Installed globally via npm. You can use `create-react-app` to create new React projects.
- **Angular 18**: Angular CLI installed globally. Use `ng new` to create new Angular projects.
- **Oracle Database 19c**: The image includes prerequisites for Oracle Database. Full Oracle installation requires downloading from Oracle's website and may need additional setup.

### General Notes

- **Data Persistence**: Remember that data in containers is ephemeral unless you use volumes.
- **Version Updates**: To update to newer versions, rebuild the Docker image with updated version numbers in the Dockerfile.

## 🔧 Customization & Extending the Image

This Docker image is designed to be a starting point for your development needs. You can easily fork this project and customize it to add additional technologies or modify existing ones.

### Forking and Adding Technologies

1. **Fork the Repository**: Fork this project to your own GitHub account
2. **Clone Your Fork**: Clone your forked repository locally
   ```bash
   git clone https://github.com/your-username/dev-docker-image.git
   cd dev-docker-image
   ```

3. **Edit the Dockerfile**: Add your desired technologies to the Dockerfile. For example:
   ```dockerfile
   # Add MongoDB
   RUN apt-get update && apt-get install -y mongodb

   # Add Redis
   RUN apt-get update && apt-get install -y redis-server

   # Add Ruby
   RUN apt-get update && apt-get install -y ruby-full

   # Add Go
   RUN wget https://go.dev/dl/go1.21.linux-amd64.tar.gz && \
       tar -C /usr/local -xzf go1.21.linux-amd64.tar.gz
   ```

4. **Update the README**: Don't forget to update the README with your new technologies and their versions

5. **Build Your Custom Image**: Build your customized image
   ```bash
   docker build -t my-custom-dev:latest .
   ```

6. **Test Your Image**: Run and test your customized image
   ```bash
   docker run -it --name my-custom-dev my-custom-dev:latest
   ```

### Tips for Adding Technologies

- **Keep it Modular**: Add each technology in its own `RUN` command or clearly separated sections
- **Document Versions**: Always specify version numbers, not just "latest"
- **Update Ports**: Remember to expose any additional ports your new technologies need
- **Test Thoroughly**: Make sure all technologies work together without conflicts
- **Share Your Fork**: Consider sharing your customized version with the community!

### Example: Adding MongoDB

```dockerfile
# Add MongoDB 7.0
RUN wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | apt-key add - && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    rm -rf /var/lib/apt/lists/*
```

Then update the `EXPOSE` directive to include MongoDB's default port (27017):
```dockerfile
EXPOSE 5432 1521 3000 4200 27017
```

## 🔄 CI/CD and Automated Builds

This repository includes GitHub Actions workflows that automatically build and publish the Docker image to GitHub Packages.

### Automated Publishing

The Docker image is automatically built and published when you:
- Push to `main`, `master`, or `felipeSilvaDeMelloStudentAccount` branches
- Create a new tag (e.g., `v1.0.0`)
- Manually trigger the workflow from GitHub Actions

### Image Location

Published images are available at:
```
ghcr.io/felipeMello/dev-docker-image:latest
ghcr.io/felipeMello/dev-docker-image:<branch-name>
ghcr.io/felipeMello/dev-docker-image:<tag>
```

### Using the Published Image

```bash
# Pull the latest image
docker pull ghcr.io/felipeMello/dev-docker-image:latest

# Or pull a specific branch/tag
docker pull ghcr.io/felipeMello/dev-docker-image:felipeSilvaDeMelloStudentAccount
```

### Workflow Details

The workflow (`/.github/workflows/docker-publish.yml`) includes:
- Multi-platform builds (AMD64 and ARM64)
- Docker layer caching for faster builds
- Automatic tagging based on branch, PR, or version tags
- Build verification on pull requests
- **Security scanning** with Trivy (see Security section below)

## 🔒 Security Scanning

This repository includes automated security scanning to ensure the Docker image is safe to use.

### Automated Security Checks

Every build automatically includes:

1. **Repository Scanning**: Scans the codebase for vulnerabilities and security issues
2. **Docker Image Scanning**: Scans the built Docker image for known vulnerabilities in installed packages
3. **Dependency Scanning**: Checks all dependencies for security vulnerabilities

### Security Tools

- **Trivy**: Comprehensive vulnerability scanner for containers and filesystems
- **GitHub Security**: Results are automatically uploaded to GitHub's Security tab
- **SARIF Format**: Results are stored in SARIF format for integration with security tools

### Security Policy

- **Critical and High severity** vulnerabilities will **fail the build** to prevent publishing vulnerable images
- **Medium severity** vulnerabilities are reported but don't block the build
- All scan results are available in the GitHub Security tab

### Viewing Security Results

1. Go to your repository on GitHub
2. Click on the **Security** tab
3. View **Code scanning alerts** to see all detected vulnerabilities
4. Review and address any critical or high-severity issues

### Security Best Practices

- Regularly update base images and dependencies
- Review security alerts in the GitHub Security tab
- Keep your Docker image updated with the latest security patches
- Use the latest stable versions of all tools

## 🤝 Contributing

Feel free to submit issues or pull requests to improve this development image! If you've created a useful customization, consider sharing it with the community.

## 📄 License

This Docker image is provided as-is for development purposes.

---

**Happy Coding! 🚀**

