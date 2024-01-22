SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1102ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1102EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      17/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1102ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_escrowid         CONSTANT CHAR(2) := '01';
   c_signdate         CONSTANT CHAR(2) := '67';
   c_scustodycd       CONSTANT CHAR(2) := '88';
   c_sfullname        CONSTANT CHAR(2) := '90';
   c_bcustodycd       CONSTANT CHAR(2) := '78';
   c_bfullname        CONSTANT CHAR(2) := '79';
   c_bddacctno_escrow   CONSTANT CHAR(2) := '03';
   c_codeid           CONSTANT CHAR(2) := '02';
   c_maxamt           CONSTANT CHAR(2) := '08';
   c_amt              CONSTANT CHAR(2) := '10';
   c_srcacctno        CONSTANT CHAR(2) := '22';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
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

    IF p_txmsg.deltd <> 'Y' THEN
        --Khong tim thay so hop dong
        select count(*) into l_count
        from ESCROW es
        where upper(es.ESCROWID) = upper(trim(p_txmsg.txfields('01').value))
            and DELTD <> 'Y';
        if l_count = 0 then
            p_err_code := '-180023';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        --Khong tim thay so hop dong
        select count(*) into l_count
        from ESCROW es
            LEFT JOIN (select rq.reqid,rq.reqcode, rq.reqtxnum,  rq.status status
                    from vw_crbtxreq_all rq
                    where reqcode in ('HOLD1102') and rq.status = 'R'
                  ) rq on es.holdreqid = rq.reqtxnum
        where upper(es.ESCROWID) = upper(trim(p_txmsg.txfields('01').value))
            and ( es.ddstatus in ('P','A') or (es.ddstatus='B' and nvl(rq.status,'C')='R') )
            and DELTD <> 'Y';
        if l_count = 0 then
            p_err_code := '-180022';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

    ELSE -- Revert GD
        --Khong tim thay so hop dong
        select count(*) into l_count
        from ESCROW es
            LEFT JOIN (select rq.reqid,rq.reqcode, rq.reqtxnum,  rq.status status
                    from vw_crbtxreq_all rq
                    where reqcode in ('HOLD1102')
                  ) rq on es.holdreqid = rq.reqtxnum
        where upper(es.ESCROWID) = upper(trim(p_txmsg.txfields('01').value))
            and es.ddstatus = 'B'
            and es.DELTD <> 'Y';
        if l_count = 0 then
            p_err_code := '-180022';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
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
    l_blocktype varchar2(20);
    l_bafacctno varchar2(20);
    l_moveamt   number;
    l_reqid     varchar2(200);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        select afacctno into l_bafacctno from ddmast where acctno = p_txmsg.txfields('03').value;
        BEGIN
            SELECT RQ.TXAMT INTO l_moveamt
            FROM VW_CRBTXREQ_ALL RQ, ESCROW SC
            WHERE RQ.REQTXNUM = SC.HOLDREQID
                AND RQ.REQCODE = 'HOLD1102' AND RQ.STATUS = 'R'
                AND SC.ESCROWID = P_TXMSG.TXFIELDS('01').VALUE
                ;
            EXCEPTION WHEN OTHERS THEN
            l_moveamt := 0;
        END;
        l_reqid := fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum);
        BEGIN
            PCK_BANKAPI.BANK_HOLDBALANCE(p_txmsg.txfields('03').value, -- tk ddmast
                                          '', -- ctck dat lenh
                                          '', -- moi gioi dat lenh
                                          '', --- so dien thoai moi gioi dat lenh
                                          TO_NUMBER(p_txmsg.txfields('10').value),  --- so tien
                                          'HOLD1102', --- code nghiep vu cua giao dich , select tu alcode
                                          l_reqid, --request key --> key duy nhat de truy vet giao dich goc
                                          p_txmsg.txfields('30').value, -- dien giai
                                          systemnums.C_SYSTEM_USERID, -- nguoi lap giao dich
                                          P_ERR_CODE);
            if P_ERR_CODE <> systemnums.C_SUCCESS then
                
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
            end if;
            EXCEPTION WHEN OTHERS THEN
                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                RETURN errnums.C_BIZ_RULE_INVALID;
        END;
        update ESCROW
        set bafacctno = l_bafacctno,
            blockedamt = blockedamt - NVL(l_moveamt,0) + TO_NUMBER(p_txmsg.txfields('10').value),
            holdreqid = l_reqid,
            pstatus = pstatus||'|'||status, status = decode(status,'A','BC','B'),
            ddstatus = 'B',
            last_change = CURRENT_TIMESTAMP
        where ESCROWID = p_txmsg.txfields('01').value and deltd = 'N';

    ELSE --Revert trans
        UPDATE TLLOG
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);



        update ESCROW
        set blockedamt = blockedamt - TO_NUMBER(p_txmsg.txfields('10').value),
            pstatus = pstatus||'|'||status, status = decode(status,'BC','A','BS'), ddstatus = 'P',
            last_change = CURRENT_TIMESTAMP
        where ESCROWID = p_txmsg.txfields('01').value  and deltd = 'N';


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
         plog.init ('TXPKS_#1102EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1102EX;
/
