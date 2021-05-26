#!/usr/bin/env bash
# source: https://github.com/urielzo/polybar-theme-for-bspwm/blob/main/.config/polybar/scripts/pavolume.sh
# finds the active sink for pulse audio and increments the volume. useful when you have multiple audio outputs and have a key bound to vol-up and down

inc='2'
capvol='no'
maxvol='200'
autosync='yes'

# Muted status
# yes: muted
# no : not muted
curStatus="no"
active_sink=""
limit=$((100 - inc))
maxlimit=$((maxvol - inc))

# Arbitrary but unique message id
msgId="991049"

function send_notification {
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($curVol / 5)) | sed 's/[0-9]//g')
    # Send the notification
    # dunstify -i audio-volume-muted-blocking -t 8 -r 2593 -u normal "    $bar"
    dunstify -i "$1" -u low  -r "$msgId" " $bar"
}

reloadSink() {
    active_sink=$(pacmd list-sinks | awk '/* index:/{print $3}')
}

function volUp {

    getCurVol

    if [ "$capvol" = 'yes' ]
    then
        if [ "$curVol" -le 100 ] && [ "$curVol" -ge "$limit" ]
        then
            pactl set-sink-volume "$active_sink" -- 100%
        elif [ "$curVol" -lt "$limit" ]
        then
            pactl set-sink-volume "$active_sink" -- "+$inc%"
        fi
    elif [ "$curVol" -le "$maxvol" ] && [ "$curVol" -ge "$maxlimit" ]
    then
        pactl set-sink-volume "$active_sink" "$maxvol%"
    elif [ "$curVol" -lt "$maxlimit" ]
    then
        pactl set-sink-volume "$active_sink" "+$inc%"
    fi

    getCurVol

    if [ ${autosync} = 'yes' ]
    then
        volSync
    fi

    send_notification "audio-volume-high"
}

function volDown {

    pactl set-sink-volume "$active_sink" "-$inc%"
    getCurVol

    if [ ${autosync} = 'yes' ]
    then
        volSync
    fi

    send_notification "audio-volume-low"
}

function getSinkInputs {
    input_array=$(pacmd list-sink-inputs | grep -B 4 "sink: $1 " | awk '/index:/{print $2}')
}

function volSync {
    getSinkInputs "$active_sink"
    getCurVol

    for each in $input_array
    do
        echo "EACH: " $each
        pactl set-sink-input-volume "$each" "$curVol%"
    done
}

function getCurVol {
    curVol=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%'| sed s/.$// | tr -d ' ')
    echo "curVol: "  $curVol
}

function volMute {
    case "$1" in
        mute)
            pactl set-sink-mute "$active_sink" 1
            curVol=0
            status=1
            dunstify -i audio-volume-muted -r "$msgId" -u normal "Mute"
            ;;
        unmute)
            pactl set-sink-mute "$active_sink" 0
            getCurVol
            status=0
            send_notification "audio-volume-medium"
            ;;
    esac

}

function volMuteStatus {
    curStatus=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | awk '/muted/{ print $2}')
}

# Prints output for bar
# Listens for events for fast update speed
function listen {
    firstrun=0

    pactl subscribe 2>/dev/null | {
        while true; do
            {
                # If this is the first time just continue
                # and print the current state
                # Otherwise wait for events
                # This is to prevent the module being empty until
                # an event occurs
                if [ $firstrun -eq 0 ]
                then
                    firstrun=1
                else
                    read -r event || break
                    if ! echo "$event" | grep -e "on card" -e "on sink"
                    then
                        # Avoid double events
                        continue
                    fi
                fi
            } &>/dev/null
            output
        done
    }
}

function output() {
    reloadSink
    getCurVol
    volMuteStatus
    if [ "${curStatus}" = 'yes' ]
    then
        echo "  "
    else
        echo "  "
    fi
} #}}}

reloadSink
case "$1" in
    --up)
        volUp
        ;;
    --down)
        volDown
        ;;
    --togmute)
        volMuteStatus
        if [ "$curStatus" = 'yes' ]
        then
            volMute unmute
        else
            volMute mute
        fi
        ;;
    --mute)
        volMute mute
        ;;
    --unmute)
        volMute unmute
        ;;
    --sync)
        volSync
        ;;
    --listen)
        # Listen for changes and immediately create new output for the bar
        # This is faster than having the script on an interval
        listen
        ;;
    *)
        # By default print output for bar
        output
        ;;
esac
