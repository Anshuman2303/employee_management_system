-- HAS EMPLOYEE DETAILS
CREATE TABLE employees (
    employee_id     NUMBER AUTOINCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) ,
    email           VARCHAR(100) UNIQUE,
    phone_number    VARCHAR(15) UNIQUE,
    salary          NUMBER(10,2) CHECK (salary > 0),
    department_id   NUMBER NOT NULL,
    hire_date       DATE DEFAULT CURRENT_DATE(),
    CONSTRAINT fk_dept FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

