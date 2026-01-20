CREATE OR REPLACE PACKAGE BODY dept_salary_report_pkg AS

    --Shows department-wise salary analytics
    
    PROCEDURE dept_salary_summary IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('DEPT ID | DEPT NAME | EMP COUNT | TOTAL SALARY | AVG SALARY | MIN SALARY | MAX SALARY');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------------------------------');

        FOR rec IN (
            SELECT
                d.dept_id,
                d.dept_name,
                COUNT(e.emp_id)        AS total_employees,
                NVL(SUM(e.salary),0)   AS total_salary,
                NVL(ROUND(AVG(e.salary),2),0) AS avg_salary,
                NVL(MIN(e.salary),0)   AS min_salary,
                NVL(MAX(e.salary),0)   AS max_salary
            FROM departments d
            LEFT JOIN employees e
                ON d.dept_id = e.dept_id
            GROUP BY d.dept_id, d.dept_name
            ORDER BY total_salary DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.dept_id || ' | ' ||
                rec.dept_name || ' | ' ||
                rec.total_employees || ' | ' ||
                rec.total_salary || ' | ' ||
                rec.avg_salary || ' | ' ||
                rec.min_salary || ' | ' ||
                rec.max_salary
            );
        END LOOP;
    END dept_salary_summary;


    --Lists departments with no employees
    PROCEDURE dept_without_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('DEPARTMENTS WITHOUT EMPLOYEES');
        DBMS_OUTPUT.PUT_LINE('------------------------------');

        FOR rec IN (
            SELECT d.dept_id, d.dept_name
            FROM departments d
            WHERE NOT EXISTS (
                SELECT 1
                FROM employees e
                WHERE e.dept_id = d.dept_id
            )
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.dept_id || ' - ' || rec.dept_name
            );
        END LOOP;
    END dept_without_employees;


    -- Displays department with maximum total salary
        PROCEDURE highest_paid_department IS
        v_dept_name     departments.dept_name%TYPE;
        v_total_salary  NUMBER;
    BEGIN
        SELECT dept_name, total_salary
        INTO v_dept_name, v_total_salary
        FROM (
            SELECT
                d.dept_name,
                SUM(e.salary) AS total_salary
            FROM departments d
            JOIN employees e ON d.dept_id = e.dept_id
            GROUP BY d.dept_name
            ORDER BY total_salary DESC
        )
        WHERE ROWNUM = 1;

        DBMS_OUTPUT.PUT_LINE('HIGHEST PAID DEPARTMENT');
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        DBMS_OUTPUT.PUT_LINE('Department : ' || v_dept_name);
        DBMS_OUTPUT.PUT_LINE('Total Salary : ' || v_total_salary);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No salary data available.');
    END highest_paid_department;

END dept_salary_report_pkg;
/
