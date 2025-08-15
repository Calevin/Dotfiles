#!/bin/bash

DIR=/tera2/Backup/Imagenes/Wallpapers
PICS=($(ls ${DIR}))

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

swww query
if [ $? -eq 1 ] ; then
    swww-daemon & sleep 0.1
fi

# swww query || swww-daemon

#change-wallpaper using swww
swww img ${DIR}/${RANDOMPICS} --transition-fps 30 --transition-type any --transition-duration 3

