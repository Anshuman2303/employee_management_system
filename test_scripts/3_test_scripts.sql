--1. Test EMPLOYEES insert
CREATE OR REPLACE PROCEDURE test_employee_table IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM employees;
    assert_equal('Employees Table Insert', v_count, 2);
END;
/

--2. add_employee
CREATE OR REPLACE PROCEDURE test_add_employee IS
    v_count NUMBER;
BEGIN
    emp_management.add_employee(
        'Amit','Sharma','amit@test.com','333',70000,2
    );

    SELECT COUNT(*) INTO v_count
    FROM employees
    WHERE email = 'amit@test.com';

    assert_equal('add_employee', v_count, 1);
END;
/

--3. update_employee
CREATE OR REPLACE PROCEDURE test_update_employee IS
    v_salary NUMBER;
BEGIN
    emp_management.update_employee(
        1,'John','Doe','john@test.com','999',2
    );

    SELECT department_id INTO v_salary
    FROM employees WHERE employee_id = 1;

    assert_equal('update_employee', v_salary, 2);
END;
/

--4. get_employee(FUNCTION)
CREATE OR REPLACE PROCEDURE test_get_employee IS
    v_emp emp_management.employee_rec;
BEGIN
    v_emp := emp_management.get_employee(1);
    assert_equal('get_employee', v_emp.employee_id, 1);
END;
/

--5. remove_employee
CREATE OR REPLACE PROCEDURE test_remove_employee IS
    v_count NUMBER;
BEGIN
    emp_management.remove_employee(1);

    SELECT COUNT(*) INTO v_count
    FROM employees WHERE employee_id = 1;

    assert_equal('remove_employee', v_count, 0);
END;
/

--6. Salary Audit Trigger
CREATE OR REPLACE PROCEDURE test_salary_audit_trigger IS
    v_count NUMBER;
BEGIN
    emp_management.update_salary(2, 90000);

    SELECT COUNT(*) INTO v_count
    FROM salary_history
    WHERE employee_id = 2;

    assert_equal('Salary Audit Trigger', v_count, 1);
END;
/

--7. Salary Validation Trigger
CREATE OR REPLACE PROCEDURE test_salary_validation IS
BEGIN
    UPDATE employees SET salary = -1 WHERE employee_id = 2;
    DBMS_OUTPUT.PUT_LINE('✖ FAIL: Salary validation trigger');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✔ PASS: Salary validation trigger');
END;
/

-- 8. Hire Date Future Check
CREATE OR REPLACE PROCEDURE test_future_hire_date IS
BEGIN
    INSERT INTO employees (
        first_name,last_name,email,phone_number,
        salary,department_id,hire_date
    ) VALUES (
        'Test','Future','f@test.com','444',50000,1,SYSDATE+5
    );

    DBMS_OUTPUT.PUT_LINE('✖ FAIL: Future hire date allowed');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✔ PASS: Future hire date blocked');
END;
/

--9. Foreign Key department check
CREATE OR REPLACE PROCEDURE test_invalid_department IS
BEGIN
    emp_management.add_employee(
        'Bad','Dept','bd@test.com','666',40000,999
    );

    DBMS_OUTPUT.PUT_LINE('✖ FAIL: Invalid department allowed');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✔ PASS: Department FK enforced');
END;
/


-- 10. REPORT PACKAGE TESTS
CREATE OR REPLACE PROCEDURE test_reports IS
BEGIN
    dept_salary_report_pkg.dept_salary_summary;
    employee_report_pkg.all_employees;

    DBMS_OUTPUT.PUT_LINE('✔ PASS: Report packages executed');
END;
/