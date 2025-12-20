import requests
import json

BASE_URL = "http://localhost:5000/students"
RESULTS_FILE = "results.txt"

def log(step, response):
    text = f"\n--- {step} ---\nStatus: {response.status_code}\nResponse: {response.text}\n"
    print(text)
    with open(RESULTS_FILE, 'a', encoding='utf-8') as f:
        f.write(text)

def main():
    # Очищуємо файл результатів
    with open(RESULTS_FILE, 'w', encoding='utf-8') as f:
        f.write("Test Results:\n")

    # 1. GET ALL
    log("1. GET All Students (Initial)", requests.get(BASE_URL))

    # 2. POST
    students = [
        {"first_name": "Vasyl", "last_name": "Klymchuk", "age": 29},
        {"first_name": "Petro", "last_name": "Poroshenko", "age": 60},
        {"first_name": "Volodymyr", "last_name": "Zelenskiy", "age": 47}
    ]
    for s in students:
        log(f"2. POST Create {s['first_name']}", requests.post(BASE_URL, json=s))

    # 3. GET ALL
    log("3. GET All Students (After Create)", requests.get(BASE_URL))

    # 4. PATCH
    log("4. PATCH Student 2 Age", requests.patch(f"{BASE_URL}/2", json={"age": 25}))

    # 5. GET Student 2
    log("5. GET Student 2", requests.get(f"{BASE_URL}/2"))

    # 6. PUT
    new_data = {"first_name": "Leonid", "last_name": "Kuchma", "age": 87}
    log("6. PUT Student 3 Full Update", requests.put(f"{BASE_URL}/3", json=new_data))

    # 7. GET Student 3
    log("7. GET Student 3", requests.get(f"{BASE_URL}/3"))

    # 8. GET ALL
    log("8. GET All Students", requests.get(BASE_URL))

    # 9. DELETE Student 1
    log("9. DELETE Student 1", requests.delete(f"{BASE_URL}/1"))

    # 10. GET ALL (Final)
    log("10. GET All Students (Final)", requests.get(BASE_URL))

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"Error: {e}")