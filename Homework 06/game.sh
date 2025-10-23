#!/usr/bin/env bash
secret=$(( RANDOM % 100 + 1 ))      # випадкове число 1..100
attempts=0
max_attempts=5

echo "Я загадав число від 1 до 100. У вас $max_attempts спроб."

while (( attempts < max_attempts )); do
  read -rp "Спроба $((attempts+1)): " game
  if ! [[ "$game" =~ ^[0-9]+$ ]]; then   # валідація: введене — ціле число?
    echo "Введіть ціле число."
    continue
  fi
  (( attempts++ ))
  if (( game == secret )); then
    echo "Вітаємо! Ви вгадали правильне число."
    exit 0
  elif (( game < secret )); then
    echo "Занадто низько."
  else
    echo "Занадто високо."
  fi
done

echo "Вибачте, у вас закінчилися спроби. Правильним числом було $secret"
