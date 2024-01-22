SET DEFINE OFF;
CREATE OR REPLACE PACKAGE TXPKS_#6695EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6695EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      07/11/2019     Created
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


CREATE OR REPLACE PACKAGE BODY TXPKS_#6695EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_type             CONSTANT CHAR(2) := '22';
   c_desc             CONSTANT CHAR(2) := '30';
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


v_money number;
V_TRFCODE_UNHOLD VARCHAR2(100);
V_TRFCODE_HOLD varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    SELECT trfcode INTO V_TRFCODE_UNHOLD FROM CRBTRFCODE WHERE OBJNAME = '6695' AND TRFCODE = 'UNHOLDOD';
    SELECT trfcode INTO V_TRFCODE_HOLD FROM CRBTRFCODE WHERE OBJNAME = '6695' AND TRFCODE = 'HOLDOD';

    --lenh mua di unhold
    IF p_txmsg.txfields('22').value = '1' then


         --lay nhung thang hold trong ngay ma chua unhold
         for t in (
                         select crb.reqtxnum,crb.txamt,crb.afacctno
                         from crbtxreq crb
                         where   crb.unhold = 'N'
                             and crb.objname = '6690'
                             and crb.txdate = getcurrdate
                             and crb.reqcode = 'BANKHOLDEDBYBROKER'

                        /*select crb.objkey reqtxnum,crb.txamt,crb.afacctno
                         from crbtxreq crb,tllog l
                         where   crb.unhold = 'N'
                             and crb.objname ='6690'
                             and crb.txdate = getcurrdate

                             and l.tltxcd = '6690'
                             and l.txnum = crb.objkey*/
                             --and crb.reqcode = 'BANKHOLDEDBYBROKER'
                     )
         loop
               
             pck_bankapi.Bank_UNholdbalance(
                                       t.reqtxnum,  ---txnum cua giao dich hold
                                       t.afacctno,  --- tk ddma st
                                       t.txamt,  -- so tien
                                       V_TRFCODE_UNHOLD, --request code cua nghiep vu trong allcode
                                       to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,  --requestkey duy nhat de truy lai giao dich goc
                                       p_txmsg.txfields('30').value,  -- dien giai
                                       systemnums.C_SYSTEM_USERID, -- nguoi tao giao dich
                                       P_ERR_CODE);

             /*if P_ERR_CODE <> systemnums.C_SUCCESS then
                 
                 plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                 RETURN errnums.C_BIZ_RULE_INVALID;
             end if;*/
         end loop;
     /*ELSE
         p_err_code := '-701420';
         plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
         RETURN errnums.C_BIZ_RULE_INVALID;*/
     END IF;

    IF p_txmsg.txfields('22').value = '0' then

        for r in (
                       Select od.orderid,sb.codeid , sb.symbol, cf.custid,af.acctno, dd.acctno ddacctno , af.acctno ||sb.codeid seacctno , cf.custodycd,
                                    od.exectype EXECTYPE,
                                    od.txdate,od.CLEARDATE settle_date,
                                    od.netamount price, od.execqtty quantity,NVL(od.feeamt,0) FEE,NVL(od.taxamt,0) TAX,fa.autoid
                        from tllog tl, odmast od,ddmast dd,afmast af,cfmast cf,sbsecurities sb,famembers fa,VW_CUSTODYCD_MEMBER mm
                            where   tl.txnum = od.txnum
                                and od.ORSTATUS = 'P'
                                and tl.tltxcd = '8893'
                                and dd.status <> 'C' and dd.CCYCD = 'VND' AND DD.ISDEFAULT = 'Y'
                                and od.custodycd = cf.custodycd
                                and cf.custodycd = dd.custodycd
                                and cf.custodycd = od.custodycd
                                and af.custid = cf.custid
                                and od.codeid = sb.codeid
                                and fa.autoid = od.member
                                and mm.value = fa.autoid
                                and mm.filtercd = od.custodycd
                                and od.exectype = 'NB'
                                and od.ishold = 'N'
                     )
        Loop
            
             If v_money > 0 THEN
                 p_err_code := '-701413';
                 plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                 RETURN errnums.C_BIZ_RULE_INVALID;
             else
                    --r.orderid join voi odmast.orderid de biet lenh nao hold


                  pck_bankapi.bank_holdbalance(r.ddacctno,'','','',NVL((r.price ),0),V_TRFCODE_HOLD,r.orderid,p_txmsg.txfields('30').value,p_txmsg.tlid,p_err_code);
                  if P_ERR_CODE = systemnums.C_SUCCESS then
                      UPDATE ODMAST
                         SET ISHOLD = 'Y',
                             ORSTATUS = '7'
                             WHERE ORDERID = r.orderid;
                  end if;
             end if;
        end loop;
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
         plog.init ('TXPKS_#6695EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6695EX;
/
