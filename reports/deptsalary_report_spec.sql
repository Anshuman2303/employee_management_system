CREATE OR REPLACE PACKAGE dept_salary_report_pkg AS
    

    -- Displays department-wise employee count and salary summary
    PROCEDURE dept_salary_summary;

    -- Displays departments having no employees
    PROCEDURE dept_without_employees;

    -- Displays department with highest total salary
    PROCEDURE highest_paid_department;

END dept_salary_report_pkg;
/
