
-- TO MAINTAIN RECORD OF THE EMPLOYEE CHANGES
CREATE TABLE emp_audit (
    emp_id       NUMBER PRIMARY KEY,
    first_name   VARCHAR2(50) NOT NULL,
    last_name    VARCHAR2(50),
    email        VARCHAR2(100),
    action       VARCHAR2(20),
    action_date  DATE
);