-- Prevents hire dates in the future.
CREATE OR REPLACE TRIGGER trg_emp_hire_date_check
BEFORE INSERT OR UPDATE OF hire_date ON employees
FOR EACH ROW
BEGIN
    IF :NEW.hire_date > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Hire date cannot be in the future.');
    END IF;
END;
/
