SET SERVEROUTPUT ON
SET VERIFY OFF
SET FEEDBACK OFF

PROMPT ======================================
PROMPT EMPLOYEE MANAGEMENT SYSTEM
PROMPT ======================================
PROMPT 1. Add Department
PROMPT 2. Add Employee
PROMPT 3. Update Employee Salary
PROMPT 4. Update Employee Department
PROMPT 5. Department Salary Report
PROMPT 6. Top Paid Employees
PROMPT 0. Exit
PROMPT ======================================

ACCEPT v_choice NUMBER PROMPT 'Enter choice: '

DECLARE
    v_choice NUMBER := &v_choice;
BEGIN
    CASE v_choice

        WHEN 1 THEN
            DECLARE
                v_name VARCHAR2(100) := '&Department_Name';
                v_loc  VARCHAR2(100) := '&Location';
            BEGIN
                emp_management.add_department(v_name, v_loc);
                DBMS_OUTPUT.PUT_LINE('✔ Department added');
            END;

        WHEN 2 THEN
            DECLARE
                v_fn   VARCHAR2(50) := '&First_Name';
                v_ln   VARCHAR2(50) := '&Last_Name';
                v_em   VARCHAR2(100) := '&Email';
                v_ph   VARCHAR2(15) := '&Phone';
                v_sal  NUMBER := &Salary;
                v_dept NUMBER := &Department_ID;
            BEGIN
                emp_management.add_employee(
                    v_fn, v_ln, v_em, v_ph, v_sal, v_dept
                );
                DBMS_OUTPUT.PUT_LINE('✔ Employee added');
            END;

        WHEN 3 THEN
            emp_management.update_salary(&Employee_ID, &New_Salary);
            DBMS_OUTPUT.PUT_LINE('✔ Salary updated');

        WHEN 4 THEN
            emp_management.update_employee_department(
                &Employee_ID, &New_Department_ID
            );
            DBMS_OUTPUT.PUT_LINE('✔ Department updated');

        WHEN 5 THEN
            dept_salary_report_pkg.dept_salary_summary;

        WHEN 6 THEN
            employee_report_pkg.top_paid_employees(&Top_N);

        WHEN 0 THEN
            DBMS_OUTPUT.PUT_LINE('Exiting...');

        ELSE
            DBMS_OUTPUT.PUT_LINE('❌ Invalid option');

    END CASE;
END;
/
