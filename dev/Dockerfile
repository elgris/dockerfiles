FROM registry.fedoraproject.org/fedora:43

LABEL maintainer="yourname"
LABEL description="Fedora 43 Dev Container with AMD GPU, Wayland, and VSCode support"

# Avoid dozens of warning messages during package installation
ENV TERM=xterm

# 1. Update system and install dependencies
# We install:
# - Basic dev tools (git, curl, etc.)
# - Wayland libraries and common X11/GTK/GLib dependencies required by Electron apps (VSCode)
# - Mesa drivers for AMD GPU hardware acceleration
# - USB and Bluetooth utilities
# - Sudo for administrative tasks inside the container
RUN dnf -y update && \
    dnf -y install \
    # Development basics
    bash-completion git curl wget which nano htop tar xz \
    # GUI/Wayland/Electron dependencies (FIXED NAMES)
    libwayland-client libwayland-cursor libxkbcommon dbus-glib dbus-x11 \
    libX11 libX11-xcb libXcomposite libXdamage libXext libXfixes libXrandr libxcb \
    alsa-lib nss nspr atk at-spi2-atk cups-libs \
    expat gdk-pixbuf2 gtk3 libdrm libgbm pango cairo \
    libnotify libsecret xdg-utils \
    # AMD GPU Drivers (Mesa)
    mesa-dri-drivers mesa-vulkan-drivers mesa-libEGL mesa-libGL vulkan-loader glx-utils \
    # Device interaction tools
    usbutils bluez \
    # Process management & Sudo
    procps-ng sudo \
    && dnf clean all

# 2. Install Visual Studio Code
# Import the Microsoft GPG key, add the repository, and install 'code'
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
    dnf -y install code && \
    dnf clean all

# 3. User Setup for --userns=keep-id alignment
# We create a user named 'dev' with UID/GID 1000.
# When using Podman's keep-id, your host UID (likely 1000) maps to this inside user.
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user and group
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/bash && \
    # Allow passwordless sudo for convenience inside the dev environment
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# 4. Prepare workspace directory
RUN mkdir -p /workspace && \
    chown $USERNAME:$USERNAME /workspace

# 5. Set environment variables for better GUI app behavior
# Tell apps to favor Wayland over X11 if possible
ENV GDK_BACKEND=wayland,x11
ENV QT_QPA_PLATFORM=wayland;xcb
# Fix for some Electron apps rendering poorly
ENV ELECTRON_OZONE_PLATFORM_HINT=auto

# Switch to the non-root user
USER $USERNAME
WORKDIR /workspace

CMD ["/bin/bash"]