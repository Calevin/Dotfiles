#!/bin/bash
## BASED ON
# https://github.com/ZacharyVarney/Linux-Backup/blob/280b856ed74cc60b41e7bee54a96435d47f33b7e/dotfiles/config/hypr/hyprsunset.sh#L10

START_HOUR=18
END_HOUR=8
CURRENT_HOUR=$(date +%H)
CURRENT_HOUR=$((10#$CURRENT_HOUR))

if ([ "$START_HOUR" -le "$END_HOUR" ] && [ "$CURRENT_HOUR" -ge "$START_HOUR" ] && [ "$CURRENT_HOUR" -lt "$END_HOUR" ]) || \
   ([ "$START_HOUR" -gt "$END_HOUR" ] && ( [ "$CURRENT_HOUR" -ge "$START_HOUR" ] || [ "$CURRENT_HOUR" -lt "$END_HOUR" ] )); then
    if ! pgrep -x "hyprsunset" >/dev/null; then
    	echo '{"text":" "}'
        nohup hyprsunset --gamma 100 --gamma_max 100 --temperature 3300 >/dev/null 2>&1 &
    else
        echo '{"text":" "}'
    fi
else
    if pgrep -x "hyprsunset" >/dev/null; then
    	echo '{"text":" "}'
        pkill -x "hyprsunset"
    else
    	echo '{"text":" "}'
    fi
fi
