SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE log_fin_content2(FILEBODY IN VARCHAR2)
IS
    L_COUNT NUMBER;
BEGIN

    SELECT COUNT(1) INTO L_COUNT FROM VSD_FIN_LOG WHERE FINFILENAME = 'TEST.fin';

    IF L_COUNT > 0 THEN
        UPDATE VSD_FIN_LOG SET FINBODY = FILEBODY WHERE FINFILENAME = 'TEST.fin';
    ELSE
        INSERT INTO VSD_FIN_LOG(FINFILENAME, FINBODY) VALUES ('TEST.fin', FILEBODY);
    END IF;

    COMMIT;
EXCEPTION WHEN OTHERS THEN
    PLOG.ERROR('LOG_FIN_CONTENT: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
