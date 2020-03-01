#------------------
# Aliases (for a full list of aliases, run `alias`)
#------------------

# python aliases
alias pip='/usr/bin/pip3'
alias python='/usr/bin/python3'
alias python3='/usr/bin/python3'
alias python2='/usr/bin/python3'

# General Aliases

alias ..='cd ..'
alias ...='cd ../..'
alias code="open -a Visual\ Studio\ Code.app"
# Open .zshrc to be editor in VS Code
alias change="code ~/.zshrc"
# Re-run source command on .zshrc to update current terminal session with new settings
alias update="source ~/.zshrc"
# Use the VS Code insiders build by default for the `code` CLI commands
# View files/folder alias using colorsls (https://github.com/athityakumar/colorls)
alias l='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long'
# Clear terminal
alias c='clear'



#------------------
# Tab completion
#------------------

# Uses the zsh precmd function hook to set the tab title to the current working directory before each prompt
function precmd () {
    window_title="\\033]0;${PWD##*/}\\007"
    echo -ne "$window_title"
}


# Enable tab completion for flags
source $(dirname $(gem which colorls))/tab_complete.sh


#------------------
# PATH Manipulations
#------------------

export PATH=/Users/think/Library/Python/3.7/bin:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/usr/lib/ruby/gems/2.6.0/bin:$PATH"

#------------------
# Miscellaneous
#------------------

# Allow the use of the z plugin to easily navigate directories
. /usr/local/etc/profile.d/z.sh

# Set Spaceship ZSH as a prompt
autoload -U promptinit
promptinit
prompt spaceship

# Add colors to terminal commands (green command means that the command is valid)
source /usr/local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
