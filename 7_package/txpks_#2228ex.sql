SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2228ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2228EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      17/07/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2228ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacct2          CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_typepon          CONSTANT CHAR(2) := '08';
   c_qttyavl          CONSTANT CHAR(2) := '20';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_depoblockavl     CONSTANT CHAR(2) := '40';
   c_depoblock        CONSTANT CHAR(2) := '06';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_shareholdersid   CONSTANT CHAR(2) := '22';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_des              CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    Custatcom varchar(2);
    l_count number;
    l_otcCustodycd varchar2(30);
    l_otcQtty number;
    l_otcPrice number;
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    l_Trade number;
    l_Netting   number;
BEGIN
   plog.setbeginsection (pkgctx, 'fn_txPreAppCheck');
   plog.debug(pkgctx,'BEGIN OF fn_txPreAppCheck');
   /***************************************************************************************************
    * PUT YOUR SPECIFIC RULE HERE, FOR EXAMPLE:
    * IF NOT <<YOUR BIZ CONDITION>> THEN
    *    p_err_code := '<<ERRNUM>>'; -- Pre-defined in DEFERROR table
    *    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    *    RETURN errnums.C_BIZ_RULE_INVALID;
    * END IF;
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        select CUSTATCOM into Custatcom from CFMAST where custodycd = p_txmsg.txfields('88').value;
        IF Custatcom = 'N' THEN
            IF p_txmsg.txfields('13').value IS NULL THEN
                p_err_code := '-901201';
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            END IF;
        END IF;

        l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(p_txmsg.txfields('05').value,'SEMAST','ACCTNO');

        if length(trim(p_txmsg.txfields('02').value)) > 0 then
            --Khong tim thay so hop dong
            select count(*) into l_count
            from OTCODMAST es
            where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('02').value))
                and DELTD <> 'Y';
            if l_count = 0 then
                p_err_code := '-180023';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            select count(*) into l_count
            from OTCODMAST es, cfmast scf
            where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('02').value))
                and es.scustodycd = scf.custodycd
                and es.DELTD <> 'Y'
                and not EXISTS (select * from cfmast bcf where bcf.custodycd = es.bcustodycd);
            if l_count = 0 then
                p_err_code := '-180051';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --Trang thai hop dong khong hop le
            select count(*), max(scustodycd), max(qtty), max(price) into l_count, l_otcCustodycd, l_otcQtty, l_otcPrice
            from OTCODMAST es
            where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('02').value)) and es.sestatus in ('PC','BC')
                and DELTD <> 'Y';
            if l_count = 0 then
                p_err_code := '-180022';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --Tai khoan chuyen khong khop voi hop dong
            if upper(trim(p_txmsg.txfields('88').value)) <> l_otcCustodycd then
                p_err_code := '-180050';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --So luong khong khop voi hop dong
            if to_number(p_txmsg.txfields('10').value) <> l_otcQtty then
                p_err_code := '-180047';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --Hop dong mua ban OTC khong thanh toan CK HCCN
            if to_number(p_txmsg.txfields('06').value) <> 0 then
                p_err_code := '-200417';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            l_Netting   := l_SEMASTcheck_arr(0).netting;

            IF NOT (to_number(l_Netting) >= to_number(p_txmsg.txfields('10').value)) THEN
                p_err_code := '-900017';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
             END IF;
        else
            l_Trade := l_SEMASTcheck_arr(0).trade;
            IF NOT (to_number(l_Trade) >= to_number(p_txmsg.txfields('10').value)) THEN
                p_err_code := '-900040';
                plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
             END IF;
        end if;
    END IF;

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
v_symbol varchar2(50);
v_custid varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.DELTD <> 'Y' THEN
        INSERT INTO SEOTCTRANLOG (AUTOID,TXNUM,TXDATE,TLTXCD,SEACCTNO,TYPEPON,SHAREHOLDERSID,STATUS,TXTYPE,TRADE,BLOCKED,QTTY,DELTD,OTCODID,DPOPLACE)
        VALUES(seq_SEOTCTRANLOG.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.tltxcd,p_txmsg.txfields('05').value,'',p_txmsg.txfields('22').value,'A',
            'D',p_txmsg.txfields('10').value,p_txmsg.txfields('06').value,p_txmsg.txfields('12').value,'N',p_txmsg.txfields('02').value,p_txmsg.txfields('13').value);
        if length(trim(p_txmsg.txfields('02').value)) > 0 then

          INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('05').value,'0020',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

          UPDATE SEMAST
             SET
               NETTING = NETTING - (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('05').value;

          update otcodmast set sestatus = 'CC',TRANSACTIONNUMBER = p_txmsg.txfields('81').value
            where upper(trim(otcodid)) = upper(trim(p_txmsg.txfields('02').value)) and deltd <> 'Y';

        ELSE
            INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('05').value,'0011',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

          UPDATE SEMAST
             SET
               TRADE = TRADE - (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('05').value;

        end if;

        ----- insert vao bang FEETRANREPAIR
        select se.symbol into v_symbol from sbsecurities se where se.codeid = p_txmsg.txfields(c_codeid).value;
        select cf.custid into v_custid from cfmast cf where cf.custodycd = p_txmsg.txfields(c_custodycd).value;

        insert into feetranrepair (TXDATE, TXNUM, ORDERID, EXECTYPE, SYMBOL, CLEARDATE, QTTY
                                 , AMOUNT, FEEAMT, REPAIRAMT, CUSTID, AFACCTNO, STATUS, DELTD, MAKERID, CHECKERID)
            values (p_txmsg.txdate, p_txmsg.txnum, to_char(p_txmsg.txdate,'YYYYMMDD') || p_txmsg.txnum, 'WT', v_symbol, null, p_txmsg.txfields('12').value
                  , p_txmsg.txfields('12').value * p_txmsg.txfields('11').value, 0, 0, v_custid, p_txmsg.txfields(c_afacct2).value, 'P', 'N', p_txmsg.tlid,p_txmsg.offid);
    ELSE
        UPDATE  SEOTCTRANLOG SET DELTD ='Y' WHERE TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND TXNUM =p_txmsg.TXNUM;

        UPDATE SETRAN        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        if length(trim(p_txmsg.txfields('02').value)) > 0 then
          UPDATE SEMAST
             SET
               NETTING = NETTING + (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('05').value;

          update otcodmast set sestatus = 'CC'
            where upper(trim(otcodid)) = upper(trim(p_txmsg.txfields('02').value)) and deltd <> 'Y';
        ELSE
          UPDATE SEMAST
             SET
               TRADE = TRADE + (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
            WHERE ACCTNO=p_txmsg.txfields('05').value;
        end if;

        update feetranrepair fe set fe.deltd = 'Y' where fe.txdate = p_txmsg.txdate and fe.txnum = p_txmsg.txnum;
    END IF;
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
         plog.init ('TXPKS_#2228EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2228EX;
/
