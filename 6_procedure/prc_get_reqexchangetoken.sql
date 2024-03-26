SET DEFINE OFF;
CREATE OR REPLACE
PROCEDURE prc_get_reqexchangetoken(P_REFCURSOR IN OUT PKG_REPORT.REF_CURSOR, P_ERR_CODE IN OUT VARCHAR2, P_ERR_PARAM IN OUT VARCHAR2)
IS

BEGIN
    P_ERR_CODE  := SYSTEMNUMS.C_SUCCESS;

    OPEN P_REFCURSOR FOR
    SELECT * FROM TLPROFILES_REQ_EXCHANGETOKEN WHERE STATUS = 'P';

EXCEPTION WHEN OTHERS THEN
    P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
    PLOG.ERROR('PRC_GET_REQEXCHANGETOKEN ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
END;
/
