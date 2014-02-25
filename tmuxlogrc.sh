#!/bin/sh
#tmux start-server

tmux new-session -d -s log 'errorlog-phperror.sh'
tmux split-window -v -l 150 'errorlog.sh'
#tmux resize-pane -t 0 -U 90

tmux -2 attach-session -t log

