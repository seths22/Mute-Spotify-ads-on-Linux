#!/bin/bash
flatpak run com.spotify.Client > /dev/null 2>&1 &
./mute_spotify_ads.sh 2>/dev/null
