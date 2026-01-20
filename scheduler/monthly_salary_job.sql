-- emp_salary_audit.sql
CREATE OR REPLACE TRIGGER trg_emp_salary_audit
AFTER UPDATE OF salary ON employees
FOR EACH ROW
WHEN (OLD.salary <> NEW.salary)
BEGIN
    INSERT INTO salary_history (employee_id, old_salary, new_salary, change_date)
    VALUES (:OLD.employee_id, :OLD.salary, :NEW.salary, SYSDATE);
END;
/
