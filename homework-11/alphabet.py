# Імпортуємо модуль, щоб легко отримати англійські літери
import string

# ===== Клас 1: Alphabet (Базовий клас) =====
class Alphabet:
    # Клас для будь-якого алфавіту, наприклад, Українського чи Англійського
    
    def __init__(self, lang_code, list_of_letters):
        # Конструктор. Приймає код мови та самі літери
        self.lang = lang_code # Зберігаємо мову, наприклад 'En'
        # Перетворюємо вхідний рядок (або що там) на список літер
        self.letters = list(list_of_letters) 

    def print_letters(self):
        # Метод, щоб просто вивести всі літери
        print(f"Літери алфавіту ({self.lang}):")
        print(' '.join(self.letters)) # Виводимо через пробіл

    def letters_count(self):
        # Метод для підрахунку кількості літер
        return len(self.letters)

# ===== Клас 2: EngAlphabet (Успадкування) =====
# Успадковуємо всі методи та властивості від Alphabet
class EngAlphabet(Alphabet):
    
    # Створюємо статичний атрибут для кількості літер. 
    # Приватний, бо починається з нижнього підкреслення
    _total_letters_num = 26 
    
    def __init__(self):
        # Задаємо англійські літери (великі + малі)
        all_en_letters = string.ascii_letters 
        
        # Викликаємо конструктор батьківського класу (Alphabet)
        super().__init__('En', all_en_letters)

    # Метод, який перевизначає батьківський метод letters_count
    def letters_num(self):
        # Тепер цей метод повертає наше фіксоване приватне статичне значення
        return EngAlphabet._total_letters_num
    
    def check_en_letter(self, letter_to_check):
        # Перевіряємо, чи є вхідна літера в нашому списку літер
        # Список self.letters містить 52 літери (великі та малі)
        return letter_to_check in self.letters

    @staticmethod
    def example_text():
        # Статичний метод. Не потребує об'єкта класу для виклику
        return "Example text: Learning Python is fun and important!"

# ===== ТЕСТУВАННЯ (Блок main) =====
if __name__ == "__main__":
    
    print("--- Тестуємо Англійський Алфавіт ---")
    
    # 1. Створюємо об'єкт
    en_alphabet = EngAlphabet()
    
    # 2. Виводимо літери
    print("\n[Крок 2] Вивід літер:")
    en_alphabet.print_letters() 
    
    # 3. Виводимо кількість літер
    # Тут викликається перевизначений letters_num()
    print(f"\n[Крок 3] Кількість літер в алфавіті: {en_alphabet.letters_num()}")
    
    # 4. Перевірка літер
    
    # Перевіряємо 'F'
    letter_F = 'F'
    is_F_in = en_alphabet.check_en_letter(letter_F)
    print(f"\n[Крок 4.1] Чи є '{letter_F}' в англійському алфавіті? {is_F_in}")
    
    # Перевіряємо 'Щ'
    letter_Shcha = 'Щ'
    is_Shcha_in = en_alphabet.check_en_letter(letter_Shcha)
    print(f"[Крок 4.2] Чи є '{letter_Shcha}' в англійському алфавіті? {is_Shcha_in}")
    
    # 5. Виводимо приклад тексту
    print(f"\n[Крок 5] Приклад тексту:")
    # Викликаємо статичний метод напряму з класу
    print(EngAlphabet.example_text())
