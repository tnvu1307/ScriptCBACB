SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2240ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2240EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      08/10/2010     Created
 **
 ** (c) 2008 by Financial Software Solutions. JSC.
 ** ----------------------------------------------------------------------------------------------------*/
IS
FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txPreAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER;
END;
 
 
/


CREATE OR REPLACE PACKAGE BODY txpks_#2240ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_license          CONSTANT CHAR(2) := '92';
   c_licensedate      CONSTANT CHAR(2) := '95';
   c_licenseplace     CONSTANT CHAR(2) := '96';
   c_phone            CONSTANT CHAR(2) := '93';
   c_securitiesname   CONSTANT CHAR(2) := '12';
   c_parvalue         CONSTANT CHAR(2) := '11';
   c_price            CONSTANT CHAR(2) := '09';
   c_depotrade        CONSTANT CHAR(2) := '06';
   c_qttytype         CONSTANT CHAR(2) := '08';
   c_depoblock        CONSTANT CHAR(2) := '07';
   c_custnameauth     CONSTANT CHAR(2) := '89';
   c_licenseauth      CONSTANT CHAR(2) := '82';
   c_qtty             CONSTANT CHAR(2) := '10';
   c_cfacctnoauth     CONSTANT CHAR(2) := '05';
   c_licenseauthdate   CONSTANT CHAR(2) := '83';
   c_licenseauthplace   CONSTANT CHAR(2) := '84';
   c_desc             CONSTANT CHAR(2) := '30';
   c_vsdcode         CONSTANT CHAR(2) := '65';
   c_isconfirm             CONSTANT CHAR(2) := '99';

FUNCTION fn_txPreAppCheck(p_txmsg in out tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_leader_license varchar2(100);
    l_leader_idexpired date;
    l_member_license varchar2(100);
    l_member_idexpired date;
    l_idexpdays apprules.field%TYPE;
    l_afmastcheck_arr txpks_check.afmastcheck_arrtype;
    l_leader_expired boolean;
    l_member_expired boolean;
    l_count number;
    l_symbol varchar2(30);
    l_DEPOTRADE number;
    l_DEPOBLOCK number;
    l_vsdmod varchar2(3);
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

   l_leader_expired:= false;
    l_member_expired:= false;
    l_DEPOTRADE := TO_NUMBER(p_txmsg.txfields('06').value);
    l_DEPOBLOCK := TO_NUMBER(p_txmsg.txfields('07').value);
    l_vsdmod :=cspks_system.fn_get_sysvar('SYSTEM', 'VSDMOD');

    --T07/2017 STP
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        --check ma dot phat hanh doi voi ck WFT
        select symbol into l_symbol from sbsecurities where codeid = p_txmsg.txfields('01').value;

        if instr(l_symbol,'_WFT') > 0 and p_txmsg.txfields('77').value is null then
            p_err_code := '-150016';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        --Check khong dc thuc hien 2 loai CK cung luc
        if l_vsdmod ='A' then --mod Auto
            if l_DEPOTRADE > 0 and l_DEPOBLOCK > 0 then
                p_err_code := '-150024';
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
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
V_RDATE DATE ;
l_symbol varchar2(50);
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
    V_RDATE := to_date(p_txmsg.txfields('13').VALUE,'dd/mm/yyyy');

       IF V_RDATE < p_txmsg.busdate THEN
          p_err_code:= -900092;
          RETURN -900092;
       END IF;


       --check ma dot phat hanh doi voi ck WFT
        select symbol into l_symbol from sbsecurities where codeid = p_txmsg.txfields('01').value;

        if instr(l_symbol,'_WFT') > 0 and p_txmsg.txfields('77').value is null then
            p_err_code := '-150016';
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

   plog.debug (pkgctx, '<<END OF fn_txAftAppCheck>>');
   plog.setendsection (pkgctx, 'fn_txAftAppCheck');
   RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM  || dbms_utility.format_error_backtrace);
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
v_strCODEID varchar2(10);
v_strAFACCTNO varchar2(20);
v_strACCTNO varchar2(20);
v_strTYPEDEPOBLOCK varchar2(20);
v_nAMT number;
v_nPRICE number;
v_nDEPOTRADE number;
v_nDEPOBLOCK number;
V_WTRADE number;
v_txnum varchar2(20);
V_txdate date;
V_RDATE DATE ;
v_vsdcode varchar2(200);
v_isconfirm varchar2(10);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

v_strCODEID := p_txmsg.txfields('01').VALUE;
v_strAFACCTNO := p_txmsg.txfields('02').VALUE;
v_strACCTNO := p_txmsg.txfields('03').VALUE;
v_nAMT := p_txmsg.txfields('10').VALUE;
v_nPRICE := p_txmsg.txfields('09').VALUE;
v_nDEPOTRADE := p_txmsg.txfields('06').VALUE;
v_nDEPOBLOCK := p_txmsg.txfields('07').VALUE;
V_WTRADE := p_txmsg.txfields('14').VALUE;
v_strTYPEDEPOBLOCK := p_txmsg.txfields('08').VALUE;
v_txnum:= p_txmsg.txnum;
V_txdate:= p_txmsg.txdate;
V_RDATE := to_date(p_txmsg.txfields('13').VALUE,'dd/mm/yyyy');
v_vsdcode:= p_txmsg.txfields('65').VALUE;
v_isconfirm:= p_txmsg.txfields('99').VALUE;


INSERT INTO SEDEPOSIT (AUTOID,ACCTNO,TXNUM,TXDATE,DEPOSITPRICE,DEPOSITQTTY,STATUS,DELTD,DESCRIPTION,DEPOTRADE,DEPOBLOCK,TYPEDEPOBLOCK,RDATE,WTRADE,DEPODATE,VSDCODE,ISCONFIRM)
VALUES(SEQ_SEDEPOSIT.NEXTVAL,v_strACCTNO,v_txnum,V_txdate,v_nPRICE,v_nAMT,'D','N',p_txmsg.txfields('77').VALUE,v_nDEPOTRADE,v_nDEPOBLOCK,v_strTYPEDEPOBLOCK,V_RDATE,V_WTRADE,p_txmsg.busdate,v_vsdcode,v_isconfirm);

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
         plog.init ('TXPKS_#2240EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2240EX;
/
