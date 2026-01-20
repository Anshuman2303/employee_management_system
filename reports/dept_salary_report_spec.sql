CREATE OR REPLACE PACKAGE dept_salary_report_pkg AS

    -- Department-wise salary summary
    PROCEDURE dept_salary_summary;

    -- Departments with no employees
    PROCEDURE dept_without_employees;

    -- Department with highest total salary
    PROCEDURE highest_paid_department;

END dept_salary_report_pkg;
/
