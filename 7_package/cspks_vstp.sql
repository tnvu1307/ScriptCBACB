SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_vstp

IS
    PROCEDURE PRC_ODVSTP_NEW(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_8864(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_ODVSTP_CANC(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_8802(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_CALL_8803(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_8822_8823_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_8821_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_VSDCONFIRM_MT544(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_VSDCONFIRM_MT546(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_2303_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_2308_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_2313_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_2318_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_2323_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_3401_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
    PROCEDURE PRC_3403_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2);
END;
/


CREATE OR REPLACE PACKAGE BODY cspks_vstp

IS
    PROCEDURE PRC_ODVSTP_NEW(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_ODVSTP_NEW');
        CSPKS_VSTP.PRC_CALL_8864(P_DATA, P_ERR_CODE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSTP_NEW');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSTP_NEW');
    END PRC_ODVSTP_NEW;

    PROCEDURE PRC_CALL_8864(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
        L_MEMBERID VARCHAR2(50);
        L_DATA_SOURCE VARCHAR2(1000);
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_8864');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '8864';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT JT.*
            FROM (
                SELECT P_DATA JSON
                FROM DUAL
            ) DT,
            JSON_TABLE(
                DT.JSON, '$[*]'
                COLUMNS (
                    CUSTODYCD VARCHAR2(20) PATH '$.CUSTODYCD',
                    CODEID VARCHAR2(20) PATH '$.CODEID',
                    SYMBOL VARCHAR2(50) PATH '$.SYMBOL',
                    PRICE NUMBER PATH '$.PRICE',
                    QTTY NUMBER PATH '$.QTTY',
                    NETAMT NUMBER PATH '$.NETAMT',
                    GROSSAMT NUMBER PATH '$.GROSSAMT',
                    TRADEDATE VARCHAR2(20) PATH '$.TRADEDATE',
                    SETTLEDATE VARCHAR2(20) PATH '$.SETTLEDATE',
                    EXECTYPE VARCHAR2(20) PATH '$.EXECTYPE',
                    VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID',
                    DEPOSITID VARCHAR2(100) PATH '$.DEPOSITID'
                )
            ) AS JT
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            BEGIN
                SELECT AUTOID INTO L_MEMBERID FROM FAMEMBERS WHERE DEPOSITMEMBER = REC.DEPOSITID;
            EXCEPTION WHEN OTHERS THEN
                L_MEMBERID := REC.DEPOSITID;
            END;

            --01    Mã ch?ng khoán   C
                 l_txmsg.txfields ('01').defname   := 'CODEID';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.CODEID;
            --04    Ngu?n ghi nh?n   C
                 l_txmsg.txfields ('04').defname   := 'KQGD';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := '3'; --VSD TPRL
            --06    S? TKNH chuy?n   C
                 l_txmsg.txfields ('06').defname   := 'DESACCTNO';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := '';
            --10    Giá tr? thanh toán   N
                 l_txmsg.txfields ('10').defname   := 'NETAMT';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.NETAMT;
            --11    Giá   N
                 l_txmsg.txfields ('11').defname   := 'PARVALUE';
                 l_txmsg.txfields ('11').TYPE      := 'N';
                 l_txmsg.txfields ('11').value      := rec.PRICE;
            --12    S? lu?ng   N
                 l_txmsg.txfields ('12').defname   := 'QTTY';
                 l_txmsg.txfields ('12').TYPE      := 'N';
                 l_txmsg.txfields ('12').value      := rec.QTTY;
            --13    Mã Citad   C
                 l_txmsg.txfields ('13').defname   := 'CITAD';
                 l_txmsg.txfields ('13').TYPE      := 'C';
                 l_txmsg.txfields ('13').value      := '';
            --14    Giá tr? l?nh   N
                 l_txmsg.txfields ('14').defname   := 'GROSSAMT';
                 l_txmsg.txfields ('14').TYPE      := 'N';
                 l_txmsg.txfields ('14').value      := rec.GROSSAMT;
            --20    Ngày giao d?ch   D
                 l_txmsg.txfields ('20').defname   := 'TRADEDATE';
                 l_txmsg.txfields ('20').TYPE      := 'D';
                 l_txmsg.txfields ('20').value      := rec.TRADEDATE;
            --21    Ngày TTBT   D
                 l_txmsg.txfields ('21').defname   := 'SETTLEDATE';
                 l_txmsg.txfields ('21').TYPE      := 'D';
                 l_txmsg.txfields ('21').value      := rec.SETTLEDATE;
            --23    Lo?i l?nh   C
                 l_txmsg.txfields ('23').defname   := 'EXECTYPE';
                 l_txmsg.txfields ('23').TYPE      := 'C';
                 l_txmsg.txfields ('23').value      := rec.EXECTYPE;
            --25    Phí GD   N
                 l_txmsg.txfields ('25').defname   := 'FEEAMT';
                 l_txmsg.txfields ('25').TYPE      := 'N';
                 l_txmsg.txfields ('25').value      := 0;
            --26    Thu?   N
                 l_txmsg.txfields ('26').defname   := 'VATAMT';
                 l_txmsg.txfields ('26').TYPE      := 'N';
                 l_txmsg.txfields ('26').value      := 0;
            --27    Lo?i giao d?ch   C
                 l_txmsg.txfields ('27').defname   := 'TRANSTYPE';
                 l_txmsg.txfields ('27').TYPE      := 'C';
                 l_txmsg.txfields ('27').value      := '';
            --29    S? d?nh danh   C
                 l_txmsg.txfields ('29').defname   := 'IDENTITY';
                 l_txmsg.txfields ('29').TYPE      := 'C';
                 l_txmsg.txfields ('29').value      := '';
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --31    Ap   C
                 l_txmsg.txfields ('31').defname   := 'AP';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := '';
            --33    S? ngày thanh toán   N
                 l_txmsg.txfields ('33').defname   := 'CLEARDAY';
                 l_txmsg.txfields ('33').TYPE      := 'N';
                 l_txmsg.txfields ('33').value      := 0;
            --35    S? TK AP   C
                 l_txmsg.txfields ('35').defname   := 'APACCT';
                 l_txmsg.txfields ('35').TYPE      := 'C';
                 l_txmsg.txfields ('35').value      := '';
            --36    Ngày ETF   C
                 l_txmsg.txfields ('36').defname   := 'ETFDATE';
                 l_txmsg.txfields ('36').TYPE      := 'C';
                 l_txmsg.txfields ('36').value      := '';
           --37    VSDORDERID   C
                 l_txmsg.txfields ('37').defname   := 'VSDORDERID';
                 l_txmsg.txfields ('37').TYPE      := 'C';
                 l_txmsg.txfields ('37').value      := rec.VSDORDERID;
            --68    Mã ch?ng khoán   C
                 l_txmsg.txfields ('68').defname   := 'SYMBOL';
                 l_txmsg.txfields ('68').TYPE      := 'C';
                 l_txmsg.txfields ('68').value      := rec.SYMBOL;
            --88    S? TKLK   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
            --99    CTCK   C
                 l_txmsg.txfields ('99').defname   := 'MEMBERID';
                 l_txmsg.txfields ('99').TYPE      := 'C';
                 l_txmsg.txfields ('99').value      := L_MEMBERID;

            IF TXPKS_#8864.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8864');
                RETURN;
            END IF;

            L_DATA_SOURCE :=  'select  ''' || rec.CUSTODYCD || '''custodycd, ''' || rec.SYMBOL || ''' symbol, ''' || rec.TRADEDATE || ''' tradedate from dual';
            NMPKS_EMS.PR_SENDINTERNALEMAIL(L_DATA_SOURCE, '102E', NULL, NULL);

            RETURN;
        END LOOP;
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8864');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8864');
    END PRC_CALL_8864;

    PROCEDURE PRC_ODVSTP_CANC(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_ODVSTP_CANC');
        FOR REC IN (
            SELECT ODV.ORDERID, ODV.AUTOID, ODV.ISODMAST
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID'
                    )
                ) AS JT
            ) DT,
            (
                SELECT AUTOID, ORDERID, VSDORDERID, ISODMAST
                FROM ODMASTVSD
                WHERE DELTD <> 'Y'
            ) ODV
            WHERE DT.VSDORDERID = ODV.VSDORDERID(+)
        )
        LOOP
            IF REC.ORDERID IS NOT NULL AND REC.ISODMAST = 'Y' THEN
                CSPKS_VSTP.PRC_CALL_8803(P_DATA, P_ERR_CODE);
            ELSIF REC.AUTOID IS NOT NULL AND REC.ISODMAST = 'N' THEN
                CSPKS_VSTP.PRC_CALL_8802(P_DATA, P_ERR_CODE);
            END IF;
        END LOOP;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSTP_CANC');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_ODVSTP_CANC');
    END PRC_ODVSTP_CANC;

    PROCEDURE PRC_CALL_8802(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_8802');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '8802';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT OD.AUTOID, TO_CHAR(OD.TXTIME,'DD/MM/RRRR')  RECORDDATE, OD.SEC_ID SYMBOL, OD.QUANTITY QTTY, OD.PRICE,
                0 FEE, 0 TAX, OD.GROSSAMOUNT, OD.TRADE_DATE TRADEDATE, OD.BROKER_CODE BROKER, NVL(A1.CDCONTENT, '') TYPEORDER,
                OD.SETTLE_DATE SETTDATE, OD.DELTD STATUS, OD.CUSTODYCD
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID'
                    )
                ) AS JT
            ) DT, ODMASTVSD OD, ODMASTVSD ODV,
            (SELECT * FROM ALLCODE WHERE CDNAME = 'EXECTYPE' AND CDTYPE = 'OD') A1
            WHERE OD.VSDORDERID = DT.VSDORDERID
            AND OD.ISODMAST = 'N'
            AND OD.DELTD <> 'Y'
            AND OD.TRANS_TYPE = A1.CDVAL(+)
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    Auto ID   N
                 l_txmsg.txfields ('01').defname   := 'AUTOID';
                 l_txmsg.txfields ('01').TYPE      := 'N';
                 l_txmsg.txfields ('01').value      := rec.AUTOID;
            --03    Kênh ghi nh?n   C
                 l_txmsg.txfields ('03').defname   := 'VIA';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := 'VSTP';
            --04    Ngày ghi nh?n   C
                 l_txmsg.txfields ('04').defname   := 'RECORDDATE';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.RECORDDATE;
            --06    Ngu?n ghi nh?n   C
                 l_txmsg.txfields ('06').defname   := 'SOURCE';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := 'VSD';
            --07    Mã CK   C
                 l_txmsg.txfields ('07').defname   := 'SYMBOL';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := rec.SYMBOL;
            --09    S? lu?ng   C
                 l_txmsg.txfields ('09').defname   := 'QTTY';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.QTTY;
            --10    Giá   C
                 l_txmsg.txfields ('10').defname   := 'PRICE';
                 l_txmsg.txfields ('10').TYPE      := 'C';
                 l_txmsg.txfields ('10').value      := rec.PRICE;
            --11    Phí   C
                 l_txmsg.txfields ('11').defname   := 'FEE';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := rec.FEE;
            --13    Giá tr? l?nh   C
                 l_txmsg.txfields ('13').defname   := 'GROSSAMOUNT';
                 l_txmsg.txfields ('13').TYPE      := 'C';
                 l_txmsg.txfields ('13').value      := rec.GROSSAMOUNT;
            --23    Ngày GD   C
                 l_txmsg.txfields ('23').defname   := 'TRADEDATE';
                 l_txmsg.txfields ('23').TYPE      := 'C';
                 l_txmsg.txfields ('23').value      := rec.TRADEDATE;
            --24    CTCK   C
                 l_txmsg.txfields ('24').defname   := 'BROKER';
                 l_txmsg.txfields ('24').TYPE      := 'C';
                 l_txmsg.txfields ('24').value      := rec.BROKER;
            --26    Lo?i GD   C
                 l_txmsg.txfields ('26').defname   := 'TYPEORDER';
                 l_txmsg.txfields ('26').TYPE      := 'C';
                 l_txmsg.txfields ('26').value      := rec.TYPEORDER;
            --27    Thu?   C
                 l_txmsg.txfields ('27').defname   := 'TAX';
                 l_txmsg.txfields ('27').TYPE      := 'C';
                 l_txmsg.txfields ('27').value      := rec.TAX;
            --28    ID file   C
                 l_txmsg.txfields ('28').defname   := 'IDFILE';
                 l_txmsg.txfields ('28').TYPE      := 'C';
                 l_txmsg.txfields ('28').value      := '';
            --29    Ngày thanh toán   C
                 l_txmsg.txfields ('29').defname   := 'SETTDATE';
                 l_txmsg.txfields ('29').TYPE      := 'C';
                 l_txmsg.txfields ('29').value      := rec.SETTDATE;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --31    Tr?ng thái   C
                 l_txmsg.txfields ('31').defname   := 'STATUS';
                 l_txmsg.txfields ('31').TYPE      := 'C';
                 l_txmsg.txfields ('31').value      := rec.STATUS;
            --32    Lo?i xóa   C
                 l_txmsg.txfields ('32').defname   := 'CANCEL';
                 l_txmsg.txfields ('32').TYPE      := 'C';
                 l_txmsg.txfields ('32').value      := 'Y';
            --88    S? TK   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;

            IF TXPKS_#8802.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8802');
                RETURN;
            END IF;
            RETURN;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8802');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8802');
    END PRC_CALL_8802;

    PROCEDURE PRC_CALL_8803(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_CALL_8803');

        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TLTXCD := '8803';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

        L_TXMSG.TLTXCD      := L_TLTXCD;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;

        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        FOR REC IN (
            SELECT DISTINCT OD.CODEID, OD.CUSTODYCD, OD.CUSTID, OD.ORDERID, OD.EXECAMT PRICE, OD.DDACCTNO, OD.SEACCTNO, OD.TXNUM, OD.TXDATE TRADEDATE, ODV.VSDORDERID
            FROM ODMAST OD,
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID'
                    )
                ) AS JT
            ) DT,
            (
                SELECT * FROM ODMASTVSD WHERE ISODMAST = 'Y' AND DELTD <> 'Y'
            ) ODV
            WHERE OD.ORDERID = ODV.ORDERID
            AND ODV.VSDORDERID =  DT.VSDORDERID
            AND OD.ISPAYMENT <> 'Y'
            AND OD.ORSTATUS NOT IN('3', '5', '7')
            AND OD.CLEARDATE >= GETCURRDATE
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            --01    CODEID    C
                 l_txmsg.txfields ('01').defname   := 'CODEID ';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.CODEID ;
            --04    Mã KH   C
                 l_txmsg.txfields ('04').defname   := 'CUSTID    ';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.CUSTID    ;
            --06    S? hi?u l?nh   C
                 l_txmsg.txfields ('06').defname   := 'ORDERID   ';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.ORDERID   ;
            --10    Giá   N
                 l_txmsg.txfields ('10').defname   := 'PRICE';
                 l_txmsg.txfields ('10').TYPE      := 'N';
                 l_txmsg.txfields ('10').value      := rec.PRICE;
            --12    TK NH   C
                 l_txmsg.txfields ('12').defname   := 'DDACCTNO';
                 l_txmsg.txfields ('12').TYPE      := 'C';
                 l_txmsg.txfields ('12').value      := rec.DDACCTNO;
            --13    TK CK   C
                 l_txmsg.txfields ('13').defname   := 'SEACCTNO';
                 l_txmsg.txfields ('13').TYPE      := 'C';
                 l_txmsg.txfields ('13').value      := rec.SEACCTNO;
            --14    S? GD   C
                 l_txmsg.txfields ('14').defname   := 'TXNUM';
                 l_txmsg.txfields ('14').TYPE      := 'C';
                 l_txmsg.txfields ('14').value      := rec.TXNUM;
            --15    Ngày GD   D
                 l_txmsg.txfields ('15').defname   := 'TRADEDATE';
                 l_txmsg.txfields ('15').TYPE      := 'D';
                 l_txmsg.txfields ('15').value      := rec.TRADEDATE;
            --30    Di?n gi?i   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --88    S? TK   C
                 l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                 l_txmsg.txfields ('88').TYPE      := 'C';
                 l_txmsg.txfields ('88').value      := rec.CUSTODYCD;

            IF TXPKS_#8803.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                L_ERR_PARAM := 'ERR: ' || SQLERRM || ' TRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8803');
                RETURN;
            END IF;

            UPDATE ODMASTVSD SET DELTD = 'Y' WHERE VSDORDERID = REC.VSDORDERID AND DELTD = 'N';

            RETURN;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8803');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_CALL_8803');
    END PRC_CALL_8803;

    PROCEDURE PRC_8822_8823_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_8822_8823_CALLBACK');

        FOR REC IN (
            SELECT ODV.AUTOID, ODV.ORDERID, DT.STATUS
            FROM ODMASTVSD ODV,
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID',
                        STATUS VARCHAR2(100) PATH '$.STATUS'
                    )
                ) AS JT
            ) DT
            WHERE ODV.VSDORDERID = DT.VSDORDERID
            AND ODV.DELTD = 'N'
            AND ODV.ISODMAST = 'Y'
        )
        LOOP
            L_ORDERID := REC.ORDERID;
            IF REC.STATUS = 'C' THEN
                UPDATE ODMASTVSD SET ISPAYMENT = 'Y' WHERE AUTOID = REC.AUTOID;
            ELSE
                UPDATE VSTP_SETTLE_LOG
                SET STATUS = '4.9', PSTATUS = STATUS, LASTCHANGE = SYSTIMESTAMP
                WHERE ORDERID = L_ORDERID;
            END IF;
        END LOOP;

        SELECT COUNT(1) INTO L_COUNT
        FROM ODMASTVSD
        WHERE ISPAYMENT = 'N'
        AND DELTD = 'N'
        AND ISODMAST = 'Y'
        AND ORDERID = L_ORDERID;

        IF L_COUNT = 0 AND NVL(L_ORDERID, 'XXX') <> 'XXX' THEN
            UPDATE VSTP_SETTLE_LOG
            SET STATUS = '4.1', PSTATUS = STATUS, LASTCHANGE = SYSTIMESTAMP
            WHERE ORDERID = L_ORDERID
            AND STATUS IN ('4','4.9');
        END IF;
        P_ERR_CODE := systemnums.C_SUCCESS;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_8822_8823_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_8822_8823_CALLBACK');
    END PRC_8822_8823_CALLBACK;

    PROCEDURE PRC_8821_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_8821_CALLBACK');

        FOR REC IN (
            SELECT ODV.AUTOID, ODV.ORDERID, DT.STATUS
            FROM ODMASTVSD ODV,
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID',
                        STATUS VARCHAR2(100) PATH '$.STATUS'
                    )
                ) AS JT
            ) DT
            WHERE ODV.VSDORDERID = DT.VSDORDERID
            AND ODV.DELTD = 'N'
            AND ODV.ISODMAST = 'Y'
        )
        LOOP
            UPDATE ODMASTVSD
            SET CFVSDSTS = REC.STATUS
            WHERE AUTOID = REC.AUTOID;
        END LOOP;

        P_ERR_CODE := systemnums.C_SUCCESS;
        PLOG.SETENDSECTION(PKGCTX, 'PRC_8821_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_8821_CALLBACK');
    END PRC_8821_CALLBACK;

    PROCEDURE PRC_VSDCONFIRM_MT544(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT544');

        FOR REC IN (
            SELECT ODV.AUTOID, ODV.ORDERID
            FROM ODMASTVSD ODV,
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID'
                    )
                ) AS JT
            ) DT
            WHERE ODV.VSDORDERID = DT.VSDORDERID
            AND ODV.DELTD = 'N'
            AND ODV.ISODMAST = 'Y'
        )
        LOOP
            UPDATE ODMASTVSD
            SET VSDCFOSETTLE = 'Y'
            WHERE AUTOID = REC.AUTOID;

            L_ORDERID := REC.ORDERID;
        END LOOP;

        SELECT COUNT(1) INTO L_COUNT FROM ODMASTVSD WHERE DELTD = 'N' AND ISODMAST = 'Y' AND VSDCFOSETTLE = 'N' AND ORDERID = L_ORDERID;
        IF L_COUNT = 0 AND NVL(L_ORDERID, 'XXX') <> 'XXX' THEN
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TLTXCD := '8819';
            SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

            L_TXMSG.TLTXCD      := L_TLTXCD;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;

            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            FOR REC IN (
                SELECT MST.AUTOID, MST.ORDERID,  MST.AFACCTNO, MST.DDACCTNO, MST.AFACCTNO || MST.CODEID SEACCTNO, MST.CODEID, MST.SYMBOL,
                    MST.QTTY, MST.AMT, MST.FEEAMT, MST.VAT TAXAMT, TO_CHAR(MST.CLEARDATE, 'DD/MM/RRRR') CLEARDATE,
                    DD.REFCASAACCT,
                    A1.CDCONTENT TYPEORDER, A1.CDVAL TYPEORDERVAL,
                    CF.CUSTODYCD, CF.FULLNAME, CF.CIFID,
                    FA.SHORTNAME BROKER
                FROM FAMEMBERS FA,
                (SELECT * FROM ODMAST WHERE EXECTYPE IN ('NB')) OD,
                (SELECT * FROM STSCHD WHERE STATUS = 'P' AND DELTD <> 'Y' AND DUETYPE IN ('RS')) MST,
                (SELECT * FROM CFMAST WHERE STATUS NOT IN ('C')) CF,
                (SELECT * FROM DDMAST WHERE STATUS NOT IN ('C')) DD,
                (SELECT * FROM SBSECURITIES WHERE TRADEPLACE = '099') SB,
                (SELECT * FROM ALLCODE WHERE CDNAME = 'EXECTYPE' AND CDTYPE = 'OD') A1
                WHERE MST.ORDERID = OD.ORDERID
                AND MST.CODEID = SB.CODEID
                AND MST.DDACCTNO = DD.ACCTNO
                AND OD.MEMBER = FA.AUTOID
                AND OD.CUSTID = CF.CUSTID
                AND TO_DATE(MST.CLEARDATE,'DD/MM/RRRR') = L_CURRDATE
                AND OD.EXECTYPE = A1.CDVAL(+)
                AND OD.ORDERID = L_ORDERID
            )
            LOOP
                /*
                SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;
                */
                SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;

                L_TXMSG.CCYUSAGE := rec.CODEID;

                --01    S? t? sinh   N
                     l_txmsg.txfields ('01').defname   := 'AUTOID';
                     l_txmsg.txfields ('01').TYPE      := 'N';
                     l_txmsg.txfields ('01').value      := rec.AUTOID;
                --02    Mã ch?ng khoán   C
                     l_txmsg.txfields ('02').defname   := 'CODEID';
                     l_txmsg.txfields ('02').TYPE      := 'C';
                     l_txmsg.txfields ('02').value      := rec.CODEID;
                --03    S? tài kho?n CI   C
                     l_txmsg.txfields ('03').defname   := 'AFACCTNO';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.AFACCTNO;
                --04    Tài kho?n ti?n t?   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --05    S? tài kho?n SE   C
                     l_txmsg.txfields ('05').defname   := 'SEACCTNO';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.SEACCTNO;
                --06    S? hi?u l?nh g?c   C
                     l_txmsg.txfields ('06').defname   := 'ORGORDERID';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.ORDERID;
                --07    Mã CK   C
                     l_txmsg.txfields ('07').defname   := 'SYMBOL';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.SYMBOL;
                --09    S? lu?ng   N
                     l_txmsg.txfields ('09').defname   := 'QTTY';
                     l_txmsg.txfields ('09').TYPE      := 'N';
                     l_txmsg.txfields ('09').value      := rec.QTTY;
                --10    S? ti?n    N
                     l_txmsg.txfields ('10').defname   := 'AMT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMT;
                --11    Phí   N
                     l_txmsg.txfields ('11').defname   := 'FEE';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := rec.FEEAMT;
                --23    Ngày TT   D
                     l_txmsg.txfields ('23').defname   := 'POSTDATE';
                     l_txmsg.txfields ('23').TYPE      := 'D';
                     l_txmsg.txfields ('23').value      := rec.CLEARDATE;
                --24    CTCK   C
                     l_txmsg.txfields ('24').defname   := 'BROKER';
                     l_txmsg.txfields ('24').TYPE      := 'C';
                     l_txmsg.txfields ('24').value      := rec.BROKER;
                --25    S? TKNH   C
                     l_txmsg.txfields ('25').defname   := 'REFACCTNO';
                     l_txmsg.txfields ('25').TYPE      := 'C';
                     l_txmsg.txfields ('25').value      := rec.REFCASAACCT;
                --26    Lo?i l?nh   C
                     l_txmsg.txfields ('26').defname   := 'TYPEORDER';
                     l_txmsg.txfields ('26').TYPE      := 'C';
                     l_txmsg.txfields ('26').value      := rec.TYPEORDER;
                --27    Thu?   N
                     l_txmsg.txfields ('27').defname   := 'TAX';
                     l_txmsg.txfields ('27').TYPE      := 'N';
                     l_txmsg.txfields ('27').value      := rec.TAXAMT;
                --28    Lo?i l?nh   C
                     l_txmsg.txfields ('28').defname   := 'TYPEORDER';
                     l_txmsg.txfields ('28').TYPE      := 'C';
                     l_txmsg.txfields ('28').value      := rec.TYPEORDERVAL;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := L_STRDESC;
                --88    So TKLK   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --90    Tên khách hàng   C
                     l_txmsg.txfields ('90').defname   := 'FULLNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.FULLNAME;
                --91    Mã KH NH   C
                     l_txmsg.txfields ('91').defname   := 'CIFID';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.CIFID;

                IF TXPKS_#8819.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                    PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                    ROLLBACK;
                    PLOG.SETENDSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT544');
                    RETURN;
                END IF;

                RETURN;
            END LOOP;
        END IF;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT544');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT544');
    END PRC_VSDCONFIRM_MT544;

    PROCEDURE PRC_VSDCONFIRM_MT546(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT546');

        FOR REC IN (
            SELECT ODV.AUTOID, ODV.ORDERID
            FROM ODMASTVSD ODV,
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        VSDORDERID VARCHAR2(100) PATH '$.VSDORDERID'
                    )
                ) AS JT
            ) DT
            WHERE ODV.VSDORDERID = DT.VSDORDERID
            AND ODV.DELTD = 'N'
            AND ODV.ISODMAST = 'Y'
        )
        LOOP
            UPDATE ODMASTVSD
            SET VSDCFOSETTLE = 'Y'
            WHERE AUTOID = REC.AUTOID;

            L_ORDERID := REC.ORDERID;
        END LOOP;

        SELECT COUNT(1) INTO L_COUNT FROM ODMASTVSD WHERE DELTD = 'N' AND ISODMAST = 'Y' AND VSDCFOSETTLE = 'N' AND ORDERID = L_ORDERID;
        IF L_COUNT = 0 AND NVL(L_ORDERID, 'XXX') <> 'XXX' THEN
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TLTXCD := '8848';
            SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

            L_TXMSG.TLTXCD      := L_TLTXCD;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;

            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            FOR REC IN (
                SELECT MST.AUTOID, MST.ORDERID,  MST.AFACCTNO, MST.DDACCTNO, MST.AFACCTNO || MST.CODEID SEACCTNO, MST.CODEID, MST.SYMBOL,
                    MST.QTTY, MST.AMT, MST.FEEAMT, MST.VAT TAXAMT, TO_CHAR(MST.CLEARDATE, 'DD/MM/RRRR') CLEARDATE,
                    DD.REFCASAACCT,
                    A1.CDCONTENT TYPEORDER, A1.CDVAL TYPEORDERVAL,
                    CF.CUSTODYCD, CF.FULLNAME, CF.CIFID,
                    FA.SHORTNAME BROKER,
                    'SE' TYPE
                FROM FAMEMBERS FA,
                (SELECT * FROM ODMAST WHERE EXECTYPE IN ('NS')) OD,
                (SELECT * FROM STSCHD WHERE STATUS = 'P' AND DELTD <> 'Y' AND DUETYPE IN ('SS')) MST,
                (SELECT * FROM CFMAST WHERE STATUS NOT IN ('C')) CF,
                (SELECT * FROM DDMAST WHERE STATUS NOT IN ('C')) DD,
                (SELECT * FROM SBSECURITIES WHERE TRADEPLACE = '099') SB,
                (SELECT * FROM ALLCODE WHERE CDNAME = 'EXECTYPE' AND CDTYPE = 'OD') A1
                WHERE MST.ORDERID = OD.ORDERID
                AND MST.CODEID = SB.CODEID
                AND MST.DDACCTNO = DD.ACCTNO
                AND OD.MEMBER = FA.AUTOID
                AND OD.CUSTID = CF.CUSTID
                AND TO_DATE(MST.CLEARDATE, 'DD/MM/RRRR') = L_CURRDATE
                AND OD.EXECTYPE = A1.CDVAL(+)
                AND OD.ORDERID = L_ORDERID
            )
            LOOP
                /*
                SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;
                */
                SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;

                L_TXMSG.CCYUSAGE := rec.CODEID;

                --01    S? t? sinh   N
                     l_txmsg.txfields ('01').defname   := 'AUTOID';
                     l_txmsg.txfields ('01').TYPE      := 'N';
                     l_txmsg.txfields ('01').value      := rec.AUTOID;
                --02    Mã ch?ng khoán   C
                     l_txmsg.txfields ('02').defname   := 'CODEID';
                     l_txmsg.txfields ('02').TYPE      := 'C';
                     l_txmsg.txfields ('02').value      := rec.CODEID;
                --03    S? tài kho?n CI   C
                     l_txmsg.txfields ('03').defname   := 'AFACCTNO';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.AFACCTNO;
                --04    Tài kho?n ti?n t?   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --05    S? tài kho?n SE   C
                     l_txmsg.txfields ('05').defname   := 'SEACCTNO';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.SEACCTNO;
                --06    S? hi?u l?nh g?c   C
                     l_txmsg.txfields ('06').defname   := 'ORGORDERID';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.ORDERID;
                --07    Mã CK   C
                     l_txmsg.txfields ('07').defname   := 'SYMBOL';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.SYMBOL;
                --09    S? lu?ng   N
                     l_txmsg.txfields ('09').defname   := 'QTTY';
                     l_txmsg.txfields ('09').TYPE      := 'N';
                     l_txmsg.txfields ('09').value      := rec.QTTY;
                --10    S? ti?n    N
                     l_txmsg.txfields ('10').defname   := 'AMT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMT;
                --11    Phí   N
                     l_txmsg.txfields ('11').defname   := 'FEE';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := rec.FEEAMT;
                --23    Ngày TT   D
                     l_txmsg.txfields ('23').defname   := 'POSTDATE';
                     l_txmsg.txfields ('23').TYPE      := 'D';
                     l_txmsg.txfields ('23').value      := rec.CLEARDATE;
                --24    CTCK   C
                     l_txmsg.txfields ('24').defname   := 'BROKER';
                     l_txmsg.txfields ('24').TYPE      := 'C';
                     l_txmsg.txfields ('24').value      := rec.BROKER;
                --25    S? TKNH   C
                     l_txmsg.txfields ('25').defname   := 'REFACCTNO';
                     l_txmsg.txfields ('25').TYPE      := 'C';
                     l_txmsg.txfields ('25').value      := rec.REFCASAACCT;
                --26    Lo?i l?nh   C
                     l_txmsg.txfields ('26').defname   := 'TYPEORDER';
                     l_txmsg.txfields ('26').TYPE      := 'C';
                     l_txmsg.txfields ('26').value      := rec.TYPEORDER;
                --27    Thu?   N
                     l_txmsg.txfields ('27').defname   := 'TAX';
                     l_txmsg.txfields ('27').TYPE      := 'N';
                     l_txmsg.txfields ('27').value      := rec.TAXAMT;
                --28    Lo?i l?nh   C
                     l_txmsg.txfields ('28').defname   := 'TYPEORDER';
                     l_txmsg.txfields ('28').TYPE      := 'C';
                     l_txmsg.txfields ('28').value      := rec.TYPEORDERVAL;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := L_STRDESC;
                --31    Lo?i GD   C
                     l_txmsg.txfields ('31').defname   := 'TYPE';
                     l_txmsg.txfields ('31').TYPE      := 'C';
                     l_txmsg.txfields ('31').value      := rec.TYPE;
                --88    So TKLK   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --90    Tên khách hàng   C
                     l_txmsg.txfields ('90').defname   := 'FULLNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.FULLNAME;
                --91    Mã KH NH   C
                     l_txmsg.txfields ('91').defname   := 'CIFID';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.CIFID;

                IF TXPKS_#8848.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                    PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                    ROLLBACK;
                    PLOG.SETENDSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT544');
                    RETURN;
                END IF;

                RETURN;
            END LOOP;
        END IF;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT546');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_VSDCONFIRM_MT546');
    END PRC_VSDCONFIRM_MT546;

    PROCEDURE PRC_2303_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_2303_CALLBACK');

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CBREF VARCHAR2(50) PATH '$.CBREF',
                        STATUS VARCHAR2(50) PATH '$.STATUS'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;
            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            IF REC.STATUS = 'C' THEN
                L_TLTXCD := '2304';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;
                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.REFERENCEID,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEDEPOSIT_TPRL WHERE DELTD = 'N' AND STATUS IN ('P','S','R')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2304'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := REC2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := REC2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := REC2.ACCTNO;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := REC2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --31    CMND/GPKD/TradingCode   C
                         l_txmsg.txfields ('31').defname   := 'IDCODE';
                         l_txmsg.txfields ('31').TYPE      := 'C';
                         l_txmsg.txfields ('31').value      := REC2.IDCODE;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := REC2.QTTYTYPE;
                    --34    Ngày sinh   D
                         l_txmsg.txfields ('34').defname   := 'DOBDATE';
                         l_txmsg.txfields ('34').TYPE      := 'D';
                         l_txmsg.txfields ('34').value      := REC2.DATEOFBIRTH;
                    --37    Noi c?p   C
                         l_txmsg.txfields ('37').defname   := 'IDPLACE';
                         l_txmsg.txfields ('37').TYPE      := 'C';
                         l_txmsg.txfields ('37').value      := REC2.IDPLACE;
                    --38    Lo?i hình c? dông   C
                         l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
                         l_txmsg.txfields ('38').TYPE      := 'C';
                         l_txmsg.txfields ('38').value      := REC2.ALTERNATEID;
                    --77    Mã s? ki?n CK ch? giao d?ch   C
                         l_txmsg.txfields ('77').defname   := 'REFERENCEID';
                         l_txmsg.txfields ('77').TYPE      := 'C';
                         l_txmsg.txfields ('77').value      := REC2.REFERENCEID;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := REC2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := REC2.FULLNAME;
                    --91    Ð?a ch?   C
                         l_txmsg.txfields ('91').defname   := 'ADDRESS';
                         l_txmsg.txfields ('91').TYPE      := 'C';
                         l_txmsg.txfields ('91').value      := REC2.ADDRESS;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := REC2.MCUSTODYCD;
                    --95    Ngày c?p   D
                         l_txmsg.txfields ('95').defname   := 'IDDATE';
                         l_txmsg.txfields ('95').TYPE      := 'D';
                         l_txmsg.txfields ('95').value      := REC2.IDDATE;
                    --96    Qu?c t?ch   C
                         l_txmsg.txfields ('96').defname   := 'COUNTRY';
                         l_txmsg.txfields ('96').TYPE      := 'C';
                         l_txmsg.txfields ('96').value      := REC2.COUNTRY;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := REC2.AUTOID;

                    IF TXPKS_#2304.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2303_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            ELSIF REC.STATUS = 'R' THEN
                L_TLTXCD := '2305';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.REFERENCEID,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEDEPOSIT_TPRL WHERE DELTD = 'N' AND STATUS IN ('S')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2305'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := REC2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := REC2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := REC2.ACCTNO;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := REC2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --31    CMND/GPKD/TradingCode   C
                         l_txmsg.txfields ('31').defname   := 'IDCODE';
                         l_txmsg.txfields ('31').TYPE      := 'C';
                         l_txmsg.txfields ('31').value      := REC2.IDCODE;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := REC2.QTTYTYPE;
                    --34    Ngày sinh   D
                         l_txmsg.txfields ('34').defname   := 'DOBDATE';
                         l_txmsg.txfields ('34').TYPE      := 'D';
                         l_txmsg.txfields ('34').value      := REC2.DATEOFBIRTH;
                    --37    Noi c?p   C
                         l_txmsg.txfields ('37').defname   := 'IDPLACE';
                         l_txmsg.txfields ('37').TYPE      := 'C';
                         l_txmsg.txfields ('37').value      := REC2.IDPLACE;
                    --38    Lo?i hình c? dông   C
                         l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
                         l_txmsg.txfields ('38').TYPE      := 'C';
                         l_txmsg.txfields ('38').value      := REC2.ALTERNATEID;
                    --77    Mã s? ki?n CK ch? giao d?ch   C
                         l_txmsg.txfields ('77').defname   := 'REFERENCEID';
                         l_txmsg.txfields ('77').TYPE      := 'C';
                         l_txmsg.txfields ('77').value      := REC2.REFERENCEID;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := REC2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := REC2.FULLNAME;
                    --91    Ð?a ch?   C
                         l_txmsg.txfields ('91').defname   := 'ADDRESS';
                         l_txmsg.txfields ('91').TYPE      := 'C';
                         l_txmsg.txfields ('91').value      := REC2.ADDRESS;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := REC2.MCUSTODYCD;
                    --95    Ngày c?p   D
                         l_txmsg.txfields ('95').defname   := 'IDDATE';
                         l_txmsg.txfields ('95').TYPE      := 'D';
                         l_txmsg.txfields ('95').value      := REC2.IDDATE;
                    --96    Qu?c t?ch   C
                         l_txmsg.txfields ('96').defname   := 'COUNTRY';
                         l_txmsg.txfields ('96').TYPE      := 'C';
                         l_txmsg.txfields ('96').value      := REC2.COUNTRY;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := REC2.AUTOID;

                    IF TXPKS_#2305.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2303_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            END IF;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_2303_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_2303_CALLBACK');
    END PRC_2303_CALLBACK;

    PROCEDURE PRC_2308_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_2308_CALLBACK');

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CBREF VARCHAR2(50) PATH '$.CBREF',
                        STATUS VARCHAR2(50) PATH '$.STATUS'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;
            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            IF REC.STATUS = 'C' THEN
                L_TLTXCD := '2309';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;
                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.REFERENCEID,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEWITHDRAWDTL_TPRL WHERE DELTD = 'N' AND STATUS IN ('P','S','R')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2309'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --31    CMND/GPKD/TradingCode   C
                         l_txmsg.txfields ('31').defname   := 'IDCODE';
                         l_txmsg.txfields ('31').TYPE      := 'C';
                         l_txmsg.txfields ('31').value      := rec2.IDCODE;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --34    Ngày sinh   D
                         l_txmsg.txfields ('34').defname   := 'DOBDATE';
                         l_txmsg.txfields ('34').TYPE      := 'D';
                         l_txmsg.txfields ('34').value      := rec2.DATEOFBIRTH;
                    --37    Noi c?p   C
                         l_txmsg.txfields ('37').defname   := 'IDPLACE';
                         l_txmsg.txfields ('37').TYPE      := 'C';
                         l_txmsg.txfields ('37').value      := rec2.IDPLACE;
                    --38    Lo?i hình c? dông   C
                         l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
                         l_txmsg.txfields ('38').TYPE      := 'C';
                         l_txmsg.txfields ('38').value      := rec2.ALTERNATEID;
                    --77    Mã s? ki?n CK ch? giao d?ch   C
                         l_txmsg.txfields ('77').defname   := 'REFERENCEID';
                         l_txmsg.txfields ('77').TYPE      := 'C';
                         l_txmsg.txfields ('77').value      := rec2.REFERENCEID;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --91    Ð?a ch?   C
                         l_txmsg.txfields ('91').defname   := 'ADDRESS';
                         l_txmsg.txfields ('91').TYPE      := 'C';
                         l_txmsg.txfields ('91').value      := rec2.ADDRESS;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --95    Ngày c?p   D
                         l_txmsg.txfields ('95').defname   := 'IDDATE';
                         l_txmsg.txfields ('95').TYPE      := 'D';
                         l_txmsg.txfields ('95').value      := rec2.IDDATE;
                    --96    Qu?c t?ch   C
                         l_txmsg.txfields ('96').defname   := 'COUNTRY';
                         l_txmsg.txfields ('96').TYPE      := 'C';
                         l_txmsg.txfields ('96').value      := rec2.COUNTRY;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2309.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2308_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            ELSIF REC.STATUS = 'R' THEN
                L_TLTXCD := '2310';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.REFERENCEID,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEWITHDRAWDTL_TPRL WHERE DELTD = 'N' AND STATUS IN ('S')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2310'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --31    CMND/GPKD/TradingCode   C
                         l_txmsg.txfields ('31').defname   := 'IDCODE';
                         l_txmsg.txfields ('31').TYPE      := 'C';
                         l_txmsg.txfields ('31').value      := rec2.IDCODE;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --34    Ngày sinh   D
                         l_txmsg.txfields ('34').defname   := 'DOBDATE';
                         l_txmsg.txfields ('34').TYPE      := 'D';
                         l_txmsg.txfields ('34').value      := rec2.DATEOFBIRTH;
                    --37    Noi c?p   C
                         l_txmsg.txfields ('37').defname   := 'IDPLACE';
                         l_txmsg.txfields ('37').TYPE      := 'C';
                         l_txmsg.txfields ('37').value      := rec2.IDPLACE;
                    --38    Lo?i hình c? dông   C
                         l_txmsg.txfields ('38').defname   := 'ALTERNATEID';
                         l_txmsg.txfields ('38').TYPE      := 'C';
                         l_txmsg.txfields ('38').value      := rec2.ALTERNATEID;
                    --77    Mã s? ki?n CK ch? giao d?ch   C
                         l_txmsg.txfields ('77').defname   := 'REFERENCEID';
                         l_txmsg.txfields ('77').TYPE      := 'C';
                         l_txmsg.txfields ('77').value      := rec2.REFERENCEID;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --91    Ð?a ch?   C
                         l_txmsg.txfields ('91').defname   := 'ADDRESS';
                         l_txmsg.txfields ('91').TYPE      := 'C';
                         l_txmsg.txfields ('91').value      := rec2.ADDRESS;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --95    Ngày c?p   D
                         l_txmsg.txfields ('95').defname   := 'IDDATE';
                         l_txmsg.txfields ('95').TYPE      := 'D';
                         l_txmsg.txfields ('95').value      := rec2.IDDATE;
                    --96    Qu?c t?ch   C
                         l_txmsg.txfields ('96').defname   := 'COUNTRY';
                         l_txmsg.txfields ('96').TYPE      := 'C';
                         l_txmsg.txfields ('96').value      := rec2.COUNTRY;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2310.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2308_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            END IF;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_2308_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_2308_CALLBACK');
    END PRC_2308_CALLBACK;

    PROCEDURE PRC_2313_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_2313_CALLBACK');

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CBREF VARCHAR2(50) PATH '$.CBREF',
                        STATUS VARCHAR2(50) PATH '$.STATUS'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;
            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            IF REC.STATUS = 'C' THEN
                L_TLTXCD := '2314';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;
                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.REFERENCEID, SED.RECCUSTODYCD, SED.RECMEMBER, SED.YBEN,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS,
                        DE.FULLNAME CRECMEMBER
                    FROM SEMAST SE, SBSECURITIES SB, DEPOSIT_MEMBER DE, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SESENDOUT_TPRL WHERE DELTD = 'N' AND STATUS IN ('P','S','R')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND SED.RECMEMBER = DE.DEPOSITID
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2314'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --34    Chuy?n kho?n th?a k?   C
                         l_txmsg.txfields ('34').defname   := 'YBEN';
                         l_txmsg.txfields ('34').TYPE      := 'C';
                         l_txmsg.txfields ('34').value      := rec2.YBEN;
                    --56    TVLK bên nh?n   C
                         l_txmsg.txfields ('56').defname   := 'RECMEMBER';
                         l_txmsg.txfields ('56').TYPE      := 'C';
                         l_txmsg.txfields ('56').value      := rec2.RECMEMBER;
                    --57    S? tài kho?n bên nh?n   C
                         l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
                         l_txmsg.txfields ('57').TYPE      := 'C';
                         l_txmsg.txfields ('57').value      := rec2.RECCUSTODYCD;
                    --77    Mã s? ki?n CK ch? giao d?ch   C
                         l_txmsg.txfields ('77').defname   := 'REFERENCEID';
                         l_txmsg.txfields ('77').TYPE      := 'C';
                         l_txmsg.txfields ('77').value      := rec2.REFERENCEID;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2314.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2313_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            ELSIF REC.STATUS = 'R' THEN
                L_TLTXCD := '2315';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.REFERENCEID, SED.RECCUSTODYCD, SED.RECMEMBER, SED.YBEN,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS,
                        DE.FULLNAME CRECMEMBER
                    FROM SEMAST SE, SBSECURITIES SB, DEPOSIT_MEMBER DE, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SESENDOUT_TPRL WHERE DELTD = 'N' AND STATUS IN ('S')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND SED.RECMEMBER = DE.DEPOSITID
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2315'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --34    Chuy?n kho?n th?a k?   C
                         l_txmsg.txfields ('34').defname   := 'YBEN';
                         l_txmsg.txfields ('34').TYPE      := 'C';
                         l_txmsg.txfields ('34').value      := rec2.YBEN;
                    --56    TVLK bên nh?n   C
                         l_txmsg.txfields ('56').defname   := 'RECMEMBER';
                         l_txmsg.txfields ('56').TYPE      := 'C';
                         l_txmsg.txfields ('56').value      := rec2.RECMEMBER;
                    --57    S? tài kho?n bên nh?n   C
                         l_txmsg.txfields ('57').defname   := 'RECCUSTODY';
                         l_txmsg.txfields ('57').TYPE      := 'C';
                         l_txmsg.txfields ('57').value      := rec2.RECCUSTODYCD;
                    --77    Mã s? ki?n CK ch? giao d?ch   C
                         l_txmsg.txfields ('77').defname   := 'REFERENCEID';
                         l_txmsg.txfields ('77').TYPE      := 'C';
                         l_txmsg.txfields ('77').value      := rec2.REFERENCEID;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2315.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2313_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            END IF;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_2313_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_2313_CALLBACK');
    END PRC_2313_CALLBACK;

    PROCEDURE PRC_2318_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_2318_CALLBACK');

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CBREF VARCHAR2(50) PATH '$.CBREF',
                        STATUS VARCHAR2(50) PATH '$.STATUS',
                        REFVSDID VARCHAR2(50) PATH '$.REFVSDID'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;
            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            IF REC.STATUS = 'C' THEN
                L_TLTXCD := '2319';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;
                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.PLACEID, SED.CONTRACTNO, SED.CONTRACTDATE,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEMORTAGE_TPRL WHERE TLTXCD = '2316' AND DELTD = 'N' AND STATUS IN ('P','S','R')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2319'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --04    Noi nh?n phong t?a   C
                         l_txmsg.txfields ('04').defname   := 'PLACEID';
                         l_txmsg.txfields ('04').TYPE      := 'C';
                         l_txmsg.txfields ('04').value      := rec2.PLACEID;
                    --05    S? h?p d?ng phong t?a   C
                         l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
                         l_txmsg.txfields ('05').TYPE      := 'C';
                         l_txmsg.txfields ('05').value      := rec2.CONTRACTNO;
                    --07    Ngày phong t?a   D
                         l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
                         l_txmsg.txfields ('07').TYPE      := 'D';
                         l_txmsg.txfields ('07').value      := rec2.CONTRACTDATE;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2319.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2318_CALLBACK');
                        RETURN;
                    END IF;

                    UPDATE SEMORTAGE_TPRL SET REFVSDID = REC.REFVSDID WHERE AUTOID = REC2.AUTOID;

                    RETURN;
                END LOOP;
            ELSIF REC.STATUS = 'R' THEN
                L_TLTXCD := '2320';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.PLACEID, SED.CONTRACTNO, SED.CONTRACTDATE,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEMORTAGE_TPRL WHERE TLTXCD = '2316' AND DELTD = 'N' AND STATUS IN ('S')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2320'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --04    Noi nh?n phong t?a   C
                         l_txmsg.txfields ('04').defname   := 'PLACEID';
                         l_txmsg.txfields ('04').TYPE      := 'C';
                         l_txmsg.txfields ('04').value      := rec2.PLACEID;
                    --05    S? h?p d?ng phong t?a   C
                         l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
                         l_txmsg.txfields ('05').TYPE      := 'C';
                         l_txmsg.txfields ('05').value      := rec2.CONTRACTNO;
                    --07    Ngày phong t?a   D
                         l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
                         l_txmsg.txfields ('07').TYPE      := 'D';
                         l_txmsg.txfields ('07').value      := rec2.CONTRACTDATE;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2320.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2318_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            END IF;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_2318_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_2318_CALLBACK');
    END PRC_2318_CALLBACK;

    PROCEDURE PRC_2323_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_2323_CALLBACK');

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CBREF VARCHAR2(50) PATH '$.CBREF',
                        STATUS VARCHAR2(50) PATH '$.STATUS'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;
            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            IF REC.STATUS = 'C' THEN
                L_TLTXCD := '2324';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;
                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.PLACEID, SED.CONTRACTNO, SED.CONTRACTDATE,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEMORTAGE_TPRL WHERE TLTXCD = '2321' AND DELTD = 'N' AND STATUS IN ('P','S','R')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2324'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --04    Noi nh?n phong t?a   C
                         l_txmsg.txfields ('04').defname   := 'PLACEID';
                         l_txmsg.txfields ('04').TYPE      := 'C';
                         l_txmsg.txfields ('04').value      := rec2.PLACEID;
                    --05    S? h?p d?ng phong t?a   C
                         l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
                         l_txmsg.txfields ('05').TYPE      := 'C';
                         l_txmsg.txfields ('05').value      := rec2.CONTRACTNO;
                    --07    Ngày phong t?a   D
                         l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
                         l_txmsg.txfields ('07').TYPE      := 'D';
                         l_txmsg.txfields ('07').value      := rec2.CONTRACTDATE;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2324.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2323_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            ELSIF REC.STATUS = 'R' THEN
                L_TLTXCD := '2325';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT SED.AUTOID, SED.TXDATE, SED.QTTY, SED.ACCTNO, SED.AFACCTNO, SED.QTTYTYPE, SED.PLACEID, SED.CONTRACTNO, SED.CONTRACTDATE,
                        SB.CODEID, SB.SYMBOL,
                        CF.CUSTODYCD, CF.MCUSTODYCD, CF.FULLNAME, CF.DATEOFBIRTH, CF.COUNTRY, CF.IDCODE, CF.IDDATE, CF.IDPLACE, CF.ALTERNATEID, CF.ADDRESS
                    FROM SEMAST SE, SBSECURITIES SB, VW_CFMAST_VSTP CF,
                    (SELECT * FROM SEMORTAGE_TPRL WHERE TLTXCD = '2321' AND DELTD = 'N' AND STATUS IN ('S')) SED
                    WHERE SE.ACCTNO = SED.ACCTNO
                    AND SE.CODEID = SB.CODEID
                    AND SED.CUSTODYCD = CF.CUSTODYCD
                    AND NOT EXISTS (
                        SELECT F.CVALUE
                        FROM TLLOG TL, TLLOGFLD F
                        WHERE TL.TXNUM = F.TXNUM
                        AND TL.TXDATE = F.TXDATE
                        AND TL.TLTXCD = '2325'
                        AND TL.TXSTATUS IN ('4')
                        AND F.FLDCD = '99'
                        AND F.NVALUE = SED.AUTOID
                    )
                    AND TO_CHAR(SED.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã ch?ng khoán   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    S? Ti?u kho?n   C
                         l_txmsg.txfields ('02').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.AFACCTNO;
                    --03    S? tài kho?n   C
                         l_txmsg.txfields ('03').defname   := 'ACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.ACCTNO;
                    --04    Noi nh?n phong t?a   C
                         l_txmsg.txfields ('04').defname   := 'PLACEID';
                         l_txmsg.txfields ('04').TYPE      := 'C';
                         l_txmsg.txfields ('04').value      := rec2.PLACEID;
                    --05    S? h?p d?ng phong t?a   C
                         l_txmsg.txfields ('05').defname   := 'CONTRACTNO';
                         l_txmsg.txfields ('05').TYPE      := 'C';
                         l_txmsg.txfields ('05').value      := rec2.CONTRACTNO;
                    --07    Ngày phong t?a   D
                         l_txmsg.txfields ('07').defname   := 'CONTRACTDATE';
                         l_txmsg.txfields ('07').TYPE      := 'D';
                         l_txmsg.txfields ('07').value      := rec2.CONTRACTDATE;
                    --10    S? lu?ng   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.QTTY;
                    --30    Mô t?   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --33    Lo?i ch?ng khoán   C
                         l_txmsg.txfields ('33').defname   := 'STOCKTYPE';
                         l_txmsg.txfields ('33').TYPE      := 'C';
                         l_txmsg.txfields ('33').value      := rec2.QTTYTYPE;
                    --88    Tài kho?n luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --94    Sô´ TKLK me?   C
                         l_txmsg.txfields ('94').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('94').TYPE      := 'C';
                         l_txmsg.txfields ('94').value      := rec2.MCUSTODYCD;
                    --99    S? t? tang   N
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'N';
                         l_txmsg.txfields ('99').value      := rec2.AUTOID;

                    IF TXPKS_#2325.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_2323_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            END IF;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_2323_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_2323_CALLBACK');
    END PRC_2323_CALLBACK;

    PROCEDURE PRC_3401_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_3401_CALLBACK');
        L_CURRDATE := GETCURRDATE;
        L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := L_TLID;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := L_CURRDATE;
        L_TXMSG.TXDATE      := L_CURRDATE;
        SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
        SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

        L_TLTXCD := '3370';
        SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;
        L_TXMSG.TLTXCD := L_TLTXCD;

        FOR REC IN (
            SELECT CA.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CBREF VARCHAR2(50) PATH '$.CBREF'
                    )
                ) AS JT
            ) DT,
            (
                SELECT CA.DUEDATE, CA.BEGINDATE, CA.VALUE CAMASTID, CA.SYMBOL, CA.REPORTDATE, CA.ACTIONDATE,
                CA.CATYPEVAL, CA.RATE, CA.RIGHTOFFRATE, CA.FRDATETRANSFER, CA.EXPRICE ROPRICE, CA.TVPRICE, CA.CODEID,
                CA.TRADE, CA.TODATETRANSFER, CA.FORMOFPAYMENT,
                A1.CDCONTENT STATUS, A2.CDCONTENT CATYPE
                FROM V_CAMAST CA,
                (SELECT * FROM ALLCODE WHERE CDNAME = 'CASTATUS' AND CDTYPE = 'CA') A1,
                (SELECT * FROM ALLCODE WHERE CDNAME = 'CATYPE' AND CDTYPE = 'CA') A2
                WHERE CA.STATUS = A1.CDVAL(+)
                AND CA.CATYPE = A2.CDVAL(+)
            ) CA
            WHERE CA.CAMASTID = REPLACE(DT.CBREF, 'CB.', '')
        )
        LOOP
            /*
            SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;
            */
            SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
            INTO L_TXMSG.TXNUM
            FROM DUAL;

            L_TXMSG.CCYUSAGE := rec.CODEID;

            --01    Ngày KT ÐKQM/nh?n CP chuy?n d?i   C
                 l_txmsg.txfields ('01').defname   := 'DUEDATE';
                 l_txmsg.txfields ('01').TYPE      := 'C';
                 l_txmsg.txfields ('01').value      := rec.DUEDATE;
            --02    Ngày BÐ ÐKQM/nh?n CP chuy?n d?i   C
                 l_txmsg.txfields ('02').defname   := 'BEGINDATE';
                 l_txmsg.txfields ('02').TYPE      := 'C';
                 l_txmsg.txfields ('02').value      := rec.BEGINDATE;
            --03    Mã s? ki?n   C
                 l_txmsg.txfields ('03').defname   := 'CAMASTID';
                 l_txmsg.txfields ('03').TYPE      := 'C';
                 l_txmsg.txfields ('03').value      := rec.CAMASTID;
            --04    Mã CK ch?t SH   C
                 l_txmsg.txfields ('04').defname   := 'SYMBOL';
                 l_txmsg.txfields ('04').TYPE      := 'C';
                 l_txmsg.txfields ('04').value      := rec.SYMBOL;
            --05    Lo?i th?c hi?n quy?n   C
                 l_txmsg.txfields ('05').defname   := 'CATYPE';
                 l_txmsg.txfields ('05').TYPE      := 'C';
                 l_txmsg.txfields ('05').value      := rec.CATYPE;
            --06    Ngày dang ký cu?i cùng   C
                 l_txmsg.txfields ('06').defname   := 'REPORTDATE';
                 l_txmsg.txfields ('06').TYPE      := 'C';
                 l_txmsg.txfields ('06').value      := rec.REPORTDATE;
            --07    Ngày th?c hi?n quy?n DK   C
                 l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
                 l_txmsg.txfields ('07').TYPE      := 'C';
                 l_txmsg.txfields ('07').value      := rec.ACTIONDATE;
            --08    Hình th?c chi tr?   T
                 l_txmsg.txfields ('08').defname   := 'FORMOFPAYMENT';
                 l_txmsg.txfields ('08').TYPE      := 'C';
                 l_txmsg.txfields ('08').value      := rec.FORMOFPAYMENT;
            --09    Lo?i th?c hi?n quy?n   C
                 l_txmsg.txfields ('09').defname   := 'CATYPEVAL';
                 l_txmsg.txfields ('09').TYPE      := 'C';
                 l_txmsg.txfields ('09').value      := rec.CATYPEVAL;
            --10    T? l?   C
                 l_txmsg.txfields ('10').defname   := 'RATE';
                 l_txmsg.txfields ('10').TYPE      := 'C';
                 l_txmsg.txfields ('10').value      := rec.RATE;
            --11    T? l? quy?n/CP du?c mua   T
                 l_txmsg.txfields ('11').defname   := 'RIGHTOFFRATE';
                 l_txmsg.txfields ('11').TYPE      := 'C';
                 l_txmsg.txfields ('11').value      := rec.RIGHTOFFRATE;
            --12    Ngày b?t d?u chuy?n nhu?ng   D
                 l_txmsg.txfields ('12').defname   := 'FRDATETRANSFER';
                 l_txmsg.txfields ('12').TYPE      := 'C';
                 l_txmsg.txfields ('12').value      := rec.FRDATETRANSFER;
            --13    Ngày KT chuy?n nhu?ng   D
                 l_txmsg.txfields ('13').defname   := 'TODATETRANSFER';
                 l_txmsg.txfields ('13').TYPE      := 'C';
                 l_txmsg.txfields ('13').value      := rec.TODATETRANSFER;
            --14    Giá mua   T
                 l_txmsg.txfields ('14').defname   := 'ROPRICE';
                 l_txmsg.txfields ('14').TYPE      := 'C';
                 l_txmsg.txfields ('14').value      := rec.ROPRICE;
            --15    Giá qui d?i cho c? phi?u l?   T
                 l_txmsg.txfields ('15').defname   := 'TVPRICE';
                 l_txmsg.txfields ('15').TYPE      := 'C';
                 l_txmsg.txfields ('15').value      := rec.TVPRICE;
            --16    Mã CK ch?t SH   C
                 l_txmsg.txfields ('16').defname   := 'CODEID';
                 l_txmsg.txfields ('16').TYPE      := 'C';
                 l_txmsg.txfields ('16').value      := rec.CODEID;
            --17    T?ng n?m gi?   T
                 l_txmsg.txfields ('17').defname   := 'TRADE';
                 l_txmsg.txfields ('17').TYPE      := 'C';
                 l_txmsg.txfields ('17').value      := rec.TRADE;
            --20    Tr?ng thái   C
                 l_txmsg.txfields ('20').defname   := 'STATUS';
                 l_txmsg.txfields ('20').TYPE      := 'C';
                 l_txmsg.txfields ('20').value      := rec.STATUS;
            --21    S? lu?ng CK s? h?u   N
                 l_txmsg.txfields ('21').defname   := 'TRADE';
                 l_txmsg.txfields ('21').TYPE      := 'N';
                 l_txmsg.txfields ('21').value      := rec.TRADE;
            --30    Mô t?   C
                 l_txmsg.txfields ('30').defname   := 'DESC';
                 l_txmsg.txfields ('30').TYPE      := 'C';
                 l_txmsg.txfields ('30').value      := L_STRDESC;
            --40    Mã CK nh?n   C
                 l_txmsg.txfields ('40').defname   := 'TOCODEID';
                 l_txmsg.txfields ('40').TYPE      := 'C';
                 l_txmsg.txfields ('40').value      := rec.CODEID;

            IF TXPKS_#3370.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                ROLLBACK;
                PLOG.SETENDSECTION(PKGCTX, 'PRC_3401_CALLBACK');
                RETURN;
            END IF;

            RETURN;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_3401_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_3401_CALLBACK');
    END PRC_3401_CALLBACK;

    PROCEDURE PRC_3403_CALLBACK(P_DATA VARCHAR2, P_ERR_CODE OUT VARCHAR2) AS
        PKGCTX PLOG.LOG_CTX;
        LOGROW TLOGDEBUG%ROWTYPE;
        L_COUNT NUMBER;
        L_ORDERID VARCHAR2(100);
        L_TXMSG TX.MSG_RECTYPE;
        L_ERR_PARAM VARCHAR2(1000);
        L_TLID VARCHAR2(100);
        L_TLTXCD VARCHAR2(10);
        L_STRDESC VARCHAR2(1000);
        L_CURRDATE DATE;
    BEGIN
        PLOG.SETBEGINSECTION(PKGCTX, 'PRC_3403_CALLBACK');

        FOR REC IN (
            SELECT DT.*
            FROM
            (
                SELECT JT.*
                FROM (
                    SELECT P_DATA JSON
                    FROM DUAL
                ) DT,
                JSON_TABLE(
                    DT.JSON, '$[*]'
                    COLUMNS (
                        CBREF VARCHAR2(50) PATH '$.CBREF',
                        STATUS VARCHAR2(50) PATH '$.STATUS'
                    )
                ) AS JT
            ) DT
        )
        LOOP
            L_CURRDATE := GETCURRDATE;
            L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;
            L_TXMSG.MSGTYPE     := 'T';
            L_TXMSG.LOCAL       := 'N';
            L_TXMSG.TLID        := L_TLID;
            L_TXMSG.OFF_LINE    := 'N';
            L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
            L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
            L_TXMSG.MSGSTS      := '0';
            L_TXMSG.OVRSTS      := '0';
            L_TXMSG.BATCHNAME   := 'DAY';
            L_TXMSG.BUSDATE     := L_CURRDATE;
            L_TXMSG.TXDATE      := L_CURRDATE;
            SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15) INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS FROM DUAL;
            SELECT BRID INTO L_TXMSG.BRID FROM TLPROFILES WHERE TLID = L_TLID;

            IF REC.STATUS = 'C' THEN
                L_TLTXCD := '3404';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;
                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT V.*, REG.QTTY REGQTTY, REG.AUTOID REGAUTOID
                    FROM V_CA040REG V,
                    (
                        SELECT * FROM CA040REGISTER  WHERE MSGSTATUS IN ('P','S','R') AND DELTD = 'N'
                    ) REG
                    WHERE V.AUTOID = REG.CASCHDAUTOID
                    AND TO_CHAR(REG.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã CK ch?t   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    Mã s? ki?n   C
                         l_txmsg.txfields ('02').defname   := 'CAMASTID';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.CAMASTID;
                    --03    S? Ti?u kho?n   C
                         l_txmsg.txfields ('03').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.AFACCTNO;
                    --04    Mã CK ch?t   C
                         l_txmsg.txfields ('04').defname   := 'SYMBOL';
                         l_txmsg.txfields ('04').TYPE      := 'C';
                         l_txmsg.txfields ('04').value      := rec2.SYMBOL;
                    --10    SL dang ký   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.REGQTTY;
                    --13    SL TP s? h?u   N
                         l_txmsg.txfields ('13').defname   := 'TRADE';
                         l_txmsg.txfields ('13').TYPE      := 'N';
                         l_txmsg.txfields ('13').value      := rec2.TRADE;
                    --30    Di?n gi?i   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --88    Sô´ TKLK me?   C
                         l_txmsg.txfields ('96').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('96').TYPE      := 'C';
                         l_txmsg.txfields ('96').value      := rec2.MCUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'FULLNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --96    S? TK luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --97    Mã KH t?i NH   C
                         l_txmsg.txfields ('97').defname   := 'CIFID';
                         l_txmsg.txfields ('97').TYPE      := 'C';
                         l_txmsg.txfields ('97').value      := rec2.CIFID;
                    --99    Mã l?ch CA   C
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'C';
                         l_txmsg.txfields ('99').value      := rec2.REGAUTOID;

                    IF TXPKS_#3404.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_3403_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            ELSIF REC.STATUS = 'R' THEN
                L_TLTXCD := '3405';
                SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

                L_TXMSG.TLTXCD := L_TLTXCD;

                FOR REC2 IN (
                    SELECT V.*, REG.QTTY REGQTTY, REG.AUTOID REGAUTOID
                    FROM V_CA040REG V,
                    (
                        SELECT * FROM CA040REGISTER  WHERE MSGSTATUS IN ('S') AND DELTD = 'N'
                    ) REG
                    WHERE V.AUTOID = REG.CASCHDAUTOID
                    AND TO_CHAR(REG.AUTOID) = REPLACE(REC.CBREF, 'CB.', '')
                )
                LOOP
                    /*
                    SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;
                    */
                    SELECT L_TXMSG.BRID || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 6, '0')
                    INTO L_TXMSG.TXNUM
                    FROM DUAL;

                    L_TXMSG.CCYUSAGE := rec2.CODEID;

                    --01    Mã CK ch?t   C
                         l_txmsg.txfields ('01').defname   := 'CODEID';
                         l_txmsg.txfields ('01').TYPE      := 'C';
                         l_txmsg.txfields ('01').value      := rec2.CODEID;
                    --02    Mã s? ki?n   C
                         l_txmsg.txfields ('02').defname   := 'CAMASTID';
                         l_txmsg.txfields ('02').TYPE      := 'C';
                         l_txmsg.txfields ('02').value      := rec2.CAMASTID;
                    --03    S? Ti?u kho?n   C
                         l_txmsg.txfields ('03').defname   := 'AFACCTNO';
                         l_txmsg.txfields ('03').TYPE      := 'C';
                         l_txmsg.txfields ('03').value      := rec2.AFACCTNO;
                    --04    Mã CK ch?t   C
                         l_txmsg.txfields ('04').defname   := 'SYMBOL';
                         l_txmsg.txfields ('04').TYPE      := 'C';
                         l_txmsg.txfields ('04').value      := rec2.SYMBOL;
                    --10    SL dang ký   N
                         l_txmsg.txfields ('10').defname   := 'QTTY';
                         l_txmsg.txfields ('10').TYPE      := 'N';
                         l_txmsg.txfields ('10').value      := rec2.REGQTTY;
                    --13    SL TP s? h?u   N
                         l_txmsg.txfields ('13').defname   := 'TRADE';
                         l_txmsg.txfields ('13').TYPE      := 'N';
                         l_txmsg.txfields ('13').value      := rec2.TRADE;
                    --30    Di?n gi?i   C
                         l_txmsg.txfields ('30').defname   := 'DESC';
                         l_txmsg.txfields ('30').TYPE      := 'C';
                         l_txmsg.txfields ('30').value      := L_STRDESC;
                    --88    Sô´ TKLK me?   C
                         l_txmsg.txfields ('96').defname   := 'MCUSTODYCD';
                         l_txmsg.txfields ('96').TYPE      := 'C';
                         l_txmsg.txfields ('96').value      := rec2.MCUSTODYCD;
                    --90    H? tên   C
                         l_txmsg.txfields ('90').defname   := 'FULLNAME';
                         l_txmsg.txfields ('90').TYPE      := 'C';
                         l_txmsg.txfields ('90').value      := rec2.FULLNAME;
                    --96    S? TK luu ký   C
                         l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                         l_txmsg.txfields ('88').TYPE      := 'C';
                         l_txmsg.txfields ('88').value      := rec2.CUSTODYCD;
                    --97    Mã KH t?i NH   C
                         l_txmsg.txfields ('97').defname   := 'CIFID';
                         l_txmsg.txfields ('97').TYPE      := 'C';
                         l_txmsg.txfields ('97').value      := rec2.CIFID;
                    --99    Mã l?ch CA   C
                         l_txmsg.txfields ('99').defname   := 'AUTOID';
                         l_txmsg.txfields ('99').TYPE      := 'C';
                         l_txmsg.txfields ('99').value      := rec2.REGAUTOID;

                    IF TXPKS_#3405.FN_AUTOTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
                        PLOG.ERROR(PKGCTX, ' RUN ' || L_TLTXCD || ' GOT ' || P_ERR_CODE || ':' || P_ERR_CODE);
                        ROLLBACK;
                        PLOG.SETENDSECTION(PKGCTX, 'PRC_3403_CALLBACK');
                        RETURN;
                    END IF;

                    RETURN;
                END LOOP;
            END IF;
        END LOOP;

        PLOG.SETENDSECTION(PKGCTX, 'PRC_3403_CALLBACK');
    EXCEPTION WHEN OTHERS THEN
        P_ERR_CODE := ERRNUMS.C_SYSTEM_ERROR;
        PLOG.ERROR(PKGCTX, SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        PLOG.SETENDSECTION(PKGCTX, 'PRC_3403_CALLBACK');
    END PRC_3403_CALLBACK;
END;
/
