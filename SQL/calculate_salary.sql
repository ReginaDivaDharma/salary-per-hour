-- DROP TABLE IF EXISTS payroll.salary_per_hour;

CREATE TABLE payroll.salary_per_hour (
    year INT,
    month INT,
    branch_id INT,
    salary_per_hour DECIMAL(12, 2)
);

TRUNCATE TABLE payroll.salary_per_hour;

WITH total_hours AS (
    SELECT 
        EXTRACT(YEAR FROM t.date) AS year,
        EXTRACT(MONTH FROM t.date) AS month,
        CAST(e.branch_id AS INT) AS branch_id,  
        e.employee_id,
        SUM(EXTRACT(EPOCH FROM (t.checkout - t.checkin)) / 3600) AS total_hours
    FROM 
        payroll.timesheets t
    JOIN 
        payroll.employees e ON e.employee_id = t.employee_id
    GROUP BY 
        EXTRACT(YEAR FROM t.date), EXTRACT(MONTH FROM t.date), e.branch_id, e.employee_id
),
salary_data AS (
    SELECT 
        EXTRACT(YEAR FROM t.date) AS year,
        EXTRACT(MONTH FROM t.date) AS month,
        CAST(e.branch_id AS INT) AS branch_id, 
        e.employee_id,
        SUM(e.salary) AS total_salary
    FROM 
        payroll.employees e
    JOIN 
        payroll.timesheets t ON e.employee_id = t.employee_id
    GROUP BY 
        EXTRACT(YEAR FROM t.date), EXTRACT(MONTH FROM t.date), e.branch_id, e.employee_id
)

INSERT INTO payroll.salary_per_hour (year, month, branch_id, salary_per_hour)
SELECT 
    h.year,
    h.month,
    h.branch_id,
    CASE 
        WHEN h.total_hours > 0 THEN ROUND(CAST(s.total_salary / h.total_hours AS NUMERIC), 2)
        ELSE 0 -- Default value if total hours is 0
    END AS salary_per_hour
FROM 
    total_hours h
JOIN 
    salary_data s 
    ON h.year = s.year AND h.month = s.month AND h.branch_id = s.branch_id AND h.employee_id = s.employee_id;
