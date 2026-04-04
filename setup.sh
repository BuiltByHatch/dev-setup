#!/bin/bash
set -e

INSTALLED=()
ALREADY_INSTALLED=()
FAILED=()

TASKS=(
    "Checking package manager"
    "Installing Homebrew"
    "Installing Git"
    "Installing OpenCode"
    "Installing Cursor"
)
TOTAL_TASKS=${#TASKS[@]}
CURRENT_TASK=0

draw_progress_bar() {
    local progress=$1
    local task_name=$2
    local width=40
    local filled=$((width * progress / 100))
    local empty=$((width - filled))
    
    printf "\r[%s%s] %3d%% | %-30s" \
        "$(printf '#%.0s' $(seq 1 $filled 2>/dev/null) 2>/dev/null || echo "")" \
        "$(printf '.%.0s' $(seq 1 $empty 2>/dev/null) 2>/dev/null || echo "")" \
        "$progress" \
        "$task_name"
}

update_progress() {
    CURRENT_TASK=$((CURRENT_TASK + 1))
    local progress=$((CURRENT_TASK * 100 / TOTAL_TASKS))
    draw_progress_bar "$progress" "${TASKS[$((CURRENT_TASK - 1))]}"
}

echo "========================================"
echo "       DEV SETUP INSTALLER"
echo "========================================"
echo ""
echo "This script will install the following:"
echo "  - Git         (version control)"
echo "  - Homebrew    (macOS package manager, if needed)"
echo "  - OpenCode    (AI coding assistant)"
echo "  - Cursor      (AI-powered IDE)"
echo ""
echo "========================================"
printf "Proceed with installation? [Y/n]: "
read -r response
response=${response:-Y}
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

echo ""
echo "Setting up development environment..."
echo ""

update_progress

# Install package managers if needed
install_homebrew() {
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

update_progress

# Install Git if not present
if ! command -v git &> /dev/null; then
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

update_progress

# Install OpenCode
if ! command -v opencode &> /dev/null; then
    curl -fsSL https://opencode.ai/install | bash && INSTALLED+=("OpenCode") || FAILED+=("OpenCode")
else
    ALREADY_INSTALLED+=("OpenCode")
fi

update_progress

# Install Cursor
if ! command -v cursor &> /dev/null; then
    curl https://cursor.com/install -fsS | bash && INSTALLED+=("Cursor") || FAILED+=("Cursor")
else
    ALREADY_INSTALLED+=("Cursor")
fi

update_progress
echo ""
echo ""

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
