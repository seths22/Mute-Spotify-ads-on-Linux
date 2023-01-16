# Script to mute Spotify audio ads in Linux

This is purely a bash script.

Uses dbus, applicable for systems using PulseAudio.

Starts Spotify client, and mutes ads with precise timing

Requires Spotify client to be installed. If you are using the Flatpak version of spotify, replace the second line in `run-spotify.sh` with the following:
`flatpak run com.spotify.Client > /dev/null 2>&1 &`

### Usage:

Run the script `run_spotify.sh` and Spotify will start with the script running in a terminal. To exit, close the terminal (simply closing the Spotify client will leave the script running).
