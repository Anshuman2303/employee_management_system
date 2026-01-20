-- Purpose: Track all salary changes for auditing.
CREATE TABLE employees (
    employee_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name    VARCHAR2(50) NOT NULL,
    last_name     VARCHAR2(50),
    email         VARCHAR2(100) UNIQUE,
    phone_number  VARCHAR2(15) UNIQUE,
    salary        NUMBER(10,2) CHECK (salary > 0),
    department_id NUMBER NOT NULL,
    hire_date     DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_dept
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);