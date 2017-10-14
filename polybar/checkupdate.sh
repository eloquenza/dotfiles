#!/bin/bash

pac=$(checkupdates | wc -l)
aur=$(cower -u | wc -l)

check=$((pac + aur))
if [[ "$check" != "0" ]]
then
    echo "$pac %{F#268bd2}%{F-} $aur"
else
	echo "%{F#268bd2}%{F-} No updates!"
fi
