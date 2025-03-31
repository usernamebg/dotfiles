eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# source <("/home/vegapunk/repo/git/bash/fzf-marks/fzf-marks.plugin.zsh")
source <(fzf --zsh)

# source $HOME/.cargo/env

# Node Version Manager (NVM) configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load NVM bash completion

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

source "/home/vegapunk/.config/zsh/zshrc"

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/.local/bin


[[ -s "/home/vegapunk/.gvm/scripts/gvm" ]] && source "/home/vegapunk/.gvm/scripts/gvm"
