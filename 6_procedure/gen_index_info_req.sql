SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE gen_index_info_req
IS
    L_REQBODY VARCHAR2(4000);
    L_TXDARE DATE;
BEGIN
    L_TXDARE := GETCURRDATE;
    FOR REC IN (
        SELECT INF.*
        FROM INDEX_INFO INF
        WHERE INF.REQSTATUS = 'P'
    )LOOP
        L_REQBODY := '';
        L_REQBODY := L_REQBODY || 'INDEXCODE:' || REC.INDEXCODE || CHR(13) || CHR(10);
        L_REQBODY := L_REQBODY || 'TOTALSTOCK:' || TO_CHAR(REC.TOTALSTOCK, 'FM999999999999990.90') || CHR(13) || CHR(10);
        L_REQBODY := L_REQBODY || 'MARKETCAP:' || TO_CHAR(REC.MARKETCAP, 'FM999999999999990.90') || CHR(13) || CHR(10);
        L_REQBODY := L_REQBODY || 'LISTINGVOLUME:' || TO_CHAR(REC.LISTINGVOLUME, 'FM999999999999990.90') || CHR(13) || CHR(10);
        L_REQBODY := L_REQBODY || 'OUTSTANDING:' || TO_CHAR(REC.OUTSTANDING, 'FM999999999999990.90') || CHR(13) || CHR(10);
        L_REQBODY := L_REQBODY || 'INDEXCATEGORY:' || REC.INDEXCATEGORY || CHR(13) || CHR(10);
        L_REQBODY := L_REQBODY || 'EXCHANGE:' || REC.EXCHANGE;

        INSERT INTO SYN_AITHER_REQ(AUTOID, TYPEREQ, OBJECTREQKEY, OBJECTKEY, TXDATE, BODYREQ)
        VALUES (SEQ_SYN_AITHER_REQ.NEXTVAL, 'INDEXINFO', REC.INDEXCODE, REC.AUTOID, NULL, L_REQBODY);

        UPDATE INDEX_INFO SET REQSTATUS = 'Q' WHERE AUTOID = REC.AUTOID;
    END LOOP;
EXCEPTION WHEN OTHERS THEN
  PLOG.ERROR ('GEN_INDEX_INFO_REQ: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
