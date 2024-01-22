SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1108ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1108EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      04/08/2020     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1108ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_escrowid         CONSTANT CHAR(2) := '01';
   c_acctno_iica      CONSTANT CHAR(2) := '07';
   c_maxamt           CONSTANT CHAR(2) := '08';
   c_amt              CONSTANT CHAR(2) := '10';
   c_desc             CONSTANT CHAR(2) := '30';
   c_bcustodycd       CONSTANT CHAR(2) := '78';
   c_bfullname        CONSTANT CHAR(2) := '79';


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
    l_blocktype varchar2(20);
    l_moveamt   number;
    l_reqid     varchar2(200);
    l_hold number;
    l_amt number;
    v_scustid varchar2(250);
    v_scustodycd varchar2(250);
    v_bcustid varchar2(250);
    v_symbol varchar2(250);
    v_codeid varchar2(250);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN

        l_reqid := fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum);
        v_scustid := '';
        v_scustodycd := '';
        v_codeid := '';
        v_symbol := '';
        begin
            select custid into v_bcustid from cfmast where custodycd = p_txmsg.txfields('78').value;
        exception when NO_DATA_FOUND
            then
            p_err_code := '-200413';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end;
        BEGIN
            PCK_BANKAPI.BANK_HOLDBALANCE(p_txmsg.txfields('07').value, -- tk ddmast
                                          '', -- ctck dat lenh
                                          '', -- moi gioi dat lenh
                                          '', --- so dien thoai moi gioi dat lenh
                                          TO_NUMBER(p_txmsg.txfields('10').value),  --- so tien
                                          'HOLD1108', --- code nghiep vu cua giao dich , select tu alcode
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
        /*update ESCROW
        set bafacctno = p_txmsg.txfields('07').value,
            hold_temp = hold_temp + TO_NUMBER(p_txmsg.txfields('10').value),
            last_change = CURRENT_TIMESTAMP
        where ESCROWID = p_txmsg.txfields('01').value and deltd = 'N';*/

        --ESCROW_HOLD_TEMP.hold_type = 'DD': tien
        insert into ESCROW_HOLD_TEMP ( autoid, escrowid, hold_type, scustid, scustodycd,
                                       sseacctno, sbankaccount, bcustid, bcustodycd,
                                       bddacctno, codeid, symbol, hold_se, hold_dd, unhold,
                                       holdreqid, unholdreqid,deltd)
                            values  (SEQ_ESCROW_HOLD_TEMP.nextval,p_txmsg.txfields('01').value,'DD',v_scustid,v_scustodycd,
                                       '','',v_bcustid,p_txmsg.txfields('78').value,
                                       p_txmsg.txfields('07').value, v_codeid,v_symbol,0,TO_NUMBER(p_txmsg.txfields('10').value),'N',
                                       l_reqid,'','N')
        ;

        /*if l_hold = l_amt then
            update ESCROW
        set
            pstatus = pstatus||'|'||status, status = decode(status,'A','BC','B'),
            ddstatus = 'B',
            last_change = CURRENT_TIMESTAMP
        where ESCROWID = p_txmsg.txfields('01').value and deltd = 'N';
        end if;*/
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
         plog.init ('TXPKS_#1108EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1108EX;
/
