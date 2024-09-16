#!/bin/bash

prevName=""
spotifyRunning=0
while true; do
    numSpotifyProc=`ps aux | grep -c /usr/share/spotify`
    if [ "$numSpotifyProc" != "1" ]; then
        spotifyRunning=1
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

	    if [[ "$song" = *"Advertisement"* || "$artist" = *"Advertisement"* || "$song" = *"Spotify"* || "$artist" = *"Spotify"* || "$song" = "" || "$artist" = "" ]]; then		    
		    if [ $songChanged == 1 ]; then
			    echo "Muting"
                pactl set-sink-mute @DEFAULT_SINK@ 1
		    fi
	    else		   
		    if [ $songChanged == 1 ]; then
			    echo "Unmuting"
                pactl set-sink-mute @DEFAULT_SINK@ 0
		    fi
	    fi
	    prevName="$song"
    else
        if [ $spotifyRunning == 1 ]; then
            echo "Spotify is not running : unmuting"
            spotifyRunning=0
            pactl set-sink-mute @DEFAULT_SINK@ 0
        fi
    fi
    sleep 0.5
done
