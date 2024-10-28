from flask import Flask, render_template, request
import mysql.connector
import os
from dotenv import load_dotenv


load_dotenv()

app = Flask(__name__)

# MySQL connection details
mydb = mysql.connector.connect(
    host=os.getenv('DATABASE_HOST'),
    user=os.getenv('DATABASE_USER'),
    password=os.getenv('DATABASE_PASSWORD'),
    database=os.getenv('DATABASE_NAME')
)

mycursor = mydb.cursor()

@app.route('/')
def index():
    # Fetch data from the database (adjust the query as needed)
    mycursor.execute("SELECT * FROM customer")
    data = mycursor.fetchall()
    return render_template('index.html', data=data)

@app.route('/search', methods=['POST'])
def search():
    search_query = request.form['search_query']
    # Implement search logic based on your database structure
    # For example:
    mycursor.execute("SELECT * FROM customer WHERE name LIKE %s", (f"%{search_query}%",))
    search_results = mycursor.fetchall()
    return render_template('index.html', data=search_results)

@app.route('/add', methods=['POST'])
def add():
    # Implement add logic, including validation and error handling
    name = request.form['name']
    email = request.form['email']
    # Insert into the database
    sql = "INSERT INTO customer (name, email) VALUES (%s, %s)"
    val = (name, email)
    mycursor.execute(sql, val)
    mydb.commit()
    return render_template('index.html')  # Redirect to the main page or show a success message

if __name__ == '__main__':
    app.run(debug=True)