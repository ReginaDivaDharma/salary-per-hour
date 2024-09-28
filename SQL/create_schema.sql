-- Schema
CREATE SCHEMA IF NOT EXISTS payroll;

-- employees table
CREATE TABLE IF NOT EXISTS payroll.employees (
    employee_id INT PRIMARY KEY,
    branch_id VARCHAR(50),
    salary FLOAT,
    join_date DATE,
    resign_date DATE
);

-- timesheets table
CREATE TABLE IF NOT EXISTS payroll.timesheets (
    timesheet_id INT PRIMARY KEY,
    employee_id INT REFERENCES payroll.employees(employee_id),
    date DATE,
    checkin TIMESTAMP,
    checkout TIMESTAMP
);

-- load data to employees table
COPY payroll.employees FROM 'C:\Users\Administrator\Desktop\IT Projects\Mekari - Salary Per Hour\Data\employees_cleaned.csv' DELIMITER ',' CSV HEADER;

-- load data to timesheets table
COPY payroll.timesheets FROM 'C:\Users\Administrator\Desktop\IT Projects\Mekari - Salary Per Hour\Data\timesheets_cleaned.csv' DELIMITER ',' CSV HEADER;
