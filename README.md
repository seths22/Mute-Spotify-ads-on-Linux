# Script to mute Spotify audio ads in Linux

This is purely a bash script.

Requires pipewire-pulse to work.

Starts Spotify client and mutes audio ads of any length, without muting songs.

Requires Spotify client to be installed. If you are using the Flatpak version of spotify, replace the second line in `run-spotify.sh` with the following:
`flatpak run com.spotify.Client > /dev/null 2>&1 &`

### Usage:

Run the script `run_spotify.sh` and Spotify will start with the script running in a terminal. To exit, close the terminal (simply closing the Spotify client will leave the script running).
To work properly, all files must be stored in the same directory.

Note: this script works with music only. Podcasts are recognized as ads, and thus are muted. Eventually I may try to find a way to fix this. In the meantime, if you want to listen to podcasts you must open Spotify without this script.
