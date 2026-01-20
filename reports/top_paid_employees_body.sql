CREATE OR REPLACE PACKAGE BODY employee_report_pkg AS

    --Displays all employee information
    
    PROCEDURE all_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EMP ID | EMP NAME | DEPT ID | JOB | SALARY | HIRE DATE ');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

        FOR rec IN (
            SELECT
                employee_id,
                first_name,
                last_name,
                email,
                phone_number,
                salary,
                department_id,
                hire_date
            FROM employees
            ORDER BY employee_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' | ' ||
                rec.last_name || ' | ' ||
                rec.email || ' | ' ||
                rec.phone_number || ' | ' ||
                rec.salary || ' | ' ||  
                rec.department_id || ' | ' ||
                TO_CHAR(rec.hire_date,'DD-MON-YYYY') 
            );
        END LOOP;
    END all_employees;


    --Displays employees for a given department
    PROCEDURE employees_by_department (
        p_dept_id IN employees.dept_id%TYPE
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EMPLOYEES IN DEPARTMENT : ' || p_dept_id);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');

        FOR rec IN (
            SELECT employee_id, first_name, last_name, email, phone_number, salary
            FROM employees
            WHERE department_id = p_dept_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' | ' ||
                rec.last_name || ' | ' ||
                rec.email || ' | ' ||
                rec.phone_number || ' | ' ||
                rec.salary
            );
        END LOOP;
    END employees_by_department;


    --Displays employee salary information
    
    PROCEDURE employee_salary_details IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EMP ID | EMP NAME | SALARY');
        DBMS_OUTPUT.PUT_LINE('--------------------------');

        FOR rec IN (
            SELECT employee_id, first_name, last_name, email, phone_number, salary
            FROM employees
            ORDER BY salary DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' | ' ||
                rec.last_name || ' | ' ||
                rec.email || ' | ' ||
                rec.phone_number || ' | ' ||
                rec.salary
            );
        END LOOP;
    END employee_salary_details;


   --Displays complete employee profile
    
    PROCEDURE employee_profile (
        p_emp_id IN employees.emp_id%TYPE
    ) IS
        v_found BOOLEAN := FALSE;
    BEGIN
        FOR rec IN (
            SELECT
                e.employee_id,
                e.first_name,
                e.last_name,
                e.email,
                e.phone_number,
                e.salary,
                e.department_id,
                e.hire_date
            FROM employees e
            LEFT JOIN departments d
                ON e.department_id = d.department_id
            WHERE e.employee_id = p_emp_id
        ) LOOP
            v_found := TRUE;

            DBMS_OUTPUT.PUT_LINE('EMPLOYEE PROFILE');
            DBMS_OUTPUT.PUT_LINE('----------------');
            DBMS_OUTPUT.PUT_LINE('ID        : ' || rec.emp_id);
            DBMS_OUTPUT.PUT_LINE('Name      : ' || rec.emp_name);
            DBMS_OUTPUT.PUT_LINE('Job Title : ' || rec.job_title);
            DBMS_OUTPUT.PUT_LINE('Department: ' || rec.dept_name);
            DBMS_OUTPUT.PUT_LINE('Salary    : ' || rec.salary);
            DBMS_OUTPUT.PUT_LINE('Hire Date : ' || TO_CHAR(rec.hire_date,'DD-MON-YYYY'));
            DBMS_OUTPUT.PUT_LINE('Status    : ' || rec.status);
        END LOOP;

        IF NOT v_found THEN
            DBMS_OUTPUT.PUT_LINE('Employee not found.');
        END IF;
    END employee_profile;


    --employees joined in last N days
    
    PROCEDURE recently_joined_employees (
        p_days IN NUMBER
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EMPLOYEES JOINED IN LAST ' || p_days || ' DAYS');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------');

        FOR rec IN (
            SELECT employee_id, first_name, last_name, hire_date
            FROM employees
            WHERE hire_date >= SYSDATE - p_days
            ORDER BY hire_date DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' | ' ||
                rec.last_name || ' | ' ||
                TO_CHAR(rec.hire_date,'DD-MON-YYYY')
            );
        END LOOP;
    END recently_joined_employees;

END employee_report_pkg;
/
CREATE OR REPLACE PACKAGE BODY employee_report_pkg AS
    ------------------------------------------------------------------
    -- Procedure: all_employees
    -- Purpose  : Displays complete employee listing
    ------------------------------------------------------------------
    PROCEDURE all_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'EMP_ID | NAME | EMAIL | PHONE | SALARY | DEPT_ID | HIRE_DATE'
        );
        DBMS_OUTPUT.PUT_LINE(
            '-----------------------------------------------------------------------'
        );

        FOR rec IN (
            SELECT
                employee_id,
                first_name,
                last_name,
                email,
                phone_number,
                salary,
                department_id,
                hire_date
            FROM employees
            ORDER BY employee_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                rec.email || ' | ' ||
                rec.phone_number || ' | ' ||
                rec.salary || ' | ' ||
                rec.department_id || ' | ' ||
                TO_CHAR(rec.hire_date, 'DD-MON-YYYY')
            );
        END LOOP;
    END all_employees;


    ------------------------------------------------------------------
    -- Procedure: employees_by_department
    -- Purpose  : Lists employees belonging to a specific department
    ------------------------------------------------------------------
    PROCEDURE employees_by_department (
        p_department_id IN employees.department_id%TYPE
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'EMPLOYEES IN DEPARTMENT ' || p_department_id
        );
        DBMS_OUTPUT.PUT_LINE(
            '------------------------------------------'
        );

        FOR rec IN (
            SELECT
                employee_id,
                first_name,
                last_name,
                email,
                phone_number,
                salary
            FROM employees
            WHERE department_id = p_department_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                rec.email || ' | ' ||
                rec.phone_number || ' | ' ||
                rec.salary
            );
        END LOOP;
    END employees_by_department;


    ------------------------------------------------------------------
    -- Procedure: employee_salary_details
    -- Purpose  : Displays employees sorted by salary (highest first)
    ------------------------------------------------------------------
    PROCEDURE employee_salary_details IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EMP_ID | NAME | SALARY');
        DBMS_OUTPUT.PUT_LINE('----------------------');

        FOR rec IN (
            SELECT employee_id, first_name, last_name, salary
            FROM employees
            ORDER BY salary DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                rec.salary
            );
        END LOOP;
    END employee_salary_details;


    ------------------------------------------------------------------
    -- Procedure: employee_profile
    -- Purpose  : Displays detailed profile of a single employee
    ------------------------------------------------------------------
    PROCEDURE employee_profile (
        p_employee_id IN employees.employee_id%TYPE
    ) IS
        v_found BOOLEAN := FALSE;
    BEGIN
        FOR rec IN (
            SELECT
                e.employee_id,
                e.first_name,
                e.last_name,
                e.email,
                e.phone_number,
                e.salary,
                d.department_name,
                e.hire_date
            FROM employees e
            LEFT JOIN departments d
                ON e.department_id = d.department_id
            WHERE e.employee_id = p_employee_id
        ) LOOP
            v_found := TRUE;

            DBMS_OUTPUT.PUT_LINE('EMPLOYEE PROFILE');
            DBMS_OUTPUT.PUT_LINE('----------------');
            DBMS_OUTPUT.PUT_LINE('ID        : ' || rec.employee_id);
            DBMS_OUTPUT.PUT_LINE('Name      : ' || rec.first_name || ' ' || rec.last_name);
            DBMS_OUTPUT.PUT_LINE('Email     : ' || rec.email);
            DBMS_OUTPUT.PUT_LINE('Phone     : ' || rec.phone_number);
            DBMS_OUTPUT.PUT_LINE('Department: ' || rec.department_name);
            DBMS_OUTPUT.PUT_LINE('Salary    : ' || rec.salary);
            DBMS_OUTPUT.PUT_LINE('Hire Date : ' || TO_CHAR(rec.hire_date, 'DD-MON-YYYY'));
        END LOOP;

        -- Handle invalid employee ID
        IF NOT v_found THEN
            DBMS_OUTPUT.PUT_LINE('Employee not found.');
        END IF;
    END employee_profile;


    ------------------------------------------------------------------
    -- Procedure: recently_joined_employees
    -- Purpose  : Displays employees joined within last N days
    ------------------------------------------------------------------
    PROCEDURE recently_joined_employees (
        p_days IN NUMBER
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'EMPLOYEES JOINED IN LAST ' || p_days || ' DAYS'
        );
        DBMS_OUTPUT.PUT_LINE(
            '----------------------------------------------'
        );

        FOR rec IN (
            SELECT employee_id, first_name, last_name, hire_date
            FROM employees
            WHERE hire_date >= SYSDATE - p_days
            ORDER BY hire_date DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                TO_CHAR(rec.hire_date, 'DD-MON-YYYY')
            );
        END LOOP;
    END recently_joined_employees;

END employee_report_pkg;
/
CREATE OR REPLACE PACKAGE BODY employee_report_pkg AS
    ------------------------------------------------------------------
    -- Procedure: all_employees
    -- Purpose  : Displays complete employee listing
    ------------------------------------------------------------------
    PROCEDURE all_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'EMP_ID | NAME | EMAIL | PHONE | SALARY | DEPT_ID | HIRE_DATE'
        );
        DBMS_OUTPUT.PUT_LINE(
            '-----------------------------------------------------------------------'
        );

        FOR rec IN (
            SELECT
                employee_id,
                first_name,
                last_name,
                email,
                phone_number,
                salary,
                department_id,
                hire_date
            FROM employees
            ORDER BY employee_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                rec.email || ' | ' ||
                rec.phone_number || ' | ' ||
                rec.salary || ' | ' ||
                rec.department_id || ' | ' ||
                TO_CHAR(rec.hire_date, 'DD-MON-YYYY')
            );
        END LOOP;
    END all_employees;


    ------------------------------------------------------------------
    -- Procedure: employees_by_department
    -- Purpose  : Lists employees belonging to a specific department
    ------------------------------------------------------------------
    PROCEDURE employees_by_department (
        p_department_id IN employees.department_id%TYPE
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'EMPLOYEES IN DEPARTMENT ' || p_department_id
        );
        DBMS_OUTPUT.PUT_LINE(
            '------------------------------------------'
        );

        FOR rec IN (
            SELECT
                employee_id,
                first_name,
                last_name,
                email,
                phone_number,
                salary
            FROM employees
            WHERE department_id = p_department_id
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                rec.email || ' | ' ||
                rec.phone_number || ' | ' ||
                rec.salary
            );
        END LOOP;
    END employees_by_department;


    ------------------------------------------------------------------
    -- Procedure: employee_salary_details
    -- Purpose  : Displays employees sorted by salary (highest first)
    ------------------------------------------------------------------
    PROCEDURE employee_salary_details IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('EMP_ID | NAME | SALARY');
        DBMS_OUTPUT.PUT_LINE('----------------------');

        FOR rec IN (
            SELECT employee_id, first_name, last_name, salary
            FROM employees
            ORDER BY salary DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                rec.salary
            );
        END LOOP;
    END employee_salary_details;


    ------------------------------------------------------------------
    -- Procedure: employee_profile
    -- Purpose  : Displays detailed profile of a single employee
    ------------------------------------------------------------------
    PROCEDURE employee_profile (
        p_employee_id IN employees.employee_id%TYPE
    ) IS
        v_found BOOLEAN := FALSE;
    BEGIN
        FOR rec IN (
            SELECT
                e.employee_id,
                e.first_name,
                e.last_name,
                e.email,
                e.phone_number,
                e.salary,
                d.department_name,
                e.hire_date
            FROM employees e
            LEFT JOIN departments d
                ON e.department_id = d.department_id
            WHERE e.employee_id = p_employee_id
        ) LOOP
            v_found := TRUE;

            DBMS_OUTPUT.PUT_LINE('EMPLOYEE PROFILE');
            DBMS_OUTPUT.PUT_LINE('----------------');
            DBMS_OUTPUT.PUT_LINE('ID        : ' || rec.employee_id);
            DBMS_OUTPUT.PUT_LINE('Name      : ' || rec.first_name || ' ' || rec.last_name);
            DBMS_OUTPUT.PUT_LINE('Email     : ' || rec.email);
            DBMS_OUTPUT.PUT_LINE('Phone     : ' || rec.phone_number);
            DBMS_OUTPUT.PUT_LINE('Department: ' || rec.department_name);
            DBMS_OUTPUT.PUT_LINE('Salary    : ' || rec.salary);
            DBMS_OUTPUT.PUT_LINE('Hire Date : ' || TO_CHAR(rec.hire_date, 'DD-MON-YYYY'));
        END LOOP;

        -- Handle invalid employee ID
        IF NOT v_found THEN
            DBMS_OUTPUT.PUT_LINE('Employee not found.');
        END IF;
    END employee_profile;


    ------------------------------------------------------------------
    -- Procedure: recently_joined_employees
    -- Purpose  : Displays employees joined within last N days
    ------------------------------------------------------------------
    PROCEDURE recently_joined_employees (
        p_days IN NUMBER
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'EMPLOYEES JOINED IN LAST ' || p_days || ' DAYS'
        );
        DBMS_OUTPUT.PUT_LINE(
            '----------------------------------------------'
        );

        FOR rec IN (
            SELECT employee_id, first_name, last_name, hire_date
            FROM employees
            WHERE hire_date >= SYSDATE - p_days
            ORDER BY hire_date DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.employee_id || ' | ' ||
                rec.first_name || ' ' || rec.last_name || ' | ' ||
                TO_CHAR(rec.hire_date, 'DD-MON-YYYY')
            );
        END LOOP;
    END recently_joined_employees;

END employee_report_pkg;
/
