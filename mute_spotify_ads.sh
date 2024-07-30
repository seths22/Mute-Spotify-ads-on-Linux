#!/bin/bash

prevName=""
while true; do
	# get Spotify playing song name
	
	song=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2`

    artist=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/artist/{n;n;p}' | cut -d '"' -f 2`
	
	if [[ "$song" != "$prevName" ]]; then
		songChanged=1
	else
		songChanged=0
	fi

	if [ $songChanged == 1 ]; then
		echo "${artist}: ${song}"
	fi

	if [[ "$song" = *"Advertisement"* || "$artist" = *"Advertisement"* || "$song" = *"Spotify"* || "$song" = "" ]]; then
		pactl set-sink-mute @DEFAULT_SINK@ 1
		if [ $songChanged == 1 ]; then
			echo "Muting"
		fi
	else
		pactl set-sink-mute @DEFAULT_SINK@ 0
		if [ $songChanged == 1 ]; then
			echo "Unmuting"
		fi
	fi
	prevName="$song"
	sleep 1
done
