SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_update_exportscript(P_KEY IN VARCHAR2, P_STATUS IN VARCHAR2, P_ERR_CODE IN OUT VARCHAR2, P_ERR_PARAM IN OUT VARCHAR2)

AS

BEGIN
    P_ERR_CODE  := 0;
    IF NVL(UPPER(P_KEY), 'ALL') = 'ALL' THEN
        UPDATE EXPORT_SCRIPT_LOG SET STATUS = NVL(P_STATUS, 'C');
    ELSE
        UPDATE EXPORT_SCRIPT_LOG SET STATUS = NVL(P_STATUS, 'C') WHERE FILENAME = P_KEY;
    END IF;
EXCEPTION WHEN OTHERS THEN
    P_ERR_CODE := -1;
    PLOG.ERROR('ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
END PRC_UPDATE_EXPORTSCRIPT;
/
