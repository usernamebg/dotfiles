#
# ~/.bash_profile
#
# In .bash_profile
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
. "$HOME/.cargo/env"

################################################################################
# Like harpoon - https://github.com/huyng/bashmarks
source /home/vegapunk/repo/git/bash/bashmarks/bashmarks.sh
# s <bookmark_name> - Saves the current directory as "bookmark_name"
# g <bookmark_name> - Goes (cd) to the directory associated with "bookmark_name"
# p <bookmark_name> - Prints the directory associated with "bookmark_name"
# d <bookmark_name> - Deletes the bookmark
# l                 - Lists all available bookmarks

##################################################################################
# https://github.com/mrzool/bash-sensible
source /home/vegapunk/repo/git/bash/bash-sensible/sensible.bash
# Some useful settings

##############################################################
# auto-complete vim mode highlighing and other
# https://github.com/akinomyoga/ble.sh
source ~/.local/share/blesh/ble.sh

# Disable auto-complete based on the command history
bleopt complete_auto_history=
# Disable ambiguous completion
bleopt complete_ambiguous=
# Disable exit marker like "[ble: exit]"
bleopt exec_errexit_mark=
# Disable exit marker like "[ble: exit]"
bleopt exec_exit_mark=
# Disable auto-complete (Note: auto-complete is enabled by default in bash-4.0+)
bleopt complete_auto_complete=

###################################################
# Initialize starship prompt
if command -v starship &>/dev/null; then
  # Configure starship to add newlines for readability
  export STARSHIP_CONFIG=~/.config/starship.toml

  # Create custom starship config if it doesn't exist
  if [[ ! -f ~/.config/starship.toml ]]; then
    mkdir -p ~/.config
    cat >~/.config/starship.toml <<'EOF'
# Add a blank line between shell prompts
add_newline = true

# Make prompt more compact
[line_break]
disabled = false
EOF
  fi

  eval "$(starship init bash)"
else
  echo "Warning: starship is not installed. Your prompt may look different."
  # Simple fallback prompt if starship is not available
  PS1='\n\[\033[1;32m\]➜\[\033[0m\]  \[\033[1;36m\]\W\[\033[0m\] '
fi

# Initialize zoxide (directory jumper) with bash syntax
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"

  # Manually add 'z' as an alias if it's not being created
  if ! command -v z &>/dev/null; then
    alias z="__zoxide_z"
  fi

  # Also add zi alias for interactive selection
  alias zi="__zoxide_zi"
fi

# Initialize fzf (fuzzy finder) with bash syntax
if command -v fzf &>/dev/null; then
  # Source fzf completion for bash
  if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
  elif [[ -f /usr/share/fzf/completion.bash ]]; then
    source /usr/share/fzf/completion.bash
  elif [[ -f /usr/share/fzf/shell/completion.bash ]]; then
    source /usr/share/fzf/shell/completion.bash
  fi

  # Source fzf key bindings for bash
  if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
    source /usr/share/fzf/key-bindings.bash
  elif [[ -f /usr/share/fzf/shell/key-bindings.bash ]]; then
    source /usr/share/fzf/shell/key-bindings.bash
  fi
fi
