#!/bin/bash
trap 'kill $BGPID; exit' INT
./mute_spotify_ads.sh &
BGPID=$!
spotify
