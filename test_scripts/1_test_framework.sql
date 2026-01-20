--------------------------------------------------------------------------------
-- Custom Assertion Framework (utPLSQL-style)
--------------------------------------------------------------------------------


-- DROP table salary_history ;
-- DROP table employees;
-- DROP table departments;

CREATE OR REPLACE PROCEDURE assert_equal (
    p_test_name IN VARCHAR2,
    p_actual    IN NUMBER,
    p_expected  IN NUMBER
) IS
BEGIN
    IF p_actual = p_expected THEN
        DBMS_OUTPUT.PUT_LINE('✔ PASS: ' || p_test_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            '✖ FAIL: ' || p_test_name ||
            ' | Expected=' || p_expected ||
            ' Actual=' || p_actual
        );
    END IF;
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE assert_true (
    p_test_name IN VARCHAR2,
    p_condition IN BOOLEAN
) IS
BEGIN
    IF p_condition THEN
        DBMS_OUTPUT.PUT_LINE('✔ PASS: ' || p_test_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('✖ FAIL: ' || p_test_name);
    END IF;
END;
/


