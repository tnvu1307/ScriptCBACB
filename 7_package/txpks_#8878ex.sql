SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8878ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8878EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      03/01/2012     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8878ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_codeid           CONSTANT CHAR(2) := '01';
   c_afacctno         CONSTANT CHAR(2) := '02';
   c_seacctno         CONSTANT CHAR(2) := '03';
   c_custname         CONSTANT CHAR(2) := '90';
   c_address          CONSTANT CHAR(2) := '91';
   c_refafacctno      CONSTANT CHAR(2) := '08';
   c_license          CONSTANT CHAR(2) := '92';
   c_exseacctno       CONSTANT CHAR(2) := '09';
   c_quoteprice       CONSTANT CHAR(2) := '11';
   c_orderqtty        CONSTANT CHAR(2) := '10';
   c_parvalue         CONSTANT CHAR(2) := '12';
   c_tradelot         CONSTANT CHAR(2) := '13';
   c_feeamt           CONSTANT CHAR(2) := '22';
   c_desc             CONSTANT CHAR(2) := '30';
   c_taxamt           CONSTANT CHAR(2) := '15';
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
    l_idcode_exp DATE ;
    l_count number;
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

    -- chek chung khoan phai chuyen ve 1 tieu khoan truoc khi ban lo le
  IF p_txmsg.txfields('93').value<>p_txmsg.txfields('94').value THEN

      p_err_code := '-201184'; -- Pre-defined in DEFERROR table
      plog.setendsection (pkgctx, 'fn_txPreAppCheck');
      RETURN errnums.C_BIZ_RULE_INVALID;
  end if;

    l_leader_expired:= false;
    l_member_expired:= false;

    SELECT to_date ( to_char(iddate,'dd/mm')||to_char(to_char(iddate,'YYYY')+15),'dd/mm/yyyy') into l_idcode_exp
    FROM cfmast WHERE custodycd = p_txmsg.txfields('88').value;

    /*IF l_idcode_exp < p_txmsg.txdate THEN
         l_leader_expired:=true;
    END IF;


    select idcode, idexpired into l_leader_license, l_leader_idexpired
    from cfmast cf, afmast af
    where cf.custid = af.custid
    and af.acctno = p_txmsg.txfields(c_afacctno).value;

    select idcode, idexpired into l_member_license, l_member_idexpired
    from cfmast where idcode = p_txmsg.txfields(c_license).value and status <> 'C';

    IF l_leader_idexpired < p_txmsg.txdate THEN --leader expired
        l_leader_expired:=true;
    END IF;

    if l_leader_license <> l_member_license or l_leader_idexpired <> l_member_idexpired then
        if l_member_idexpired < p_txmsg.txdate then
            l_member_expired:=true;
        end if;
    end if;


    if l_leader_expired = true and l_member_expired = true then
        p_txmsg.txWarningException('-2002091').value:= cspks_system.fn_get_errmsg('-200209');
        p_txmsg.txWarningException('-2002091').errlev:= '1';
    else
        if l_leader_expired = true and l_member_expired = false then
            p_txmsg.txWarningException('-2002081').value:= cspks_system.fn_get_errmsg('-200208');
            p_txmsg.txWarningException('-2002081').errlev:= '1';
        elsif l_leader_expired = false and l_member_expired = true then
            p_txmsg.txWarningException('-2002071').value:= cspks_system.fn_get_errmsg('-200207');
            p_txmsg.txWarningException('-2002071').errlev:= '1';
        end if;
    end if;*/

    SELECT count(1)
        into l_count
    FROM afmast af, cfmast cf
    WHERE af.custid = cf.custid and af.acctno = p_txmsg.txfields(c_refafacctno).value
    AND substr(cf.custodycd,1,4) = (select to_char(varvalue) from sysvar where grname ='SYSTEM' and varname ='DEALINGCUSTODYCD');
    if l_count <= 0 then
        p_err_code := '-200084'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    end if;

    SELECT count(1) INTO l_count FROM semast mst, securities_info inf
        WHERE mst.codeid = inf.codeid
              AND acctno = p_txmsg.txfields('03').value
              AND MOD(mst.trade, inf.tradelot) >= p_txmsg.txfields('10').value;
    IF l_count <= 0 THEN
        -- Giao dich khong duoc phep thuc hien do so ck ban khong phai la so le lo cua tk
        p_err_code := '-201185'; -- Pre-defined in DEFERROR table
        plog.setendsection (pkgctx, 'fn_txPreAppCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
    END IF;

    plog.debug (pkgctx, '<<END OF fn_txPreAppCheck');
    plog.setendsection (pkgctx, 'fn_txPreAppCheck');
    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
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
      plog.error (pkgctx, SQLERRM);
       plog.setendsection (pkgctx, 'fn_txPreAppUpdate');
      RAISE errnums.E_SYSTEM_ERROR;
END fn_txPreAppUpdate;

FUNCTION fn_txAftAppUpdate(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
   v_blnREVERSAL boolean;
   l_lngErrCode    number(20,0);
   v_strOBJTYPE    varchar2(100);
   v_strTRFCODE    varchar2(100);
   v_strBANK    varchar2(200);
   v_strAMTEXP    varchar2(200);
   v_strAFACCTNO    varchar2(100);
   v_strVERSION varchar2(100);
   v_strTXDATE varchar2(100);
   v_strREFCODE    varchar2(100);
   v_strBANKACCT    varchar2(100);
   v_strFLDAFFECTDATE    varchar2(100);
   v_strAFFECTDATE    varchar2(100);
   v_strNOTES    varchar2(1000);
   v_strFLOGSTATUS varchar2(100);
   v_strVALUE     varchar2(1000);
   v_strFLDNAME     varchar2(100);
   v_strFLDTYPE     varchar2(100);
   v_strREFAUTOID     number;
   v_strCOUNT number;
   v_strREQID varchar2(100);
   v_strSQL     varchar2(4000);
   v_strStatus char(1);
   v_strREFID number;
   v_strCCOUNT number;
   v_strCOREBANK    char(1);
   v_strAUTOID number;
   v_strafbankname varchar(100);
   v_strafbankacctno    varchar2(100);
   v_refdorc char(1);
   v_refunhold char(1);
   v_strREFAUTOID_DT number;
   v_lngREQID number;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd <> 'Y' then
        INSERT INTO SERETAIL (TXDATE,TXNUM,BUSDATE,ACCTNO,PRICE,QTTY,desacctno,feeamt,TAXAMT, PITQTTY)
        VALUES (p_txmsg.txdate,p_txmsg.txnum,p_txmsg.busdate,p_txmsg.txfields(c_seacctno).value,to_number(p_txmsg.txfields(c_quoteprice).value),
            to_number(p_txmsg.txfields(c_orderqtty).value),p_txmsg.txfields(c_exseacctno).value,to_number(p_txmsg.txfields(c_feeamt).value),
            to_number(p_txmsg.txfields(c_taxamt).value),
            to_number(p_txmsg.txfields('18').value)
            );
    else
        DELETE SERETAIL WHERE TXDATE = p_txmsg.txdate AND TXNUM = p_txmsg.txnum and ACCTNO = p_txmsg.txfields(c_seacctno).value;
    end if;

    plog.debug (pkgctx, '<<END OF fn_txAftAppUpdate');
    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');


    RETURN systemnums.C_SUCCESS;
EXCEPTION
WHEN OTHERS
   THEN
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
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
         plog.init ('TXPKS_#8878EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8878EX;
/
