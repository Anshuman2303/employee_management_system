-- Automatically assigns the current date if none is provided.
CREATE OR REPLACE TRIGGER trg_emp_hire_date_default
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF :NEW.hire_date IS NULL THEN
        :NEW.hire_date := SYSDATE;
    END IF;
END;
/
