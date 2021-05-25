#!/bin/bash
# source: https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
# source: https://gist.github.com/Blaradox/030f06d165a82583ae817ee954438f2e
# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

# Arbitrary but unique message id
msgId="991049"

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    # dunstify -i audio-volume-muted-blocking -t 8 -r 2593 -u normal "    $bar"
    echo "$1"
    dunstify -i "$1" -u low  -r "$msgId" "    $bar"
}

function up_volumen {
	# Set the volume on (if it was muted)
	amixer -D pulse set Master on > /dev/null
	# Up the volume (+ 5%)
	amixer -D pulse sset Master 5%+ > /dev/null

    send_notification "audio-volume-high"
}

function down_volumen {
	# Set the volume on (if it was muted)
	amixer -D pulse set Master on > /dev/null
	# Down the volume (+ 5%)
	amixer -D pulse sset Master 5%- > /dev/null

    send_notification "audio-volume-low"
}

function toggle_mute {
    # Toggle mute
    amixer -D pulse set Master 1+ toggle > /dev/null

    if is_mute ; then
	    dunstify -i audio-volume-muted -r "$msgId" -u normal "Mute"
	else
	    send_notification "audio-volume-medium"
	fi
}

case $1 in
    up)
        up_volumen	
	;;
    down)
        down_volumen
	;;
    mute)
        toggle_mute
	;;
esac