SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#2211EX
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#2211EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      24/10/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#2211EX
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_otcodid          CONSTANT CHAR(2) := '01';
   c_scustodycd       CONSTANT CHAR(2) := '88';
   c_sfullname        CONSTANT CHAR(2) := '90';
   c_sbankaccount     CONSTANT CHAR(2) := '15';
   c_sbankid          CONSTANT CHAR(2) := '16';
   c_bcustodycd       CONSTANT CHAR(2) := '78';
   c_bfullname        CONSTANT CHAR(2) := '79';
   c_bddacctno        CONSTANT CHAR(2) := '03';
   c_codeid           CONSTANT CHAR(2) := '02';
   c_maxamt           CONSTANT CHAR(2) := '08';
   c_amt              CONSTANT CHAR(2) := '10';
   c_desc             CONSTANT CHAR(2) := '30';
FUNCTION fn_txPreAppCheck(p_txmsg in tx.msg_rectype,p_err_code out varchar2)
RETURN NUMBER
IS
    l_count number;
    l_bddacctno varchar2(50);
    l_ddmastcheck_arr txpks_check.ddmastcheck_arrtype;
    l_balance apprules.field%TYPE;
    l_STATUS apprules.field%TYPE;

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
        from OTCODMAST es
        where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('01').value))
            and DELTD <> 'Y';
        if l_count = 0 then
            p_err_code := '-180023';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        --Khong tim thay so hop dong
        select count(*) into l_count
        from OTCODMAST es
            LEFT JOIN (select rq.reqid,rq.reqcode, rq.reqtxnum,  rq.status status
                    from vw_crbtxreq_all rq
                    where reqcode in ('PAYMENT2211') and rq.status = 'R'
                  ) rq on es.trfreqid = rq.reqtxnum
        where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('01').value))
            and ( es.ddstatus in ('P') or (es.ddstatus='C' and nvl(rq.status,'C')='R') )
            and DELTD <> 'Y';
        if l_count = 0 then
            p_err_code := '-180022';
            
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        l_bddacctno :=  trim(upper(p_txmsg.txfields('03').value));
        l_DDMASTcheck_arr := txpks_check.fn_DDMASTcheck(l_bddacctno,'DDMAST','ACCTNO');
        l_BALANCE := l_DDMASTcheck_arr(0).BALANCE;
        l_STATUS := l_DDMASTcheck_arr(0).STATUS;

        IF NOT (to_number(l_BALANCE) >= to_number(p_txmsg.txfields('10').value)) THEN
            p_err_code := '-400101';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
        END IF;

        IF NOT ( INSTR('A',l_STATUS) > 0) THEN
            p_err_code := '-400100';
            plog.setendsection (pkgctx, 'fn_txPreAppCheck');
            RETURN errnums.C_BIZ_RULE_INVALID;
         END IF;

    ELSE -- Revert GD
        --Khong tim thay so hop dong
        select count(*) into l_count
        from OTCODMAST es
        where upper(es.OTCODID) = upper(trim(p_txmsg.txfields('01').value))
            and es.ddstatus = 'C'
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
l_checkInternal number;
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
    l_checkInternal := 0;
    begin
        select count(*) into l_checkInternal from ddmast where custodycd = p_txmsg.txfields('88').value and REFCASAACCT = p_txmsg.txfields('15').value and status <> 'C';
    EXCEPTION WHEN OTHERS THEN
        l_checkInternal := 0;
    END;

    if l_checkInternal = 0 then
        if p_txmsg.txstatus = 0  and p_txmsg.deltd <> 'Y' then --cho duyet
           pck_bankapi.Checkblacklist( p_txmsg.txfields('90').value,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tlid,'',p_err_code);
        end if;
    end if;
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
    l_bddacctno varchar2(50);
    l_checkInternal number;
    l_sddacctno varchar2(50);
    v_custodycd varchar2(20);
    v_sb        varchar2(1);
    v_fundcode  varchar2(50);
    l_txtype    varchar2(50);
    l_citad     varchar2(50);
    l_bankacc   varchar2(50);
    l_custname  varchar2(50);
    l_bankname  varchar2(50);
    l_bankbranch varchar2(50);
    l_txamt     NUMBER;
    v_globalid  varchar2(50);
    v_refbankacct varchar2(100);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
     v_custodycd := p_txmsg.txfields(c_bcustodycd).value;
     l_bddacctno :=  trim(upper(p_txmsg.txfields('03').value));
     l_txtype := 'OTCPAY';
     l_citad  := trim(upper(p_txmsg.txfields('16').value));
     l_bankacc := p_txmsg.txfields('15').value;
     l_custname := p_txmsg.txfields('79').value;
     l_txamt := TO_NUMBER(p_txmsg.txfields('10').value);

     select bankname, branchname into l_bankname, l_bankbranch
     from CRBBANKLIST where citad = l_citad;

     select NVL(SUPEBANK,'N'), NVL(FUNDCODE,'') into v_sb, v_fundcode from CFMAST where CUSTODYCD = v_custodycd;

     select d.refcasaacct into v_refbankacct from ddmast d where d.acctno = l_bddacctno;

     v_globalid := fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum); --'CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum;

     INSERT INTO CBFA_BANKPAYMENT(AUTOID,GLOBALID,CUSTODYCD,ACCTNO,TXTYPE,TRANSTYPE,TXNUM,TXDATE,
                                 CITAD,BANKNAME,BANKBRACH,BENEFICIARYACCOUNT,CUSTNAME,CREATETIME,TXAMT,
                                 REFCONTRACT,FEETYPE,SUPERBANK,ISAPPRSB,BANKSTATUS,SYNSTATUS,VALUEDATE,
                                  REFBANKACCT,TLTXCD)
     SELECT SEQ_CBFABANKPAYMENT.NEXTVAL,v_globalid,v_custodycd,l_bddacctno,l_txtype,null,p_txmsg.txnum,
           p_txmsg.txdate,l_citad,l_bankname,l_bankbranch,l_bankacc,l_custname, systimestamp,l_txamt,
           p_txmsg.txfields('01').value,p_txmsg.txfields('18').value,v_sb,CASE WHEN v_sb = 'N' THEN 'Y' ELSE 'N' END,
           'P','P',null,v_refbankacct,p_txmsg.tltxcd
     FROM DUAL;

    IF p_txmsg.deltd <> 'Y' THEN
      IF v_sb = 'Y' OR (v_fundcode is not null and length(trim(v_fundcode)) >0) then--gui events sang SB
      insert into log_notify_cbfa(GLOBALID,autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd,logtime,busdate)
       values
            ('CB.'||TO_CHAR(p_txmsg.txdate,'YYYYMMDD')||'.'||p_txmsg.txnum,seq_log_notify_cbfa.nextval,'CBFABANKPAYMENT','GLOBALID',v_globalid,p_txmsg.txfields(c_desc).value,p_txmsg.txnum,p_txmsg.txdate,p_txmsg.tltxcd,sysdate,p_txmsg.busdate);
      ELSE --Goi truc tiep bankapi
        begin
            select count(*), max(acctno) into l_checkInternal, l_sddacctno from ddmast where custodycd = p_txmsg.txfields('88').value and REFCASAACCT = p_txmsg.txfields('15').value and status <> 'C';
        EXCEPTION WHEN OTHERS THEN
            l_checkInternal := 0;
            l_sddacctno:='';
        END;

        BEGIN
            SELECT RQ.TXAMT INTO l_moveamt
            FROM VW_CRBTXREQ_ALL RQ, ESCROW SC
            WHERE RQ.REQTXNUM = SC.HOLDREQID
                AND RQ.REQCODE = 'PAYMENT2211' AND RQ.STATUS = 'R'
                AND SC.ESCROWID = P_TXMSG.TXFIELDS('01').VALUE
                ;
            EXCEPTION WHEN OTHERS THEN
            l_moveamt := 0;
        END;
        if l_checkInternal > 0 then
            BEGIN
                PCK_BANKAPI.Bank_Internal_Tranfer(
                                              l_bddacctno,  --- tk ddmast tk chuyen
                                              p_txmsg.txfields('90').value, ---ten tk nhan
                                              l_sddacctno, --- so tk nhan
                                              TO_NUMBER(p_txmsg.txfields('10').value),  --- so tien
                                              l_txtype, --request code cua nghiep vu trong allcode
                                              v_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                              p_txmsg.txfields('30').value,  -- dien giai
                                              p_txmsg.tlid, -- nguoi tao giao dich
                                              P_ERR_CODE);

                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'I'
                    WHERE GLOBALID = v_globalid;
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                else
                    UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'I'
                    WHERE GLOBALID = v_globalid;
                end if;
                EXCEPTION WHEN OTHERS THEN
                    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
            END;
        else
            BEGIN
                PCK_BANKAPI.BANK_TRANFER_OUT(
                                              l_bddacctno,  --- tk ddmast tk chuyen
                                              p_txmsg.txfields('90').value, ---ten tk nhan
                                              trim(upper(p_txmsg.txfields('15').value)), --- so tk nhan
                                              trim(upper(p_txmsg.txfields('16').value)), --- so citad ngan hang nhan
                                              TO_NUMBER(p_txmsg.txfields('10').value),  --- so tien
                                              l_txtype, --request code cua nghiep vu trong allcode
                                              v_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                              p_txmsg.txfields('30').value,  -- dien giai
                                              p_txmsg.tlid, -- nguoi tao giao dich
                                              P_ERR_CODE);

                if P_ERR_CODE <> systemnums.C_SUCCESS then
                    UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'I'
                    WHERE GLOBALID = v_globalid;
                    
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
                else
                  UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'D'
                  WHERE GLOBALID = v_globalid;
                end if;
                EXCEPTION WHEN OTHERS THEN
                    plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                    plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
                    RETURN errnums.C_BIZ_RULE_INVALID;
            END;
        end if;
        update OTCODMAST
        set trfreqid = to_char(p_txmsg.txdate,'DD/MM/RRRR')||p_txmsg.txnum,
            ddstatus = 'C',
            last_change = CURRENT_TIMESTAMP
        where OTCODID = p_txmsg.txfields('01').value and deltd = 'N';
    END IF;
    ELSE --Revert trans
        UPDATE TLLOG
        SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);



        update OTCODMAST
        set trfreqid = '',
            ddstatus = 'P',
            last_change = CURRENT_TIMESTAMP
        where OTCODID = p_txmsg.txfields('01').value  and deltd = 'N';


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
         plog.init ('TXPKS_#2211EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#2211EX;
/
