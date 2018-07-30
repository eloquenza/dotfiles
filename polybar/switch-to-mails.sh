#! /usr/bin/env sh

nohup thunderbird > /dev/null 2>&1 &
i3-msg 'workspace "5: mails"'
