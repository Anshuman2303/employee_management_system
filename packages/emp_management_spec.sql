CREATE OR REPLACE PACKAGE emp_management AS

    -- type of employee_rec yet to be declared as a record
    -- if you want to add it to record files feel free to do so .

    TYPE employee_rec IS RECORD (
        employee_id   NUMBER,
        first_name    VARCHAR2(50),
        last_name     VARCHAR2(50),
        email         VARCHAR2(100),
        phone_number  VARCHAR2(15),
        salary        NUMBER(10,2),
        department_id NUMBER,
        hire_date     DATE
    );
    -- Purpose: Procedure to add a new employee
    PROCEDURE add_employee(
        p_first_name    IN VARCHAR2,
        p_last_name     IN VARCHAR2,
        p_email         IN VARCHAR2,
        p_phone_number  IN VARCHAR2,
        p_salary        IN NUMBER,
        p_department_id IN NUMBER
    );
    -- purpse: update employees
    PROCEDURE update_employee( 
        p_id NUMBER,
        p_first_name VARCHAR2, 
        p_last_name VARCHAR2,
        p_email VARCHAR2,
        p_phone_number VARCHAR2, 
        p_dept_id NUMBER
    );

    -- purpose get employee details
    FUNCTION get_employee(p_id NUMBER) 
        RETURN employee_rec;

    --remove employee
    PROCEDURE remove_employee(p_id NUMBER);

    -- purpose; procedure to add department
    PROCEDURE add_department(p_id NUMBER, p_name VARCHAR2);

    -- procedure to remove departmet
    PROCEDURE remove_department(p_id NUMBER);

    -- procedure to update department
    PROCEDURE update_department(p_id NUMBER, p_name VARCHAR2);

    -- function to get department details
    FUNCTION get_department(p_id NUMBER) RETURN VARCHAR2;

    -- procedure to update salary
    PROCEDURE update_salary(
        p_emp_id NUMBER, 
        p_new_salary NUMBER
    );

END emp_management;