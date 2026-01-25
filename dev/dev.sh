#!/bin/bash

CONTAINER_NAME="dev"
IMAGE_NAME="dev:latest"

# 1. Check if the container is already running
if [ "$(podman inspect -f '{{.State.Running}}' $CONTAINER_NAME 2>/dev/null)" == "true" ]; then
    echo "Container is already running. Entering..."
    podman exec -it $CONTAINER_NAME /bin/bash
    exit 0
fi

# 2. If it exists but is stopped, start it
if podman ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "Starting stopped container..."
    podman start $CONTAINER_NAME
    echo "Entering..."
    podman exec -it $CONTAINER_NAME /bin/bash
    exit 0
fi

# 3. Otherwise, run a fresh one in the background (-d)
echo "Starting a fresh background container..."
xhost +si:localuser:$(whoami) > /dev/null

podman run -d \
  --name $CONTAINER_NAME \
  --userns=keep-id \
  --security-opt label=disable \
  -v "$HOME/workspace:/workspace:Z" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/wayland-0:ro" \
  -e DISPLAY=$DISPLAY \
  -e WAYLAND_DISPLAY=wayland-0 \
  -e XDG_RUNTIME_DIR=/tmp \
  -e PS1='\[\033[01;35m\]📦 [DEV] \w \$ \[\033[00m\]' \
  -e TERM=xterm-256color \
  --dns 8.8.8.8 \
  --dns 1.1.1.1 \
  --cap-add=NET_RAW \
  --device /dev/dri \
  --device /dev/kfd \
  --device /dev/bus/usb \
  -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
  --group-add keep-groups \
  --network bridge \
  --network dev_network \
  $IMAGE_NAME \
  sleep infinity  # This keeps the container alive in the background


# `--network bridge` gives the container access to the internet.
# `--network dev_network` lets the container talk to services in the internal dev network.

echo "Entering..."
# Drop user into the newly started container
podman exec -it $CONTAINER_NAME /bin/bash