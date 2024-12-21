#!/bin/bash

prevName=""
spotifyStarted=0
muted=0
while true; do
    numSpotifyProc=`ps aux | grep -c /usr/share/spotify`
    if [ "$numSpotifyProc" != "1" ]; then
        spotifyStarted=1
	    # get Spotify playing song name
	    
	    song=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2`

        artist=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/artist/{n;n;p}' | cut -d '"' -f 2`
	    
	    if [[ "$song" != "$prevName" ]]; then
		    songChanged=1
	    else
		    songChanged=0
	    fi

	    if [[ "$artist" = "" ]]; then	    
            if [ $muted == 0 ]; then
                echo "Advertisement: Muting"
                pactl set-sink-mute @DEFAULT_SINK@ 1
                muted=1
            fi
	    else		   
		    if [ $songChanged == 1 ]; then
			    echo "${artist}: ${song}"                
		    fi
            if [ $muted == 1 ]; then
                echo "Unmuting"
                pactl set-sink-mute @DEFAULT_SINK@ 0
                muted=0
            fi
	    fi
	    prevName="$song"
    else
        if [ $spotifyStarted == 1 ]; then
            # unmute
            pactl set-sink-mute @DEFAULT_SINK@ 0
            # fix bug related to frequency of ads playing
            rm ~/.config/spotify/Users/*/ad-state-storage.bnk
            exit 0
        fi
    fi
    sleep 0.5
done
