#!/usr/bin/env bash
# Стежить за ~/watch. На новий файл: друк вмісту і перейменування у *.back

set -uo pipefail
WATCH_DIR="${HOME}/watch"
mkdir -p -- "$WATCH_DIR"

# stdbuf робить вивід пострічковим для journald
exec stdbuf -oL -eL inotifywait -m -e create,close_write,moved_to \
  --format '%e|%f' -- "$WATCH_DIR" | \
while IFS="|" read -r event fname; do
  # ігноруємо власні .back
  [[ "$fname" == *.back ]] && continue

  fpath="$WATCH_DIR/$fname"
  [[ -f "$fpath" ]] || continue

  printf 'EVENT=%s FILE=%s\n' "$event" "$fname"

  if ! cat -- "$fpath"; then
    echo "WARN: cannot read $fname" >&2
    continue
  fi

  target="${fpath}.back"
  # якщо ціль існує — додамо високоточний штамп, щоб не зіштовхувалось за секунду
  [[ -e "$target" ]] && target="${fpath}.$(date +%s%N).back"

  mv -- "$fpath" "$target"
  echo "RENAMED -> $(basename -- "$target")"
done
