SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#6678ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#6678EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      28/09/2021     Created
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


CREATE OR REPLACE PACKAGE BODY txpks_#6678ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_txdate           CONSTANT CHAR(2) := '20';
   c_txtype           CONSTANT CHAR(2) := '02';
   c_custype          CONSTANT CHAR(2) := '01';
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
    L_TXMSG     TX.MSG_RECTYPE;
    L_ERR_PARAM VARCHAR2(1000);
    L_STRDESC   VARCHAR2(400);
    L_CUSTYPE   VARCHAR2(10);
    L_TXTYPE    VARCHAR2(50);
    L_SETTLE_DATE DATE;
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    IF p_txmsg.deltd <> 'Y' THEN
        SELECT CASE WHEN P_TXMSG.TXFIELDS('01').VALUE = 'FA' THEN 'Y'
                    WHEN P_TXMSG.TXFIELDS('01').VALUE = 'CB' THEN 'N'
                    ELSE '%%'
               END
        INTO L_CUSTYPE
        FROM DUAL;

        L_TXTYPE := P_TXMSG.TXFIELDS('02').VALUE;
        L_SETTLE_DATE := TO_DATE(P_TXMSG.TXFIELDS('20').VALUE,'DD/MM/RRRR');

        L_TXMSG.MSGTYPE     := 'T';
        L_TXMSG.LOCAL       := 'N';
        L_TXMSG.TLID        := P_TXMSG.TLID;
        L_TXMSG.BRID        := P_TXMSG.BRID;
        L_TXMSG.WSNAME      := P_TXMSG.WSNAME;
        L_TXMSG.IPADDRESS   := P_TXMSG.IPADDRESS;
        L_TXMSG.OFF_LINE    := 'N';
        L_TXMSG.DELTD       := TXNUMS.C_DELTD_TXNORMAL;
        L_TXMSG.TXSTATUS    := TXSTATUSNUMS.C_TXCOMPLETED;
        L_TXMSG.MSGSTS      := '0';
        L_TXMSG.OVRSTS      := '0';
        L_TXMSG.BATCHNAME   := 'DAY';
        L_TXMSG.BUSDATE     := P_TXMSG.BUSDATE;
        L_TXMSG.TXDATE      := P_TXMSG.TXDATE;
        L_TXMSG.REFTXNUM    := P_TXMSG.TXNUM;

        IF L_TXTYPE = 'UNHOLDORDER' THEN --6691
        BEGIN
            SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = '6691';
            L_TXMSG.TLTXCD      := '6691';
            FOR rec IN
            (
                SELECT DD.CUSTODYCD, F.TXNUM REFTXNUM, DD.AFACCTNO SECACCOUNT, DD.ACCTNO DDACCTNO, CF.FULLNAME CUSTNAME,
                       DD.REFCASAACCT REFCASAACCT, DD.BALANCE, DD.HOLDBALANCE, F.MEMBERID, F.BRNAME, F.BRPHONE, F.CCYCD, CRB.TXAMT AMOUNT, F.NOTE,
                       CRB.CREATEDATE, CRB.REQID
                FROM CRBTXREQ CRB, DDMAST DD, CFMAST CF,
                (
                    SELECT TXNUM,
                         MAX (CASE WHEN F.FLDCD = '05' THEN F.CVALUE ELSE '' END)  MEMBERID,
                         MAX (CASE WHEN F.FLDCD = '06' THEN F.CVALUE ELSE '' END)  BRNAME,
                         MAX (CASE WHEN F.FLDCD = '07' THEN F.CVALUE ELSE '' END)  BRPHONE,
                         MAX (CASE WHEN F.FLDCD = '93' THEN F.CVALUE ELSE '' END)  BANKACCTNO,
                         MAX (CASE WHEN F.FLDCD = '20' THEN F.CVALUE ELSE '' END)  CCYCD,
                         MAX (CASE WHEN F.FLDCD = '30' THEN F.CVALUE ELSE '' END)  NOTE
                    FROM TLLOGFLD F
                    WHERE FLDCD IN ('04','05', '06', '07', '20', '93','30')
                    GROUP BY TXNUM
                )F
                WHERE CRB.OBJNAME = '6690'
                AND CRB.REQCODE = 'BANKHOLDEDBYBROKER'
                AND CRB.TXDATE = GETCURRDATE
                AND DD.ACCTNO = CRB.AFACCTNO
                AND DD.CUSTODYCD = CF.CUSTODYCD
                AND CRB.OBJKEY = F.TXNUM
                AND CRB.UNHOLD = 'N'
                AND CRB.STATUS = 'C'
                AND NOT EXISTS (
                    SELECT F1.CVALUE
                    FROM TLLOG TL, TLLOGFLD F1
                    WHERE TL.TXNUM = F1.TXNUM
                    AND TL.TXDATE = F1.TXDATE
                    AND TL.TLTXCD = '6691'
                    AND F1.FLDCD = '91'
                    AND TL.TXSTATUS IN('1', '4')
                    AND F1.CVALUE =  F.TXNUM
                )
                AND CF.SUPEBANK LIKE L_CUSTYPE
            )
            LOOP
                SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;

                --03    S? ti?u kho?n   C
                     l_txmsg.txfields ('03').defname   := 'SECACCOUNT';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.SECACCOUNT;
                --04    Tài kho?n ti?n   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --05    Công ty ch?ng khoán   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.MEMBERID;
                --06    Tên nhân viên   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.BRNAME;
                --07    S? di?n tho?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.BRPHONE;
                --10    S? ti?n   N
                     l_txmsg.txfields ('10').defname   := 'AMOUNT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMOUNT;
                --11    S? du có th? gi?i t?a   N
                     l_txmsg.txfields ('11').defname   := 'BANKHOLDEDBYBROKER';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := GETRMBALDEFAVL(rec.DDACCTNO, rec.MEMBERID);
                --12    S? ti?n dã t?m gi?   N
                     l_txmsg.txfields ('12').defname   := 'BANKHOLDED';
                     l_txmsg.txfields ('12').TYPE      := 'N';
                     l_txmsg.txfields ('12').value      := rec.HOLDBALANCE;
                --13    S? du kh? d?ng   N
                     l_txmsg.txfields ('13').defname   := 'BANKBALANCE';
                     l_txmsg.txfields ('13').TYPE      := 'N';
                     l_txmsg.txfields ('13').value      := rec.BALANCE;
                --20    Ti?n t?   C
                     l_txmsg.txfields ('20').defname   := 'CCYCD';
                     l_txmsg.txfields ('20').TYPE      := 'C';
                     l_txmsg.txfields ('20').value      := rec.CCYCD;
                --21    T? giá   N
                     l_txmsg.txfields ('21').defname   := 'EXCHANGERATE';
                     l_txmsg.txfields ('21').TYPE      := 'N';
                     l_txmsg.txfields ('21').value      := GETEXCHANGERATE(rec.CCYCD);
                --22    Giá tr? th? tru?ng   N
                     l_txmsg.txfields ('22').defname   := 'VALUE';
                     l_txmsg.txfields ('22').TYPE      := 'N';
                     l_txmsg.txfields ('22').value      := rec.AMOUNT * GETEXCHANGERATE(rec.CCYCD);
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := L_STRDESC;
                --88    S? TK luu ký   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                --91    S? t.chi?u gd hold   C
                     l_txmsg.txfields ('91').defname   := 'REFHOLDTXNUM';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.REFTXNUM;
                --93    S? TK t?i ngân hàng   C
                     l_txmsg.txfields ('93').defname   := 'REFCASAACCT';
                     l_txmsg.txfields ('93').TYPE      := 'C';
                     l_txmsg.txfields ('93').value      := rec.REFCASAACCT;
                --94    Ma nghiep vu   C
                     l_txmsg.txfields ('94').defname   := 'REQCODE';
                     l_txmsg.txfields ('94').TYPE      := 'C';
                     l_txmsg.txfields ('94').value      := '';
                --95    Ma GD request   C
                     l_txmsg.txfields ('95').defname   := 'REQTXNUM';
                     l_txmsg.txfields ('95').TYPE      := 'C';
                     l_txmsg.txfields ('95').value      := '';

                BEGIN
                    IF TXPKS_#6691.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
						plog.error (pkgctx, 'got error 6691: ' || p_err_code);
                        ROLLBACK;
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END;
            END LOOP;
        END;
        ELSIF L_TXTYPE = 'UNHOLDORDERGB' THEN --6623
        BEGIN
            SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = '6623';
            L_TXMSG.TLTXCD      := '6623';
            FOR rec IN
            (
                SELECT DD.CUSTODYCD,CRB.OBJKEY REFTXNUM ,OD.TRADE_DATE TRADEDATE,OD.CLEARDATE SETTLE_DATE,DD.AFACCTNO SECACCOUNT,DD.ACCTNO DDACCTNO,CF.FULLNAME CUSTNAME,OD.ORDERID,
                       DD.REFCASAACCT REFCASAACCT,DD.BALANCE,DD.HOLDBALANCE,VMB.VALUE MEMBERID,'' BRNAME,'' BRPHONE,CRB.CURRENCY CCYCD,CRB.TXAMT AMOUNT,'' NOTE
                FROM CRBTXREQ CRB, DDMAST DD, CFMAST CF, ODMAST OD, SBSECURITIES SB, VW_CUSTODYCD_MEMBER VMB,
                (
                    SELECT VARVALUE  FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD'
                ) SYS
                WHERE CRB.OBJNAME = '6690'
                AND CRB.REQCODE = 'HOLDOD'
                AND VMB.FILTERCD = DD.CUSTODYCD
                AND VMB.VALUE = OD.MEMBER
                AND DD.ACCTNO = CRB.AFACCTNO
                AND DD.CUSTODYCD = CF.CUSTODYCD
                AND OD.ORDERID = CRB.REQTXNUM
                AND OD.CODEID = SB.CODEID
                AND SB.BONDTYPE = '001'
                AND CRB.UNHOLD = 'N'
                AND SUBSTR(OD.CUSTODYCD,0,4) NOT LIKE SYS.VARVALUE
                AND CRB.STATUS = 'C'
                AND NOT EXISTS (
                    SELECT F.CVALUE
                    FROM TLLOG TL, TLLOGFLD F
                    WHERE TL.TXNUM = F.TXNUM
                    AND TL.TXDATE = F.TXDATE
                    AND TL.TLTXCD = '6623'
                    AND F.FLDCD = '95'
                    AND TL.TXSTATUS IN('1', '4')
                    AND F.CVALUE =  OD.ORDERID
                )
                AND CF.SUPEBANK LIKE L_CUSTYPE
                AND OD.CLEARDATE = L_SETTLE_DATE
            )
            LOOP
                SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;

                --03    S? ti?u kho?n   C
                     l_txmsg.txfields ('03').defname   := 'SECACCOUNT';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.SECACCOUNT;
                --04    Tài kho?n ti?n   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --05    Công ty ch?ng khoán   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.MEMBERID;
                --06    Tên nhân viên   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.BRNAME;
                --07    S? di?n tho?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.BRPHONE;
                --10    S? ti?n   N
                     l_txmsg.txfields ('10').defname   := 'AMOUNT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMOUNT;
                --11    S? du có th? gi?i t?a   N
                     l_txmsg.txfields ('11').defname   := 'BANKHOLDEDBYBROKER';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := GETRMBALDEFAVL(rec.DDACCTNO, rec.MEMBERID);
                --12    S? ti?n dã t?m gi?   N
                     l_txmsg.txfields ('12').defname   := 'BANKHOLDED';
                     l_txmsg.txfields ('12').TYPE      := 'N';
                     l_txmsg.txfields ('12').value      := rec.HOLDBALANCE;
                --13    S? du kh? d?ng   N
                     l_txmsg.txfields ('13').defname   := 'BANKBALANCE';
                     l_txmsg.txfields ('13').TYPE      := 'N';
                     l_txmsg.txfields ('13').value      := rec.BALANCE;
                --20    Ti?n t?   C
                     l_txmsg.txfields ('20').defname   := 'CCYCD';
                     l_txmsg.txfields ('20').TYPE      := 'C';
                     l_txmsg.txfields ('20').value      := rec.CCYCD;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := L_STRDESC;
                --88    S? TK luu ký   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                --91    S? t.chi?u gd hold   C
                     l_txmsg.txfields ('91').defname   := 'REFHOLDTXNUM';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.REFTXNUM;
                --93    S? TK t?i ngân hàng   C
                     l_txmsg.txfields ('93').defname   := 'REFCASAACCT';
                     l_txmsg.txfields ('93').TYPE      := 'C';
                     l_txmsg.txfields ('93').value      := rec.REFCASAACCT;
                --94    Ma nghiep vu   C
                     l_txmsg.txfields ('94').defname   := 'REQCODE';
                     l_txmsg.txfields ('94').TYPE      := 'C';
                     l_txmsg.txfields ('94').value      := '';
                --95    Ma GD request   C
                     l_txmsg.txfields ('95').defname   := 'REQTXNUM';
                     l_txmsg.txfields ('95').TYPE      := 'C';
                     l_txmsg.txfields ('95').value      := rec.ORDERID;

                BEGIN
                    IF TXPKS_#6623.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
						plog.error (pkgctx, 'got error 6623: ' || p_err_code);
                        ROLLBACK;
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END;
            END LOOP;
        END;
        ELSIF L_TXTYPE = 'UNHOLDORDERQK' THEN --6623
        BEGIN
            SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = '6623';
            L_TXMSG.TLTXCD      := '6623';
            FOR rec IN
            (
                SELECT TL.TXDATE,DD.CUSTODYCD,TL.TXNUM,TL.TLTXCD,F.TXNUM REFTXNUM ,DD.AFACCTNO SECACCOUNT,DD.ACCTNO DDACCTNO,CF.FULLNAME CUSTNAME,TLP.TLFULLNAME,
                        DD.REFCASAACCT REFCASAACCT,DD.BALANCE,DD.HOLDBALANCE,F.MEMBERID,F.BRNAME,F.BRPHONE,F.CCYCD,CRB.TXAMT AMOUNT,F.NOTE,F.REQTXNUM,
                        M.SHORTNAME MEMBERIDTEXT,MX1.EXTRAVAL BRNAMETEXT,MX2.EXTRAVAL BRPHONETEXT
                FROM CRBTXREQ CRB, DDMAST DD, CFMAST CF, VW_TLLOG_ALL TL, TLPROFILES TLP, FAMEMBERS M, FAMEMBERSEXTRA MX1, FAMEMBERSEXTRA MX2,
                (
                    SELECT TXNUM,TXDATE,
                        MAX(CASE WHEN F.FLDCD = '05' THEN F.CVALUE ELSE '' END) MEMBERID,
                        MAX(CASE WHEN F.FLDCD = '06' THEN F.CVALUE ELSE '' END) BRNAME,
                        MAX(CASE WHEN F.FLDCD = '07' THEN F.CVALUE ELSE '' END) BRPHONE,
                        MAX(CASE WHEN F.FLDCD = '93' THEN F.CVALUE ELSE '' END) BANKACCTNO,
                        MAX(CASE WHEN F.FLDCD = '20' THEN F.CVALUE ELSE '' END) CCYCD,
                        MAX(CASE WHEN F.FLDCD = '30' THEN F.CVALUE ELSE '' END) NOTE,
                        MAX(CASE WHEN F.FLDCD = '95' THEN F.CVALUE ELSE '' END) REQTXNUM
                    FROM VW_TLLOGFLD_ALL F
                    WHERE FLDCD IN ('04','05', '06', '07', '20', '93','30','95')
                    GROUP BY TXNUM, TXDATE
                )F
                WHERE CRB.OBJNAME = '6690'
                AND CRB.REQCODE = 'BANKHOLDEDBYBROKER'
                AND DD.ACCTNO = CRB.AFACCTNO
                AND DD.CUSTODYCD = CF.CUSTODYCD
                AND CRB.OBJKEY = F.TXNUM
                AND CRB.TXDATE < GETCURRDATE
                AND F.MEMBERID = M.AUTOID
                AND MX1.AUTOID = F.BRNAME
                AND MX2.AUTOID = F.BRPHONE
                AND CRB.TXDATE =TL.TXDATE
                AND CRB.OBJKEY = TL.TXNUM
                AND TL.TLID = TLP.TLID
                AND CRB.TXDATE = F.TXDATE
                AND CRB.UNHOLD = 'N'
                AND CRB.STATUS = 'C'
                AND NOT EXISTS (
                    SELECT F.CVALUE
                    FROM TLLOG TL, TLLOGFLD F
                    WHERE TL.TXNUM = F.TXNUM
                    AND TL.TXDATE = F.TXDATE
                    AND TL.TLTXCD = '6691'
                    AND F.FLDCD = '91'
                    AND TL.TXSTATUS IN('1', '4')
                    AND F.CVALUE =  F.TXNUM
                )
                AND CF.SUPEBANK LIKE L_CUSTYPE
                AND TL.TXDATE = L_SETTLE_DATE
            )
            LOOP
                SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;

                --03    S? ti?u kho?n   C
                     l_txmsg.txfields ('03').defname   := 'SECACCOUNT';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.SECACCOUNT;
                --04    Tài kho?n ti?n   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --05    Công ty ch?ng khoán   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.MEMBERID;
                --06    Tên nhân viên   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.BRNAME;
                --07    S? di?n tho?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.BRPHONE;
                --10    S? ti?n   N
                     l_txmsg.txfields ('10').defname   := 'AMOUNT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMOUNT;
                --11    S? du có th? gi?i t?a   N
                     l_txmsg.txfields ('11').defname   := 'BANKHOLDEDBYBROKER';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := GETRMBALDEFAVL(rec.DDACCTNO, rec.MEMBERID);
                --12    S? ti?n dã t?m gi?   N
                     l_txmsg.txfields ('12').defname   := 'BANKHOLDED';
                     l_txmsg.txfields ('12').TYPE      := 'N';
                     l_txmsg.txfields ('12').value      := rec.HOLDBALANCE;
                --13    S? du kh? d?ng   N
                     l_txmsg.txfields ('13').defname   := 'BANKBALANCE';
                     l_txmsg.txfields ('13').TYPE      := 'N';
                     l_txmsg.txfields ('13').value      := rec.BALANCE;
                --20    Ti?n t?   C
                     l_txmsg.txfields ('20').defname   := 'CCYCD';
                     l_txmsg.txfields ('20').TYPE      := 'C';
                     l_txmsg.txfields ('20').value      := rec.CCYCD;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := L_STRDESC;
                --88    S? TK luu ký   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                --91    S? t.chi?u gd hold   C
                     l_txmsg.txfields ('91').defname   := 'REFHOLDTXNUM';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.REFTXNUM;
                --93    S? TK t?i ngân hàng   C
                     l_txmsg.txfields ('93').defname   := 'REFCASAACCT';
                     l_txmsg.txfields ('93').TYPE      := 'C';
                     l_txmsg.txfields ('93').value      := rec.REFCASAACCT;
                --94    Ma nghiep vu   C
                     l_txmsg.txfields ('94').defname   := 'REQCODE';
                     l_txmsg.txfields ('94').TYPE      := 'C';
                     l_txmsg.txfields ('94').value      := '';
                --95    Ma GD request   C
                     l_txmsg.txfields ('95').defname   := 'REQTXNUM';
                     l_txmsg.txfields ('95').TYPE      := 'C';
                     l_txmsg.txfields ('95').value      := rec.REQTXNUM;

                BEGIN
                    IF TXPKS_#6623.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
						plog.error (pkgctx, 'got error 6623: ' || p_err_code);
                        ROLLBACK;
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END;
            END LOOP;
        END;
        ELSIF L_TXTYPE = 'UNHOLDORDERT' THEN --6623
        BEGIN
            SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = '6623';
            L_TXMSG.TLTXCD      := '6623';
            FOR rec IN
            (
                SELECT DD.CUSTODYCD, CRB.OBJKEY REFTXNUM, OD.TRADE_DATE TRADEDATE, OD.CLEARDATE SETTLE_DATE, CF.CUSTID SECACCOUNT, DD.ACCTNO DDACCTNO, CF.FULLNAME CUSTNAME, OD.ORDERID,
                       DD.REFCASAACCT REFCASAACCT, DD.BALANCE, DD.HOLDBALANCE, VMB.VALUE MEMBERID, '' BRNAME,'' BRPHONE, CRB.CURRENCY CCYCD, CRB.TXAMT AMOUNT, '' NOTE
                FROM CRBTXREQ CRB, DDMAST DD, CFMAST CF, ODMAST OD, SBSECURITIES SB, VW_CUSTODYCD_MEMBER VMB,
                (
                    SELECT VARVALUE  FROM SYSVAR WHERE VARNAME = 'DEALINGCUSTODYCD'
                ) SYS
                WHERE   CRB.OBJNAME = '6690'
                AND CRB.REQCODE = 'HOLDOD'
                AND VMB.FILTERCD = DD.CUSTODYCD AND VMB.VALUE = OD.MEMBER
                AND DD.ACCTNO = CRB.AFACCTNO
                AND DD.CUSTODYCD = CF.CUSTODYCD
                AND OD.ORDERID = CRB.REQTXNUM
                AND OD.CODEID = SB.CODEID
                AND SB.BONDTYPE <> '001'
                AND CRB.UNHOLD = 'N'
                AND CRB.STATUS = 'C'
                AND SUBSTR(OD.CUSTODYCD,0,4) NOT LIKE SYS.VARVALUE
                AND NOT EXISTS (
                    SELECT F.CVALUE
                    FROM TLLOG TL, TLLOGFLD F
                    WHERE TL.TXNUM = F.TXNUM
                    AND TL.TXDATE = F.TXDATE
                    AND TL.TLTXCD = '6623'
                    AND F.FLDCD = '95'
                    AND TL.TXSTATUS IN('1', '4')
                    AND F.CVALUE =  OD.ORDERID
                )
                AND CF.SUPEBANK LIKE L_CUSTYPE
                AND OD.CLEARDATE = L_SETTLE_DATE
            )
            LOOP
                SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;

                --03    S? ti?u kho?n   C
                     l_txmsg.txfields ('03').defname   := 'SECACCOUNT';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.SECACCOUNT;
                --04    Tài kho?n ti?n   C
                     l_txmsg.txfields ('04').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('04').TYPE      := 'C';
                     l_txmsg.txfields ('04').value      := rec.DDACCTNO;
                --05    Công ty ch?ng khoán   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := rec.MEMBERID;
                --06    Tên nhân viên   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := rec.BRNAME;
                --07    S? di?n tho?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := rec.BRPHONE;
                --10    S? ti?n   N
                     l_txmsg.txfields ('10').defname   := 'AMOUNT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMOUNT;
                --11    S? du có th? gi?i t?a   N
                     l_txmsg.txfields ('11').defname   := 'BANKHOLDEDBYBROKER';
                     l_txmsg.txfields ('11').TYPE      := 'N';
                     l_txmsg.txfields ('11').value      := GETRMBALDEFAVL(rec.DDACCTNO, rec.MEMBERID);
                --12    S? ti?n dã t?m gi?   N
                     l_txmsg.txfields ('12').defname   := 'BANKHOLDED';
                     l_txmsg.txfields ('12').TYPE      := 'N';
                     l_txmsg.txfields ('12').value      := rec.HOLDBALANCE;
                --13    S? du kh? d?ng   N
                     l_txmsg.txfields ('13').defname   := 'BANKBALANCE';
                     l_txmsg.txfields ('13').TYPE      := 'N';
                     l_txmsg.txfields ('13').value      := rec.BALANCE;
                --20    Ti?n t?   C
                     l_txmsg.txfields ('20').defname   := 'CCYCD';
                     l_txmsg.txfields ('20').TYPE      := 'C';
                     l_txmsg.txfields ('20').value      := rec.CCYCD;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := L_STRDESC;
                --88    S? TK luu ký   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                --91    S? t.chi?u gd hold   C
                     l_txmsg.txfields ('91').defname   := 'REFHOLDTXNUM';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.REFTXNUM;
                --93    S? TK t?i ngân hàng   C
                     l_txmsg.txfields ('93').defname   := 'REFCASAACCT';
                     l_txmsg.txfields ('93').TYPE      := 'C';
                     l_txmsg.txfields ('93').value      := rec.REFCASAACCT;
                --94    Ma nghiep vu   C
                     l_txmsg.txfields ('94').defname   := 'REQCODE';
                     l_txmsg.txfields ('94').TYPE      := 'C';
                     l_txmsg.txfields ('94').value      := '';
                --95    Ma GD request   C
                     l_txmsg.txfields ('95').defname   := 'REQTXNUM';
                     l_txmsg.txfields ('95').TYPE      := 'C';
                     l_txmsg.txfields ('95').value      := rec.ORDERID;

                BEGIN
                    IF TXPKS_#6623.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
						plog.error (pkgctx, 'got error 6623: ' || p_err_code);
                        ROLLBACK;
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END;
            END LOOP;
        END;
        ELSIF L_TXTYPE = 'UNHOLDTKTD' THEN --6604
        BEGIN
            SELECT TXDESC INTO L_STRDESC FROM TLTX WHERE TLTXCD = '6604';
            L_TXMSG.TLTXCD      := '6604';
            FOR rec IN
            (
                SELECT FL.*, TL.TXNUM REQTXNUM
                FROM TLLOG TL, CFMAST CF,
                (
                    SELECT TXNUM, TXDATE,
                    MAX(CASE WHEN F.FLDCD = '88' THEN F.CVALUE ELSE '' END) CUSTODYCD,
                    MAX(CASE WHEN F.FLDCD = '03' THEN F.CVALUE ELSE '' END) DDACCTNO,
                    MAX(CASE WHEN F.FLDCD = '90' THEN F.CVALUE ELSE '' END) CUSTNAME,
                    MAX(CASE WHEN F.FLDCD = '89' THEN F.CVALUE ELSE '' END) CIFID,
                    MAX(CASE WHEN F.FLDCD = '91' THEN F.CVALUE ELSE '' END) ADDRESS,
                    MAX(CASE WHEN F.FLDCD = '92' THEN F.CVALUE ELSE '' END) LICENSE,
                    MAX(CASE WHEN F.FLDCD = '93' THEN F.CVALUE ELSE '' END) BANKACCT,
                    MAX(CASE WHEN F.FLDCD = '95' THEN F.CVALUE ELSE '' END) BANKNAME,
                    MAX(CASE WHEN F.FLDCD = '10' THEN F.NVALUE ELSE  0 END) AMOUNT,
                    MAX(CASE WHEN F.FLDCD = '30' THEN F.CVALUE ELSE '' END) NOTE
                    FROM TLLOGFLD F
                    WHERE FLDCD IN ('88', '03', '90', '89', '91','92','93','95','10','30')
                    GROUP BY TXNUM, TXDATE
                ) FL
                WHERE TL.TLTXCD = '6603'
                AND TL.TXNUM = FL.TXNUM
                AND TL.TXDATE = FL.TXDATE
                AND FL.CUSTODYCD = CF.CUSTODYCD
                AND NOT EXISTS (
                    SELECT FL2.CVALUE
                    FROM TLLOG F2, TLLOGFLD FL2
                    WHERE F2.TXNUM = FL2.TXNUM
                    AND F2.TXDATE = FL2.TXDATE
                    AND F2.TLTXCD = '6604'
                    AND FL2.FLDCD = '96'
                    AND F2.TXSTATUS IN('1', '4')
                    AND FL2.CVALUE =  TL.TXNUM
                )
                AND CF.SUPEBANK LIKE L_CUSTYPE
            )
            LOOP
                SELECT SYSTEMNUMS.C_BATCH_PREFIXED || LPAD(SEQ_BATCHTXNUM.NEXTVAL, 8, '0')
                INTO L_TXMSG.TXNUM
                FROM DUAL;

                --03    S? tài kho?n ti?n   C
                     l_txmsg.txfields ('03').defname   := 'DDACCTNO';
                     l_txmsg.txfields ('03').TYPE      := 'C';
                     l_txmsg.txfields ('03').value      := rec.DDACCTNO;
                --05    Công ty ch?ng khoán   C
                     l_txmsg.txfields ('05').defname   := 'MEMBERID';
                     l_txmsg.txfields ('05').TYPE      := 'C';
                     l_txmsg.txfields ('05').value      := '';
                --06    H? tên môi gi?i   C
                     l_txmsg.txfields ('06').defname   := 'BRNAME';
                     l_txmsg.txfields ('06').TYPE      := 'C';
                     l_txmsg.txfields ('06').value      := '';
                --07    SÐT môi gi?i   C
                     l_txmsg.txfields ('07').defname   := 'BRPHONE';
                     l_txmsg.txfields ('07').TYPE      := 'C';
                     l_txmsg.txfields ('07').value      := '';
                --10    S? ti?n t?m gi?   N
                     l_txmsg.txfields ('10').defname   := 'AMOUNT';
                     l_txmsg.txfields ('10').TYPE      := 'N';
                     l_txmsg.txfields ('10').value      := rec.AMOUNT;
                --30    Di?n gi?i   C
                     l_txmsg.txfields ('30').defname   := 'DESC';
                     l_txmsg.txfields ('30').TYPE      := 'C';
                     l_txmsg.txfields ('30').value      := rec.NOTE;
                --88    S? TK luu ký   C
                     l_txmsg.txfields ('88').defname   := 'CUSTODYCD';
                     l_txmsg.txfields ('88').TYPE      := 'C';
                     l_txmsg.txfields ('88').value      := rec.CUSTODYCD;
                --89    Mã KH t?i NH   C
                     l_txmsg.txfields ('89').defname   := 'CIFID';
                     l_txmsg.txfields ('89').TYPE      := 'C';
                     l_txmsg.txfields ('89').value      := rec.CIFID;
                --90    H? tên   C
                     l_txmsg.txfields ('90').defname   := 'CUSTNAME';
                     l_txmsg.txfields ('90').TYPE      := 'C';
                     l_txmsg.txfields ('90').value      := rec.CUSTNAME;
                --91    Ð?a ch?   C
                     l_txmsg.txfields ('91').defname   := 'ADDRESS';
                     l_txmsg.txfields ('91').TYPE      := 'C';
                     l_txmsg.txfields ('91').value      := rec.ADDRESS;
                --92    S? gi?y t?   C
                     l_txmsg.txfields ('92').defname   := 'LICENSE';
                     l_txmsg.txfields ('92').TYPE      := 'C';
                     l_txmsg.txfields ('92').value      := rec.LICENSE;
                --93    S? TK Ngân hàng   C
                     l_txmsg.txfields ('93').defname   := 'BANKACCT';
                     l_txmsg.txfields ('93').TYPE      := 'C';
                     l_txmsg.txfields ('93').value      := rec.BANKACCT;
                --95    Ngân hàng   C
                     l_txmsg.txfields ('95').defname   := 'BANKNAME';
                     l_txmsg.txfields ('95').TYPE      := 'C';
                     l_txmsg.txfields ('95').value      := rec.BANKNAME;
                --95    Ngân hàng   C
                     l_txmsg.txfields ('96').defname   := 'REQTXNUM';
                     l_txmsg.txfields ('96').TYPE      := 'C';
                     l_txmsg.txfields ('96').value      := rec.REQTXNUM;

                BEGIN
                    IF TXPKS_#6604.FN_BATCHTXPROCESS(L_TXMSG, P_ERR_CODE, L_ERR_PARAM) <> SYSTEMNUMS.C_SUCCESS THEN
						plog.error (pkgctx, 'got error 6604: ' || p_err_code);
                        ROLLBACK;
                        RETURN errnums.C_BIZ_RULE_INVALID;
                    END IF;
                END;
            END LOOP;
        END;
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
         plog.init ('TXPKS_#6678EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#6678EX;
/
