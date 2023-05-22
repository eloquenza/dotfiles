#!/usr/bin/env bash

#set -o xtrace
set -o errexit -o nounset -o pipefail -o errtrace
IFS=$'\n\t'

eval $(luarocks path --bin)

disp_num=1
disp=:$disp_num
Xephyr -screen 1024x768 $disp -ac -br -sw-cursor &
pid=$!
while [ ! -e /tmp/.X11-unix/X${disp_num} ] ; do
    sleep 0.1
done

export DISPLAY=$disp
awesome -c ~/development/open-source/saimoomedits-dotfiles/.config/awesome/rc.lua &
awesome-client

kill $pid
exit 0
