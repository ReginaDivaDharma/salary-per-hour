-- Schema
CREATE SCHEMA IF NOT EXISTS payroll;

-- employees table
CREATE TABLE IF NOT EXISTS payroll.employees (
    employee_id SERIAL PRIMARY KEY,
    branch_id VARCHAR(50),
    salary VARCHAR(50),
    join_date DATE,
    resign_date DATE
);

-- timesheets table
CREATE TABLE IF NOT EXISTS payroll.timesheets (
    timesheet_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES payroll.employees(employee_id),
    date DATE,
    checkin DATE,
    checkout DATE
);