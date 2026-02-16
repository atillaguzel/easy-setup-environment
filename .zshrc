# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         🚀 Modern Zsh Configuration                        ║
# ║                                                                            ║
# ║  Deployed by: https://github.com/atillaguzel/easy-setup-environment        ║
# ║  Prompt:      Starship (https://starship.rs)                               ║
# ║  Theme:       Gruvbox Dark                                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# ── Instant Prompt (reduce startup latency) ────────────────────────────────────
# If you use Powerlevel10k, enable instant prompt here. Starship doesn't need it
# but we keep the area reserved for any startup optimisations.

# ── Environment Variables ──────────────────────────────────────────────────────
export EDITOR="code --wait"
export VISUAL="code --wait"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# XDG Base Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ── Homebrew ───────────────────────────────────────────────────────────────────
if [[ "$(uname -s)" == "Darwin" ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null
    else
        eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null
    fi
else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null
fi

# ── PATH Additions ─────────────────────────────────────────────────────────────
# uv / Python
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Go (if installed)
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# ── NVM (Lazy Loading for fast shell startup) ──────────────────────────────────
export NVM_DIR="$HOME/.nvm"

# Lazy-load nvm to avoid ~200ms startup penalty
nvm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
}

node() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
}

npm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
}

npx() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npx "$@"
}

# ── Google Cloud SDK ───────────────────────────────────────────────────────────
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# ── History ────────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # write timestamp to history
setopt HIST_EXPIRE_DUPS_FIRST    # expire duplicates first
setopt HIST_FIND_NO_DUPS         # do not display duplicates during search
setopt HIST_IGNORE_DUPS          # ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS      # remove older duplicates
setopt HIST_IGNORE_SPACE         # ignore commands starting with space
setopt HIST_SAVE_NO_DUPS         # do not save duplicates
setopt SHARE_HISTORY             # share history between sessions
setopt INC_APPEND_HISTORY        # append immediately, not on exit

# ── Completion ─────────────────────────────────────────────────────────────────
autoload -Uz compinit
# Only regenerate completion dump once a day
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Key Bindings ───────────────────────────────────────────────────────────────
bindkey -e                       # emacs key bindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ── Aliases ────────────────────────────────────────────────────────────────────

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'

# Modern replacements (eza → ls, bat → cat)
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza --icons --group-directories-first -la'
    alias lt='eza --icons --tree --level=3'
    alias la='eza --icons -a'
else
    alias ls='ls --color=auto'
    alias ll='ls -la'
fi

if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat --plain'
fi

# Git shortcuts
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpl='git pull'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias ga='git add'
alias gaa='git add --all'

# Docker shortcuts
alias d='docker'
alias dc='docker compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'

# Python / uv
alias py='python3'
alias uvinit='uv init && uv venv && source .venv/bin/activate'
alias uvact='source .venv/bin/activate'

# Editor
alias code="open -a 'Visual Studio Code'"
alias change="code ~/.zshrc"
alias reload="source ~/.zshrc"

# Quick config access
alias zshrc="$EDITOR ~/.zshrc"
alias starconf="$EDITOR ~/.config/starship.toml"

# ── Zsh Plugins ────────────────────────────────────────────────────────────────

# zsh-autosuggestions
if [ -f "$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting (must be sourced LAST)
if [ -f "$(brew --prefix 2>/dev/null)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ── fzf Integration ───────────────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
    # Modern fzf (0.48+) uses this
    if [[ -f "$HOME/.fzf.zsh" ]]; then
        source "$HOME/.fzf.zsh"
    else
        eval "$(fzf --zsh 2>/dev/null)" || true
    fi
    export FZF_DEFAULT_OPTS="
        --height=40%
        --layout=reverse
        --border
        --info=inline
        --color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374
        --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
        --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
    "
    # Use fd for fzf if available
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
fi

# ── Zoxide (smart cd) ─────────────────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# ── direnv ─────────────────────────────────────────────────────────────────────
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# ── Starship Prompt (MUST be last) ────────────────────────────────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi
