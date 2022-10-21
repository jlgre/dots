# .bashrc
source /usr/share/doc/git/contrib/completion/git-prompt.sh

#if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
	# Adapted from https://unix.stackexchange.com/a/176885/347104
	# Create session 'main' or attach to 'main' if already exists.
# 	tmux new-session -A -s main
#fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/usr/local/bin

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias ls="ls --color"
alias ll="ls -al"
alias cd="cd_with_venv_check"

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM="auto"

#PS1='[$?][\u@\h \w]$(__git_ps1)$ '
PS1='[$?] \u:\w$(__git_ps1)$ '
cd_with_venv_check() {
	builtin cd ${1:+"$@"}
	activate_venv
}

activate_venv() {
	[ -d "./venv/" ] && [ -f "./venv/bin/activate" ] && source ./venv/bin/activate
	return 0
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR=nvim

[ -f ~/.custom.sh ] && source ~/.custom.sh

BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"
        
base16_gruvbox-dark-hard
. "$HOME/.cargo/env"
