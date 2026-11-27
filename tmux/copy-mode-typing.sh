#!/bin/sh
# In copy mode (e.g. after scrolling up), typing a printable character exits
# copy mode and sends that character to the pane, like a normal terminal.
# Ctrl/Alt keys, arrows, PageUp/PageDown, Enter and Escape keep their
# copy-mode meaning (search with C-s/C-r, select, copy, cancel).
# Keys are sent as hex bytes (send-keys -H) to avoid quoting issues.
for hex in $(seq 33 126); do
    hex=$(printf '%x' "$hex")
    key=$(printf "\\$(printf '%03o' "0x$hex")")
    [ "$key" = ";" ] && key='\;'
    tmux bind -T copy-mode -- "$key" send -X cancel '\;' send-keys -H "$hex"
done
tmux bind -T copy-mode Space send -X cancel '\;' send-keys -H 20
exit 0
