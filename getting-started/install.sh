#!/bin/bash

# Check the root privileges
if [ "$(whoami)" != "root" ]; then
  echo "Requires root privileges"

  exit 1
fi

# Initialize the host OS variable
OS=$(uname -s)
case "$OS" in
    Linux)
        OS="linux"
        ;;
    Darwin)
        OS="mac"
        ;;
    *)
        echo "Unsupported OS: $OS"
        echo "Supported OS are Linux and MacOS"

        exit 1
        ;;
esac

# Initialize the host architecture variable
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        echo "Supported architectures are x86_64, aarch64, and arm64"

        exit 1
        ;;
esac

# Install the CLI
echo "Installing dxflow ..."
# Define a temporary directory for download
TEMP_DIR=$(mktemp -d)
CLI_ARCHIVE="${TEMP_DIR}/dxflow_${OS}_${ARCH}.tar.gz"

# Download the CLI archive
wget -qO "${CLI_ARCHIVE}" "https://github.com/diphyx/dxflow-docs/releases/download/v1.0.0/dxflow_1.0.0_${OS}_${ARCH}.tar.gz"
if [ $? -ne 0 ]; then
    echo "Failed to download ${CLI} from GitHub"
    echo "Please check your internet connection and try again"

    exit 1
fi

# Extract the CLI to /usr/local/bin
tar -xzf "${CLI_ARCHIVE}" -C /usr/local/bin
if [ $? -ne 0 ]; then
    echo "Failed to extract ${CLI} archive"
    echo "Please check the archive and try again"

    exit 1
fi

# Clean up the temporary directory
rm -rf "${TEMP_DIR}"

# Make the CLI executable
chmod +x "/usr/local/bin/dxflow"

# Done CLI installation
echo "dxflow installed successfully"
echo "You can verify the CLI installation by running: 'dxflow --version'"