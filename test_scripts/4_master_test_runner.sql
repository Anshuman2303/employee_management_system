CREATE OR REPLACE PROCEDURE run_all_tests IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('==============================');
    DBMS_OUTPUT.PUT_LINE(' RUNNING FULL SYSTEM TESTS ');
    DBMS_OUTPUT.PUT_LINE('==============================');

    setup_test_data;

    test_employee_table;
    test_add_employee;
    test_update_employee;
    test_get_employee;
    test_remove_employee;

    test_salary_audit_trigger;
    test_salary_validation;
    test_future_hire_date;

    test_invalid_department;
    test_reports;

    DBMS_OUTPUT.PUT_LINE('==============================');
    DBMS_OUTPUT.PUT_LINE(' ALL OBJECTS TESTED ');
    DBMS_OUTPUT.PUT_LINE('==============================');
END;
/
