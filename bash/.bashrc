# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

TERM=linux
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# function current_branch
# {
#     x=$(git branch 2> /dev/null | grep ^* | awk '{print $2}')
#     if [ ! -z $x ]
#     then
#         echo "!$x"
#     fi
# }
# 
# PS1='\u@\[\033[01;32m\]\h\[\033[0m\] \w\[\033[01;33m\]$(current_branch)\[\033[0m\] \$ '

if [ -f ~/.bash_prompt ]
then
  source ~/.bash_prompt
fi

# Alias definition.

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
export EDITOR=vim
export BROWSER=chromium

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export PATH=~/bin:$HOME/.rvm/bin:/usr/local/bin:/usr/lib/ccache/bin/:/usr/lib/icecream/bin/:/usr/bin/vendor_perl/:${PATH}

if [ -e $HOME/TODO ]
then
    echo "Cosas por hacer:"
    echo ""
    cat $HOME/TODO
    echo ""
fi

export LD_LIBRARY_PATH=.

xhost +local: &> /dev/null

# RVM
if [ -f ~/.rvm/scripts/rvm ]; then
    source ~/.rvm/scripts/rvm
fi

# NVM
[[ -s ~/.nvm/nvm.sh ]] && source ~/.nvm/nvm.sh # This loads NVM
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
