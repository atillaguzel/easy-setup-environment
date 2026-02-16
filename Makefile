# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                    🚀  Dev Environment Setup — Makefile                     ║
# ║                                                                            ║
# ║  A single, idempotent, cross-platform script to bootstrap a beautiful      ║
# ║  development environment on macOS (Intel + Apple Silicon) and Linux.        ║
# ║                                                                            ║
# ║  Usage:                                                                    ║
# ║    make all        — install everything                                    ║
# ║    make <target>   — install a specific tool                               ║
# ║    make status     — show what's installed                                 ║
# ║                                                                            ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

.PHONY: all brew python node starship nerd-fonts gcloud gh docker tailwindcss \
        gemini-cli claude-code codex-cli tailscale zsh-config shell-extras \
        status clean help

SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

# ── Colours ─────────────────────────────────────────────────────────────────────
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
RED    := \033[0;31m
CYAN   := \033[0;36m
BOLD   := \033[1m
RESET  := \033[0m

# ── Platform Detection ──────────────────────────────────────────────────────────
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)
    OS := macos
    ifeq ($(UNAME_M),arm64)
        ARCH := arm64
        BREW_PREFIX := /opt/homebrew
    else
        ARCH := x86_64
        BREW_PREFIX := /usr/local
    endif
else ifeq ($(UNAME_S),Linux)
    OS := linux
    ARCH := $(UNAME_M)
    BREW_PREFIX := /home/linuxbrew/.linuxbrew
else
    $(error Unsupported OS: $(UNAME_S). Only macOS and Linux are supported.)
endif

# ── Ensure Homebrew is on PATH for all recipes ────────────────────────────────
export PATH := $(BREW_PREFIX)/bin:$(BREW_PREFIX)/sbin:$(PATH)

# ── Helper Functions ────────────────────────────────────────────────────────────
define log_info
	printf "$(BLUE)$(BOLD)ℹ $(RESET)$(BLUE) %s$(RESET)\n" $(1)
endef

define log_ok
	printf "$(GREEN)$(BOLD)✓ $(RESET)$(GREEN) %s$(RESET)\n" $(1)
endef

define log_warn
	printf "$(YELLOW)$(BOLD)⚠ $(RESET)$(YELLOW) %s$(RESET)\n" $(1)
endef

define log_install
	printf "$(CYAN)$(BOLD)⬇ $(RESET)$(CYAN) Installing %s...$(RESET)\n" $(1)
endef

define log_skip
	printf "$(GREEN)$(BOLD)✓ $(RESET) %s already installed$(RESET)\n" $(1)
endef

# ── Default Target ──────────────────────────────────────────────────────────────
all: banner brew python node starship nerd-fonts gcloud gh docker tailwindcss \
     gemini-cli claude-code codex-cli tailscale shell-extras zsh-config status
	@printf "\n$(GREEN)$(BOLD)══════════════════════════════════════════════════════════════$(RESET)\n"
	@printf "$(GREEN)$(BOLD)  🎉  All done! Restart your terminal or run: source ~/.zshrc  $(RESET)\n"
	@printf "$(GREEN)$(BOLD)══════════════════════════════════════════════════════════════$(RESET)\n\n"

banner:
	@printf "\n"
	@printf "$(CYAN)$(BOLD)  ╔══════════════════════════════════════════════════════════╗$(RESET)\n"
	@printf "$(CYAN)$(BOLD)  ║          🚀  Dev Environment Bootstrap v2.0              ║$(RESET)\n"
	@printf "$(CYAN)$(BOLD)  ║                                                          ║$(RESET)\n"
	@printf "$(CYAN)$(BOLD)  ║   OS:   %-10s  Arch: %-10s                  ║$(RESET)\n" "$(OS)" "$(ARCH)"
	@printf "$(CYAN)$(BOLD)  ╚══════════════════════════════════════════════════════════╝$(RESET)\n"
	@printf "\n"

# ═════════════════════════════════════════════════════════════════════════════════
# ── Homebrew ────────────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
brew:
	@if command -v brew &>/dev/null; then \
		$(call log_skip,"Homebrew"); \
	else \
		$(call log_install,"Homebrew"); \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		if [ "$(OS)" = "macos" ]; then \
			echo 'eval "$$($(BREW_PREFIX)/bin/brew shellenv)"' >> ~/.zprofile; \
			eval "$$($(BREW_PREFIX)/bin/brew shellenv)"; \
		else \
			echo 'eval "$$($(BREW_PREFIX)/bin/brew shellenv)"' >> ~/.profile; \
			eval "$$($(BREW_PREFIX)/bin/brew shellenv)"; \
		fi; \
		$(call log_ok,"Homebrew installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── Python (via uv) ────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
python:
	@printf "\n$(BOLD)── Python (via uv) ──────────────────────────────────────────$(RESET)\n"
	@# Step 1: Install uv
	@if command -v uv &>/dev/null; then \
		$(call log_skip,"uv"); \
	else \
		$(call log_install,"uv"); \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
		export PATH="$$HOME/.local/bin:$$PATH"; \
		$(call log_ok,"uv installed"); \
	fi
	@# Ensure uv is on PATH for subsequent steps
	@export PATH="$$HOME/.local/bin:$$PATH"; \
	\
	echo ""; \
	for ver in 3.11 3.12 3.13 3.14; do \
		if uv python find "$$ver" &>/dev/null; then \
			printf "$(GREEN)$(BOLD)✓ $(RESET) Python $$ver already installed\n"; \
		else \
			printf "$(CYAN)$(BOLD)⬇ $(RESET)$(CYAN) Installing Python $$ver...$(RESET)\n"; \
			uv python install "$$ver"; \
			printf "$(GREEN)$(BOLD)✓ $(RESET)$(GREEN) Python $$ver installed$(RESET)\n"; \
		fi; \
	done; \
	\
	echo ""; \
	echo "  Pinning default Python to 3.13..."; \
	uv python pin 3.13; \
	printf "$(GREEN)$(BOLD)✓ $(RESET)$(GREEN) Python 3.13 pinned as default$(RESET)\n"

# ═════════════════════════════════════════════════════════════════════════════════
# ── Node.js Ecosystem (nvm + pnpm + bun) ───────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
node:
	@printf "\n$(BOLD)── Node.js Ecosystem ───────────────────────────────────────$(RESET)\n"
	@# nvm
	@if [ -d "$$HOME/.nvm" ]; then \
		$(call log_skip,"nvm"); \
	else \
		$(call log_install,"nvm"); \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash; \
		$(call log_ok,"nvm installed"); \
	fi
	@# Load nvm and install Node LTS
	@export NVM_DIR="$$HOME/.nvm"; \
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; \
	if command -v node &>/dev/null; then \
		printf "$(GREEN)$(BOLD)✓ $(RESET) Node.js $$(node --version) already installed\n"; \
	else \
		printf "$(CYAN)$(BOLD)⬇ $(RESET)$(CYAN) Installing Node.js LTS...$(RESET)\n"; \
		nvm install --lts; \
		nvm use --lts; \
		nvm alias default lts/*; \
		printf "$(GREEN)$(BOLD)✓ $(RESET)$(GREEN) Node.js LTS installed$(RESET)\n"; \
	fi
	@# pnpm
	@if command -v pnpm &>/dev/null; then \
		$(call log_skip,"pnpm"); \
	else \
		$(call log_install,"pnpm"); \
		curl -fsSL https://get.pnpm.io/install.sh | sh -; \
		$(call log_ok,"pnpm installed"); \
	fi
	@# bun
	@if command -v bun &>/dev/null; then \
		$(call log_skip,"bun"); \
	else \
		$(call log_install,"bun"); \
		curl -fsSL https://bun.sh/install | bash; \
		$(call log_ok,"bun installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── Starship Prompt ─────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
starship:
	@printf "\n$(BOLD)── Starship Prompt ─────────────────────────────────────────$(RESET)\n"
	@if command -v starship &>/dev/null; then \
		$(call log_skip,"Starship"); \
	else \
		$(call log_install,"Starship"); \
		if [ "$(OS)" = "macos" ]; then \
			brew install starship; \
		else \
			curl -sS https://starship.rs/install.sh | sh -s -- --yes; \
		fi; \
		$(call log_ok,"Starship installed"); \
	fi
	@# Copy config
	@mkdir -p "$$HOME/.config"
	@cp -f starship.toml "$$HOME/.config/starship.toml"
	@$(call log_ok,"Starship config deployed to ~/.config/starship.toml")
	@# Download official Nerd Font symbols and merge into config
	@printf "$(CYAN)$(BOLD)⬇ $(RESET)$(CYAN) Downloading Nerd Font symbols preset...$(RESET)\n"
	@curl -fsSL https://starship.rs/presets/toml/nerd-font-symbols.toml > /tmp/nerd-font-symbols.toml
	@python3 scripts/merge-starship-symbols.py "$$HOME/.config/starship.toml" /tmp/nerd-font-symbols.toml
	@rm -f /tmp/nerd-font-symbols.toml
	@$(call log_ok,"Nerd Font symbols merged into Starship config")

# ═════════════════════════════════════════════════════════════════════════════════
# ── Nerd Fonts ──────────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════

nerd-fonts:
	@printf "\n$(BOLD)── Nerd Fonts ──────────────────────────────────────────────$(RESET)\n"
	@bash scripts/install_nerd_fonts.sh

# ═════════════════════════════════════════════════════════════════════════════════
# ── Google Cloud SDK ────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
gcloud:
	@printf "\n$(BOLD)── Google Cloud SDK ────────────────────────────────────────$(RESET)\n"
	@if command -v gcloud &>/dev/null; then \
		$(call log_skip,"Google Cloud SDK"); \
	else \
		$(call log_install,"Google Cloud SDK"); \
		if [ "$(OS)" = "macos" ]; then \
			brew install --cask google-cloud-sdk; \
		else \
			curl -fsSL https://sdk.cloud.google.com | bash -s -- --disable-prompts; \
			echo 'source "$$HOME/google-cloud-sdk/path.zsh.inc"' >> ~/.zshrc; \
			echo 'source "$$HOME/google-cloud-sdk/completion.zsh.inc"' >> ~/.zshrc; \
		fi; \
		$(call log_ok,"Google Cloud SDK installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── GitHub CLI ──────────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
gh:
	@printf "\n$(BOLD)── GitHub CLI ──────────────────────────────────────────────$(RESET)\n"
	@if command -v gh &>/dev/null; then \
		$(call log_skip,"GitHub CLI (gh)"); \
	else \
		$(call log_install,"GitHub CLI"); \
		if [ "$(OS)" = "macos" ]; then \
			brew install gh; \
		else \
			(type -p wget >/dev/null || sudo apt-get install wget -y) && \
			sudo mkdir -p -m 755 /etc/apt/keyrings && \
			out=$$(mktemp) && \
			wget -nv -O "$$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
			cat "$$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
			sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
			echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
			sudo apt-get update && \
			sudo apt-get install gh -y; \
		fi; \
		$(call log_ok,"GitHub CLI installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── Docker ──────────────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
docker:
	@printf "\n$(BOLD)── Docker ──────────────────────────────────────────────────$(RESET)\n"
	@if command -v docker &>/dev/null; then \
		$(call log_skip,"Docker"); \
	else \
		$(call log_install,"Docker"); \
		if [ "$(OS)" = "macos" ]; then \
			brew install --cask docker; \
			$(call log_warn,"Open Docker Desktop to complete setup"); \
		else \
			curl -fsSL https://get.docker.com | sh; \
			sudo usermod -aG docker "$$USER"; \
			$(call log_warn,"Log out and back in for Docker group to take effect"); \
		fi; \
		$(call log_ok,"Docker installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── Tailwind CSS ────────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
tailwindcss:
	@printf "\n$(BOLD)── Tailwind CSS ────────────────────────────────────────────$(RESET)\n"
	@export NVM_DIR="$$HOME/.nvm"; \
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; \
	if command -v tailwindcss &>/dev/null || (npm list -g @tailwindcss/cli 2>/dev/null | grep -q tailwindcss); then \
		$(call log_skip,"Tailwind CSS"); \
	else \
		$(call log_install,"Tailwind CSS CLI"); \
		npm install -g @tailwindcss/cli; \
		$(call log_ok,"Tailwind CSS CLI installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── AI Coding Tools ─────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
gemini-cli:
	@printf "\n$(BOLD)── Gemini CLI ──────────────────────────────────────────────$(RESET)\n"
	@export NVM_DIR="$$HOME/.nvm"; \
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; \
	if command -v gemini &>/dev/null; then \
		$(call log_skip,"Gemini CLI"); \
	else \
		$(call log_install,"Gemini CLI"); \
		npm install -g @google/gemini-cli; \
		$(call log_ok,"Gemini CLI installed"); \
	fi

claude-code:
	@printf "\n$(BOLD)── Claude Code (Anthropic) ─────────────────────────────────$(RESET)\n"
	@export NVM_DIR="$$HOME/.nvm"; \
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; \
	if command -v claude &>/dev/null; then \
		$(call log_skip,"Claude Code"); \
	else \
		$(call log_install,"Claude Code"); \
		npm install -g @anthropic-ai/claude-code; \
		$(call log_ok,"Claude Code installed"); \
	fi

codex-cli:
	@printf "\n$(BOLD)── Codex CLI ───────────────────────────────────────────────$(RESET)\n"
	@export NVM_DIR="$$HOME/.nvm"; \
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; \
	if command -v codex &>/dev/null; then \
		$(call log_skip,"Codex CLI"); \
	else \
		$(call log_install,"Codex CLI"); \
		npm install -g @openai/codex; \
		$(call log_ok,"Codex CLI installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── Tailscale ───────────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
tailscale:
	@printf "\n$(BOLD)── Tailscale ───────────────────────────────────────────────$(RESET)\n"
	@if command -v tailscale &>/dev/null; then \
		$(call log_skip,"Tailscale"); \
	else \
		$(call log_install,"Tailscale"); \
		if [ "$(OS)" = "macos" ]; then \
			brew install --cask tailscale; \
		else \
			curl -fsSL https://tailscale.com/install.sh | sh; \
		fi; \
		$(call log_ok,"Tailscale installed"); \
	fi

# ═════════════════════════════════════════════════════════════════════════════════
# ── Shell Extras (CLI productivity tools) ───────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
BREW_FORMULAE := fzf ripgrep fd bat eza zoxide jq yq htop btop tmux lazygit \
                 lazydocker zsh-autosuggestions zsh-syntax-highlighting direnv

shell-extras:
	@printf "\n$(BOLD)── Shell Extras (CLI Tools) ────────────────────────────────$(RESET)\n"
ifeq ($(OS),macos)
	@for pkg in $(BREW_FORMULAE); do \
		if brew list "$$pkg" &>/dev/null 2>&1; then \
			printf "$(GREEN)$(BOLD)✓ $(RESET) $$pkg already installed\n"; \
		else \
			printf "$(CYAN)$(BOLD)⬇ $(RESET)$(CYAN) Installing $$pkg...$(RESET)\n"; \
			brew install "$$pkg"; \
		fi; \
	done
else
	@# Install what's available via apt, rest via brew/curl
	@APT_PKGS="fzf ripgrep fd-find bat jq htop tmux direnv"; \
	for pkg in $$APT_PKGS; do \
		if dpkg -l "$$pkg" 2>/dev/null | grep -q '^ii'; then \
			printf "$(GREEN)$(BOLD)✓ $(RESET) $$pkg already installed\n"; \
		else \
			printf "$(CYAN)$(BOLD)⬇ $(RESET)$(CYAN) Installing $$pkg...$(RESET)\n"; \
			sudo apt-get install -y "$$pkg" 2>/dev/null || true; \
		fi; \
	done
	@# Tools best installed via Homebrew on Linux
	@BREW_ONLY="eza zoxide yq btop lazygit lazydocker zsh-autosuggestions zsh-syntax-highlighting"; \
	if command -v brew &>/dev/null; then \
		for pkg in $$BREW_ONLY; do \
			if brew list "$$pkg" &>/dev/null 2>&1; then \
				printf "$(GREEN)$(BOLD)✓ $(RESET) $$pkg already installed\n"; \
			else \
				printf "$(CYAN)$(BOLD)⬇ $(RESET)$(CYAN) Installing $$pkg via Homebrew...$(RESET)\n"; \
				brew install "$$pkg"; \
			fi; \
		done; \
	else \
		$(call log_warn,"Homebrew not found — some extras skipped. Run 'make brew' first."); \
	fi
endif
	@$(call log_ok,"Shell extras complete")

# ═════════════════════════════════════════════════════════════════════════════════
# ── Zsh Configuration ──────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
zsh-config:
	@printf "\n$(BOLD)── Zsh Configuration ───────────────────────────────────────$(RESET)\n"
	@if [ -f "$$HOME/.zshrc" ] && [ ! -f "$$HOME/.zshrc.backup" ]; then \
		cp "$$HOME/.zshrc" "$$HOME/.zshrc.backup"; \
		$(call log_ok,"Existing .zshrc backed up to ~/.zshrc.backup"); \
	fi
	@cp -f .zshrc "$$HOME/.zshrc"
	@$(call log_ok,".zshrc deployed to ~/")

# ═════════════════════════════════════════════════════════════════════════════════
# ── Status Report ───────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
status:
	@printf "\n"
	@printf "$(BOLD)╔══════════════════════════════════════════════════════════════╗$(RESET)\n"
	@printf "$(BOLD)║              📋  Environment Status Report                  ║$(RESET)\n"
	@printf "$(BOLD)╠══════════════════════════════════════════════════════════════╣$(RESET)\n"
	@printf "$(BOLD)║  %-20s │ %-10s │ %-22s ║$(RESET)\n" "Tool" "Status" "Version"
	@printf "$(BOLD)╠══════════════════════════════════════════════════════════════╣$(RESET)\n"
	@# Helper: truncate version to 22 chars max and display status row
	@_check() { \
		local name="$$1"; \
		local ver="$$(echo "$$2" | cut -c1-22)"; \
		if [ -n "$$ver" ]; then \
			printf "$(BOLD)║$(RESET)  %-20s │ $(GREEN)%-10s$(RESET) │ %-22s $(BOLD)║$(RESET)\n" "$$name" "  ✓" "$$ver"; \
		else \
			printf "$(BOLD)║$(RESET)  %-20s │ $(RED)%-10s$(RESET) │ %-22s $(BOLD)║$(RESET)\n" "$$name" "  ✗" "not found"; \
		fi; \
	}; \
	\
	# Load nvm so node/pnpm/bun and npm-installed tools are found \
	export NVM_DIR="$$HOME/.nvm"; \
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh"; \
	\
	printf "$(BOLD)║  ── Core ────────────────────────────────────────────────── ║$(RESET)\n"; \
	_check "brew"    "$$(brew --version 2>/dev/null | head -1 | cut -d' ' -f2 || true)"; \
	_check "uv"      "$$(uv --version 2>/dev/null | cut -d' ' -f2 || true)"; \
	_check "python"  "$$(python3 --version 2>/dev/null | cut -d' ' -f2 || true)"; \
	_check "node"    "$$(node --version 2>/dev/null | tr -d 'v' || true)"; \
	_check "pnpm"    "$$(pnpm --version 2>/dev/null || true)"; \
	_check "bun"     "$$(bun --version 2>/dev/null || true)"; \
	_check "nvm"     "$$( [ -d "$$HOME/.nvm" ] && echo 'installed' || true)"; \
	\
	printf "$(BOLD)║  ── Cloud & DevOps ──────────────────────────────────────── ║$(RESET)\n"; \
	_check "gcloud"    "$$(gcloud --version 2>/dev/null | head -1 | awk '{print $$NF}' || true)"; \
	_check "gh"        "$$(gh --version 2>/dev/null | head -1 | awk '{print $$3}' || true)"; \
	_check "docker"    "$$(docker --version 2>/dev/null | sed 's/.*version //' | sed 's/,.*//' || true)"; \
	_check "tailscale" "$$(tailscale version 2>/dev/null | head -1 || true)"; \
	\
	printf "$(BOLD)║  ── AI Coding Tools ─────────────────────────────────────── ║$(RESET)\n"; \
	_check "gemini"      "$$(gemini --version 2>/dev/null | head -1 || true)"; \
	_check "claude"       "$$(claude --version 2>/dev/null | head -1 || true)"; \
	_check "codex"       "$$(codex --version 2>/dev/null | head -1 | awk '{print $$NF}' || true)"; \
	\
	printf "$(BOLD)║  ── Shell & Prompt ──────────────────────────────────────── ║$(RESET)\n"; \
	_check "starship" "$$(starship --version 2>/dev/null | head -1 | awk '{print $$NF}' || true)"; \
	_check "fzf"      "$$(fzf --version 2>/dev/null | awk '{print $$1}' || true)"; \
	_check "rg"       "$$(rg --version 2>/dev/null | head -1 | awk '{print $$2}' || true)"; \
	_check "bat"      "$$(bat --version 2>/dev/null | awk '{print $$2}' || true)"; \
	_check "eza"      "$$(eza --version 2>/dev/null | head -1 | awk '{print $$2}' || true)"; \
	_check "zoxide"   "$$(zoxide --version 2>/dev/null | awk '{print $$2}' || true)"; \
	_check "tmux"     "$$(tmux -V 2>/dev/null | awk '{print $$2}' || true)"; \
	_check "lazygit"  "$$(lazygit --version 2>/dev/null | sed -n 's/.*version=\([^,]*\).*/\1/p' || true)"; \
	_check "jq"       "$$(jq --version 2>/dev/null | tr -d 'jq-' || true)"; \
	_check "direnv"   "$$(direnv --version 2>/dev/null || true)"; \
	\
	printf "$(BOLD)╚══════════════════════════════════════════════════════════════╝$(RESET)\n\n"

# ═════════════════════════════════════════════════════════════════════════════════
# ── Help ────────────────────────────────────────────────────────────────────────
# ═════════════════════════════════════════════════════════════════════════════════
help:
	@printf "\n$(BOLD)Available targets:$(RESET)\n\n"
	@printf "  $(CYAN)make all$(RESET)            Install everything\n"
	@printf "  $(CYAN)make status$(RESET)         Show installation status\n"
	@printf "  $(CYAN)make brew$(RESET)           Install Homebrew\n"
	@printf "  $(CYAN)make python$(RESET)         Install uv + Python 3.11–3.14\n"
	@printf "  $(CYAN)make node$(RESET)           Install nvm + Node LTS + pnpm + bun\n"
	@printf "  $(CYAN)make starship$(RESET)       Install Starship prompt + config\n"
	@printf "  $(CYAN)make nerd-fonts$(RESET)     Install Nerd Fonts\n"
	@printf "  $(CYAN)make gcloud$(RESET)         Install Google Cloud SDK\n"
	@printf "  $(CYAN)make gh$(RESET)             Install GitHub CLI\n"
	@printf "  $(CYAN)make docker$(RESET)         Install Docker\n"
	@printf "  $(CYAN)make tailwindcss$(RESET)    Install Tailwind CSS CLI\n"
	@printf "  $(CYAN)make gemini-cli$(RESET)     Install Gemini CLI\n"
	@printf "  $(CYAN)make claude-code$(RESET)   Install Claude Code (Anthropic)\n"
	@printf "  $(CYAN)make codex-cli$(RESET)      Install Codex CLI\n"
	@printf "  $(CYAN)make tailscale$(RESET)      Install Tailscale\n"
	@printf "  $(CYAN)make shell-extras$(RESET)   Install CLI productivity tools\n"
	@printf "  $(CYAN)make zsh-config$(RESET)     Deploy .zshrc\n"
	@printf "  $(CYAN)make help$(RESET)           Show this message\n\n"
