# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)"
fi

alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -hFX'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

## Safety
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

## Misc

alias shot="scrot ~/media/screenshots/`date +%y-%m-%d-%H:%M:%S`.png"
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias mount='mount | column -t'
# Look for high priority errors in the systemd journal
alias errors="sudo journalctl -p 0..3 -xn"

# only here due to an WM bug - seemed like a good trick, so lets keep it around just in case
#alias maximize-dota2='xdotool windowactivate $(xdotool search dota2)'
