SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE PRC_AUTO_EA1108
IS
    pkgctx   plog.log_ctx;
    logrow   tlogdebug%ROWTYPE;
    L_TXMSG     TX.MSG_RECTYPE;
    L_ERR_PARAM VARCHAR2(1000);
    L_ERR_CODE VARCHAR2(100);
    L_TLID VARCHAR2(100);
    L_TLTXCD VARCHAR2(10);
    L_STRDESC VARCHAR2(1000);
    L_CURRDATE      DATE;
BEGIN
    plog.setbeginsection(pkgctx, 'PRC_AUTO_EA1108');
    L_CURRDATE := GETCURRDATE;
    L_TLID := SYSTEMNUMS.C_SYSTEM_USERID;

    L_TLTXCD := '1108';
    SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = L_TLTXCD;

    L_TXMSG.TLTXCD      := L_TLTXCD;
    L_TXMSG.MSGTYPE     := 'T';
    L_TXMSG.LOCAL       := 'N';
    L_TXMSG.TLID        := L_TLID;
    SELECT SYS_CONTEXT('USERENV', 'HOST'), SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;
    SELECT BRID
    INTO L_TXMSG.BRID
    FROM TLPROFILES WHERE TLID = L_TLID;
    L_TXMSG.OFF_LINE    := 'N';
    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
    L_TXMSG.MSGSTS      := '0';
    L_TXMSG.OVRSTS      := '0';
    L_TXMSG.BATCHNAME   := 'DAY';
    L_TXMSG.BUSDATE     := L_CURRDATE;
    L_TXMSG.TXDATE      := L_CURRDATE;

    FOR rec IN
    (
        SELECT * FROM
        (
            SELECT R2.*,
                   (CASE WHEN R2.CCYCD = 'VND' THEN
                              LEAST(R2.BLKAMT - R2.BALANCE - R2.HOLDBALANCE, R2.BALANCE)
                         ELSE ROUND(LEAST(R2.BLKAMT_USD - R2.BALANCE_USD - R2.HOLDBALANCE/(EX.VND + EX.VND*SY.RATIO), R2.BALANCE/(EX.VND + EX.VND*SY.RATIO)) * EX.VND)
                         END
                   ) MAXBLKAMT,
                   (CASE WHEN R2.CCYCD = 'VND' THEN
                              LEAST(R2.BLKAMT - R2.BALANCE - R2.HOLDBALANCE, R2.BALANCE)
                         ELSE ROUND(LEAST(R2.BLKAMT_USD - R2.BALANCE_USD - R2.HOLDBALANCE/(EX.VND + EX.VND*SY.RATIO), R2.BALANCE/(EX.VND + EX.VND*SY.RATIO)) * EX.VND)
                         END
                   ) AMTCHK,
                   NVL(EDT.HOLD_TEMP,0) HOLD_TEMP
            FROM
            (
                SELECT R1.CCYCD, R1.BCUSTODYCD, R1.BFULLNAME, R1.BDDACCTNO, R1.REFCASAACCT, R1.BALANCE, R1.BALANCE_USD, R1.HOLDBALANCE,
                       SUM(R1.BLKAMT_USD) BLKAMT_USD, SUM(R1.BLKAMT) BLKAMT
                FROM
                (
                    SELECT DD.CCYCD, E.BCUSTODYCD, E.BFULLNAME,
                        (CASE WHEN DD.CCYCD = 'VND' THEN DD.ACCTNO ELSE D_II.ACCTNO END) BDDACCTNO,
                        (CASE WHEN DD.CCYCD = 'VND' THEN DD.REFCASAACCT ELSE D_II.REFCASAACCT END) REFCASAACCT,
                        (CASE WHEN DD.CCYCD = 'VND' THEN DD.BALANCE ELSE D_II.BALANCE END) BALANCE,
                        (CASE WHEN DD.CCYCD = 'VND' THEN DD.HOLDBALANCE ELSE D_II.HOLDBALANCE END) HOLDBALANCE,
                        DD.BALANCE BALANCE_USD,
                        E.BLKAMT_USD, E.BLKAMT
                    FROM ESCROW E ,DDMAST DD, DDMAST D_II,
                    (
                        SELECT GETCURRDATE CURRDATE FROM DUAL
                    ) CRDATE
                    WHERE E.BDDACCTNO_ESCROW = DD.ACCTNO
                    AND E.BDDACCTNO_IICA = D_II.ACCTNO
                    AND E.DELTD <> 'Y'
                    AND TRIM(E.BDDACCTNO_IICA) IS NOT NULL
                    AND E.DDSTATUS IN ('P','A')
                    AND E.BLOCKDATE <= CRDATE.CURRDATE
                    AND E.BLOCKENDDATE >= CRDATE.CURRDATE
                ) R1
                GROUP BY R1.CCYCD, R1.BCUSTODYCD, R1.BFULLNAME, R1.BDDACCTNO, R1.REFCASAACCT, R1.BALANCE, R1.BALANCE_USD, R1.HOLDBALANCE
            ) R2,
            (
                SELECT VND, CURRENCY FROM EXCHANGERATE WHERE RTYPE = 'TTM' AND ITYPE = 'SHV'
            ) EX,
            (
                SELECT BCUSTODYCD,BDDACCTNO,SUM(HOLD_DD) HOLD_TEMP FROM ESCROW_HOLD_TEMP WHERE UNHOLD = 'N' AND DELTD <>'Y' GROUP BY BCUSTODYCD, BDDACCTNO
            ) EDT,
            (
                SELECT TO_NUMBER(VARVALUE) RATIO FROM SYSVAR WHERE VARNAME = 'EAUSDRATIO' AND GRNAME = 'EA'
            ) SY
            WHERE R2.CCYCD = EX.CURRENCY
            AND R2.BCUSTODYCD = EDT.BCUSTODYCD(+)
            AND R2.BDDACCTNO = EDT.BDDACCTNO(+)
        )WHERE MAXBLKAMT > 0
    )
    LOOP
        SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
        INTO L_TXMSG.TXNUM
        FROM DUAL;
        --01    S? h?p d?ng   T
             l_txmsg.txfields ('01').defname   := 'ESCROWID';
             l_txmsg.txfields ('01').TYPE      := 'T';
             l_txmsg.txfields ('01').value      := '';
        --07    S? TK ti?n thanh toán   T
             l_txmsg.txfields ('07').defname   := 'BDDACCTNO';
             l_txmsg.txfields ('07').TYPE      := 'T';
             l_txmsg.txfields ('07').value      := rec.BDDACCTNO;
        --08    S? ti?n PT t?i da   T
             l_txmsg.txfields ('08').defname   := 'MAXAMT';
             l_txmsg.txfields ('08').TYPE      := 'T';
             l_txmsg.txfields ('08').value      := rec.BLKAMT;
        --09    S? TK ti?n thanh toán   T
             l_txmsg.txfields ('09').defname   := 'REFCASAACCT';
             l_txmsg.txfields ('09').TYPE      := 'T';
             l_txmsg.txfields ('09').value      := rec.REFCASAACCT;
        --10    S? ti?n PT   T
             l_txmsg.txfields ('10').defname   := 'AMT';
             l_txmsg.txfields ('10').TYPE      := 'T';
             l_txmsg.txfields ('10').value      := rec.MAXBLKAMT;
        --11    S? ti?n du?c phép PT   T
             l_txmsg.txfields ('11').defname   := 'AMTCHK';
             l_txmsg.txfields ('11').TYPE      := 'T';
             l_txmsg.txfields ('11').value      := rec.AMTCHK;
        --13    S? ti?n kh? d?ng   T
             l_txmsg.txfields ('13').defname   := 'BALANCE_IICA';
             l_txmsg.txfields ('13').TYPE      := 'T';
             l_txmsg.txfields ('13').value      := rec.BALANCE;
        --30    Di?n gi?i   T
             l_txmsg.txfields ('30').defname   := 'DESC';
             l_txmsg.txfields ('30').TYPE      := 'T';
             l_txmsg.txfields ('30').value      := L_STRDESC;
        --78    TKCK nh?n chuy?n nhu?ng   T
             l_txmsg.txfields ('78').defname   := 'BCUSTODYCD';
             l_txmsg.txfields ('78').TYPE      := 'T';
             l_txmsg.txfields ('78').value      := rec.BCUSTODYCD;
        --79    Tên bên nh?n chuy?n nhu?ng   T
             l_txmsg.txfields ('79').defname   := 'BFULLNAME';
             l_txmsg.txfields ('79').TYPE      := 'T';
             l_txmsg.txfields ('79').value      := rec.BFULLNAME;

         BEGIN
            IF TXPKS_#1108.FN_BATCHTXPROCESS(L_TXMSG, L_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN

                ROLLBACK;
            ELSE
                COMMIT;
            END IF;
        END;
    END LOOP;
    plog.setendsection(pkgctx, 'PRC_AUTO_EA1108');
EXCEPTION
  WHEN others THEN
    rollback;
    plog.error(pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
    plog.setendsection(pkgctx, 'PRC_AUTO_EA1108');
    RAISE errnums.E_SYSTEM_ERROR;
END;
/
