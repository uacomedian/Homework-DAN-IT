#!/usr/bin/env bash
#
file="${1:?Вкажіть файл}"

if [[ ! -e "$file" ]]; then
  echo "Помилка: файл '$file' не існує." >&2
  exit 1
elif [[ ! -r "$file" ]]; then
  echo "Помилка: файл '$file' не має прав на читання." >&2
  exit 1
fi

cat -- "$file"
