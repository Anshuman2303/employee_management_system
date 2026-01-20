-- Purpose: Create indexes on frequently used ID columns for performance.

-- Index on department_id in employees table (for faster joins)
CREATE INDEX idx_employees_dept_id
    ON employees (department_id);

-- Index on employee_id in salary_history table
CREATE INDEX idx_salary_history_emp_id
    ON salary_history (employee_id);

