CREATE OR REPLACE PACKAGE BODY security_pkg
AS

    /* AUTHENTICATION */

    FUNCTION authenticate_user (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2
    ) RETURN BOOLEAN
    IS
        v_user_id           NUMBER;
        v_stored_password   VARCHAR2(200);
    BEGIN
        SELECT user_id, password
        INTO   v_user_id, v_stored_password
        FROM   users
        WHERE  username = p_username;

        IF NOT is_account_active(v_user_id) THEN
            log_security_event(v_user_id, 'LOGIN_FAILED', 'Account is locked');
            RETURN FALSE;
        END IF;

        IF verify_password(p_password, v_stored_password) THEN
            log_login(v_user_id, SYSDATE);
            RETURN TRUE;
        ELSE
            log_security_event(v_user_id, 'LOGIN_FAILED', 'Invalid password');
            RETURN FALSE;
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    END authenticate_user;


    FUNCTION is_account_active (
        p_user_id IN NUMBER
    ) RETURN BOOLEAN
    IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT account_status
        INTO   v_status
        FROM   users
        WHERE  user_id = p_user_id;

        RETURN (v_status = 'ACTIVE');
    END is_account_active;


    FUNCTION encrypt_password (
        p_password IN VARCHAR2
    ) RETURN VARCHAR2
    IS
    BEGIN
        RETURN DBMS_CRYPTO.hash(
                   UTL_RAW.cast_to_raw(p_password),
                   DBMS_CRYPTO.hash_sh256
               );
    END encrypt_password;


    FUNCTION verify_password (
        p_entered_password IN VARCHAR2,
        p_stored_password  IN VARCHAR2
    ) RETURN BOOLEAN
    IS
        v_encrypted VARCHAR2(200);
    BEGIN
        v_encrypted := encrypt_password(p_entered_password);
        RETURN (v_encrypted = p_stored_password);
    END verify_password;


    /* AUTHORIZATION */

    FUNCTION has_role (
        p_user_id IN NUMBER,
        p_role_name IN VARCHAR2
    ) RETURN BOOLEAN
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   v_count
        FROM   user_roles ur
        JOIN   roles r ON ur.role_id = r.role_id
        WHERE  ur.user_id = p_user_id
        AND    r.role_name = p_role_name;

        RETURN (v_count > 0);
    END has_role;


    FUNCTION has_permission (
        p_user_id IN NUMBER,
        p_permission_code IN VARCHAR2
    ) RETURN BOOLEAN
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   v_count
        FROM   user_roles ur
        JOIN   role_permissions rp ON ur.role_id = rp.role_id
        JOIN   permissions p ON rp.permission_id = p.permission_id
        WHERE  ur.user_id = p_user_id
        AND    p.permission_code = p_permission_code;

        RETURN (v_count > 0);
    END has_permission;


    /* SESSION MANAGEMENT */

    PROCEDURE log_login (
        p_user_id IN NUMBER,
        p_login_time IN DATE
    )
    IS
    BEGIN
        INSERT INTO login_audit (
            user_id,
            login_time
        ) VALUES (
            p_user_id,
            p_login_time
        );
    END log_login;


    PROCEDURE log_logout (
        p_user_id IN NUMBER,
        p_logout_time IN DATE
    )
    IS
    BEGIN
        UPDATE login_audit
        SET    logout_time = p_logout_time
        WHERE  user_id = p_user_id
        AND    logout_time IS NULL;
    END log_logout;


    FUNCTION get_failed_login_attempts (
        p_user_id IN NUMBER
    ) RETURN NUMBER
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   v_count
        FROM   security_audit
        WHERE  user_id = p_user_id
        AND    event_type = 'LOGIN_FAILED'
        AND    event_time >= SYSDATE - 1;

        RETURN v_count;
    END get_failed_login_attempts;


    /* ACCOUNT SECURITY */

    PROCEDURE lock_account (
        p_user_id IN NUMBER
    )
    IS
    BEGIN
        UPDATE users
        SET    account_status = 'LOCKED'
        WHERE  user_id = p_user_id;

        log_security_event(p_user_id, 'ACCOUNT_LOCKED', 'Account locked');
    END lock_account;


    PROCEDURE unlock_account (
        p_user_id IN NUMBER
    )
    IS
    BEGIN
        UPDATE users
        SET    account_status = 'ACTIVE'
        WHERE  user_id = p_user_id;

        log_security_event(p_user_id, 'ACCOUNT_UNLOCKED', 'Account unlocked');
    END unlock_account;


    PROCEDURE reset_password (
        p_user_id IN NUMBER,
        p_new_password IN VARCHAR2
    )
    IS
    BEGIN
        UPDATE users
        SET    password = encrypt_password(p_new_password)
        WHERE  user_id = p_user_id;

        log_security_event(p_user_id, 'PASSWORD_RESET', 'Password reset by admin');
    END reset_password;


    PROCEDURE change_password (
        p_user_id IN NUMBER,
        p_old_password IN VARCHAR2,
        p_new_password IN VARCHAR2
    )
    IS
        v_stored_password VARCHAR2(200);
    BEGIN
        SELECT password
        INTO   v_stored_password
        FROM   users
        WHERE  user_id = p_user_id;

        IF verify_password(p_old_password, v_stored_password) THEN
            UPDATE users
            SET    password = encrypt_password(p_new_password)
            WHERE  user_id = p_user_id;

            log_security_event(p_user_id, 'PASSWORD_CHANGED', 'Password changed');
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Old password incorrect');
        END IF;
    END change_password;


    /* AUDIT LOGGING */

    PROCEDURE log_security_event (
        p_user_id IN NUMBER,
        p_event_type IN VARCHAR2,
        p_event_description IN VARCHAR2
    )
    IS
    BEGIN
        INSERT INTO security_audit (
            user_id,
            event_type,
            event_description,
            event_time
        ) VALUES (
            p_user_id,
            p_event_type,
            p_event_description,
            SYSDATE
        );
    END log_security_event;

END security_pkg;
/
