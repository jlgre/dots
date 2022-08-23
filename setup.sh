#!/bin/bash

[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
ln -s "$(pwd)/bashrc" ~/.bashrc

[ -d ~/.config/nvim ] || mkdir -p ~/.config/nvim
[ -f ~/.config/nvim/init.lua ] && mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
ln -s "$(pwd)/init.lua" "~/.config/nvim/init.lua"
