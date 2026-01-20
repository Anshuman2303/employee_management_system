CREATE OR REPLACE PACKAGE security_pkg
AS
    /* AUTHENTICATION PROCEDURES / FUNCTIONS */

    -- Validate user login credentials
    FUNCTION authenticate_user (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2
    ) RETURN BOOLEAN;

    -- Check if a user account is locked or active
    FUNCTION is_account_active (
        p_user_id IN NUMBER
    ) RETURN BOOLEAN;

    -- Encrypt password before storing
    FUNCTION encrypt_password (
        p_password IN VARCHAR2
    ) RETURN VARCHAR2;

    -- Verify entered password with stored encrypted password
    FUNCTION verify_password (
        p_entered_password IN VARCHAR2,
        p_stored_password  IN VARCHAR2
    ) RETURN BOOLEAN;


    /* AUTHORIZATION / ROLE MANAGEMENT */

    -- Check whether a user has a specific role
    FUNCTION has_role (
        p_user_id IN NUMBER,
        p_role_name IN VARCHAR2
    ) RETURN BOOLEAN;

    -- Check whether a user has permission to perform an action
    FUNCTION has_permission (
        p_user_id IN NUMBER,
        p_permission_code IN VARCHAR2
    ) RETURN BOOLEAN;


    /* USER SESSION & ACCESS CONTROL */

    -- Log user login activity
    PROCEDURE log_login (
        p_user_id IN NUMBER,
        p_login_time IN DATE
    );

    -- Log user logout activity
    PROCEDURE log_logout (
        p_user_id IN NUMBER,
        p_logout_time IN DATE
    );

    -- Get number of failed login attempts
    FUNCTION get_failed_login_attempts (
        p_user_id IN NUMBER
    ) RETURN NUMBER;


    /* ACCOUNT SECURITY & POLICY ENFORCEMENT */

    -- Lock a user account
    PROCEDURE lock_account (
        p_user_id IN NUMBER
    );

    -- Unlock a user account
    PROCEDURE unlock_account (
        p_user_id IN NUMBER
    );

    -- Reset user password
    PROCEDURE reset_password (
        p_user_id IN NUMBER,
        p_new_password IN VARCHAR2
    );

    -- Change password (used by logged-in user)
    PROCEDURE change_password (
        p_user_id IN NUMBER,
        p_old_password IN VARCHAR2,
        p_new_password IN VARCHAR2
    );

    /*  AUDIT & SECURITY LOGGING */

    -- Log security-related events (failed login, role change, etc.)
    PROCEDURE log_security_event (
        p_user_id IN NUMBER,
        p_event_type IN VARCHAR2,
        p_event_description IN VARCHAR2
    );

END security_pkg;
/
