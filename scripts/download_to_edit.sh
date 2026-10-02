#!/usr/bin/env bash
# Downloads every clip link from the show script into ~/Desktop/TO EDIT (macOS).
# Needs: brew install yt-dlp ffmpeg. Uses Chrome cookies so YouTube doesn't block as a bot.
set -euo pipefail
DEST="$HOME/Desktop/TO EDIT"
mkdir -p "$DEST"
cd "$DEST"

get() { # name url
  yt-dlp --cookies-from-browser chrome -f "bv*[height<=1080]+ba/b" --merge-output-format mp4 \
    -o "$1_%(id)s.%(ext)s" "$2"
}

get clip1_angela_fargo      "https://www.youtube.com/watch?v=6gUOZ7tYfZ8"   # IN 1:00  OUT 1:46
get clip2_clearview_pbs     "https://www.youtube.com/watch?v=GeIc-yhGmx4"   # IN 2:48  OUT 3:50
get clip3_beacons_explainer "https://www.youtube.com/watch?v=ZGL0HpNm5BY"   # IN 0:13  OUT 0:57
get clip4_target_basket     "https://www.tiktok.com/@user60342208753/video/7679448051202657566"  # whole video
get clip5_instacart_caper   "https://www.youtube.com/watch?v=IO1wx3zBR6s"   # 0:00-0:41 + 0:50-1:08
get clip6_mcd_ai_drivethru  "https://www.tiktok.com/@emmyhaggerty/video/7677807744350522637"      # 0:00-0:26

echo "Done: $DEST"
