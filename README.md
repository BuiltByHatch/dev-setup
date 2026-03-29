# Dev Setup

Scripts for setting up a development environment.

## Prerequisites

- **macOS/Linux**: Bash shell
- **Windows**: PowerShell 7+ (pwsh)

## Installation

### macOS / Linux

```bash
chmod +x setup.sh
./setup.sh
```

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

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
