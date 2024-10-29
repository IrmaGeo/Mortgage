from flask import Flask, render_template, request, flash, redirect, url_for
import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__, template_folder='templates')
app.secret_key = os.getenv('FLASK_SECRET_KEY')
# MySQL connection details
mydb = mysql.connector.connect(
    host=os.getenv('DATABASE_HOST'),
    port=int(os.getenv('DATABASE_PORT')),
    user=os.getenv('DATABASE_USER'),
    password=os.getenv('DATABASE_PASSWORD'),
    database=os.getenv('DATABASE_NAME')
)

mycursor = mydb.cursor()

def setup_database():
    try:
        # Create Customers table
        mycursor.execute('''
            CREATE TABLE IF NOT EXISTS customer (
                customer_id INT PRIMARY KEY AUTO_INCREMENT,
                first_name VARCHAR(50) NOT NULL,
                middle_name VARCHAR(50),
                last_name VARCHAR(50) NOT NULL,
                street_number VARCHAR(10),
                street_name VARCHAR(100),
                apt_number VARCHAR(10),
                city VARCHAR(50),
                state VARCHAR(50),
                country VARCHAR(50),
                zip_code VARCHAR(10),
                phone_number VARCHAR(15),
                email_address VARCHAR(100) UNIQUE,
                date_of_birth DATE,
                citizen_status VARCHAR(20),
                status VARCHAR(20),
                user_id VARCHAR(50)
            )
        ''')

        # Create Loans table
        mycursor.execute('''
            CREATE TABLE IF NOT EXISTS loans (
                loan_id INT PRIMARY KEY AUTO_INCREMENT,
                customer_id INT,
                loan_amount DECIMAL(15,2),
                loan_term INT,
                interest_rate DECIMAL(5,2),
                status VARCHAR(20),
                FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
            )
        ''')

        # Add this to your setup_database() function
        mycursor.execute('''
            CREATE TABLE IF NOT EXISTS collateral (
                collateral_id INT PRIMARY KEY AUTO_INCREMENT,
                loan_id INT,
                collateral_type VARCHAR(50),
                collateral_value DECIMAL(15,2),
                status VARCHAR(20),
                FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
            )
        ''')

        mydb.commit()
        print("Database setup complete.")
    except mysql.connector.Error as err:
        print(f"Error setting up database: {err}")

def view_customers(connection):
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM customer')
    customers = cursor.fetchall()
    for customer in customers:
        print(customer)
    return customers  # Add return statement to get the customers list

def add_customer_to_db(customer_data):
    try:
        sql = """
            INSERT INTO customer (
                first_name, middle_name, last_name, 
                street_number, street_name, apt_number, 
                city, state, country, zip_code, 
                phone_number, email_address, date_of_birth, 
                citizen_status, status, user_id
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        mycursor.execute(sql, customer_data)
        mydb.commit()
        return True, "Customer added successfully"
    except mysql.connector.Error as err:
        return False, f"Error adding customer: {err}"

def update_customer_in_db(customer_id, customer_data):
    try:
        sql = """
            UPDATE customer SET 
                first_name = %s, middle_name = %s, last_name = %s,
                street_number = %s, street_name = %s, apt_number = %s,
                city = %s, state = %s, country = %s, zip_code = %s,
                phone_number = %s, email_address = %s, date_of_birth = %s,
                citizen_status = %s, status = %s
            WHERE customer_id = %s
        """
        mycursor.execute(sql, customer_data + (customer_id,))
        mydb.commit()
        return True, "Customer updated successfully"
    except mysql.connector.Error as err:
        return False, f"Error updating customer: {err}"

def delete_customer_from_db(customer_id):
    try:
        # First, delete associated loans
        mycursor.execute("DELETE FROM loans WHERE customer_id = %s", (customer_id,))
        # Then delete the customer
        mycursor.execute("DELETE FROM customer WHERE customer_id = %s", (customer_id,))
        mydb.commit()
        return True, "Customer and associated loans deleted successfully"
    except mysql.connector.Error as err:
        return False, f"Error deleting customer: {err}"

def search_customers(criteria):
    try:
        query = "SELECT * FROM customer WHERE 1=1"
        params = []
        
        if criteria.get('first_name'):
            query += " AND first_name LIKE %s"
            params.append(f"%{criteria['first_name']}%")
        if criteria.get('last_name'):
            query += " AND last_name LIKE %s"
            params.append(f"%{criteria['last_name']}%")
        if criteria.get('phone_number'):
            query += " AND phone_number LIKE %s"
            params.append(f"%{criteria['phone_number']}%")
        
        mycursor.execute(query, params)
        return mycursor.fetchall()
    except mysql.connector.Error as err:
        print(f"Error searching customers: {err}")
        return []

def view_loans():
    try:
        mycursor.execute('SELECT l.*, c.first_name, c.last_name FROM loans l JOIN customer c ON l.customer_id = c.customer_id')
        return mycursor.fetchall()
    except mysql.connector.Error as err:
        print(f"Error viewing loans: {err}")
        return []

def add_loan(mycursor, mydb, customer_id, loan_amount, loan_term, interest_rate, status="Active"):
    try:
        sql = '''
            INSERT INTO loans (customer_id, loan_amount, loan_term, interest_rate, status)
            VALUES (%s, %s, %s, %s, %s)
        '''
        mycursor.execute(sql, (customer_id, loan_amount, loan_term, interest_rate, status))
        mydb.commit()
        return True, "Loan added successfully"
    except mysql.connector.Error as err:
        return False, f"Error adding loan: {err}"

def update_loan(cursor, connection, loan_id, status):
    try:
        cursor.execute('UPDATE loans SET status = %s WHERE loan_id = %s', (status, loan_id))
        connection.commit()
        return True, "Loan updated successfully"
    except mysql.connector.Error as err:
        return False, f"Error updating loan: {err}"

def delete_loan(mycursor, mydb, loan_id):
    try:
        mycursor.execute('DELETE FROM loans WHERE loan_id = %s', (loan_id,))
        mydb.commit()
        return True, "Loan deleted successfully"
    except mysql.connector.Error as err:
        return False, f"Error deleting loan: {err}"

def get_loan_by_id(loan_id):
    try:
        mycursor.execute('''
            SELECT l.*, c.first_name, c.last_name 
            FROM loans l
            JOIN customer c ON l.customer_id = c.customer_id
            WHERE l.loan_id = %s
        ''', (loan_id,))
        return mycursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error fetching loan: {err}")
        return None

def get_customer_loans(customer_id):
    try:
        mycursor.execute('''
            SELECT l.*, c.first_name, c.last_name 
            FROM loans l
            JOIN customer c ON l.customer_id = c.customer_id
            WHERE l.customer_id = %s
            ORDER BY l.loan_id DESC
        ''', (customer_id,))
        return mycursor.fetchall()
    except mysql.connector.Error as err:
        print(f"Error fetching customer loans: {err}")
        return []
    
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

@app.route('/delete_customer/<int:customer_id>', methods=['POST'])
def delete_customer(connection, customer_id):
    cursor = connection.cursor()
    cursor.execute('DELETE FROM Customers WHERE CustomerID = ?', (customer_id,))
    connection.commit()
    print("Customer deleted successfully.")

# Loan Routes
@app.route('/loans')
def view_all_loans():
    loans = view_loans()
    return render_template('loans.html', loans=loans)

@app.route('/customer_loans/<int:customer_id>')
def view_customer_loans(customer_id):
    loans = get_customer_loans(customer_id)
    mycursor.execute("SELECT * FROM customer WHERE customer_id = %s", (customer_id,))
    customer = mycursor.fetchone()
    return render_template('customer_loans.html', loans=loans, customer=customer)

@app.route('/add_loan', methods=['GET', 'POST'])
def add_loan_route():
    if request.method == 'POST':
        loan_data = (
            request.form['customer_id'],
            request.form['loan_amount'],
            request.form['loan_term'],
            request.form['interest_rate'],
            request.form.get('status', 'Active')
        )
        
        success, message = add_loan(mycursor, mydb, *loan_data)  # Changed from add_loan_to_db to add_loan
        flash(message, 'success' if success else 'danger')
        if success:
            return redirect(url_for('view_all_loans'))
    
    # Fix: Pass only mydb as the connection
    customers = view_customers(mydb)
    return render_template('add_loan.html', customers=customers)

@app.route('/update_loan/<int:loan_id>', methods=['GET', 'POST'])
def update_loan_route(loan_id):
    if request.method == 'POST':
        status = request.form['status']
        success, message = update_loan(mycursor, mydb, loan_id, status)
        flash(message, 'success' if success else 'danger')
        if success:
            return redirect(url_for('view_all_loans'))
    
    loan = get_loan_by_id(loan_id)
    return render_template('update_loan.html', loan=loan)

@app.route('/delete_loan/<int:loan_id>', methods=['POST'])
def delete_loan_route(loan_id):
    success, message = delete_loan(mycursor, mydb, loan_id)
    flash(message, 'success' if success else 'danger')
    return redirect(url_for('view_all_loans'))

@app.route('/search_loan', methods=['GET', 'POST'])
def search_loan():
    loans = None
    if request.method == 'POST':
        loan_id = request.form.get('loan_id', '')
        customer_id = request.form.get('customer_id', '')

        query = "SELECT l.*, c.first_name, c.last_name FROM loans l JOIN customer c ON l.customer_id = c.customer_id WHERE 1=1"
        params = []

        if loan_id:
            query += " AND l.loan_id = %s"
            params.append(loan_id)
        if customer_id:
            query += " AND l.customer_id = %s"
            params.append(customer_id)

        mycursor.execute(query, params)
        loans = mycursor.fetchall()

    return render_template('search_loan.html', loans=loans)

@app.route('/search_collateral', methods=['GET', 'POST'])
def search_collateral():
    collaterals = None
    if request.method == 'POST':
        collateral_id = request.form.get('collateral_id', '')
        loan_id = request.form.get('loan_id', '')

        query = """
            SELECT c.*, l.loan_amount, cu.first_name, cu.last_name 
            FROM collateral c 
            JOIN loans l ON c.loan_id = l.loan_id 
            JOIN customer cu ON l.customer_id = cu.customer_id 
            WHERE 1=1
        """
        params = []

        if collateral_id:
            query += " AND c.collateral_id = %s"
            params.append(collateral_id)
        if loan_id:
            query += " AND c.loan_id = %s"
            params.append(loan_id)

        mycursor.execute(query, params)
        collaterals = mycursor.fetchall()

    return render_template('search_collateral.html', collaterals=collaterals)

@app.route('/add_collateral', methods=['GET', 'POST'])
def add_collateral():
    if request.method == 'POST':
        loan_id = request.form['loan_id']
        collateral_type = request.form['collateral_type']
        collateral_value = request.form['collateral_value']
        status = request.form.get('status', 'Active')

        try:
            sql = '''
                INSERT INTO collateral (loan_id, collateral_type, collateral_value, status)
                VALUES (%s, %s, %s, %s)
            '''
            mycursor.execute(sql, (loan_id, collateral_type, collateral_value, status))
            mydb.commit()
            flash('Collateral added successfully!', 'success')
            return redirect(url_for('search_collateral'))
        except mysql.connector.Error as err:
            flash(f'Error adding collateral: {err}', 'danger')
            return render_template('add_collateral.html')

    # For GET request, fetch all loans for the dropdown
    mycursor.execute('''
        SELECT l.loan_id, c.first_name, c.last_name, l.loan_amount 
        FROM loans l 
        JOIN customer c ON l.customer_id = c.customer_id
    ''')
    loans = mycursor.fetchall()
    return render_template('add_collateral.html', loans=loans)

# Error handlers
@app.errorhandler(404)
def not_found_error(error):
    return render_template('404.html'), 404

@app.errorhandler(500)
def internal_error(error):
    mydb.rollback()  # Roll back any failed transactions
    return render_template('500.html'), 500

if __name__ == '__main__':
    setup_database()  # Setup database tables if they don't exist
    app.run(debug=True)
