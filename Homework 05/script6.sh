#!/usr/bin/env bash
#
#

read -r -p "Введіть речення: " sentence
# Розбиваємо на слова (за пробілами/табами)
read -r -a words <<< "$sentence"

# Друкуємо у зворотному порядку
for (( i=${#words[@]}-1; i>=0; i-- )); do
  printf "%s" "${words[i]}"
  (( i > 0 )) && printf " "
done
printf "\n"
