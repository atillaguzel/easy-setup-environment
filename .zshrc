# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                         🚀 Modern Zsh Configuration                        ║
# ║                                                                            ║
# ║  Deployed by: https://github.com/atillaguzel/easy-setup-environment        ║
# ║  Prompt:      Starship (https://starship.rs)                               ║
# ║  Theme:       Gruvbox Dark                                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

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
# Local binaries (uv, pip-installed tools, etc.)
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[[ "$(uname -s)" != "Darwin" ]] && PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Google Cloud SDK (Homebrew install puts it here on macOS)
if [[ -d "/usr/local/share/google-cloud-sdk" ]]; then
    export PATH="/usr/local/share/google-cloud-sdk/bin:$PATH"
    source "/usr/local/share/google-cloud-sdk/path.zsh.inc" 2>/dev/null
    source "/usr/local/share/google-cloud-sdk/completion.zsh.inc" 2>/dev/null
elif [[ -d "/opt/homebrew/share/google-cloud-sdk" ]]; then
    export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
    source "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc" 2>/dev/null
    source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc" 2>/dev/null
elif [[ -d "$HOME/google-cloud-sdk" ]]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc" 2>/dev/null
    source "$HOME/google-cloud-sdk/completion.zsh.inc" 2>/dev/null
fi

# libpq (PostgreSQL CLI tools like psql, pg_dump)
if [[ -d "/opt/homebrew/opt/libpq/bin" ]]; then
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
elif [[ -d "/usr/local/opt/libpq/bin" ]]; then
    export PATH="/usr/local/opt/libpq/bin:$PATH"
fi

# Java (OpenJDK via Homebrew)
if [[ -d "$(brew --prefix openjdk 2>/dev/null)/bin" ]]; then
    export PATH="$(brew --prefix openjdk)/bin:$PATH"
    export CPPFLAGS="-I$(brew --prefix openjdk)/include"
fi

# Docker CLI completions
if [[ -d "$HOME/.docker/completions" ]]; then
    fpath=($HOME/.docker/completions $fpath)
fi

# ── NVM (Lazy Loading for fast shell startup) ──────────────────────────────────
export NVM_DIR="$HOME/.nvm"

# Lazy-load nvm to avoid ~200ms startup penalty
_load_nvm() {
    unset -f nvm node npm npx pnpx 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }
npx()  { _load_nvm; npx "$@"; }

# ── SSH Agent (auto-start, macOS Keychain integration) ─────────────────────────
if [[ "$(uname -s)" == "Darwin" ]]; then
    eval "$(ssh-agent)" >/dev/null 2>&1
    # Auto-add keys from Keychain — add your keys below
    for key in ~/.ssh/id_rsa ~/.ssh/id_ed25519; do
        [[ -f "$key" ]] && ssh-add --apple-use-keychain "$key" >/dev/null 2>&1
    done
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

# ── Shell Options ──────────────────────────────────────────────────────────────
setopt AUTO_CD                   # cd into directory by typing its name
setopt AUTO_PUSHD                # push directory onto stack with cd
setopt PUSHD_IGNORE_DUPS         # no duplicate dirs on stack
setopt PUSHD_SILENT              # don't print dir stack on pushd/popd
setopt CORRECT                   # suggest corrections for mistyped commands
setopt NO_CASE_GLOB              # case-insensitive globbing
setopt GLOB_DOTS                 # include dotfiles in glob results
setopt INTERACTIVE_COMMENTS      # allow comments in interactive mode

# ── Completion ─────────────────────────────────────────────────────────────────
autoload -Uz compinit
# Only regenerate completion dump once a day
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select                                    # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'            # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"               # colourised
zstyle ':completion:*' group-name ''                                  # group by category
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'     # group headers
zstyle ':completion:*:warnings' format '%F{red}No matches%f'          # no-match message
zstyle ':completion:*' squeeze-slashes true                           # //foo → /foo
zstyle ':completion:*' use-cache on                                   # cache completions
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# ── Key Bindings ───────────────────────────────────────────────────────────────
bindkey -e                                     # emacs mode
bindkey '^[[A'   history-search-backward       # ↑ history search
bindkey '^[[B'   history-search-forward        # ↓ history search
bindkey '^[[1;5C' forward-word                 # Ctrl+→  forward word
bindkey '^[[1;5D' backward-word                # Ctrl+←  backward word
bindkey '^[[3~'  delete-char                   # Delete key
bindkey '^[[H'   beginning-of-line             # Home
bindkey '^[[F'   end-of-line                   # End
bindkey '^U'     backward-kill-line            # Ctrl+U  clear to start
bindkey '^K'     kill-line                     # Ctrl+K  clear to end

# ══════════════════════════════════════════════════════════════════════════════
# ── Aliases ───────────────────────────────────────────────────────────────────
# ══════════════════════════════════════════════════════════════════════════════

# ── Navigation ─────────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'
alias md='mkdir -p'                            # create parent dirs too

# ── File Listing (eza → ls) ───────────────────────────────────────────────────
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias l='eza -l --all --group-directories-first --git --icons'
    alias ll='eza -l --all --group-directories-first --git --icons'
    alias la='eza --icons -a --group-directories-first'
    alias lt='eza --icons --tree --level=2 --group-directories-first --git-ignore'
    alias llt='eza -lT --level=2 --group-directories-first --git-ignore --icons'
    alias lt3='eza --icons --tree --level=3 --group-directories-first --git-ignore'
    alias lt4='eza --icons --tree --level=4 --group-directories-first --git-ignore'
else
    alias ls='ls --color=auto'
    alias ll='ls -la'
    alias la='ls -A'
fi

# ── File Viewing (bat → cat) ──────────────────────────────────────────────────
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat --plain'                   # no line numbers/decorations
    alias batd='bat --diff'                    # show diffs
fi

# ── Searching ──────────────────────────────────────────────────────────────────
if command -v rg &>/dev/null; then
    alias rg='rg --smart-case'                 # case-insensitive when lowercase
    alias rgi='rg --no-ignore'                 # include gitignored files
fi

if command -v fd &>/dev/null; then
    alias fd='fd --hidden --follow --exclude .git'
fi

# ── Git ────────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'                      # short + branch info
alias gd='git diff'
alias gds='git diff --staged'                  # staged diff
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'
alias gp='git push'
alias gpf='git push --force-with-lease'        # safe force push
alias gpl='git pull --rebase'                  # rebase by default
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'       # quick amend
alias gco='git checkout'
alias gsw='git switch'                         # modern branch switching
alias gb='git branch'
alias gba='git branch -a'                      # all branches
alias ga='git add'
alias gaa='git add --all'
alias gap='git add -p'                         # interactive staging
alias gst='git stash'
alias gstp='git stash pop'
alias grb='git rebase'
alias grbi='git rebase -i'                     # interactive rebase
alias gcp='git cherry-pick'
alias gclean='git branch --merged | grep -v "main\|master\|\*" | xargs git branch -d'

# Lazygit
if command -v lazygit &>/dev/null; then
    alias lg='lazygit'
fi

# ── Docker ─────────────────────────────────────────────────────────────────────
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'              # start in background
alias dcd='docker compose down'               # stop and remove
alias dcr='docker compose restart'            # restart services
alias dcl='docker compose logs -f --tail=50'  # follow last 50 lines
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'
alias dprune='docker system prune -af'        # nuke everything unused
alias docker.="open -a /Applications/Docker.app"   # open Docker Desktop

if command -v lazydocker &>/dev/null; then
    alias lzd='lazydocker'
fi

# ── Python / uv ────────────────────────────────────────────────────────────────
alias py='python3'
alias uvinit='uv init && uv venv && source .venv/bin/activate'
alias uvact='source .venv/bin/activate'
alias ack='source .venv/bin/activate'          # shorthand
alias pipreq='uv pip freeze > requirements.txt'
export VIRTUAL_ENV_DISABLE_PROMPT=true         # let Starship handle venv display

# ── Node.js / Package Managers ─────────────────────────────────────────────────
alias bunx='bun x'
alias ni='npm install'
alias nr='npm run'
alias pi='pnpm install'
alias pr='pnpm run'
alias pd='pnpm dev'
alias pb='pnpm build'

# ── Google Cloud ───────────────────────────────────────────────────────────────
alias glogin='gcloud auth application-default login'
alias gproject='gcloud config get-value project'
alias gset='gcloud config set project'

# ── Editor / Config ────────────────────────────────────────────────────────────
alias code="open -a 'Visual Studio Code'"
alias change="code ~/.zshrc"                   # edit zshrc in VS Code
alias reload="source ~/.zshrc"                 # reload shell config
alias zshrc="\$EDITOR ~/.zshrc"
alias starconf="\$EDITOR ~/.config/starship.toml"

# ── macOS Shortcuts ────────────────────────────────────────────────────────────
if [[ "$(uname -s)" == "Darwin" ]]; then
    alias slack="open -n /Applications/Slack.app"
    alias finder='open -a Finder .'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
    alias localip="ipconfig getifaddr en0"
fi

# ── Network / Utility ─────────────────────────────────────────────────────────
alias pubip='curl -s ifconfig.me'
alias ports='lsof -i -P -n | grep LISTEN'
alias weather='curl wttr.in'
alias myip='curl -s ipinfo.io | jq .'
alias h='history | tail -30'
alias path='echo $PATH | tr ":" "\n" | sort'  # print PATH one per line
alias sizeof='du -sh'                          # human-readable dir size
alias diskuse='df -h | head -10'

# ── Make / Build ───────────────────────────────────────────────────────────────
alias mk='make'
alias mks='make status'

# ══════════════════════════════════════════════════════════════════════════════
# ── Plugins & Integrations ────────────────────────────────────────────────────
# ══════════════════════════════════════════════════════════════════════════════

# ── Zsh Plugins ────────────────────────────────────────────────────────────────

# zsh-autosuggestions
if [[ -f "$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting (must be sourced near the end)
if [[ -f "$(brew --prefix 2>/dev/null)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ── fzf Integration ───────────────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
    if [[ -f "$HOME/.fzf.zsh" ]]; then
        source "$HOME/.fzf.zsh"
    else
        eval "$(fzf --zsh 2>/dev/null)" || true
    fi

    # Gruvbox-themed fzf
    export FZF_DEFAULT_OPTS="
        --height=40%
        --layout=reverse
        --border
        --info=inline
        --color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374
        --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
        --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
    "
    # Use fd for fzf if available (much faster than find)
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
fi

# ── Zoxide (smart cd) ─────────────────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'                               # replace cd with zoxide
fi

# ── direnv (auto-load .envrc) ──────────────────────────────────────────────────
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# ── bun completions ────────────────────────────────────────────────────────────
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# ══════════════════════════════════════════════════════════════════════════════
# ── User Overrides (add machine-specific config below) ────────────────────────
# ══════════════════════════════════════════════════════════════════════════════
# Source a local override file if it exists (not tracked by git)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ── Starship Prompt (MUST be last) ────────────────────────────────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi
