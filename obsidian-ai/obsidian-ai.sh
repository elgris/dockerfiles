#!/usr/bin/env bash

# Configuration Variables
CONTAINER_NAME="obsidian-ai-container"
IMAGE_NAME="obsidian-ai-image"
NETWORK_NAME="dev-network"
CONTAINER_USER="pi" # Must match the user inside the container

# 1. Create and launch the container if it doesn't exist yet
if ! podman container exists "$CONTAINER_NAME"; then
    echo "Workspace '$CONTAINER_NAME' not found. Spooling up a new instance..."
    
    podman run -d \
      --name "$CONTAINER_NAME" \
      --network "$NETWORK_NAME" \
      --userns=keep-id \
      -v ~/.config/obsidian-ai/agent/:/home/${CONTAINER_USER}/.pi/agent/:U,Z \
      -v ~/Documents/Obsidian/:/workspace:ro,Z \
      -e PS1="\[\e[1;95m\][𝝿-Obsidian-AI]\[\e[0m\] \[\e[32m\]\w\[\e[0m\] \$" \
      "$IMAGE_NAME" > /dev/null

    if [ $? -ne 0 ]; then
        echo "Error: Failed to spin up the container."
        echo "Verify that the network '$NETWORK_NAME' and image '$IMAGE_NAME' exist."
        exit 1
    fi
    echo "Workspace container initialized."
fi

# 2. Start the container if it was stopped (e.g., after a host reboot)
STATE=$(podman inspect -f '{{.State.Status}}' "$CONTAINER_NAME" 2>/dev/null)
if [ "$STATE" != "running" ]; then
    echo "Waking up '$CONTAINER_NAME'..."
    podman start "$CONTAINER_NAME" > /dev/null
fi

# 3. Enter the container or execute commands
if [ $# -eq 0 ]; then
    # No arguments passed -> open an interactive shell
    echo "Connected to Pi workspace (as ${CONTAINER_USER}). (Type 'exit' to detach)"
    podman exec -it --user "$CONTAINER_USER" "$CONTAINER_NAME" /bin/sh
else
    # Arguments passed -> forward them directly into the container execution line
    podman exec -it --user "$CONTAINER_USER" "$CONTAINER_NAME" "$@"
fi