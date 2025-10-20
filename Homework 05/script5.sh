#!/usr/bin/env bash
#

set -euo pipefail

src="${1:-}"
dst="${2:-}"

# 1) Перевірка аргументів
if [[ -z "$src" || -z "$dst" ]]; then
  echo "Потрібно 2 аргументи: джерело і призначення."
  echo "Приклад: ./script5.sh src.txt out/dst.txt"
  exit 1
fi

# 2) Джерело має існувати
if [[ ! -e "$src" ]]; then
  echo "Помилка: джерело '$src' не існує." >&2
  exit 1
fi

# 3) Визначаємо, що таке призначення: тека чи файл
if [[ "$dst" == */ || -d "$dst" ]]; then
  # Призначення — тека (існуюча або вказана зі слешем у кінці)
  mkdir -p -- "$dst"
  target="${dst%/}/$(basename -- "$src")"
else
  # Призначення — конкретний файл; створимо батьківську теку
  mkdir -p -- "$(dirname -- "$dst")"
  target="$dst"
fi

# 4) Копіювання
cp -- "$src" "$target"

echo "OK: '$src' -> '$target'"
