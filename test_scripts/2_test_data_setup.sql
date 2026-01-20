CREATE OR REPLACE PROCEDURE setup_test_data IS
BEGIN
    DELETE FROM salary_history;
    DELETE FROM employees;
    DELETE FROM departments;
    COMMIT;

    -- Departments
    INSERT INTO departments (department_name, location)
    VALUES ('HR', 'NY');

    INSERT INTO departments (department_name, location)
    VALUES ('IT', 'BLR');

    -- Employees
    emp_management.add_employee(
        'John','Doe','john@test.com','111',50000,1
    );

    emp_management.add_employee(
        'Jane','Smith','jane@test.com','222',80000,2
    );

    COMMIT;
END;
/

