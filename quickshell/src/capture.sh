#!/bin/bash
GEOMETRY="$1 $2"
ERROR=$(grim -g "$GEOMETRY" /tmp/cap.png 2>&1)

if [ $? -eq 0 ]; then
  wl-copy -t image/png </tmp/cap.png

  notify-send "NotGrim" "Took the screen shot!" -i /tmp/cap.png
else
  notify-send "NotGrim - i-i couldnt do it" "The error is: ${ERROR:0:80}"
fi
