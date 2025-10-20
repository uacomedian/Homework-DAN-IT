#!/usr/bin/env bash
#
file="${1:?Вкажіть назву файлу як аргумент}"

if [[ -e "$file" ]]; then
  echo "Файл '$file' існує."
else
  echo "Файл '$file' не існує."
fi
