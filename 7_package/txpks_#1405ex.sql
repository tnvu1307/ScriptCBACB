SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1405ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1405EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      29/11/2019     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
/


CREATE OR REPLACE PACKAGE BODY txpks_#1405ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '01';
   c_crphysagreeid    CONSTANT CHAR(2) := '02';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_codeid           CONSTANT CHAR(2) := '03';
   c_crqtty           CONSTANT CHAR(2) := '15';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_refno            CONSTANT CHAR(2) := '11';
   c_sender           CONSTANT CHAR(2) := '31';
   c_receiver         CONSTANT CHAR(2) := '32';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
V_SUMALL NUMBER;
V_CONGDON NUMBER;
v_acctno varchar2(30);
v_tradeplace varchar2(5);
v_total NUMBER;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   --*************************************************************************************************
      /*BEGIN
            SELECT SUM(NVL(NVALUE,0))
            into V_SUMALL
            FROM
                (
                    SELECT TLF.NVALUE
                    FROM VW_TLLOGFLD_ALL TLF
                    WHERE  TLF.FLDCD IN ('10') AND (TLF.TXNUM,TLF.TXDATE) IN
                            (
                            SELECT TLF.TXNUM,TLF.TXDATE
                            FROM (SELECT * FROM VW_TLLOG_ALL WHERE TXSTATUS ='1') TLA, VW_TLLOGFLD_ALL TLF
                            WHERE TLF.FLDCD IN ('02')  AND TLF.CVALUE =p_txmsg.txfields('02').value AND TLA.TXNUM = TLF.TXNUM AND TLA.TXDATE = TLF.TXDATE AND TLA.TLTXCD ='1405'
                            )
                );
       EXCEPTION
                  WHEN OTHERS THEN
                    V_SUMALL :=0;
       END;
   ---------------------------------------------------------------------------------------------------
       V_CONGDON:= V_SUMALL + p_txmsg.txfields('10').value;
       IF V_CONGDON > p_txmsg.txfields('15').value AND p_txmsg.txfields('02').value IS NOT NULL THEN
           P_ERR_CODE := '-100551';
           PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
           RETURN ERRNUMS.C_BIZ_RULE_INVALID;
       END IF;*/
   --************************************************************************************************/
   select cr.acctno||cr.codeid,qtty into v_acctno,v_sumall from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
   /*select sum(namt) into V_SUMALL
   from vw_setran_gen where acctno =v_acctno and tltxcd='1405' and busdate <=  p_txmsg.busdate;*/
   BEGIN
        SELECT SUM(qtty+receiving) total  into v_total
        FROM crphysagree_log WHERE crphysagreeid = p_txmsg.txfields('02').value AND TYPE = 'R' GROUP BY crphysagreeid;
   EXCEPTION WHEN OTHERS THEN  v_total := 0;
   END;
   if v_sumall < p_txmsg.txfields(c_qtty).value + p_txmsg.txfields('12').value then
        P_ERR_CODE := '-100551';
           PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
           RETURN ERRNUMS.C_BIZ_RULE_INVALID;
   end if;

   BEGIN
        SELECT TRADEPLACE INTO V_TRADEPLACE FROM SBSECURITIES WHERE CODEID = p_txmsg.txfields(c_codeid).value;
        EXCEPTION WHEN OTHERS THEN  V_TRADEPLACE :='';
    END;

--THANGPV SHBVNEX-2732
   if V_TRADEPLACE = '003' then
        if v_sumall - v_total < p_txmsg.txfields(c_qtty).value + p_txmsg.txfields('12').value  then
            P_ERR_CODE := '-100551';
           PLOG.SETENDSECTION (PKGCTX, 'FN_TXPREAPPCHECK');
           RETURN ERRNUMS.C_BIZ_RULE_INVALID;
        end if;
   end if;


    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppCheck;

FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txAftAppCheck');
   plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppCheck>>');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txAftAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      plog.setendsection (pkgctx, 'fn_txAftAppCheck');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppCheck;

FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    plog.debug (pkgctx, '<<END OF fn_txPreAppUpdate');
    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
v_count      NUMBER;
V_SYMBOL     VARCHAR2(80);
V_CUSTID     VARCHAR2(20);
V_AFACCTNO   VARCHAR2(20);
V_FEEAMT     NUMBER(20,4);
V_TAXAMT     NUMBER(20,4);
V_TAXRATE    NUMBER(20,4);
V_CCYCD      VARCHAR2(20);
V_FAUTOID    NUMBER;
V_TAUTOID    NUMBER;
V_SUPEBANK   VARCHAR2(1);
v_tradeplace varchar2(5);
v_acctno varchar2(30);
v_sumqtty number;
v_qtty number;
v_setqtty number;
v_debitrecqtty number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    --
    BEGIN
        SELECT SYMBOL,TRADEPLACE INTO V_SYMBOL,V_TRADEPLACE FROM SBSECURITIES WHERE CODEID = p_txmsg.txfields(c_codeid).value;
        EXCEPTION WHEN OTHERS THEN V_SYMBOL := ''; V_TRADEPLACE :='';
    END;
    --
    BEGIN
        SELECT CF.CUSTID, AF.ACCTNO, CF.SUPEBANK
        INTO V_CUSTID, V_AFACCTNO, V_SUPEBANK
        FROM CFMAST CF, AFMAST AF
        WHERE CF.CUSTID = AF.CUSTID AND
              CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
        EXCEPTION WHEN OTHERS THEN V_CUSTID   := NULL;
                                   V_AFACCTNO := NULL;
                                   V_SUPEBANK := NULL;
    END;

    --Thoai.tran 27/06/2022
    --SHBVNEX-2732
    v_debitrecqtty := p_txmsg.txfields(c_qtty).value + p_txmsg.txfields('12').value;
    IF p_txmsg.deltd <> 'Y' THEN

        -- Thoai.tran 14/04/2022 Ck unlisted (1404)
        if V_TRADEPLACE = '003' then
            select cr.acctno||cr.codeid into v_acctno from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;

            -- Set qtty (1404) search CRPHYSAGREE_PY field 55
            SELECT  CASE WHEN CRLOG.AQTTY IS NULL THEN CR.QTTY ELSE (CR.QTTY - CRLOG.AQTTY) END REMQTTY into v_setqtty
            FROM (SELECT *fROM CRPHYSAGREE WHERE DELTD <>'Y') CR, CFMAST CF,
            (SELECT CRL.CRPHYSAGREEID, SUM(CRL.QTTY) AQTTY FROM CRPHYSAGREE_LOG CRL WHERE CRL.TYPE = 'R' AND CRL.DELTD <> 'Y' GROUP BY CRL.CRPHYSAGREEID) CRLOG
            WHERE CR.CRPHYSAGREEID = CRLOG.CRPHYSAGREEID(+)
            AND CR.STATUS = 'A'
            AND CR.ACCTNO = CF.CUSTID
            and CR.CRPHYSAGREEID = p_txmsg.txfields(c_crphysagreeid).value;

            update semast se
            set se.trade = trade + p_txmsg.txfields(c_qtty).value,
            se.receiving = se.receiving - v_debitrecqtty
            where se.acctno = v_acctno;

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_acctno,'0012',p_txmsg.txfields(c_qtty).value,NULL,'','N','',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
            VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),v_acctno,'0015',v_debitrecqtty,NULL,'','N','',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

            --trung.luu: 02-07-2020 log lai de len view physical
            --bao.nguyen: 25-07-2022 SHBVNEX-2730
            insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,CUSTODYCD,symbol,typedoc, custid)
            values (p_txmsg.txdate, p_txmsg.txnum,'NP',null,p_txmsg.txfields(c_crphysagreeid).value ,NULL, NULL, v_setqtty, p_txmsg.txfields(c_qtty).value, 'A', 'N',p_txmsg.txfields(c_desc).value,null,p_txmsg.tltxcd,null,p_txmsg.txfields(c_custodycd).value,V_SYMBOL,'1407', v_custid);

            insert into crphysagree_log (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC, RECEIVING)
            values (p_txmsg.txdate, p_txmsg.txnum, 'R', null, p_txmsg.txfields(c_crphysagreeid).value, null, null, v_setqtty, p_txmsg.txfields(c_qtty).value, 'A', 'N', p_txmsg.txfields(c_desc).value, p_txmsg.txfields('12').value);


            select sum(crl.qtty) into v_sumqtty from crphysagree_log crl where crl.type = 'R' and crl.deltd <> 'Y' and crl.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
            select cr.qtty into v_qtty from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;

            if v_sumqtty = v_qtty then
                update crphysagree cr
                set cr.balancestatus = 'R'
                where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
            end if;

        end if;

        --trung.luu: 02-07-2020 log lai de len view physical
        --bao.nguyen: 25-07-2022 SHBVNEX-2730
        insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SYMBOL,CUSTODYCD,REFNO,SENDER,RECEIVER,typedoc, custid)
        values (p_txmsg.txdate, p_txmsg.txnum,'NK',null,p_txmsg.txfields(c_crphysagreeid).value ,NULL, NULL, null, p_txmsg.txfields(c_qtty).value, 'A', 'N',p_txmsg.txfields(c_desc).value,
        null,p_txmsg.tltxcd,null,V_SYMBOL,p_txmsg.txfields(c_custodycd).value,p_txmsg.txfields(c_refno).value,p_txmsg.txfields(c_sender).value,p_txmsg.txfields(c_receiver).value,'1405', v_custid);

        IF p_txmsg.txfields(c_qtty).value > 0 THEN
            insert into docstransfer (AUTOID, OPNDATE
            , CLSDATE, CRPHYSAGREEID, QTTY
            , OPNTXNUM, DELTD, STATUS, OPNSENDER, OPNRECEIVER
            , OPNTXDATE, REFNO, CLSTXDATE, CLSTXNUM, CLSSENDER, CLSRECEIVER, CUSTODYCD, SYMBOL, CODEID, CUSTID)
            values (seq_docstransfer.nextval, TO_DATE(p_txmsg.txfields(c_txdate).value, systemnums.C_DATE_FORMAT)
            --, null, p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_crqtty).value --nam.ly 07-02-2020
            , null, p_txmsg.txfields(c_crphysagreeid).value, p_txmsg.txfields(c_qtty).value --nam.ly 07-02-2020
            , p_txmsg.txnum, 'N', 'OPN', p_txmsg.txfields(c_sender).value, p_txmsg.txfields(c_receiver).value
            , p_txmsg.txdate, p_txmsg.txfields(c_refno).value, null, null, null, null, p_txmsg.txfields(c_custodycd).value, V_SYMBOL,p_txmsg.txfields(c_codeid).value, V_CUSTID);
        END IF;

        select nvl(count(*), 0) into v_count from crphysagree cr where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
        if v_count > 0 then
            update crphysagree cr
            set cr.reposstatus = 'R'
            where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
        end if;
     else
            UPDATE SETRAN SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE (P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);
            UPDATE CRPHYSAGREE_LOG_ALL SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);
            UPDATE CRPHYSAGREE_LOG SET DELTD = 'Y' WHERE TXNUM = P_TXMSG.TXNUM AND TXDATE = TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT);

            UPDATE SEMAST SE
            SET SE.TRADE = TRADE - P_TXMSG.TXFIELDS(C_QTTY).VALUE,
                SE.RECEIVING = SE.RECEIVING + v_debitrecqtty
            WHERE SE.ACCTNO = V_ACCTNO;

            SELECT SUM(CRL.QTTY) INTO V_SUMQTTY FROM CRPHYSAGREE_LOG CRL WHERE CRL.TYPE = 'R' AND CRL.DELTD <> 'Y' AND CRL.CRPHYSAGREEID = P_TXMSG.TXFIELDS(C_CRPHYSAGREEID).VALUE;
            SELECT CR.QTTY INTO V_QTTY FROM CRPHYSAGREE CR WHERE CR.CRPHYSAGREEID = P_TXMSG.TXFIELDS(C_CRPHYSAGREEID).VALUE;

            UPDATE docstransfer SET DELTD = 'Y' WHERE OPNTXNUM = p_txmsg.txnum AND OPNTXDATE = p_txmsg.txdate;

            if v_sumqtty <> v_qtty then
                update crphysagree cr
                set cr.balancestatus = 'P'
                where cr.crphysagreeid = p_txmsg.txfields(c_crphysagreeid).value;
            end if;
    end if;
    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
       plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txAftAppUpdate;

BEGIN
      FOR i IN (SELECT *
                FROM tlogdebug)
      LOOP
         logrow.loglevel    := i.loglevel;
         logrow.log4table   := i.log4table;
         logrow.log4alert   := i.log4alert;
         logrow.log4trace   := i.log4trace;
      END LOOP;
      pkgctx    :=
         plog.init ('TXPKS_#1405EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1405EX;
/
