#!/bin/bash

# Helper script to set up SSH key authentication for the development container

CONTAINER_NAME=${1:-my-dev-env}

echo "Setting up SSH key authentication for container: $CONTAINER_NAME"
echo ""

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Error: Container '$CONTAINER_NAME' not found!"
    echo "Please make sure the container is running or exists."
    exit 1
fi

# Check if SSH key exists
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "SSH key not found. Generating one..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
    echo "SSH key generated!"
fi

echo "Copying SSH public key to container..."
docker exec -it $CONTAINER_NAME mkdir -p /root/.ssh
docker cp ~/.ssh/id_rsa.pub $CONTAINER_NAME:/tmp/id_rsa.pub
docker exec -it $CONTAINER_NAME sh -c "cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && rm /tmp/id_rsa.pub"
docker exec -it $CONTAINER_NAME chmod 600 /root/.ssh/authorized_keys
docker exec -it $CONTAINER_NAME chmod 700 /root/.ssh

echo ""
echo "SSH key authentication set up successfully!"
echo ""
echo "You can now connect without password:"
echo "  ssh root@localhost -p 22"
echo ""
echo "Or if the container is on a remote host:"
echo "  ssh root@<container-host-ip> -p 22"

