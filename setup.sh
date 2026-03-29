#!/bin/bash
set -e

INSTALLED=()
ALREADY_INSTALLED=()
FAILED=()

echo "Setting up development environment..."

# Install package managers if needed
install_homebrew() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        if install_homebrew 2>/dev/null; then
            INSTALLED+=("Homebrew")
        else
            FAILED+=("Homebrew")
        fi
    else
        ALREADY_INSTALLED+=("Homebrew")
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt-get &> /dev/null; then
        echo "apt detected"
    elif command -v yum &> /dev/null; then
        echo "yum detected"
    elif command -v pacman &> /dev/null; then
        echo "pacman detected"
    else
        echo "Warning: No known package manager detected"
    fi
fi

# Install Git if not present
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    if command -v brew &> /dev/null; then
        brew install git && INSTALLED+=("Git") || FAILED+=("Git")
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y git && INSTALLED+=("Git") || FAILED+=("Git")
    elif command -v yum &> /dev/null; then
        sudo yum install -y git && INSTALLED+=("Git") || FAILED+=("Git")
    else
        echo "Error: Could not detect package manager. Please install Git manually."
        FAILED+=("Git")
    fi
else
    ALREADY_INSTALLED+=("Git")
fi

# Install OpenCode
if ! command -v opencode &> /dev/null; then
    echo "Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash && INSTALLED+=("OpenCode") || FAILED+=("OpenCode")
else
    ALREADY_INSTALLED+=("OpenCode")
fi

# Install Cursor
if ! command -v cursor &> /dev/null; then
    echo "Installing Cursor..."
    curl https://cursor.com/install -fsS | bash && INSTALLED+=("Cursor") || FAILED+=("Cursor")
else
    ALREADY_INSTALLED+=("Cursor")
fi

# Summary
echo ""
echo "========================================"
echo "           SETUP SUMMARY"
echo "========================================"

if [ ${#INSTALLED[@]} -gt 0 ]; then
    echo ""
    echo "INSTALLED:"
    for item in "${INSTALLED[@]}"; do
        echo "  [+] $item"
    done
fi

if [ ${#ALREADY_INSTALLED[@]} -gt 0 ]; then
    echo ""
    echo "ALREADY INSTALLED:"
    for item in "${ALREADY_INSTALLED[@]}"; do
        echo "  [=] $item"
    done
fi

if [ ${#FAILED[@]} -gt 0 ]; then
    echo ""
    echo "FAILED:"
    for item in "${FAILED[@]}"; do
        echo "  [!] $item"
    done
fi

echo ""
echo "========================================"
