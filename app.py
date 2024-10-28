from flask import Flask, render_template, request, flash, redirect, url_for
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
    mycursor.execute("SELECT * FROM customer")
    data = mycursor.fetchall()
    return render_template('index.html', data=data)

@app.route('/search_customer', methods=['GET', 'POST'])
def search_customer():
    customers = None
    if request.method == 'POST':
        first_name = request.form.get('first_name', '')
        last_name = request.form.get('last_name', '')
        phone_number = request.form.get('phone_number', '')

        # Build the search query dynamically based on provided fields
        query = "SELECT * FROM customer WHERE 1=1"
        params = []

        if first_name:
            query += " AND first_name LIKE %s"
            params.append(f"%{first_name}%")
        if last_name:
            query += " AND last_name LIKE %s"
            params.append(f"%{last_name}%")
        if phone_number:
            query += " AND phone_number LIKE %s"
            params.append(f"%{phone_number}%")

        mycursor.execute(query, params)
        customers = mycursor.fetchall()

    return render_template('search_customer.html', customers=customers)

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
        email_address = request.form['email_address']
        date_of_birth = request.form['date_of_birth']
        citizen_status = request.form['citizen_status']
        status = request.form['status']
        user_id = request.form['user_ID']

        sql = """
            INSERT INTO customer (
                first_name, middle_name, last_name, 
                street_number, street_name, apt_number, city, state, country, zip_code, 
                phone_number, email_address, date_of_birth, citizen_status, status, user_id
            ) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """

        val = (first_name, middle_name, last_name, street_number, street_name, apt_number, city, state, country, zip_code, phone_number, email_address, date_of_birth, citizen_status, status, user_id)

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

@app.route('/delete_customer/<int:customer_id>', methods=['POST'])
def delete_customer(customer_id):
    try:
        mycursor.execute("DELETE FROM customer WHERE customer_id = %s", (customer_id,))
        mydb.commit()
        flash('Customer deleted successfully!', 'success')
    except mysql.connector.Error as err:
        flash(f'Error deleting customer: {err}', 'danger')
    return redirect(url_for('search_customer'))  # Redirect to the search page or results

@app.route('/update_customer/<int:customer_id>', methods=['GET', 'POST'])
def update_customer(customer_id):
    if request.method == 'POST':
        # Get updated data from the form
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
        email_address = request.form['email_address']
        date_of_birth = request.form['date_of_birth']
        citizen_status = request.form['citizen_status']
        status = request.form['status']
        user_id = request.form['user_ID']

        try:
            # Update the customer record
            mycursor.execute("""
                UPDATE customer SET first_name = %s, middle_name = %s, last_name = %s,
                street_number = %s, street_name = %s, apt_number = %s, city = %s,
                state = %s, country = %s, zip_code = %s, phone_number = %s,
                email_address = %s, date_of_birth = %s, citizen_status = %s, status = %s
                WHERE customer_id = %s
            """, (first_name, middle_name, last_name, street_number, street_name, apt_number, city,
                  state, country, zip_code, phone_number, email_address, date_of_birth, citizen_status,
                  status, customer_id))
            mydb.commit()
            flash('Customer updated successfully!', 'success')
            return redirect(url_for('search_customer'))  # Redirect to search page
        except mysql.connector.Error as err:
            flash(f'Error updating customer: {err}', 'danger')

    # If GET, fetch the current data for the customer
    mycursor.execute("SELECT * FROM customer WHERE customer_id = %s", (customer_id,))
    customer = mycursor.fetchone()
    return render_template('update_customer.html', customer=customer)

if __name__ == '__main__':
    app.run(debug=True)
