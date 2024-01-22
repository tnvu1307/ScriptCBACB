SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#8872EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8872EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      30/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY TXPKS_#8872EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_symbol           CONSTANT CHAR(2) := '68';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_acct             CONSTANT CHAR(2) := '03';
   c_desacctno        CONSTANT CHAR(2) := '06';
   c_acctno           CONSTANT CHAR(2) := '05';
   c_exectype         CONSTANT CHAR(2) := '23';
   c_tradedate        CONSTANT CHAR(2) := '20';
   c_settledate       CONSTANT CHAR(2) := '21';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_parvalue         CONSTANT CHAR(2) := '11';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS

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
L_COUNT number;
L_orderid VARCHAR2(20);
l_prefix  VARCHAR2(20);
v_txdate DATE;
v_custid varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    SELECT to_date(VARVALUE,'dd/mm/yyyy') INTO v_txdate FROM sysvar WHERE VARNAME='CURRDATE';
    SELECT NVL(COUNT(*),0) INTO L_COUNT FROM  compare_trading_result WHERE STATUS ='F';

    L_PREFIX:=TO_CHAR (GETCURRDATE(), 'YYMMDD');

        Select custid into v_custid from cfmast  where custodycd = p_txmsg.txfields(c_custodycd).value;
        L_orderid:=L_PREFIX|| LPAD(seq_odmast.NEXTVAL,8,'0');

        INSERT INTO iod (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,ORDERQTTY,EXECQTTY, EXECPRICE , EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE)
        VALUES(L_orderid,p_txmsg.txfields(c_codeid).value,p_txmsg.txfields(c_symbol).value,v_custid,p_txmsg.txfields('03').value ,p_txmsg.txfields(c_desacctno).value,p_txmsg.txfields('05').value,p_txmsg.txfields(c_custodycd).value,NULL,v_txdate,NULL,
            p_txmsg.txfields(c_exectype).value,NULL,NULL,NULL,NULL,p_txmsg.txfields(c_settledate).value,'A',NULL,0,0,p_txmsg.txfields(c_qtty).value,p_txmsg.txfields(c_parvalue).value,
            p_txmsg.txfields(c_qtty).value*p_txmsg.txfields(c_parvalue).value ,0,0,'N','0000',SYSDATE);

        INSERT INTO odmast (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,ORDERQTTY,EXECQTTY,EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE)
        VALUES(L_orderid,p_txmsg.txfields(c_codeid).value,p_txmsg.txfields(c_symbol).value,v_custid,p_txmsg.txfields('03').value ,p_txmsg.txfields(c_desacctno).value,p_txmsg.txfields('05').value,p_txmsg.txfields(c_custodycd).value,NULL,v_txdate,NULL,
            p_txmsg.txfields(c_exectype).value,NULL,NULL,NULL,NULL,p_txmsg.txfields(c_settledate).value,'A',NULL,0,0,p_txmsg.txfields(c_qtty).value,
            p_txmsg.txfields(c_qtty).value*p_txmsg.txfields(c_parvalue).value ,0,0,'N','0000',SYSDATE);


        INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE)
        VALUES(seq_stschd.NEXTVAL ,p_txmsg.txfields(c_exectype).value,L_orderid,p_txmsg.txfields(c_codeid).value,p_txmsg.txfields(c_symbol).value,v_custid,p_txmsg.txfields('03').value ,p_txmsg.txfields(c_desacctno).value,p_txmsg.txfields('05').value,p_txmsg.txfields(c_custodycd).value,NULL,0,'B'
                ,p_txmsg.txfields(c_qtty).value*p_txmsg.txfields(c_parvalue).value ,p_txmsg.txfields(c_qtty).value,0,0,'N','N',p_txmsg.txfields(c_tradedate).value,SYSDATE);

        INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE)
        VALUES(seq_stschd.NEXTVAL ,p_txmsg.txfields(c_exectype).value,L_orderid,p_txmsg.txfields(c_codeid).value,p_txmsg.txfields(c_symbol).value,v_custid,p_txmsg.txfields('03').value ,p_txmsg.txfields(c_desacctno).value,p_txmsg.txfields('05').value,p_txmsg.txfields(c_custodycd).value,NULL,0,'B'
                ,p_txmsg.txfields(c_qtty).value*p_txmsg.txfields(c_parvalue).value ,p_txmsg.txfields(c_qtty).value,0,0,'N','N',p_txmsg.txfields(c_settledate).value,SYSDATE);


    --xoa bang tam, insert v?b?ng hist

    INSERT INTO ODMASTCMPHIST (SELECT * FROM ODMASTCMP);
    DELETE FROM ODMASTCMP;

    INSERT INTO ODMASTVSDHIST (SELECT * FROM ODMASTVSD);
    DELETE FROM ODMASTVSD;

    INSERT INTO ODMASTCUSTHIST (SELECT * FROM ODMASTCUST);
    DELETE FROM ODMASTCUST;
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
         plog.init ('TXPKS_#8872EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8872EX;
/
