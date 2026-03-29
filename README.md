# Dev Setup

Scripts for setting up a development environment.

## Prerequisites

- **macOS/Linux**: Bash shell
- **Windows**: PowerShell 7+ (pwsh)

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/dev-setup/main/setup.sh | bash
```

### Windows

```powershell
irm 'https://raw.githubusercontent.com/YOUR_USERNAME/dev-setup/main/setup.ps1' | iex
```

Replace `YOUR_USERNAME` with your GitHub username.

## What's Installed

- **Git** - Version control system
- **OpenCode** - AI coding assistant
- **Cursor** - AI-powered IDE

## Post-Installation

After setup, you may need to restart your terminal or source your shell config:

```bash
source ~/.zshrc  # or ~/.bashrc, ~/.bash_profile
```

Configure OpenCode with your API keys:

```bash
opencode auth login
```
