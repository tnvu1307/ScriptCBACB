SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#8807ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#8807EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      16/03/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#8807ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
   c_registtype       CONSTANT CHAR(2) := '04';
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
L_txnum         VARCHAR2(20);
l_txmsg         tx.msg_rectype;
v_strCURRDATE varchar2(20);
v_strEN_Desc VARCHAR2(250);
l_err_param varchar2(4000);
globalid_bank VARCHAR2(250);
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN -- Normal transaction
        
        if p_txmsg.txfields('04').value = 'HOLDMT0' then
                select txdesc into v_strEN_Desc from tltx where tltxcd = '6690';
                FOR rec IN ( SELECT *FROM VW_HOLDMT0_HOLDMT0)
                LOOP
                    /* --SHBVNEX-1819 khach hang va BA confirm unhold loi 1 dong thi cac dong khac van di tiep
                    SELECT TO_DATE (varvalue, systemnums.c_date_format)
                       INTO v_strCURRDATE
                       FROM sysvar
                       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
                    SELECT systemnums.C_BATCH_PREFIXED
                                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                              INTO l_txmsg.txnum
                              FROM DUAL;
                    l_txmsg.msgtype:='T';
                    l_txmsg.local:='N';
                    l_txmsg.tlid        := p_txmsg.tlid;
                    l_txmsg.brid        := p_txmsg.brid;
                    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                      INTO l_txmsg.wsname, l_txmsg.ipaddress
                    FROM DUAL;
                    select txdesc into v_strEN_Desc from tltx where tltxcd = '6690';

                    l_txmsg.off_line    := 'N';
                    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
                    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txpending;
                    l_txmsg.ovrrqd      := '@00';
                    l_txmsg.msgsts      := '0';
                    l_txmsg.ovrsts      := '0';
                    l_txmsg.batchname   := 'DAY';
                    l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
                    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
                    l_txmsg.BUSDATE:=to_date(p_txmsg.txfields('20').value,systemnums.c_date_format);
                    l_txmsg.tltxcd:='6690';
                    l_txmsg.nosubmit    := '2';


                    --95    Ma GD request   C
                     l_txmsg.txfields ('95').defname   := 'REQTXNUM';
                     l_txmsg.txfields ('95').TYPE      := 'C';
                     l_txmsg.txfields ('95').value      := rec.ORDERID;
                --94    Ma nghiep vu   C
                     l_txmsg.txfields ('94').defname   := 'REQCODE';
                     l_txmsg.txfields ('94').TYPE      := 'C';
                     l_txmsg.txfields ('94').value      := rec.REQCODE;
                --88    S? TK luu k?   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --03    S? ti?u kho?n   C
                     l_txmsg.txfields ('03').defname   := 'ACCOUNTNO';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.ACCTNO;
                --04    T?i kho?n ti?n t?   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --90    H? t?n   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                --89    M? KH t?i NH   C
                     l_txmsg.txfields ('89').defname   := 'CIFID';
                     l_txmsg.txfields ('89').TYPE      := 'C';
                     l_txmsg.txfields ('89').value      := rec.CIFID;
                --93    S? TK t?i ng?n h?ng   C
                     l_txmsg.txfields ('93').defname   := 'REFCASAACCT';
                     l_txmsg.txfields ('93').TYPE      := 'C';
                     l_txmsg.txfields ('93').value      := rec.REFCASAACCT;
                --13    S? du t?i NH   N
                     l_txmsg.txfields ('13').defname   := 'BANKBALANCE';
                     l_txmsg.txfields ('13').TYPE      := 'N';
                     l_txmsg.txfields ('13').value      := rec.BALANCE;
                --12    S? ti?n d? t?m gi?   N
                     l_txmsg.txfields ('12').defname   := 'BANKHOLDED';
                     l_txmsg.txfields ('12').TYPE      := 'N';
                     l_txmsg.txfields ('12').value      := rec.HOLDBALANCE;
                --05    C?ng ty ch?ng kho?n   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.MEMBERID;
                --06    H? t?n m?i gi?i   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.BRNAME;
                --07    S?T m?i gi?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.BRPHONE;
                --11    S? ti?n d? t?m gi? b?i Broker   N
                     l_txmsg.txfields ('11').defname   := 'BANKHOLDEDBYBROKER';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := rec.BANKHOLDEDBYBROKER;
                --20    Ti?n t?   C
                     l_txmsg.txfields ('20').defname   := 'CCYCD';
                     l_txmsg.txfields ('20').TYPE      := 'C';
                     l_txmsg.txfields ('20').value      := rec.CCYCD;
                --21    T? gi?   N
                     l_txmsg.txfields ('21').defname   := 'EXCHANGERATE';
                     l_txmsg.txfields ('21').TYPE      := 'N';
                     l_txmsg.txfields ('21').value      := 0;
                --10    S? ti?n t?m gi?   N
                     l_txmsg.txfields ('10').defname   := 'AMOUNT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMOUNT;
                --22    Gi? tr? qui d?i   N
                     l_txmsg.txfields ('22').defname   := 'VALUE';
                     l_txmsg.txfields ('22').TYPE      := 'N';
                     l_txmsg.txfields ('22').value      := 0;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := v_strEN_Desc;

                     */

                     begin
                        PCK_BANKAPI.Bank_holdbalance_no_rollback(rec.DDACCTNO, -- tk ddmast
                                              rec.MEMBERID, -- ctck dat lenh
                                              rec.BRNAME, -- moi gioi dat lenh
                                              rec.BRPHONE, --- so dien thoai moi gioi dat lenh
                                              TO_NUMBER(rec.AMOUNT),  --- so tien
                                              rec.REQCODE, --- code nghiep vu cua giao dich , select tu alcode
                                              rec.ORDERID, --request key --> key duy nhat de truy vet giao dich goc
                                              v_strEN_Desc, -- dien giai
                                              p_txmsg.tlid, -- nguoi lap giao dich
                                              P_ERR_CODE);
                     end;
                     /*
                     IF  txpks_#6690.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                        plog.error (pkgctx,'8807 goi 6690 loi: '|| l_err_param);
                        --ROLLBACK;
                     else
                        p_err_code:=systemnums.c_success;
                        
                     end if ;
                     */
                    --log lai
                     insert into log_8807(txdate, txnum, type, orderid, tlid, txtime,ERRCODE,autoid)
                     values(p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields('04').value,rec.orderid,p_txmsg.tlid,sysTIMESTAMP,l_err_param,seq_log_8807.nextval);
                END LOOP;



        elsif p_txmsg.txfields('04').value = 'UNHOLDMT2' then
                 /* --SHBVNEX-1819 khach hang va BA confirm unhold loi 1 dong thi cac dong khac van di tiep
                SELECT TO_DATE (varvalue, systemnums.c_date_format)
                       INTO v_strCURRDATE
                       FROM sysvar
                       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

                    l_txmsg.msgtype:='T';
                    l_txmsg.local:='N';
                    l_txmsg.tlid        := p_txmsg.tlid;
                    l_txmsg.brid        := p_txmsg.brid;
                    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                      INTO l_txmsg.wsname, l_txmsg.ipaddress
                    FROM DUAL;
                    select txdesc into v_strEN_Desc from tltx where tltxcd = '6623';
                */
                select txdesc into v_strEN_Desc from tltx where tltxcd = '6623';
                FOR rec IN ( SELECT *FROM vw_UNHOLDMT2_UNHOLDMT2)
                LOOP
                    /* --SHBVNEX-1819 khach hang va BA confirm unhold loi 1 dong thi cac dong khac van di tiep
                    SELECT systemnums.C_BATCH_PREFIXED
                                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                              INTO l_txmsg.txnum
                              FROM DUAL;

                    l_txmsg.off_line    := 'N';
                    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
                    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txpending;
                    l_txmsg.ovrrqd      := '@00';
                    l_txmsg.msgsts      := '0';
                    l_txmsg.ovrsts      := '0';
                    l_txmsg.batchname   := 'DAY';
                    l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
                    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
                    l_txmsg.BUSDATE:=to_date(p_txmsg.txfields('20').value,systemnums.c_date_format);
                    l_txmsg.tltxcd:='6623';
                    l_txmsg.nosubmit    := '2';

                    --95    Ma GD request   C
                     l_txmsg.txfields ('95').defname   := 'REQTXNUM';
                     l_txmsg.txfields ('95').TYPE      := 'C';
                     l_txmsg.txfields ('95').value      := rec.ORDERID;
                --94    Ma nghiep vu   C
                     l_txmsg.txfields ('94').defname   := 'REQCODE';
                     l_txmsg.txfields ('94').TYPE      := 'C';
                     l_txmsg.txfields ('94').value      := '';
                --88    S? TK luu k?   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --91    S? t.chi?u gd hold   C
                     l_txmsg.txfields ('91').defname   := 'REFHOLDTXNUM';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.REFTXNUM;
                --03    S? ti?u kho?n   C
                     l_txmsg.txfields ('03').defname   := 'SECACCOUNT';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.SECACCOUNT;
                --04    T?i kho?n ti?n   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --90    H? t?n   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                --93    S? TK t?i ng?n h?ng   C
                     l_txmsg.txfields ('93').defname   := 'REFCASAACCT';
                     l_txmsg.txfields ('93').TYPE      := 'C';
                     l_txmsg.txfields ('93').value      := rec.REFCASAACCT;
                --13    S? du kh? d?ng   N
                     l_txmsg.txfields ('13').defname   := 'BANKBALANCE';
                     l_txmsg.txfields ('13').TYPE      := 'N';
                     l_txmsg.txfields ('13').value      := rec.BALANCE;
                --12    S? ti?n d? t?m gi?   N
                     l_txmsg.txfields ('12').defname   := 'BANKHOLDED';
                     l_txmsg.txfields ('12').TYPE      := 'N';
                     l_txmsg.txfields ('12').value      := rec.HOLDBALANCE;
                --05    C?ng ty ch?ng kho?n   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.MEMBERID;
                --06    T?n nh?n vi?n   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.BRNAME;
                --07    S? di?n tho?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.BRPHONE;
                --11    S? du c? th? gi?i t?a   N
                     l_txmsg.txfields ('11').defname   := 'BANKHOLDEDBYBROKER';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := 0;
                --20    Ti?n t?   C
                     l_txmsg.txfields ('20').defname   := 'CCYCD';
                     l_txmsg.txfields ('20').TYPE      := 'C';
                     l_txmsg.txfields ('20').value      := rec.CCYCD;
                --10    S? ti?n   N
                     l_txmsg.txfields ('10').defname   := 'AMOUNT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMOUNT;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := v_strEN_Desc;
                    */
                     select fn_getglobalid(p_txmsg.txdate, p_txmsg.txnum) into globalid_bank from dual;
                     begin
                         PCK_BANKAPI.Bank_UNholdbalance_No_Broker(
                                      rec.ORDERID,  ---txnum cua giao dich hold
                                      rec.DDACCTNO,  --- tk ddmast
                                      rec.AMOUNT ,  -- so tien
                                      'UNHOLDOD', --request code cua nghiep vu trong allcode
                                      globalid_bank ,  --requestkey duy nhat de truy lai giao dich goc
                                      v_strEN_Desc,  -- dien giai
                                      p_txmsg.tlid , -- nguoi tao giao dich
                                      P_ERR_CODE)
                            ;
                     end;
                     /*
                     IF  txpks_#6623.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                        plog.error (pkgctx,'8807 goi 6623 loi: '|| l_err_param);
                        --ROLLBACK;
                     else
                        p_err_code:=systemnums.c_success;
                        
                     end if ;
                     */
                    --log lai
                     insert into log_8807(txdate, txnum, type, orderid, tlid, txtime,ERRCODE,autoid)
                     values(p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields('04').value,rec.orderid,p_txmsg.tlid,sysTIMESTAMP,l_err_param,seq_log_8807.nextval);
                end loop;
        elsif p_txmsg.txfields('04').value = 'UNHOLDSEF8' then
                    /* --SHBVNEX-1819 khach hang va BA confirm unhold loi 1 dong thi cac dong khac van di tiep
                    SELECT TO_DATE (varvalue, systemnums.c_date_format)
                       INTO v_strCURRDATE
                       FROM sysvar
                       WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

                    l_txmsg.msgtype:='T';
                    l_txmsg.local:='N';
                    l_txmsg.tlid        := p_txmsg.tlid;
                    l_txmsg.brid        := p_txmsg.brid;
                    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
                             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
                      INTO l_txmsg.wsname, l_txmsg.ipaddress
                    FROM DUAL;
                    select txdesc into v_strEN_Desc from tltx where tltxcd = '2216';
                    */
                    select txdesc into v_strEN_Desc from tltx where tltxcd = '2216';
                FOR rec IN ( SELECT *FROM vw_UNHOLDSEF8_UNHOLDSEF8)
                LOOP
                    /*--SHBVNEX-1819 khach hang va BA confirm unhold loi 1 dong thi cac dong khac van di tiep
                    SELECT systemnums.C_BATCH_PREFIXED
                                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                              INTO l_txmsg.txnum
                              FROM DUAL;

                    l_txmsg.off_line    := 'N';
                    L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
                    L_TXMSG.TXSTATUS    := TXSTATUSNUMS.c_txpending;
                    l_txmsg.ovrrqd      := '@00';
                    l_txmsg.msgsts      := '0';
                    l_txmsg.ovrsts      := '0';
                    l_txmsg.batchname   := 'DAY';
                    l_txmsg.txtime    := to_char(SYSdate,'hh24:mi:ss');
                    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
                    l_txmsg.BUSDATE:=to_date(p_txmsg.txfields('20').value,systemnums.c_date_format);
                    l_txmsg.tltxcd:='2216';
                    l_txmsg.nosubmit    := '2';


                    --88    S? TK luu k?   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CFCUSTODYCD;
                --90    H? t?n   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CFFULLNAME;
                --14    M? ch?ng kho?n   C
                     l_txmsg.txfields ('14').defname   := 'SYMBOL';
                     l_txmsg.txfields ('14').TYPE      := 'C';
                     l_txmsg.txfields ('14').value      := rec.SYMBOL;
                --03    Ti?u kho?n CK ghi c?   C
                     l_txmsg.txfields ('03').defname   := 'ACCTNO';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.SEACCOUNT;
                --15    M? giao d?ch   C
                     l_txmsg.txfields ('15').defname   := 'TXNUM';
                     l_txmsg.txfields ('15').TYPE      := 'C';
                     l_txmsg.txfields ('15').value      := rec.TXNUM;
                --04    M? ch?ng kho?n   C
                     l_txmsg.txfields ('04').defname   := 'CODEID';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.CODEID;
                --05    C?ng ty ch?ng kho?n   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.MEMBERID;
                --06    T?n nh?n vi?n   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.BRNAME;
                --07    S? di?n tho?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.BRPHONE;
                --10    S? lu?ng   N
                     l_txmsg.txfields ('10').defname   := 'QUANTITY';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.QTTY;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := v_strEN_Desc;


                     IF  txpks_#2216.fn_AutoTxProcess(l_txmsg, p_err_code, l_err_param) <> systemnums.c_success THEN
                        plog.error (pkgctx,'8807 goi 2216 loi: '|| l_err_param);
                        --ROLLBACK;
                     else
                        p_err_code:=systemnums.c_success;
                        
                     end if ;
                     */
                     --SHBVNEX-1819 khach hang va BA confirm unhold loi 1 dong thi cac dong khac van di tiep
                     begin
                         PCK_BANKAPI.se_unhold(
                              rec.SEACCOUNT, -- tk semast
                              rec.MEMBERID,
                              '',
                              '',
                              rec.QTTY,  --- so luong
                              v_strEN_Desc, -- dien giai
                              p_txmsg.tlid, -- nguoi lap giao dich
                              P_ERR_CODE  );
                      end;
                    --log lai
                     insert into log_8807(txdate, txnum, type, orderid, tlid, txtime,ERRCODE,autoid)
                     values(p_txmsg.txdate,p_txmsg.txnum,p_txmsg.txfields('04').value,rec.seaccount,p_txmsg.tlid,sysTIMESTAMP,P_ERR_CODE,seq_log_8807.nextval);
                end loop;
        END IF;
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
         plog.init ('TXPKS_#8807EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#8807EX;
/
