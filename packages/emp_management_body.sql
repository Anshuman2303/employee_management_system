CREATE OR REPLACE PACKAGE BODY emp_management AS

    PROCEDURE add_employee(
        p_first_name     IN VARCHAR2,
        p_last_name      IN VARCHAR2,
        p_email          IN VARCHAR2,
        p_phone_number   IN VARCHAR2,
        p_salary         IN NUMBER,
        p_department_id  IN NUMBER
    ) IS
    BEGIN
        INSERT INTO employees (
            first_name, last_name, email,
            phone_number, salary, department_id
        )
        VALUES (
            p_first_name, p_last_name, p_email,
            p_phone_number, p_salary, p_department_id
        );
    END add_employee;


    PROCEDURE update_employee(
        p_id            NUMBER,
        p_first_name    VARCHAR2,
        p_last_name     VARCHAR2,
        p_email         VARCHAR2,
        p_phone_number  VARCHAR2,
        p_dept_id       NUMBER
    ) IS
    BEGIN
        UPDATE employees
        SET first_name   = p_first_name,
            last_name    = p_last_name,
            email        = p_email,
            phone_number = p_phone_number,
            department_id = p_dept_id
        WHERE employee_id = p_id;
    END update_employee;


    FUNCTION get_employee(p_id NUMBER)
        RETURN employee_rec
    IS
        v_emp employee_rec;
    BEGIN
        SELECT employee_id, first_name, last_name,
               email, phone_number, salary,
               department_id, hire_date
        INTO v_emp
        FROM employees
        WHERE employee_id = p_id;

        RETURN v_emp;
    END get_employee;


    PROCEDURE remove_employee(p_id NUMBER) IS
    BEGIN
        DELETE FROM employees
        WHERE employee_id = p_id;
    END remove_employee;


    PROCEDURE add_department(p_name VARCHAR2) IS
    BEGIN
        INSERT INTO departments (department_name)
        VALUES (p_name);
    END add_department;


    PROCEDURE remove_department(p_id NUMBER) IS
    BEGIN
        DELETE FROM departments
        WHERE department_id = p_id;
    END remove_department;


    PROCEDURE update_department(p_id NUMBER, p_name VARCHAR2) IS
    BEGIN
        UPDATE departments
        SET department_name = p_name
        WHERE department_id = p_id;
    END update_department;


    FUNCTION get_department(p_id NUMBER)
        RETURN VARCHAR2
    IS
        v_name departments.department_name%TYPE;
    BEGIN
        SELECT department_name
        INTO v_name
        FROM departments
        WHERE department_id = p_id;

        RETURN v_name;
    END get_department;


    PROCEDURE update_salary(
        p_emp_id NUMBER,
        p_new_salary NUMBER
    ) IS
    BEGIN
        UPDATE employees
        SET salary = p_new_salary
        WHERE employee_id = p_emp_id;
    END update_salary;

END emp_management;
/
