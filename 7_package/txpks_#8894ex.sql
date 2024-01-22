SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8894ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8894EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      14/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8894ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
   c_ddacctno         CONSTANT CHAR(2) := '04';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_etfid            CONSTANT CHAR(2) := '03';
   c_etfname          CONSTANT CHAR(2) := '82';
   c_ctck             CONSTANT CHAR(2) := '05';
   c_etfqtty          CONSTANT CHAR(2) := '06';
   c_type             CONSTANT CHAR(2) := '12';
   c_fullname         CONSTANT CHAR(2) := '07';
   c_nav              CONSTANT CHAR(2) := '08';
   c_amount           CONSTANT CHAR(2) := '09';
   c_fee              CONSTANT CHAR(2) := '10';
   c_tax              CONSTANT CHAR(2) := '11';
   c_desc             CONSTANT CHAR(2) := '30';
   c_stringvalue      CONSTANT CHAR(2) := '50';
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
L_orderid VARCHAR2(20);
l_prefix  VARCHAR2(20);
v_txdate DATE;
v_custid varchar2(10);
v_acctno varchar2(50);
v_dacctno varchar2(100);
v_seacctno varchar2(100);

v_dbcode varchar2(20);
l_STRDT  varchar2(4000);
v_refqtty number;
v_refapqtty number;
v_hold number;
v_price number;
v_refsymbol varchar2(30);
v_amount number;
v_autoid number;
L_COUNT                NUMBER(5);
codeid_semast varchar2(100);
l_txdate DATE;
l_strdesc    varchar2(400);
v_etfname varchar2(100);
v_apaccount varchar2(100);
v_trade number;

BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    SELECT to_date(VARVALUE,'dd/mm/yyyy') INTO v_txdate FROM sysvar WHERE VARNAME='CURRDATE';
    L_PREFIX:=TO_CHAR (GETCURRDATE(), 'YYMMDD');
    L_orderid:=L_PREFIX|| LPAD(seq_odmast.NEXTVAL,8,'0');

    select custid into v_custid from cfmast where custodycd = p_txmsg.txfields('88').value;
    begin
        select afacctno,acctno into v_acctno,v_dacctno from ddmast where custodycd = p_txmsg.txfields('88').value and status = 'A' and isdefault = 'Y';
    exception when NO_DATA_FOUND
        then
            p_err_code := '-900058';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
    end;
    select v_acctno || p_txmsg.txfields('03').value into v_seacctno from dual;

    begin
        select symbol into v_etfname from sbsecurities where codeid= p_txmsg.txfields('03').value;
    exception when NO_DATA_FOUND
        then
            p_err_code := '-930018';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
    end;

    INSERT INTO odmast (ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXNUM,TXDATE,
                        TIMETYPE,EXECTYPE,NORK,MATCHTYPE,VIA,CLEARDAY,CLEARDATE,ORSTATUS,PRICETYPE,ORDERPRICE,
                        ORDERQTTY,EXECQTTY,EXECAMT,FEEAMT,FEEACR,DELTD,TLID,LASTCHANGE,actype,grporder,
                        taxamt,NAV,MEMBER,ap,DifferenceAmonut,trade_date,ODTYPE)
                VALUES(L_orderid,p_txmsg.txfields('03').value,v_etfname,v_custid,v_acctno ,v_dacctno,v_seacctno,p_txmsg.txfields('88').value,p_txmsg.txnum,p_txmsg.txdate,
                NULL,p_txmsg.txfields('12').value,NULL,NULL,NULL,NULL,TO_DATE (p_txmsg.txfields('40').value, systemnums.C_DATE_FORMAT),'4',NULL,p_txmsg.txfields('09').value,
                p_txmsg.txfields('06').value,p_txmsg.txfields('06').value,p_txmsg.txfields('09').value ,p_txmsg.txfields('10').value,0,'N','0000',SYSDATE,'0000','N',
                p_txmsg.txfields('11').value,p_txmsg.txfields('08').value,p_txmsg.txfields('05').value,
                p_txmsg.txfields('83').value,p_txmsg.txfields('41').value,TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'SWE');

    INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE,fvstatus)
    VALUES(seq_stschd.NEXTVAL ,DECODE (p_txmsg.txfields('12').value,'NS','SS','NB','SM'),L_orderid,p_txmsg.txfields('03').value,v_etfname,v_custid,v_acctno,v_dacctno,v_seacctno,p_txmsg.txfields('88').value,p_txmsg.txdate,0,'B',p_txmsg.txfields('09').value ,p_txmsg.txfields('06').value,p_txmsg.txfields('10').value,p_txmsg.txfields('11').value,'P','N',TO_DATE (p_txmsg.txfields('40').value, systemnums.C_DATE_FORMAT),SYSDATE,'P');

    INSERT INTO stschd (AUTOID,DUETYPE,ORDERID,CODEID,SYMBOL,CUSTID,AFACCTNO,DDACCTNO,SEACCTNO,CUSTODYCD,TXDATE,CLEARDAY,CLEARCD,AMT,QTTY,FEEAMT,VAT,STATUS,DELTD,CLEARDATE,LASTCHANGE,fvstatus)
    VALUES(seq_stschd.NEXTVAL ,DECODE (p_txmsg.txfields('12').value,'NS','RM','NB','RS'),L_orderid,p_txmsg.txfields('03').value,v_etfname,v_custid,v_acctno,v_dacctno,v_seacctno,p_txmsg.txfields('88').value,p_txmsg.txdate,0,'B',p_txmsg.txfields('09').value ,p_txmsg.txfields('06').value,p_txmsg.txfields('10').value,p_txmsg.txfields('11').value,'P','N',TO_DATE (p_txmsg.txfields('40').value, systemnums.C_DATE_FORMAT),SYSDATE,'P');


    v_autoid := SEQ_FEETRAN.NEXTVAL;
    l_txdate:=TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT);
    l_STRDT:=   p_txmsg.txfields('50').VALUE;
    
    if l_STRDT is not null then
        FOR REC0 IN (
            SELECT REGEXP_SUBSTR(l_STRDT, '[^#,]+', 1, LEVEL) tmp
            FROM dual CONNECT BY REGEXP_SUBSTR(l_STRDT, '[^#,]+', 1, LEVEL) is NOT NULL
        )
        LOOP

             SELECT SUBSTR( rec0.tmp,0,INSTR (rec0.tmp,'|') -1 ),
                   SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|') +1,INSTR (rec0.tmp,'|',1,2) -  INSTR (rec0.tmp,'|',1,1)-1),
                   SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,2) +1,INSTR (rec0.tmp,'|',1,3) -  INSTR (rec0.tmp,'|',1,2)-1),
                   SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,3) +1,INSTR (rec0.tmp,'|',1,4) -  INSTR (rec0.tmp,'|',1,3)-1),
                   SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,4) +1,INSTR (rec0.tmp,'|',1,5) -  INSTR (rec0.tmp,'|',1,4)-1),
                   SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,5) +1,INSTR (rec0.tmp,'|',1,6) -  INSTR (rec0.tmp,'|',1,5)-1),
                   SUBSTR( rec0.tmp,INSTR (rec0.tmp,'|',1,6) +1)
             INTO v_refsymbol,v_refqtty,v_refapqtty,v_hold,v_price, v_amount,v_apaccount
             FROM dual;



             select v_acctno || v_refsymbol into codeid_semast from dual;

             SELECT COUNT(*) INTO L_COUNT FROM SEMAST WHERE ACCTNO = codeid_semast and status ='A';

             IF L_COUNT = 0 THEN
                
                IF  p_txmsg.txfields('12').value = 'NB' THEN

                    INSERT INTO semast
                     (actype, custid, acctno,
                      codeid,
                      afacctno, opndate, lastdate,
                      costdt, tbaldt, status, irtied, ircd, costprice, trade,
                      mortage, margin, receiving, standing, withdraw, deposit,
                      loan
                     )
                      VALUES ('0000', v_custid, codeid_semast,
                              SUBSTR (codeid_semast, 11, 6),
                              SUBSTR (codeid_semast, 1, 10), l_txdate, l_txdate,
                              l_txdate, l_txdate, 'A', 'Y', '000', 0, 0,
                              0, 0, v_refqtty, 0, 0, 0,
                              0
                             );
                     INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0016',v_refqtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'' || '' || '');

                ELSE
                    /*INSERT INTO semast
                     (actype, custid, acctno,
                      codeid,
                      afacctno, opndate, lastdate,
                      costdt, tbaldt, status, irtied, ircd, costprice, trade,
                      mortage, margin, netting, standing, withdraw, deposit,
                      loan
                     )
                      VALUES ('0000', v_custid, codeid_semast,
                              SUBSTR (codeid_semast, 11, 6),
                              SUBSTR (codeid_semast, 1, 10), l_txdate, l_txdate,
                              l_txdate, l_txdate, 'A', 'Y', '000', 0, 0,
                              0, 0, v_refqtty, 0, 0, 0,
                              0
                             );

                     INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0019',v_refqtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'' || '' || '');
*/                    --trung.luu: yeu cau 20-02-2020 bo check so du CK voi lenh ban
                    ---200502
                    --trung.luu:SHBVNEX-1039 30-06-2020 yeu cau lai, check so du voi lenh ban
                    p_err_code := '-200502';
                    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                END IF;
            ELSE
                
                IF  p_txmsg.txfields('12').value = 'NB' THEN
                    Update semast
                    set receiving = receiving + v_refqtty
                    where ACCTNO = codeid_semast;

                    INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0016',v_refqtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'' || '' || '');

                ELSE
                    --trung.luu: yeu cau 20-02-2020 bo check so du CK voi lenh ban
                    --trung.luu:SHBVNEX-1039 30-06-2020 yeu cau lai, check so du voi lenh ban
                    select nvl(trade,0) into v_trade from semast where acctno = codeid_semast;
                    if v_trade < v_refqtty then
                        p_err_code := '-200502';
                        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    else
                        Update semast
                            set NETTING = NETTING + v_refqtty,
                                TRADE  = TRADE - v_refqtty
                                where ACCTNO = codeid_semast;
                        INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0019',v_refqtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'' || '' || '');

                        INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                        VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0011',v_refqtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,TO_DATE (p_txmsg.txfields('20').value, systemnums.C_DATE_FORMAT),'' || '' || '');
                   end if;
                END IF;

            END IF;
             /*IF  p_txmsg.txfields(c_type).value = '0' THEN
                INSERT INTO SETRAN(TXNUM,TXDATE,ACCTNO,TXCD,NAMT,CAMT,ACCTREF,DELTD,REF,AUTOID,TLTXCD,BKDATE,TRDESC)
                    VALUES (p_txmsg.txnum, TO_DATE (p_txmsg.txdate, systemnums.C_DATE_FORMAT),codeid_semast,'0016',v_refqtty,NULL,'',p_txmsg.deltd,'',seq_SETRAN.NEXTVAL,p_txmsg.tltxcd,p_txmsg.busdate,'' || '' || '');

             ELSE

             END IF;*/
            insert into ETFWSAP (AUTOID,ORDERID,CUSTODYCD,AFACCTNO,TXDATE,TXNUM,CODEID,QTTY,PRICE,AMT,STATUS,DELTD,LASTCHANGE,APQTTY,HOLDFS,APACCOUNT)
            values(seq_etfwsap.NEXTVAL,L_orderid,p_txmsg.txfields('88').value,v_acctno,p_txmsg.txdate,p_txmsg.txnum,v_refsymbol,v_refqtty,v_price,v_amount,'P','N',SYSDATE,v_refapqtty,v_hold,v_apaccount);
             --

        END LOOP;
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
         plog.init ('TXPKS_#8894EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8894EX;
/
