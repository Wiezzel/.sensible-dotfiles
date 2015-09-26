# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# ALIASES

# redefine some commands by adding "default" settings
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias less='less --RAW-CONTROL-CHARS'  # parses color codes!

# this will color matches even when output to a non-tty (e.g. piped to less)
alias grp='grep --line-number --color=always'

# common ls aliases
alias l='ls --file-type --ignore-backups'
alias la='ls --almost-all --file-type'
alias ll='ls -l --human-readable --almost-all --file-type'

# Some commands are so common that they deserve one-letter shortcuts :)
alias g='git'
alias v='vim'
alias L='less'  # typing |L is convenient, especially using left shift

# Aliasing 'g' to 'git' wouldn't be useful if it didn't have autocompletion.
# This is tricky and I'm not sure I did it 100% right, but it seems to work.
complete -o default -o nospace -F _git g
# make sure the autocompletion function (`_git`) is loaded
. /usr/share/bash-completion/completions/git 2> /dev/null

# Instead of rm, which deletes files permanently, I prefer to use trash-cli
# (github.com/andreafrancia/trash-cli) which moves files to system trash.
alias tp='trash-put'
#alias rm='echo "This is not the footgun you are looking for."; false'

# Show a desktop notification when a command finishes. Use like this:
#   sleep 5; alert
function alert() {
    if [ $? = 0 ]; then icon=terminal; else icon=error; fi
    last_cmd="$(history | tail -n1 | sed 's/^\s*[0-9]*\s*//' | sed 's/;\s*alert\s*$//')"
    notify-send -i $icon "$last_cmd"
}



# SETTINGS

# enable autocompletion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# make autocompletion case-insensitive
bind "set completion-ignore-case on"

# let aliases work after sudo (see http://askubuntu.com/a/22043)
alias sudo='sudo '

# cd to a dir just by typing its name (requires bash > 4.0), autocorrect typos
shopt -s autocd
shopt -s cdspell

# shell history is very useful, so let's make sure we can harness its full power
export HISTFILESIZE=1000000
export HISTSIZE=1000000
export HISTCONTROL=ignoredups   # don't store duplicated commands
shopt -s histappend   # don't overwrite history file after each session

# disable useless flow control binding, allowing Ctrl-S to search history forward
stty -ixon

# let Ctrl-O open ranger, a console file manager (http://nongnu.org/ranger/)
bind '"\C-o":"ranger\C-m"'



# PROMPT

# Colored prompt stands out in the sea of text, which makes it _much_ easier
# to navigate through the terminal output.  Note that I'm using bright versions
# of colors, because in many color palettes the normal ones are too dim -
# depending on your palette, you may want to use \e[34m, \e[35m and \e[36m
# instead, or use green (\e[32m / \e[92m) for username.
BR_BLUE="\e[94m"
BR_MAGENTA="\e[95m"
BR_CYAN="\e[96m"
DEFAULT_COLOR="\e[0m"

# Using \[ and \] around color codes is necessary to prevent issues
# with the prompt such as text overlapping one line over and over again.
pathcolor="\[${BR_CYAN}\]"
resetcolors="\[${DEFAULT_COLOR}\]"

# When I'm logged in via ssh, display the path in scp-like format (-> easy
# selecting with a double click) and display username in a different color.
if [ -n "$SSH_CONNECTION" ]; then
    usercolor="\[${BR_MAGENTA}\]"
    separator=":"
else
    usercolor="\[${BR_BLUE}\]"
    separator=" "
fi

# $(__git_ps1) displays git repository status in the prompt, which is extremely handy.
# Read more: https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="verbose git"
#GIT_PS1_SHOWCOLORHINTS="true"

# Use PROMPT_COMMAND instead of PS1 because it supports more features of __git_ps1.
# The syntax used here is "__git_ps1 <prefix> <suffix>", see link above.
export PROMPT_COMMAND='__git_ps1 "${usercolor}\u@\h${pathcolor}${separator}\w${resetcolors}" "\n\\$ "'
