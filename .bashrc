# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# function for detecting whether current directory is a git repo, used in bash prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Bash prompt
user_color='\[\e[0;32m\]'
if [ "$EUID" -eq 0 ]; then
user_color='\[\e[0;31m\]'
fi
PS1="\[\e[0;34m\]╔══<=$user_color\u\[\e[0;34m\]=>[\[\e[0;35m\]\w\[\e[0;34m\]] \[\e[91m\]\$(parse_git_branch) \n\[\e[0;34m\]╚══>>>\\$ \[$(tput sgr0)\]"
unset user_color


# prevent nested shells in ranger file manager
ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}
