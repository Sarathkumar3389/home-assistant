
## MPC configuration in RPi player device to forward audio to remote RPi device
mkdir -p ~/.config/mpd/playlists ~/.local/share/mpd

cat > ~/.config/mpd/mpd.conf <<'EOF'
music_directory "/mnt/music"
playlist_directory "~/.config/mpd/playlists"
db_file "~/.local/share/mpd/tag_cache"
state_file "~/.local/share/mpd/state"
sticker_file "~/.local/share/mpd/sticker.sql"

bind_to_address "127.0.0.1"
port "6600"

audio_output {
    type "pulse"
    name "Ethernet Audio"
    server "unix:/run/user/1000/pulse/native"
    sink "pi3_audio"
}
EOF

### restart  MPD
systemctl --user reset-failed mpd
systemctl --user restart mpd
systemctl --user status mpd --no-pager
