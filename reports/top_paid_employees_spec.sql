CREATE OR REPLACE PACKAGE employee_report_pkg AS
    

    -- Displays all employee details
    PROCEDURE all_employees;

    -- Displays employees of a specific department
    PROCEDURE employees_by_department (
        p_department_id IN employees.department_id%TYPE
    );

    -- Displays salary details of all employees
    PROCEDURE employee_salary_details;

    -- Displays complete profile of a specific employee
    PROCEDURE employee_profile (
        p_employee_id IN employees.employee_id%TYPE
    );

    -- Displays employees joined in the last N days
    PROCEDURE recently_joined_employees (
        p_days IN NUMBER
    );

END employee_report_pkg;
/
