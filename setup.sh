#!/bin/bash

[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
ln -s "$(pwd)/bashrc" ~/.bashrc

[ -f ~/.bash_profile ] && mv ~/.bash_profile ~/.bash_profile.bak
ln -s "$(pwd)/bash_profile" ~/.bash_profile

[ -f ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.bak
ln -s "$(pwd)/tmux.conf" ~/.tmux.conf

[ -f ~/.tmux_dark.conf ] && mv ~/.tmux_dark.conf ~/.tmux_dark.conf.bak
ln -s "$(pwd)/tmux_dark.conf" ~/.tmux_dark.conf

[ -f ~/.tmux_light.conf ] && mv ~/.tmux_light.conf ~/.tmux_light.conf.bak
ln -s "$(pwd)/tmux_light.conf" ~/.tmux_light.conf

[ -d ~/.config/nvim ] || mkdir -p ~/.config/nvim
[ -f ~/.config/nvim/init.lua ] && mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak
ln -s "$(pwd)/init.lua" ~/.config/nvim/init.lua
