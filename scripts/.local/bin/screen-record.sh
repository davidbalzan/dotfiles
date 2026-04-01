#!/bin/bash
RECDIR="$HOME/Videos/recordings"
mkdir -p "$RECDIR"

if pidof wf-recorder > /dev/null; then
    killall -SIGINT wf-recorder
    notify-send "Recording" "Saved to $RECDIR" -t 3000
else
    FILENAME="$RECDIR/rec-$(date +%Y%m%d-%H%M%S).mp4"
    GEOM=$(slurp)
    [ -z "$GEOM" ] && exit 0
    wf-recorder -g "$GEOM" -f "$FILENAME" &
    notify-send "Recording" "Started — press again to stop" -t 2000
fi
