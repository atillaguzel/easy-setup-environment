<div align="center">

# 🚀 Dev Environment Setup

**One command to bootstrap a beautiful, modern development environment.**

[![macOS](https://img.shields.io/badge/macOS-Intel%20%26%20Apple%20Silicon-999999?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Linux](https://img.shields.io/badge/Linux-Ubuntu%20%2F%20Debian-E95420?style=flat-square&logo=linux&logoColor=white)](https://ubuntu.com/)
[![MIT License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)

</div>

---

## ⚡ Quick Start

```bash
git clone https://github.com/atillaguzel/easy-setup-environment.git
cd easy-setup-environment
make all
```

That's it. Go grab a coffee ☕ while everything installs.

---

## 📦 What Gets Installed

### Core Toolchain

| Tool | Purpose | Install Target |
|------|---------|----------------|
| [Homebrew](https://brew.sh) | Package manager | `make brew` |
| [uv](https://docs.astral.sh/uv/) | Python package manager | `make python` |
| Python 3.11–3.14 | Multiple Python versions (pinned to 3.13) | `make python` |
| [nvm](https://github.com/nvm-sh/nvm) | Node.js version manager | `make node` |
| [pnpm](https://pnpm.io) | Fast Node package manager | `make node` |
| [bun](https://bun.sh) | JavaScript runtime & toolkit | `make node` |
| [Tailwind CSS](https://tailwindcss.com) | CSS framework CLI | `make tailwindcss` |

### Cloud & DevOps

| Tool | Purpose | Install Target |
|------|---------|----------------|
| [Google Cloud SDK](https://cloud.google.com/sdk) | GCP CLI | `make gcloud` |
| [GitHub CLI](https://cli.github.com) | GitHub from terminal | `make gh` |
| [Docker](https://www.docker.com) | Containers | `make docker` |
| [Tailscale](https://tailscale.com) | Zero-config VPN | `make tailscale` |

### AI Coding Tools

| Tool | Purpose | Install Target |
|------|---------|----------------|
| [Gemini CLI](https://geminicli.com) | Google's AI coding assistant | `make gemini-cli` |
| [Antigravity](https://antigravity.google) | Google's AI dev tool | `make antigravity` |
| [Codex CLI](https://developers.openai.com/codex/cli/) | OpenAI's coding agent | `make codex-cli` |

### Shell & Prompt

| Tool | Purpose | Install Target |
|------|---------|----------------|
| [Starship](https://starship.rs) | Beautiful cross-shell prompt | `make starship` |
| Nerd Fonts | Icon fonts (FiraCode, JetBrains, Meslo) | `make nerd-fonts` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | `make shell-extras` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast search (rg) | `make shell-extras` |
| [fd](https://github.com/sharkdp/fd) | Fast find | `make shell-extras` |
| [bat](https://github.com/sharkdp/bat) | Better cat | `make shell-extras` |
| [eza](https://github.com/eza-community/eza) | Better ls | `make shell-extras` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart cd | `make shell-extras` |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI | `make shell-extras` |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker TUI | `make shell-extras` |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer | `make shell-extras` |
| [htop](https://htop.dev) / [btop](https://github.com/aristocratos/btop) | System monitor | `make shell-extras` |
| [jq](https://jqlang.github.io/jq/) / [yq](https://github.com/mikefarah/yq) | JSON/YAML processor | `make shell-extras` |
| [direnv](https://direnv.net) | Per-directory env vars | `make shell-extras` |
| zsh-autosuggestions | Fish-like suggestions | `make shell-extras` |
| zsh-syntax-highlighting | Command validation colours | `make shell-extras` |

---

## 🎯 Individual Targets

Install components selectively:

```bash
make python          # uv + Python 3.11–3.14
make node            # nvm + Node LTS + pnpm + bun
make starship        # Starship prompt + Gruvbox config
make shell-extras    # All CLI productivity tools
make docker          # Docker
make status          # Check what's installed
make help            # Show all targets
```

---

## 🖥️ Platform Support

| Platform | Architecture | Status |
|----------|-------------|--------|
| macOS    | Apple Silicon (arm64) | ✅ Fully supported |
| macOS    | Intel (x86_64) | ✅ Fully supported |
| Linux    | x86_64 | ✅ Fully supported (Ubuntu/Debian) |
| Linux    | arm64 | ✅ Supported |

---

## 🔄 Idempotent

Every target checks if the tool is already installed before taking action. You can safely run `make all` multiple times — it will only install what's missing.

---

## 📂 What's Included

```
.
├── Makefile          # Main install script — all targets
├── .zshrc            # Modern shell config (Starship, aliases, plugins)
├── .gitignore        # Comprehensive ignore patterns
├── starship.toml     # Starship prompt config (Gruvbox Dark theme)
└── README.md         # This file
```

---

## ⌨️ Shell Aliases

The `.zshrc` includes modern aliases:

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Beautiful file listing |
| `ll` | `eza -la --icons` | Detailed listing |
| `lt` | `eza --tree` | Tree view |
| `cat` | `bat` | Syntax-highlighted output |
| `gs` | `git status` | Quick git status |
| `gl` | `git log --oneline --graph` | Pretty git log |
| `dc` | `docker compose` | Docker Compose |
| `py` | `python3` | Python shortcut |
| `uvinit` | `uv init && uv venv && source .venv/bin/activate` | Quick project setup |
| `..` | `cd ..` | Go up |
| `...` | `cd ../..` | Go up two levels |

---

## 🎨 Theme

Uses the **Gruvbox Dark** colour palette via Starship + fzf:

```
┌──────────────────────────────────────────┐
│  gcloud 󰅟 user@domain [project]          │
│                                          │
│ 󰀵  user  ~/Projects   main  3.13   │
│ ❯                                        │
└──────────────────────────────────────────┘
```

---

## 📋 Status Check

See what's installed at a glance:

```bash
make status
```

Outputs a formatted table showing each tool, its status (✓/✗), and version.

---

## 📜 License

MIT
