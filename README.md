# salary-per-hour

# Project Overview
This project is an ETL (Extract, Transform, Load) pipeline designed to calculate and store the salary per hour for employees based on their daily timesheets and salaries. The data is loaded incrementally, ensuring that only new records are processed and appended to the target database table. The pipeline uses Python to read CSV files, process them, and load the results into a PostgreSQL database

# Files
employees_cleaned.csv: Contains employee information (ID, branch, salary, etc.).
timesheets_cleaned.csv: Contains timesheet records (check-in and check-out times).
script.py: Python script that processes the data and inserts it into the salary_per_hour table.
calculate_salary.sql: Sql snapshot that processes the salary per hour calculation using the timesheet and employees table
create_schema.sql: Sql script that creates the schema needed for the task as well as both tables such as timesheet and employees.