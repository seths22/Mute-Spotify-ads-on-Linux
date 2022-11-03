#!/bin/bash

prevName=""
while true; do
	# get Spotify playing song name
	
	name=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2`
	
	if [[ "$name" != "$prevName" ]]; then
		songChanged=1
	else
		songChanged=0
	fi

	if [ $songChanged == 1 ]; then
		echo $name
	fi

	if [[ "$name" = *"Advertisement"* || "$name" = *"Spotify"* || "$name" = "" ]]; then
		if [ $songChanged == 1 ]; then
			echo "Muting"
			~/mute_app.sh spotify mute
		fi
	else
		if [ $songChanged == 1 ]; then
			echo "Unmuting"
			~/mute_app.sh spotify unmute
		fi
	fi
	prevName="$name"
	sleep 0.5
done
