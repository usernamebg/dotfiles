# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set vi motions (Not VIM)
set -o vi

# Add some useful aliases
alias dotfiles='/usr/bin/git --git-dir=$HOME/repo/dotfiles/ --work-tree=$HOME'
alias vol='pulsemixer'
alias bt='bluetuith'
alias fetch="fastfetch"
alias nv="nvim"
alias f='fzf'
alias zsh-update-plugins="find "$ZSH_DIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"
alias nvimrc='nvim ~/.config/nvim/'
alias py='python3'
alias obs='flatpak run com.obsproject.Studio'
alias webcam='ffmpeg -f v4l2 -input_format mjpeg -video_size 640x480 -framerate 30 -i /dev/video0 -c:v libx264 -preset veryfast -crf 21 ~/recordings/webcam_$(date +%Y%m%d_%H%M%S).mp4'
alias record='/home/vegapunk/repo/scripts/record.sh'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# easier to read disk
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB

# get top process eating memory
alias psmem='ps auxf | sort -nr -k 4 | head -5'

# get top process eating cpu
alias pscpu='ps auxf | sort -nr -k 3 | head -5'

alias ls='ls --color=auto'
alias searchman='apropos'

################################################################################

source /home/vegapunk/repo/git/bash/fzf-marks/fzf-marks.plugin.bash

##################################################################################
# https://github.com/mrzool/bash-sensible
source /home/vegapunk/repo/git/bash/bash-sensible/sensible.bash
# Some useful settings

##############################################################
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

#################################################################################
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

########################################################################################
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
#####################################################################
