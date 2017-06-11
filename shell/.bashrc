#
# ~/.bashrc
#

###############################################################################
# EXPORTS
###############################################################################

export EDITOR=nvim
export VISUAL=nvim

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

## APPLICATION SPECIFIC EXPORTS

#export TERM=screen-256color
# change it back to rxvt-unicode-256color after neovim fixes this

# COLORS FOR MAN PAGES
export LESS_TERMCAP_mb=$'\e[0;32m'
export LESS_TERMCAP_md=$'\e[0;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[0;34;36m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;31m'

# Smooth scroll in firefox
export MOZ_USE_OMTC=1

# Fix CSGO mouse issues
export SDL_VIDEO_X11_DGAMOUSE=0

# export socket path made available from systemd
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

#Make steam not close to tray.
# export STEAM_FRAME_FORCE_CLOSE=0

###############################################################################
# SHOPT SETTINGS
###############################################################################

# Update window size after every command
shopt -s checkwinsize
# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2
# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;
# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

###############################################################################
# SANE HISTORY DEFAULTS
###############################################################################

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=5000000
HISTFILESIZE=1000000
# Avoid duplicate entries
HISTCONTROL="ignoredups:erasedups:ignoreboth"
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:ll:la:tmux:kill:ps"
# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '
# Record each line as it gets issued
# Append to the history file, don't overwrite it
shopt -s histappend
# Save multi-line commands as one command
shopt -s cmdhist

# see: https://unix.stackexchange.com/questions/18212/bash-history-ignoredups-and-erasedups-setting-conflict-with-common-history
# This is going to be longer, and I should save the comment here, just in case:

## [Edit] "And the winner is..."
##
##  *  option 3:
##
##     HISTCONTROL=ignoredups:erasedups
##     shopt -s histappend
##     PROMPT_COMMAND="history -n; history -w; history -c; history -r;
##     $PROMPT_COMMAND"
##
##     This is as far as it gets. It is the only option to have both erasedups
##     and common history working simultaneously. This is probably the final
##     solution to all your problems, Aahan.
##
## 2. Why does option 2 not seem to work (or: what really doesn't work as
##    expected)?
##
## As I mentioned, each of the above solutions works differently. But the most
## misleading interpretation of how the settings work comes from analysing the
## output of history command. In many cases, the command can give false output.
## Why? Because it is executed before the sequence of other history commands
## contained in the PROMPT_COMMAND! However, when using the second or third
## option, one can monitor the changes of .bash_history contents (using
## watch -n1 "tail -n20 .bash_history" for example) and see what the real
## history is.
##
## 3. Why option 3 is so complicated?
##
## It all lies in the way erasedups works. As the bash manual states, "(...)
## erasedups causes all previous lines matching the current line to be removed
## from the history list before that line is saved". So this is really what the
## OP wanted (and not just, as I previously thought, to have no duplicates
## appearing in sequence). Here's why each of the history -. commands either
## has to or can not be in the PROMPT_COMMAND:
##
## *   history -n has to be there before history -w to read from .bash_history
##     the commands saved from any other terminal,
##
## *   history -w has to be there in order to save the history to file and
##     erase duplicates,
##
## *   history -a must not be placed there instead of history -w, because it
##     does not trigger erasing duplicates,
##
##  *  history -c is also needed because it prevents trashing the history buffer
##     after each command,
##
##  *  and finally, history -r is needed to restore the history buffer from
##     file, thus finally making the history shared across terminal sessions.
##

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

###############################################################################
# ALIAS DEFINITIONS
###############################################################################.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
for f in .bash_aliases .bash_functions; do
    if [ -f "$HOME/$f" ]; then
        source "$HOME/$f"
    fi
done

###############################################################################
# BASH COMPLETIONS
###############################################################################
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

###############################################################################
# MISCELLANEOUS
###############################################################################

complete -cf sudo

# run man on command
bind '"\eh": "\C-a\eb\ed\C-y\e#man \C-y\C-m\C-p\C-p\C-a\C-d\C-e"'

PS1='[\u@\h \W]\$ '

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source ~/.local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
