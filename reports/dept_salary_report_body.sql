CREATE OR REPLACE PACKAGE BODY dept_salary_report_pkg AS
    ------------------------------------------------------------------
    -- Procedure: dept_salary_summary
    -- Purpose  : Displays department-wise employee count and
    --            salary statistics (total, avg, min, max)
    ------------------------------------------------------------------
    PROCEDURE dept_salary_summary IS
    BEGIN
        -- Print report header
        DBMS_OUTPUT.PUT_LINE(
            'DEPT_ID | DEPT_NAME | EMP_COUNT | TOTAL_SALARY | AVG_SALARY | MIN_SALARY | MAX_SALARY'
        );
        DBMS_OUTPUT.PUT_LINE(
            '--------------------------------------------------------------------------------------'
        );

        -- Loop through department-wise aggregated salary data
        FOR rec IN (
            SELECT
                d.department_id,
                d.department_name,
                COUNT(e.employee_id)               AS emp_count,
                NVL(SUM(e.salary), 0)              AS total_salary,
                NVL(ROUND(AVG(e.salary), 2), 0)    AS avg_salary,
                NVL(MIN(e.salary), 0)              AS min_salary,
                NVL(MAX(e.salary), 0)              AS max_salary
            FROM departments d
            LEFT JOIN employees e
                ON d.department_id = e.department_id
            GROUP BY d.department_id, d.department_name
            ORDER BY total_salary DESC
        ) LOOP
            -- Print each department summary
            DBMS_OUTPUT.PUT_LINE(
                rec.department_id || ' | ' ||
                rec.department_name || ' | ' ||
                rec.emp_count || ' | ' ||
                rec.total_salary || ' | ' ||
                rec.avg_salary || ' | ' ||
                rec.min_salary || ' | ' ||
                rec.max_salary
            );
        END LOOP;
    END dept_salary_summary;


    ------------------------------------------------------------------
    -- Procedure: dept_without_employees
    -- Purpose  : Lists departments that currently have no employees
    ------------------------------------------------------------------
    PROCEDURE dept_without_employees IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('DEPARTMENTS WITHOUT EMPLOYEES');
        DBMS_OUTPUT.PUT_LINE('------------------------------');

        FOR rec IN (
            SELECT department_id, department_name
            FROM departments d
            WHERE NOT EXISTS (
                SELECT 1
                FROM employees e
                WHERE e.department_id = d.department_id
            )
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(
                rec.department_id || ' | ' || rec.department_name
            );
        END LOOP;
    END dept_without_employees;


    ------------------------------------------------------------------
    -- Procedure: highest_paid_department
    -- Purpose  : Displays the department with the highest total salary
    ------------------------------------------------------------------
    PROCEDURE highest_paid_department IS
        v_dept_name     departments.department_name%TYPE;
        v_total_salary  NUMBER;
    BEGIN
        -- Fetch department with highest salary expense
        SELECT department_name, total_salary
        INTO v_dept_name, v_total_salary
        FROM (
            SELECT
                d.department_name,
                SUM(e.salary) AS total_salary
            FROM departments d
            JOIN employees e
                ON d.department_id = e.department_id
            GROUP BY d.department_name
            ORDER BY total_salary DESC
        )
        WHERE ROWNUM = 1;

        DBMS_OUTPUT.PUT_LINE('HIGHEST PAID DEPARTMENT');
        DBMS_OUTPUT.PUT_LINE('-----------------------');
        DBMS_OUTPUT.PUT_LINE('Department   : ' || v_dept_name);
        DBMS_OUTPUT.PUT_LINE('Total Salary : ' || v_total_salary);

    EXCEPTION
        -- Handles scenario where no employees exist
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No salary data available.');
    END highest_paid_department;

END dept_salary_report_pkg;
/
