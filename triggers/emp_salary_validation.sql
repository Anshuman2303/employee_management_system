-- Ensures salary is positive and within a valid range.
CREATE OR REPLACE TRIGGER trg_emp_salary_validation
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Salary must be greater than zero.');
    ELSIF :NEW.salary > 1000000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Salary exceeds allowed limit.');
    END IF;
END;
/
