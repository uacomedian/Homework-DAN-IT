import random

def guess_number_game():
    # Генеруємо випадкове число від 1 до 100
    target_number = random.randint(1, 100)
    attempts = 0
    max_attempts = 5

    print("Вгадайте число від 1 до 100!")

    while attempts < max_attempts:
        try:
            # Отримуємо ввід від користувача
            user_input = input(f"Спроба {attempts + 1} з {max_attempts}. Введіть число: ")
            guess = int(user_input)

            # Перевірка числа
            if guess == target_number:
                print("Вітаємо! Ви вгадали правильне число.")
                return # Вихід з функції, оскільки перемога
            elif guess < target_number:
                print("Занадто низько")
            else:
                print("Занадто високо")

            attempts += 1

        except ValueError:
            print("Будь ласка, введіть коректне ціле число.")

    # Якщо цикл закінчився і число не вгадане
    print(f"Вибачте, у вас закінчилися спроби. Правильний номер був {target_number}")

# Запуск програми
if __name__ == "__main__":
    guess_number_game()
