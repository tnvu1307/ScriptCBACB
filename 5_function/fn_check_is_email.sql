SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_check_is_email(P_EMAIL VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    IF REGEXP_LIKE(P_EMAIL, '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
        RETURN 'TRUE';
    ELSE
        RETURN 'FALSE'; -- Invalid email
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'FALSE'; -- Error occurred, treat it as an invalid email
END fn_check_is_email;
/
