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

# View all customers
def view_customers():
    mycursor.execute('SELECT * FROM customer')
    return mycursor.fetchall()

# Add customer to database
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

# Update customer in database
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

# Delete customer from database
def delete_customer_from_db(customer_id):
    try:
        # First, delete associated loans
        mycursor.execute("DELETE FROM loan WHERE customer_id = %s", (customer_id,))
        # Then delete the customer
        mycursor.execute("DELETE FROM customer WHERE customer_id = %s", (customer_id,))
        mydb.commit()
        return True, "Customer and associated loans deleted successfully"
    except mysql.connector.Error as err:
        return False, f"Error deleting customer: {err}"

# Search customers
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

# View all loans
def view_loans():
    try:
        mycursor.execute('SELECT l.*, c.first_name, c.last_name FROM loan l JOIN customer c ON l.customer_id = c.customer_id')
        return mycursor.fetchall()
    except mysql.connector.Error as err:
        print(f"Error viewing loans: {err}")
        return []

# Add loan to database
def add_loan(customer_id, start_date, end_date, agreement_amount, withdraw_amount, int_rate, int_rate_type, loan_type, loan_purpose, user_ID, status, account_ID):
    try:
        cursor = mydb.cursor()
        sql = """
            INSERT INTO loan (customer_ID, start_date, end_date, agreement_amount, withdraw_amount, int_rate, int_rate_type, loan_type, loan_purpose, user_ID, status, account_ID)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        val = (customer_id, start_date, end_date, agreement_amount, withdraw_amount, int_rate, int_rate_type, loan_type, loan_purpose, user_ID, status, account_ID)

        cursor.execute(sql, val)
        mydb.commit()
        print(f"Loan added successfully, ID: {cursor.lastrowid}")
        return True, f"Loan added successfully with ID: {cursor.lastrowid}"
    except mysql.connector.Error as e:
        print(f"Error adding loan: {e}")
        return False, f"Error adding loan: {e}"
    finally:
        cursor.close()



# Update loan in database
def update_loan(loan_id, status):
    try:
        mycursor.execute('UPDATE loans SET status = %s WHERE loan_id = %s', (status, loan_id))
        mydb.commit()
        return True, "Loan updated successfully"
    except mysql.connector.Error as err:
        return False, f"Error updating loan: {err}"

# Delete loan from database
def delete_loan(loan_id):
    try:
        mycursor.execute('DELETE FROM loan WHERE loan_id = %s', (loan_id,))
        mydb.commit()
        return True, "Loan deleted successfully"
    except mysql.connector.Error as err:
        return False, f"Error deleting loan: {err}"

# Get loan by ID
def get_loan_by_id(loan_id):
    try:
        mycursor.execute('''
            SELECT l.*, c.first_name, c.last_name 
            FROM loan l
            JOIN customer c ON l.customer_id = c.customer_id
            WHERE l.loan_id = %s
        ''', (loan_id,))
        return mycursor.fetchone()
    except mysql.connector.Error as err:
        print(f"Error fetching loan: {err}")
        return None

# Get loans for a customer
def get_customer_loans(customer_id):
    try:
        mycursor.execute('''
            SELECT l.*, c.first_name, c.last_name 
            FROM loan l
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
    data = view_customers()
    return render_template('index.html', data=data)

@app.route('/search_customer', methods=['GET', 'POST'])
def search_customer():
    if request.method == 'POST':
        criteria = {
            'first_name': request.form.get('first_name'),
            'last_name': request.form.get('last_name'),
            'phone_number': request.form.get('phone_number'),
        }

        customers = search_customers(criteria)

        if not customers:
            flash('No customers found with the provided criteria.', 'warning')
        return render_template('search_customer.html', customers=customers)

    return render_template('search_customer.html', customers=[])

@app.route('/add_customer', methods=['GET', 'POST'])
def add_customer():
    if request.method == 'POST':
        customer_data = (
            request.form['first_name'],
            request.form['middle_name'],
            request.form['last_name'],
            request.form['street_number'],
            request.form['street_name'],
            request.form['apt_number'],
            request.form['city'],
            request.form['state'],
            request.form['country'],
            request.form['zip_code'],
            request.form['phone_number'],
            request.form['email_address'],
            request.form['date_of_birth'],
            request.form['citizen_status'],
            request.form['status'],
            request.form['user_id']
        )

        success, message = add_customer_to_db(customer_data)
        flash(message, 'success' if success else 'danger')
        if success:
            return redirect(url_for('index'))
    return render_template('add_customer.html')

@app.route('/update_customer/<int:customer_id>', methods=['GET', 'POST'])
def update_customer(customer_id):
    if request.method == 'POST':
        customer_data = (
            request.form['first_name'],
            request.form['middle_name'],
            request.form['last_name'],
            request.form['street_number'],
            request.form['street_name'],
            request.form['apt_number'],
            request.form['city'],
            request.form['state'],
            request.form['country'],
            request.form['zip_code'],
            request.form['phone_number'],
            request.form['email_address'],
            request.form['date_of_birth'],
            request.form['citizen_status'],
            request.form['status']
        )

        success, message = update_customer_in_db(customer_id, customer_data)
        flash(message, 'success' if success else 'danger')
        if success:
            return redirect(url_for('index'))
    else:
        mycursor.execute('SELECT * FROM customer WHERE customer_id = %s', (customer_id,))
        customer = mycursor.fetchone()
        return render_template('update_customer.html', customer=customer)

@app.route('/delete_customer/<int:customer_id>', methods=['POST'])
def delete_customer(customer_id):
    success, message = delete_customer_from_db(customer_id)
    flash(message, 'success' if success else 'danger')
    return redirect(url_for('index'))

@app.route('/add_loan', methods=['GET', 'POST'])
def add_loan_route():
    if request.method == 'POST':
        customer_id = request.form['customer_id']
        start_date = request.form['start_date']
        end_date = request.form['end_date']
        agreement_amount = request.form['agreement_amount']
        withdraw_amount = request.form.get('withdraw_amount', 0)  # Default to 0
        int_rate = request.form['int_rate']
        int_rate_type = request.form['int_rate_type']
        loan_type = request.form['loan_type']
        loan_purpose = request.form.get('loan_purpose', '')  # Default to empty string
        user_ID = request.form.get('user_ID', 0)  # Default to 0
        status = request.form.get('status', 'Active')  # Default to 'Active'
        account_ID = request.form.get('account_ID', 0)  # Default to 0

        # Call the add_loan function
        success, message = add_loan(customer_id, start_date, end_date, agreement_amount, withdraw_amount, int_rate, int_rate_type, loan_type, loan_purpose, user_ID, status, account_ID)
        flash(message, 'success' if success else 'danger')
        if success:
            return redirect(url_for('view_loans_route'))
    
    return render_template('add_loan.html')


@app.route('/view_loans', methods=['GET'])
def view_loans_route():
    loans = view_loans()
    return render_template('search_loan.html', loans=loans)

@app.route('/update_loan/<int:loan_id>', methods=['POST'])
def update_loan_route(loan_id):
    status = request.form['status']
    success, message = update_loan(loan_id, status)
    flash(message, 'success' if success else 'danger')
    return redirect(url_for('view_loans_route'))

@app.route('/delete_loan/<int:loan_id>', methods=['POST'])
def delete_loan_route(loan_id):
    success, message = delete_loan(loan_id)  
    flash(message, 'success' if success else 'danger') 
    return redirect(url_for('view_loans_route'))

if __name__ == '__main__':
    app.run(debug=True)
