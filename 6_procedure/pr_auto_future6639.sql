SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE pr_auto_future6639
IS
    L_TXMSG TX.MSG_RECTYPE;
    V_CURRDATE DATE;
    P_ERR_CODE NUMBER;
    P_ERR_MESSAGE VARCHAR2(500);
BEGIN
    V_CURRDATE := GETCURRDATE;

    L_TXMSG.MSGTYPE := 'T';
    L_TXMSG.LOCAL := 'N';
    L_TXMSG.TLID := SYSTEMNUMS.C_SYSTEM_USERID;
    L_TXMSG.OFF_LINE := 'N';
    L_TXMSG.DELTD := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS := '0';
    L_TXMSG.OVRSTS := '0';
    L_TXMSG.BATCHNAME := 'DAY';
    L_TXMSG.TXDATE := V_CURRDATE;
    L_TXMSG.BUSDATE := V_CURRDATE;
    L_TXMSG.TLTXCD := '6638';

    SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    SELECT BRID
    INTO L_TXMSG.BRID
    FROM TLPROFILES
    WHERE TLID=L_TXMSG.TLID;

    SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS')
    INTO L_TXMSG.TXTIME
    FROM DUAL;

    FOR REC IN (
        SELECT * FROM LOG_FUTURE6639 WHERE STATUS = 'P' AND VALUEDATE = V_CURRDATE ORDER BY AUTOID
    )
    LOOP
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;

        --01    NGàY CH?NG T?   D
             L_TXMSG.TXFIELDS ('01').DEFNAME   := 'POSTINGDATE';
             L_TXMSG.TXFIELDS ('01').TYPE      := 'D';
             L_TXMSG.TXFIELDS ('01').VALUE      := REC.POSTINGDATE;
        --02    S? TK GIAO D?CH   C
             L_TXMSG.TXFIELDS ('02').DEFNAME   := 'TRADINGACCT';
             L_TXMSG.TXFIELDS ('02').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('02').VALUE      := REC.TRADINGACCT;
        --03    S? TK CHUY?N   C
             L_TXMSG.TXFIELDS ('03').DEFNAME   := 'ACCTNO';
             L_TXMSG.TXFIELDS ('03').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('03').VALUE      := REC.ACCTNO;
        --04    Mã KH T?I NGâN HàNG   C
             L_TXMSG.TXFIELDS ('04').DEFNAME   := 'PORFOLIO';
             L_TXMSG.TXFIELDS ('04').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('04').VALUE      := REC.PORFOLIO;
        --05    S? DU HI?N T?I   N
             L_TXMSG.TXFIELDS ('05').DEFNAME   := 'BALANCE';
             L_TXMSG.TXFIELDS ('05').TYPE      := 'N';
             L_TXMSG.TXFIELDS ('05').VALUE      := REC.BALANCE;
        --06    S? DU KH? D?NG   N
             L_TXMSG.TXFIELDS ('06').DEFNAME   := 'AVAILABLE';
             L_TXMSG.TXFIELDS ('06').TYPE      := 'N';
             L_TXMSG.TXFIELDS ('06').VALUE      := REC.AVAILABLE;
        --07    LO?I CH? TH?   C
             L_TXMSG.TXFIELDS ('07').DEFNAME   := 'INSTRUCTION';
             L_TXMSG.TXFIELDS ('07').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('07').VALUE      := REC.INSTRUCTION;
        --08    LO?I CHY?N TI?N   C
             L_TXMSG.TXFIELDS ('08').DEFNAME   := 'TRANSFER';
             L_TXMSG.TXFIELDS ('08').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('08').VALUE      := REC.TRANSFER;
        --09    Mã CITAD   C
             L_TXMSG.TXFIELDS ('09').DEFNAME   := 'CITAD';
             L_TXMSG.TXFIELDS ('09').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('09').VALUE      := REC.CITAD;
        --10    S? TI?N CHUY?N   N
             L_TXMSG.TXFIELDS ('10').DEFNAME   := 'AMT';
             L_TXMSG.TXFIELDS ('10').TYPE      := 'N';
             L_TXMSG.TXFIELDS ('10').VALUE      := REC.AMT;
        --11    NH NH?N   C
             L_TXMSG.TXFIELDS ('11').DEFNAME   := 'BANK';
             L_TXMSG.TXFIELDS ('11').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('11').VALUE      := REC.BANK;
        --12    CHI NHáNH NH NH?N   C
             L_TXMSG.TXFIELDS ('12').DEFNAME   := 'BANKBRANCH';
             L_TXMSG.TXFIELDS ('12').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('12').VALUE      := REC.BANKBRANCH;
        --13    S? TK NH?N   C
             L_TXMSG.TXFIELDS ('13').DEFNAME   := 'BANKACCTNO';
             L_TXMSG.TXFIELDS ('13').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('13').VALUE      := REC.BANKACCTNO;
        --14    TêN NGU?I NH?N   C
             L_TXMSG.TXFIELDS ('14').DEFNAME   := 'NAME';
             L_TXMSG.TXFIELDS ('14').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('14').VALUE      := REC.FULLNAME;
        --15    S? H?P D?NG   C
             L_TXMSG.TXFIELDS ('15').DEFNAME   := 'REFCONTRACT';
             L_TXMSG.TXFIELDS ('15').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('15').VALUE      := REC.REFCONTRACT;
        --16    LO?I PHí   C
             L_TXMSG.TXFIELDS ('16').DEFNAME   := 'FEETYPE';
             L_TXMSG.TXFIELDS ('16').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('16').VALUE      := REC.FEETYPE;
        --17    NGàY HI?U L?C   C
             L_TXMSG.TXFIELDS ('17').DEFNAME   := 'VALUEDATE';
             L_TXMSG.TXFIELDS ('17').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('17').VALUE      := REC.VALUEDATE;
        --19    PHI´ CHUYê?N TIê`N   N
             L_TXMSG.TXFIELDS ('19').DEFNAME   := 'FEE';
             L_TXMSG.TXFIELDS ('19').TYPE      := 'N';
             L_TXMSG.TXFIELDS ('19').VALUE      := REC.FEE;
        --20    Sô´ TIê`N NET   N
             L_TXMSG.TXFIELDS ('20').DEFNAME   := 'NETAMT';
             L_TXMSG.TXFIELDS ('20').TYPE      := 'N';
             L_TXMSG.TXFIELDS ('20').VALUE      := REC.NETAMT;
        --21    AUTO ID   C
             L_TXMSG.TXFIELDS ('21').DEFNAME   := 'AUTOID';
             L_TXMSG.TXFIELDS ('21').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('21').VALUE      := REC.AUTOID;
         --30    DI?N GI?I   C
             L_TXMSG.TXFIELDS ('30').DEFNAME   := 'DESCS';
             L_TXMSG.TXFIELDS ('30').TYPE      := 'C';
             L_TXMSG.TXFIELDS ('30').VALUE      := REC.DESCRIPTION;
        BEGIN
            IF TXPKS_#6638.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, P_ERR_MESSAGE) <> SYSTEMNUMS.C_SUCCESS THEN
                ROLLBACK;
                UPDATE LOG_FUTURE6639 SET STATUS = 'E', ERRMSG = P_ERR_CODE WHERE AUTOID = REC.AUTOID;
            ELSE
                COMMIT;
            END IF;
        END;
    END LOOP;
EXCEPTION WHEN OTHERS THEN
    RETURN;
END;
/
