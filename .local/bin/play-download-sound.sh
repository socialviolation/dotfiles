#!/bin/bash
# Plays the most recent sound file from ~/Downloads when Claude finishes tasks

# Find the most recent audio/video file in Downloads
# Supports: mp3, wav, ogg, flac, m4a, aac, mp4, webm, etc.
SOUND_FILE=$(find "${HOME}/Downloads" -maxdepth 1 -type f \
  \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.flac" \
  -o -iname "*.m4a" -o -iname "*.aac" -o -iname "*.opus" -o -iname "*.wma" \
  -o -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" \) \
  -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)

if [[ -z "$SOUND_FILE" ]]; then
  echo "No sound files found in ~/Downloads" >&2
  exit 0
fi

echo "Playing: $SOUND_FILE" >&2

# Try different players in order of preference
if command -v mpv &>/dev/null; then
  mpv --no-video --really-quiet "$SOUND_FILE" &>/dev/null &
elif command -v ffplay &>/dev/null; then
  ffplay -nodisp -autoexit -loglevel quiet "$SOUND_FILE" &>/dev/null &
elif command -v paplay &>/dev/null && [[ "$SOUND_FILE" == *.wav ]]; then
  paplay "$SOUND_FILE" &>/dev/null &
elif command -v aplay &>/dev/null && [[ "$SOUND_FILE" == *.wav ]]; then
  aplay -q "$SOUND_FILE" &>/dev/null &
else
  echo "No suitable audio player found (tried: mpv, ffplay, paplay, aplay)" >&2
  exit 1
fi

exit 0
