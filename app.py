from flask import Flask, render_template, request, flash, redirect, url_for
import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Set a secret key for session management

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
    mycursor.execute("SELECT * FROM customer")
    data = mycursor.fetchall()
    return render_template('index.html', data=data)

@app.route('/search', methods=['POST'])
def search():
    search_query = request.form['search_query']
    mycursor.execute("SELECT * FROM customer WHERE name LIKE %s", (f"%{search_query}%",))
    search_results = mycursor.fetchall()
    return render_template('index.html', data=search_results)

@app.route('/add_customer', methods=['GET', 'POST'])
def add_customer():
    if request.method == 'POST':
        first_name = request.form['first_name']
        middle_name = request.form['middle_name']
        last_name = request.form['last_name']
        street_number = request.form['street_number']
        street_name = request.form['street_name']
        apt_number = request.form['apt_number']
        city = request.form['city']
        state = request.form['state']
        country = request.form['country']
        zip_code = request.form['zip_code']
        phone_number = request.form['phone_number']
        email = request.form['email_address']  # Make sure this matches the form field
        date_of_birth = request.form['date_of_birth']
        citizen_status = request.form['citizen_status']
        status = request.form['status']
        user_id = request.form['user_ID']  # Make sure this matches the form field

        sql = """
            INSERT INTO customers (
                first_name, middle_name, last_name, 
                street_number, street_name, apt_number, city, state, country, zip_code, 
                phone_number, email, date_of_birth, citizen_status, status, user_id
            ) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        val = (first_name, middle_name, last_name, street_number, street_name, apt_number, city, state, country, zip_code, phone_number, email, date_of_birth, citizen_status, status, user_id)

        try:
            mycursor.execute(sql, val)
            mydb.commit()
            flash('Customer added successfully!', 'success')
            return redirect(url_for('index'))
        except mysql.connector.Error as err:
            flash(f'Error adding customer: {err}', 'danger')
            return render_template('add_customer.html')
    else:
        return render_template('add_customer.html')

if __name__ == '__main__':
    app.run(debug=True)
