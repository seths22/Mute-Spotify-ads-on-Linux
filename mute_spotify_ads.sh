#!/bin/bash
prevName=""
spotifyStarted=0
muted=0
while true; do
    numSpotifyProc=`pgrep -fc /usr/share/spotify`
    if [ $numSpotifyProc -gt 0 ]; then
        spotifyStarted=1
	    # get Spotify playing song name	    
	    song=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2`

        artist=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/artist/{n;n;p}' | cut -d '"' -f 2`

	    if [ "$artist" = "" ]; then	    
            if [ $muted == 0 ]; then
                pactl set-sink-mute @DEFAULT_SINK@ 1
                muted=1
            fi
	    else		   
            if [ $muted == 1 ]; then
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
    sleep 0.2
done
