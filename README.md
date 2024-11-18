# Mortgage Management System

    ## Description
The Mortgage Management System is a web-based application designed to manage mortgage records, including customers, loans, and related data. The system provides an intuitive user interface to perform CRUD (Create, Read, Update, Delete) operations on customers and loans, making mortgage data management efficient and secure. The application is built using Python with Flask as the web framework, and MySQL as the database.

## Features
- **Customer Management**: Add, search, update, and delete customer records.
- **Loan Management**: Add, search, update, and delete loan records.
- **Report Generation**: Generate various reports including percent rank reports, loan analysis, top users, monthly disbursements, and overdue loans.

- **Error Handling and Validation**: Robust error handling and input validation ensure the integrity and security of the data.

## Prerequisites
- **Python 3.8 or higher**: Make sure Python is installed on your machine.
- **MySQL**: Install MySQL for database management.
- **Libraries**: The following Python libraries are required:
  - Flask
  - Flask-MySQL
  - pymysql
  - python-dotenv
  - MySQL Connector

## Installation

1. **Clone the Repository**
   ```sh
   git clone https://github.com/IrmaGeo/mortgage-management-system.git
   cd mortgage-management-system
   ```

2. **Create a Virtual Environment**
   ```sh
   python -m venv venv
   source venv/bin/activate # On Windows use `venv\Scripts\activate`
   ```
3. **Set Up Environment Variables**
   Create a `.env` file in the root directory with the following environment variables:
   ```sh
   DATABASE_HOST=localhost
   DATABASE_PORT=3306
   DATABASE_USER=<Your_MySQL_User>
   DATABASE_PASSWORD=<Your_MySQL_Password>
   DATABASE_NAME=Mortgage
   FLASK_SECRET_KEY=<Your_Flask_Secret_Key>
   ```

4. **Initialize the Database**
   - Use the `mortgage_management_system.sql` file to create and initialize the necessary tables.
   - Connect to your MySQL database and run the SQL script.

5. **Run the Application**
   ```sh
   flask run
   ```
   Open your browser and go to `http://127.0.0.1:5000/` to access the system.

## Usage

1. **Add Customers and Loans**
   - Navigate to the **Customers** or **Loans** section from the main page.
   - Use the "Add" option to enter details and create new records.

2. **Search, Update, or Delete Records**
   - Use the **Search** option to look for existing customers or loans.
   - View details, and use the **Update** or **Delete** options as needed.

3. **Generate Reports**
   - Navigate to the **Reports** section to generate and view various business insights, such as Percent Rank, Loan Analysis, Top Users, Monthly Disbursements, and Overdue Loans.


## Database Schema
The application uses the following tables:
- **Customer Table**: Stores customer details such as name, address, contact information, citizenship status, etc.
- **Loan Table**: Stores loan details like loan type, agreement amount, interest rate, loan status, etc.

## Technologies Used
- **Backend**: Python (Flask)
- **Frontend**: HTML, CSS, JavaScript
- **Database**: MySQL

## Contributing
If you wish to contribute:
- Fork the repository.
- Create a new branch (`git checkout -b feature-branch-name`).
- Commit your changes (`git commit -m 'Add some feature'`).
- Push to the branch (`git push origin feature-branch-name`).
- Open a pull request.


## Acknowledgments
- University of Illinois - for supporting the Master's program in AI.
- OpenAI - for providing language support for this documentation.

---
Please feel free to raise any issues or questions regarding the application through GitHub. Your contributions and feedback are highly valued!

