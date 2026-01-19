-- Validates that assigned department exists (useful if foreign key is disabled or soft-linked).
CREATE OR REPLACE TRIGGER trg_emp_department_check
BEFORE INSERT OR UPDATE OF department_id ON employees
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM departments
    WHERE department_id = :NEW.department_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Invalid department ID.');
    END IF;
END;
/
