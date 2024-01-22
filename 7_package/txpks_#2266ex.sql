SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2266ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2266EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      27/08/2012     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2266ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_autoid           CONSTANT CHAR(2) := '18';
   c_custodycd        CONSTANT CHAR(2) := '05';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_symbol           CONSTANT CHAR(2) := '07';
   c_trade            CONSTANT CHAR(2) := '10';
   c_blocked          CONSTANT CHAR(2) := '06';
   c_caqtty           CONSTANT CHAR(2) := '13';
   c_qtty             CONSTANT CHAR(2) := '12';
   c_recustodycd      CONSTANT CHAR(2) := '23';
   c_recustname       CONSTANT CHAR(2) := '24';
   c_desc             CONSTANT CHAR(2) := '30';
   c_codeid           CONSTANT CHAR(2) := '01';
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
l_count NUMBER(20);
l_trade NUMBER(20);
l_blocked NUMBER(20);
l_caqtty NUMBER(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_trade:=p_txmsg.txfields('10').value;
    l_blocked:=p_txmsg.txfields('06').value;
    l_caqtty:=p_txmsg.txfields('13').value;
    if(p_txmsg.deltd <> 'Y') THEN
        BEGIN
           SELECT COUNT(*) INTO L_count
           FROM sesendout
           WHERE autoid=p_txmsg.txfields('18').value
           AND ((strade < l_trade) OR(sblocked<l_blocked) OR(scaqtty<l_caqtty))
           AND deltd='N';
        EXCEPTION WHEN OTHERS THEN
                      p_err_code:='-200402';
                      plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
                      RETURN errnums.C_BIZ_RULE_INVALID;
         END;
       IF(l_count >0) THEN
          p_err_code := '-200402'; -- Pre-defined in DEFERROR table
          plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
          RETURN errnums.C_BIZ_RULE_INVALID;
       END IF;
    ELSE -- xoa jao dich
       BEGIN
             SELECT COUNT(*) INTO L_count
             FROM sesendout
             WHERE autoid=p_txmsg.txfields('18').value
             AND ((ctrade < l_trade) OR(cblocked<l_blocked) OR(ccaqtty<l_caqtty))
             AND deltd='N';
         EXCEPTION WHEN OTHERS THEN
                    p_err_code:='-200404';
                    plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
         END;
         IF(l_count >0) THEN
            p_err_code := '-200404'; -- Pre-defined in DEFERROR table
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
         END IF;
    END IF;
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
l_trade NUMBER(20);
l_blocked NUMBER(20);
l_caqtty NUMBER(20);
l_price NUMBER(20);
l_codeid varchar2(20);
l_trans_type_2244 varchar2(20);
l_price_2244 number;
l_amount number;
l_custid varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    l_trade:=p_txmsg.txfields('10').value;
    l_blocked:=p_txmsg.txfields('06').value;
    l_caqtty:=p_txmsg.txfields('13').value;
    select max(price), max(codeid) into l_price, l_codeid from sesendout where autoid= p_txmsg.txfields('18').value;
    if(p_txmsg.deltd <> 'Y') THEN

        UPDATE sesendout
        SET strade=strade-l_trade ,sblocked=sblocked-l_blocked, scaqtty=scaqtty-l_caqtty,
        ctrade=ctrade+l_trade ,cblocked=cblocked+l_blocked, ccaqtty=ccaqtty+l_caqtty,
        status='C'
        WHERE autoid= p_txmsg.txfields('18').value;
                -----    secmast_generate(p_txmsg.txnum, p_txmsg.txdate, p_txmsg.busdate, PV_AFACCTNO=>?, PV_SYMBOL=>?, PV_SECTYPE=>?, PV_PTYPE=>?, PV_CAMASTID=>?, PV_ORDERID=>?, PV_QTTY=>?, PV_COSTPRICE=>?, PV_MAPAVL=>?);
    secmast_generate(p_txmsg.txnum, p_txmsg.txdate, p_txmsg.busdate, p_txmsg.txfields('02').value,
             l_codeid, 'D', 'O', NULL, NULL, l_trade + l_blocked , l_price, 'Y');



        --trung.luu: 10-09-2020
            begin
                select nvl(trim(F.TR_TYPE),''),nvl(F.PRICE,0) into l_trans_type_2244,l_price_2244
                    from SESENDOUT se,
                        (
                            SELECT   txnum,txdate,
                                     MAX (CASE WHEN f.fldcd = '31' THEN f.cvalue ELSE '' END)  tr_type,
                                     MAX (CASE WHEN f.fldcd = '09' THEN f.nvalue ELSE 0 END)  price
                              FROM   vw_tllogfld_all f
                              WHERE   fldcd IN ('31','09','18')
                              GROUP BY   txnum,txdate
                        )f
                    where   se.txnum = f.txnum
                        and se.txdate = f.txdate
                        and se.autoid = p_txmsg.txfields('18').value;
                select custid into l_custid from cfmast where custodycd = p_txmsg.txfields('05').value;
            exception when NO_DATA_FOUND
                then
                l_trans_type_2244 := '';
                l_price_2244:= 0;
                l_custid := '';
            end;
            plog.error('Loai chuyen khoan tai 2244: '||l_trans_type_2244);
            if l_trans_type_2244 = '001' then
                l_amount:= to_number(p_txmsg.txfields('10').value) * l_price_2244;
                INSERT INTO FEETRANREPAIR (TXDATE, TXNUM, ORDERID, EXECTYPE, SYMBOL, CLEARDATE,
                      QTTY, AMOUNT, FEEAMT, REPAIRAMT,
                      CUSTID, AFACCTNO, STATUS, DELTD, MAKERID, CHECKERID, FEETYPES)
                values
                    (to_date(p_txmsg.txdate,'dd/MM/RRRR'),p_txmsg.txnum,'2266','',p_txmsg.txfields('07').value,to_date(p_txmsg.busdate,'dd/MM/RRRR'),
                    to_number(p_txmsg.txfields('10').value),l_amount,0,0,
                    l_custid,p_txmsg.txfields('02').value,'P','N',p_txmsg.tlid,p_txmsg.tlid,''
                    )
                ;
            end if;
    ELSE
        UPDATE sesendout
        SET strade=strade+l_trade ,sblocked=sblocked+l_blocked, scaqtty=scaqtty+l_caqtty,
        ctrade=ctrade-l_trade ,cblocked=cblocked-l_blocked, ccaqtty=ccaqtty-l_caqtty,
        status='S'
        WHERE autoid= p_txmsg.txfields('18').value;

    secnet_un_map(p_txmsg.txnum, p_txmsg.txdate);
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
         plog.init ('TXPKS_#2266EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2266EX;
/
