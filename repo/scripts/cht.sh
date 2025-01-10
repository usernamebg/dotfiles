#!/bin/bash

languages=$(echo -e "golang\njs\nlua\nc\ntypescript\nnodejs\nrust")
core_utils=$(echo -e "xargs\nfind\nmv\nsed\nawk\ntmux\nffmpeg")
options=$(echo -e "$languages\n$core_utils")

selected=$(echo "$options" | fzf)

read -p "query: " query

formatted_query=$(echo "$query" | tr ' ' '+')

if echo "$languages" | grep -qs "^$selected$"; then
  # Language query
  tmux neww bash -c "curl cht.sh/$selected/$formatted_query; read -p 'Press Enter to exit...'"
else
  # Core utilities query
  tmux neww bash -c "curl cht.sh/$selected~$formatted_query; read -p 'Press Enter to exit...'"
fi
