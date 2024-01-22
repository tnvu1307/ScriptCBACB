SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2229ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2229EX
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


CREATE OR REPLACE PACKAGE BODY txpks_#2229ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacct2          CONSTANT CHAR(2) := '03';
   c_acct2            CONSTANT CHAR(2) := '05';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_license          CONSTANT CHAR(2) := '92';
   c_shareholdersid   CONSTANT CHAR(2) := '22';
   c_custodycdcr      CONSTANT CHAR(2) := '89';
   c_afacctnocr       CONSTANT CHAR(2) := '13';
   c_seacctnocr       CONSTANT CHAR(2) := '15';
   c_typepon          CONSTANT CHAR(2) := '08';
   c_shareholdersidcr   CONSTANT CHAR(2) := '33';
   c_trademax         CONSTANT CHAR(2) := '21';
   c_trade            CONSTANT CHAR(2) := '10';
   c_blockedmax       CONSTANT CHAR(2) := '17';
   c_blocked          CONSTANT CHAR(2) := '06';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_price            CONSTANT CHAR(2) := '09';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    Status varchar(2);
    l_count number;
    l_otcSCustodycd varchar2(30);
    l_otcBCustodycd varchar2(30);
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
        select status into Status from afmast where acctno = p_txmsg.txfields('03').value;
        IF Status LIKE 'B' THEN
            p_err_code := '-670411';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        IF p_txmsg.txfields('22').value = p_txmsg.txfields('33').value THEN
            p_err_code := '-901137';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(p_txmsg.txfields('05').value,'SEMAST','ACCTNO');
        if length(trim(p_txmsg.txfields('02').value)) > 0 then
            --Khong tim thay so hop dong
            select count(*) into l_count
            from OTCODMAST es
            where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('02').value))
                and SCUSTODYCD = upper(trim(p_txmsg.txfields('88').value))
                and BCUSTODYCD = upper(trim(p_txmsg.txfields('89').value))
                and CODEID = upper(trim(p_txmsg.txfields('01').value))
                and DELTD <> 'Y';
            if l_count = 0 then
                p_err_code := '-180023';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --Trang thai hop dong khong hop le
            select count(*), max(scustodycd), max(bcustodycd), max(qtty), max(price) into l_count, l_otcSCustodycd, l_otcBCustodycd, l_otcQtty, l_otcPrice
            from OTCODMAST es
            where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('02').value)) and es.sestatus in ('PC','BC')
                and DELTD <> 'Y';
            if l_count = 0 then
                p_err_code := '-180022';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --Tai khoan chuyen khong khop voi hop dong
            if upper(trim(p_txmsg.txfields('88').value)) <> l_otcSCustodycd then
                p_err_code := '-180050';
                
                plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;

            --Tai khoan nhan khong khop voi hop dong
            if upper(trim(p_txmsg.txfields('89').value)) <> l_otcBCustodycd then
                p_err_code := '-180049';
                
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
l_count    number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
IF p_txmsg.DELTD <> 'Y' THEN
    INSERT INTO SEOTCTRANLOG (AUTOID,TXNUM,TXDATE,TLTXCD,SEACCTNO,TYPEPON,SHAREHOLDERSID,STATUS,TXTYPE,TRADE,BLOCKED,QTTY,DELTD,OTCODID,DPOPLACE)
    VALUES(seq_SEOTCTRANLOG.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.tltxcd,p_txmsg.txfields('15').value,p_txmsg.txfields('08').value,p_txmsg.txfields('22').value,'A',
        'C',p_txmsg.txfields('10').value,p_txmsg.txfields('06').value,p_txmsg.txfields('12').value,'N',p_txmsg.txfields('02').value,'');

    INSERT INTO SEOTCTRANLOG (AUTOID,TXNUM,TXDATE,TLTXCD,SEACCTNO,TYPEPON,SHAREHOLDERSID,STATUS,TXTYPE,TRADE,BLOCKED,QTTY,DELTD,OTCODID,DPOPLACE)
        VALUES(seq_SEOTCTRANLOG.NEXTVAL,p_txmsg.txnum,TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.tltxcd,p_txmsg.txfields('05').value,p_txmsg.txfields('08').value,p_txmsg.txfields('22').value,'A',
            'D',p_txmsg.txfields('10').value,p_txmsg.txfields('06').value,p_txmsg.txfields('12').value,'N',p_txmsg.txfields('02').value,'');

    UPDATE SEMAST SET OLDshareholdersid = shareholdersid,  shareholdersid= p_txmsg.txfields('33').value WHERE ACCTNO =p_txmsg.txfields('15').value;

    if length(trim(p_txmsg.txfields('02').value)) > 0 then

       INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
             VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('05').value,'0020',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

       UPDATE SEMAST
          SET
            NETTING = NETTING - (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
         WHERE ACCTNO=p_txmsg.txfields('05').value;

       update otcodmast set sestatus = 'CC'
         where upper(trim(otcodid)) = upper(trim(p_txmsg.txfields('02').value)) and deltd <> 'Y';
     ELSE
         INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
             VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),p_txmsg.txfields ('05').value,'0011',ROUND(p_txmsg.txfields('10').value,0),NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

       UPDATE SEMAST
          SET
            TRADE = TRADE - (ROUND(p_txmsg.txfields('10').value,0)), LAST_CHANGE = SYSTIMESTAMP
         WHERE ACCTNO=p_txmsg.txfields('05').value;

     end if;
ELSE

    UPDATE SEMAST SET shareholdersid=OLDshareholdersid ,OLDshareholdersid='' WHERE ACCTNO =p_txmsg.txfields('15').value;
    UPDATE  SEOTCTRANLOG SET DELTD ='Y' WHERE TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT) AND TXNUM =p_txmsg.TXNUM;

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
         plog.init ('TXPKS_#2229EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2229EX;
/
