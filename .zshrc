#------------------
# Command line
#------------------

fpath=($fpath "/Users/think/.zfunctions")

# Set Spaceship ZSH as a prompt
autoload -U promptinit
promptinit
prompt spaceship
export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"

# Allow the use of the z plugin to easily navigate directories
. /Users/think/zsh-stuff/z/z.sh

# Add colors to terminal commands (green command means that the command is valid)
source /Users/think/zsh-stuff/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#------------------
# General aliases
#------------------

alias ..='cd ..'
alias ...='cd ../..'

# Open VS Code Insiders
alias code="open -a Visual\ Studio\ Code\ -\ Insiders.app"

# Open .zshrc to be editor in VS Code
alias change="code ~/.zshrc"

# Re-run source command on .zshrc to update current terminal session with new settings
alias update="source ~/.zshrc"

# View files/folder alias using colorsls (https://github.com/athityakumar/colorls)
alias l='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long'

# Clear terminal
alias c='clear'

# jupyter lab and notebook
alias jl='jupyter lab'
alias jn='jupyter notebook'

# project shortcuts
alias goto_p="cd '/Users/think/projects/'"
alias goto_sandbox="cd '/Users/think/projects/sandbox/'"





#------------------
# PATH Manipulations
#------------------

# export PATH=/Users/think/Library/Python/3.7/bin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=/opt/homebrew/bin:$PATH
eval "$(rbenv init -)"
# export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin"
# export PATH="/usr/lib/ruby/gems/2.6.0/bin:$PATH"
export PATH="/Users/think/.gem/ruby/2.6.0/bin:$PATH"
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export LDFLAGS="-L/opt/homebrew/opt/readline/lib"
export CPPFLAGS="-I/opt/homebrew/opt/readline/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig"


#------------------
# Tab completion
#------------------

# Uses the zsh precmd function hook to set the tab title to the current working directory before each prompt
function precmd () {
    window_title="\\033]0;${PWD##*/}\\007"
    echo -ne "$window_title"
}

# # Enable tab completion for colorls flags
source $(dirname $(gem which colorls))/tab_complete.sh


#------------------
# Conda
#------------------

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/think/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/think/conda/etc/profile.d/conda.sh" ]; then
        . "/Users/think/conda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/think/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda activate arm


#------------------
# Command line 2
#------------------

setopt PROMPT_CR
setopt PROMPT_SP
export PROMPT_EOL_MARK=""