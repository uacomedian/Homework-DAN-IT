import csv
import os
from flask import Flask, jsonify, request

app = Flask(__name__)
DATA_FILE = 'students.csv'
FIELDNAMES = ['id', 'first_name', 'last_name', 'age']

# Ініціалізація CSV
def init_db():
    if not os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
            writer.writeheader()

def read_students():
    students = []
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                students.append(row)
    return students

def write_students(students):
    with open(DATA_FILE, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        writer.writeheader()
        writer.writerows(students)

# GET
@app.route('/students', methods=['GET'])
def get_students():
    students = read_students()
    last_name_query = request.args.get('last_name')
    
    if last_name_query:
        filtered = [s for s in students if s['last_name'] == last_name_query]
        if not filtered:
            return jsonify({"error": "Student not found"}), 404
        return jsonify(filtered), 200
        
    return jsonify(students), 200

# GET
@app.route('/students/<int:student_id>', methods=['GET'])
def get_student(student_id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if student:
        return jsonify(student), 200
    return jsonify({"error": "Student not found"}), 404

# POST
@app.route('/students', methods=['POST'])
def create_student():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No data"}), 400
        
    required = ['first_name', 'last_name', 'age']
    if not all(k in data for k in required):
        return jsonify({"error": "Missing fields"}), 400

    students = read_students()
    new_id = 1
    if students:
        new_id = int(students[-1]['id']) + 1
        
    new_student = {
        'id': new_id,
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'age': data['age']
    }
    students.append(new_student)
    write_students(students)
    return jsonify(new_student), 201

# PUT
@app.route('/students/<int:student_id>', methods=['PUT'])
def update_student(student_id):
    data = request.get_json()
    if not data: 
        return jsonify({"error": "No data"}), 400
        
    required = ['first_name', 'last_name', 'age']
    if not all(k in data for k in required):
        return jsonify({"error": "Missing fields"}), 400

    students = read_students()
    idx = next((i for i, s in enumerate(students) if int(s['id']) == student_id), None)
    
    if idx is None:
        return jsonify({"error": "Student not found"}), 404
        
    students[idx].update({
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'age': data['age']
    })
    write_students(students)
    return jsonify(students[idx]), 200

# PATCH
@app.route('/students/<int:student_id>', methods=['PATCH'])
def update_age(student_id):
    data = request.get_json()
    if not data or 'age' not in data:
        return jsonify({"error": "Missing age"}), 400
        
    students = read_students()
    idx = next((i for i, s in enumerate(students) if int(s['id']) == student_id), None)
    
    if idx is None:
        return jsonify({"error": "Student not found"}), 404
        
    students[idx]['age'] = data['age']
    write_students(students)
    return jsonify(students[idx]), 200

# DELETE
@app.route('/students/<int:student_id>', methods=['DELETE'])
def delete_student(student_id):
    students = read_students()
    idx = next((i for i, s in enumerate(students) if int(s['id']) == student_id), None)
    
    if idx is None:
        return jsonify({"error": "Student not found"}), 404
        
    students.pop(idx)
    write_students(students)
    return jsonify({"message": "Deleted successfully"}), 200

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000)