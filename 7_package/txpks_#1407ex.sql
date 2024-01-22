SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#1407ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#1407EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      26/12/2019     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#1407ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_no               CONSTANT CHAR(2) := '25';
   c_name             CONSTANT CHAR(2) := '24';
   c_creatdate        CONSTANT CHAR(2) := '14';
   c_effdate          CONSTANT CHAR(2) := '18';
   c_custodycd        CONSTANT CHAR(2) := '88';
   c_custid           CONSTANT CHAR(2) := '17';
   c_acctno           CONSTANT CHAR(2) := '03';
   c_symbol           CONSTANT CHAR(2) := '29';
   c_codeid           CONSTANT CHAR(2) := '15';
   c_issuerid         CONSTANT CHAR(2) := '23';
   c_issuedate        CONSTANT CHAR(2) := '22';
   c_expdate          CONSTANT CHAR(2) := '19';
   c_intcoupon        CONSTANT CHAR(2) := '20';
   c_interestdate     CONSTANT CHAR(2) := '21';
   c_parvalue         CONSTANT CHAR(2) := '26';
   c_qtty             CONSTANT CHAR(2) := '27';
   c_clvalue          CONSTANT CHAR(2) := '10';
   c_citad            CONSTANT CHAR(2) := '13';
   c_bankcode         CONSTANT CHAR(2) := '12';
   c_bankacctno       CONSTANT CHAR(2) := '11';
   c_bname            CONSTANT CHAR(2) := '32';
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
    l_semastcheck_arr txpks_check.semastcheck_arrtype;
    l_STATUS    varchar2(1000);
    l_seacctno  varchar2(1000);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txPreAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txPreAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC PROCESS HERE. . DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/

    l_seacctno := p_txmsg.txfields('03').value || p_txmsg.txfields('15').value;

    l_SEMASTcheck_arr := txpks_check.fn_SEMASTcheck(l_seacctno,'SEMAST','ACCTNO');

    l_STATUS := l_SEMASTcheck_arr(0).STATUS;

    IF NOT ( INSTR('A',l_STATUS) > 0) THEN
        p_err_code := '-900019';
        plog.setendsection (pkgctx, 'fn_txAppAutoCheck');
        RETURN errnums.C_BIZ_RULE_INVALID;
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
v_crphysagreeid varchar2(4);
v_result varchar2(4);
v_seacctno varchar2(30);
v_count number;
V_TAXABLEPARTY varchar2(250);
V_DEDUCTIONPLACE varchar2(250);
v_PAYSTATUS varchar2(250);
v_qt_1405 number;
v_qt_1404 number;
v_qt_1414 number;
v_qt_1406 number;
v_qt_1400 number;
v_qt_RUT number;
v_trade number;
v_custodycd varchar2(250);
v_custid varchar2(20);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    BEGIN
        SELECT CF.CUSTID
        INTO V_CUSTID
        FROM CFMAST CF
        WHERE CF.CUSTODYCD = p_txmsg.txfields(c_custodycd).value;
    END;
    v_seacctno := p_txmsg.txfields(c_acctno).value ||p_txmsg.txfields(c_codeid).value;

    IF p_txmsg.deltd <> 'Y' then
        SELECT NVL(MAX(ODR)+1,1) AUTOINV into v_result FROM
                  (SELECT ROWNUM ODR, INVACCT
                  FROM (SELECT * FROM (
                        SELECT CRPHYSAGREEID INVACCT FROM CRPHYSAGREE
                        ) ORDER BY INVACCT) DAT
                  WHERE TO_NUMBER(INVACCT)=ROWNUM) INVTAB;
        v_crphysagreeid := LPAD( v_result, 4, 0 );

        insert into crphysagree (CRPHYSAGREEID, NO, NAME, CODEID, QTTY,
                                 STATUS, CREATDATE, EFFDATE, CUSTODYCD, ACCTNO,
                                 CLVALUE, BANKACCTNO, BANKCODE, DESCRIPTION, PSTATUS,
                                 REQTTY, SYMBOL, PAYSTATUS, BALANCESTATUS, REPOSSTATUS,
                                 CITAD, ISSUERID,TXDATE,TXNUM,ORIGIONAL_NO,ROLLID,BNAME)
             values (v_crphysagreeid, p_txmsg.txfields(c_no).value, p_txmsg.txfields(c_name).value, p_txmsg.txfields(c_codeid).value, p_txmsg.txfields(c_qtty).value,
                    'A', to_date(p_txmsg.txfields(c_creatdate).value, systemnums.C_DATE_FORMAT), to_date(p_txmsg.txfields(c_effdate).value, systemnums.C_DATE_FORMAT), p_txmsg.txfields(c_custodycd).value, p_txmsg.txfields(c_acctno).value,
                    p_txmsg.txfields(c_clvalue).value, p_txmsg.txfields(c_bankacctno).value, p_txmsg.txfields(c_bankcode).value, p_txmsg.txdesc, null,
                    0, p_txmsg.txfields(c_symbol).value, NVL(p_txmsg.txfields('99').value, 'P'), 'P', 'P',
                    p_txmsg.txfields(c_citad).value, p_txmsg.txfields(c_issuerid).value, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), p_txmsg.txnum,p_txmsg.txfields('28').value, p_txmsg.txfields('31').value, p_txmsg.txfields('32').value);

        --trung.luu: 02-07-2020 log lai de len view physical
        --bao.nguyen: 25-07-2022 SHBVNEX-2730
       insert into CRPHYSAGREE_LOG_ALL (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC,CITAD,TLTXCD,FEETYPE,SYMBOL,CUSTODYCD,
                Beneficiary_Name,Beneficiary_account,VAT,TAXABLEPARTY -- ben chiu thue
                ,DEDUCTIONPLACE-- noi khau tru thue
                ,ROLLOVER_NO -- so hop dong tai phu luc
                ,ORIGIONAL_NO -- so hop dong me
                ,typedoc, custid
        )
       values (p_txmsg.txdate, p_txmsg.txnum,'BP',null,v_crphysagreeid, P_TXMSG.TXFIELDS('10').VALUE, P_TXMSG.TXFIELDS('10').VALUE, p_txmsg.txfields('27').value, p_txmsg.txfields('27').value, 'A', 'N',p_txmsg.txfields('30').value,p_txmsg.txfields('13').value,p_txmsg.tltxcd,null,p_txmsg.txfields('29').value,p_txmsg.txfields('88').value,
                p_txmsg.txfields('32').value,p_txmsg.txfields('11').value,0,null,
                null,
                p_txmsg.txfields('31').value,
                p_txmsg.txfields('28').value,
                '1407', v_custid
        );


        UPDATE SEMAST SET RECEIVING = RECEIVING + p_txmsg.txfields(c_qtty).value WHERE ACCTNO = v_seacctno;

        insert into setran (TXNUM, TXDATE, ACCTNO, TXCD, NAMT, CAMT, REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC)
             values (p_txmsg.txnum, to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT), v_seacctno, '0016', p_txmsg.txfields(c_qtty).value, null, null, 'N', seq_setran.nextval, null, p_txmsg.tltxcd, to_date(p_txmsg.busdate, systemnums.C_DATE_FORMAT), null);
    Else

            select PAYSTATUS,crphysagreeid,custodycd,acctno||codeid into v_PAYSTATUS,v_crphysagreeid,v_custodycd,v_seacctno from crphysagree where txnum = p_txmsg.txnum and txdate =to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

            begin
                select sum(nvl(qtty,0)) into v_qt_1405 from docstransfer where status = 'OPN' and crphysagreeid =v_crphysagreeid and deltd <> 'Y' group by crphysagreeid;
            exception when NO_DATA_FOUND then
                v_qt_1405:=0;
            end;

            begin
                select sum(qtty) into v_qt_1406 from docstransfer where status = 'CLS' and crphysagreeid =v_crphysagreeid and deltd <> 'Y' group by crphysagreeid;
            exception when NO_DATA_FOUND then
                v_qt_1406:=0;
            end;
            begin
                select  sum(nvl(qtty,0)) into v_qt_1404  from crphysagree_log where type= 'R' and crphysagreeid =v_crphysagreeid and deltd <> 'Y' group by crphysagreeid;
            exception when NO_DATA_FOUND then
                v_qt_1404:=0;
            end;
            begin
                select sum(nvl(icqtty,0)) into v_qt_1414 from crphysagree_withdraw_log where type = 'IC' and crphysagreeid =v_crphysagreeid and deltd <> 'Y' group by crphysagreeid;
            exception when NO_DATA_FOUND then
                v_qt_1414:=0;
            end;
            begin
                SELECT nvl(trade,0) into v_trade FROM semast where acctno = v_seacctno;
            exception when NO_DATA_FOUND then
                v_trade:=0;
            end;
            begin
                select sum(wdqtty) into v_qt_RUT from crphysagree_withdraw_log where type = 'WD' and  crphysagreeid =v_crphysagreeid and deltd <> 'Y' group by crphysagreeid;
            exception when NO_DATA_FOUND then
                v_qt_RUT:=0;
            end;

            begin
                 select sum(qtty) into v_qt_1400 from crphysagree_sell_log where crphysagreeid =v_crphysagreeid and deltd <> 'Y' group by crphysagreeid;
            exception when NO_DATA_FOUND then
                v_qt_1400:=0;
            end;

            --trung.luu: 13-04-2021 SHBVNEX-1652
            -- chi cho phep lam khi thoa cac dieu kien duoi
            --Truo`ng Tra?ng tha?i thanh toa?n ti?`n = null   => v_PAYSTATUS = 'P'
            --Tra?ng tha?i s?? du di??n tu? = Null      =>  v_qt_1405 = 0 and v_qt_1406 = 0
            -- Tra?ng tha?i kho = Null     =>  v_qt_1404 = 0 and  v_qt_1414 = 0 and v_qt_RUT = 0 and v_qt_1400 = 0
        if v_PAYSTATUS <> 'P'  or  v_qt_1405 <> 0 or v_qt_1406 <> 0 or  v_qt_1404 <>0 or v_qt_1414 <> 0 or v_qt_RUT <> 0 or v_qt_1400 <> 0 then
            p_err_code := '-930107';
            plog.setendsection (pkgctx, 'fn_txAftAppUpdate');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;

        --trung.luu: 31-03-2021 update co deltd, khong delete
        --Delete from crphysagree where txnum = p_txmsg.txnum and txdate =to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        update crphysagree set deltd ='Y'  where txnum = p_txmsg.txnum and txdate =to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        --update co deltd bang log CRPHYSAGREE_LOG_ALL
        update CRPHYSAGREE_LOG_ALL set deltd = 'Y'   where txnum = p_txmsg.txnum and txdate =to_date(p_txmsg.txdate, systemnums.C_DATE_FORMAT);
        UPDATE setran
            SET DELTD = 'Y'
        WHERE TXNUM = p_txmsg.txnum AND TXDATE = TO_DATE(p_txmsg.txdate, systemnums.C_DATE_FORMAT);

        Update  SEMAST SET RECEIVING = RECEIVING - p_txmsg.txfields(c_qtty).value WHERE ACCTNO = v_seacctno;
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
         plog.init ('TXPKS_#1407EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#1407EX;
/
