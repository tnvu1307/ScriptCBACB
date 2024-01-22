SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sp_gen_datajob_getmrktprice
IS
  PKGCTX   PLOG.LOG_CTX;
BEGIN
    PLOG.SETBEGINSECTION(PKGCTX, 'SP_GEN_DATAJOB_GETMRKTPRICE');

    FOR REC IN (
        SELECT ISS.AUTOID ISSUESID, ISS.ISSUECODE,ISS.ISSUERID, ISR.FULLNAME, ISS.ISSUEDATE, ISS.VALUEOFISSUE, ISS.LTVRATE, ISS.TYPERATE, ISS.MAXLTVRATE, ISS.WARNINGLTVRATE
        FROM ISSUES ISS, ISSUERS ISR
        WHERE ISR.ISSUERID = ISS.ISSUERID
    )LOOP
        FOR R IN (
            SELECT SYMBOL, ACTYPE, SECTYPE, VALMETHOD
            FROM (
                SELECT DISTINCT TRIM(REGEXP_SUBSTR(BO.TICKERLIST,'[^,]+', 1, LEVEL)) SYMBOL, BO.ACTYPE, BO.SECTYPE, BO.VALMETHOD
                FROM BONDTYPE BO
                WHERE BO.ISSUESID = REC.ISSUESID
                CONNECT BY REGEXP_SUBSTR(BO.TICKERLIST, '[^,]+', 1, LEVEL) IS NOT NULL
             )
             WHERE SECTYPE IN ('111')
             GROUP BY SYMBOL, ACTYPE, SECTYPE, VALMETHOD
            )
        LOOP
            INSERT INTO LOG_DATAJOB_GETMRKTPRICE(AUTOID, SYMBOL, STATUS, CREATEDDATE)
            VALUES(seq_LOG_DATAJOB_GETMRKTPRICE.nextval, R.SYMBOL, 'P', SYSTIMESTAMP);
        END LOOP;
    END LOOP;

    COMMIT;
    PLOG.SETENDSECTION(PKGCTX, 'SP_GEN_DATAJOB_GETMRKTPRICE');
EXCEPTION
WHEN OTHERS THEN
PLOG.ERROR (PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
RETURN;
END;
/
