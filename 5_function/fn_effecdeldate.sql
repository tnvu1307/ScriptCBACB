SET DEFINE OFF;
CREATE OR REPLACE FUNCTION fn_effecdeldate(pv_VALUEIN In VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
   RETURN trim(pv_VALUEIN);
EXCEPTION
   WHEN OTHERS THEN
    RETURN '';
END;
/
