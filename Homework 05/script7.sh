#!/usr/bin/env bash
#
file="${1:?Вкажіть файл}"

if [[ ! -e "$file" ]]; then
  echo "Помилка: файл '$file' не існує." >&2
  exit 1
fi

# wc -l виводить кількість рядків; cut забирає ім'я файлу
lines=$(wc -l < "$file")
echo "Кількість рядків у '$file': $lines"
