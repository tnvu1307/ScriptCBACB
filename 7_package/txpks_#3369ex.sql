SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_#3369ex
/**----------------------------------------------------------------------------------------------------
 ** Package: TXPKS_#3369EX
 ** and is copyrighted by FSS.
 **
 **    All rights reserved.  No part of this work may be reproduced, stored in a retrieval system,
 **    adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
 **    graphic, optic recording or otherwise, translated in any language or computer language,
 **    without the prior written permission of Financial Software Solutions. JSC.
 **
 **  MODIFICATION HISTORY
 **  Person      Date           Comments
 **  System      06/10/2014     Created
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
PROCEDURE CUT_STOCK_EXCUTE(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2);
END;
 
 
/


CREATE OR REPLACE PACKAGE BODY txpks_#3369ex
IS
   pkgctx   plog.log_ctx;
   logrow   tlogdebug%ROWTYPE;

   c_camastid         CONSTANT CHAR(2) := '02';
   c_symbol           CONSTANT CHAR(2) := '04';
   c_bankid           CONSTANT CHAR(2) := '05';
   c_bankacc          CONSTANT CHAR(2) := '08';
   c_bankname         CONSTANT CHAR(2) := '85';
   c_bankaccname      CONSTANT CHAR(2) := '86';
   c_qtty             CONSTANT CHAR(2) := '21';
   c_amt              CONSTANT CHAR(2) := '10';
   c_benefcustname    CONSTANT CHAR(2) := '82';
   c_benefacct        CONSTANT CHAR(2) := '81';
   c_benefname        CONSTANT CHAR(2) := '80';
   c_potxdate         CONSTANT CHAR(2) := '98';
   c_potxnum          CONSTANT CHAR(2) := '99';
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
BEGIN
    plog.setbeginsection (pkgctx, 'fn_txAftAppUpdate');
    plog.debug (pkgctx, '<<BEGIN OF fn_txAftAppUpdate');
   /***************************************************************************************************
    ** PUT YOUR SPECIFIC AFTER PROCESS HERE. DO NOT COMMIT/ROLLBACK HERE, THE SYSTEM WILL DO IT
    ***************************************************************************************************/
    if p_txmsg.deltd<>'Y' then
        CUT_STOCK_EXCUTE(p_txmsg,p_err_code);
        if p_err_code <> systemnums.C_SUCCESS THEN
            plog.setendsection (pkgctx, 'pr_3387_CUT_STOCK_EXCUTE');
            RETURN errnums.C_BIZ_RULE_INVALID;
        end if;
    End If;


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

PROCEDURE CUT_STOCK_EXCUTE(p_txmsg in tx.msg_rectype,p_err_code  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);

      l_alternateacct   char(1);
      l_autotrf         char(1);
      l_potxnum         VARCHAR2(10);
      v_count number;
       v_codeid varchar2(10);
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_3387_CUT_STOCK_EXCUTE');
    SELECT varvalue
         INTO v_strCURRDATE
         FROM sysvar
         WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype :='T';
    l_txmsg.local   :='N';
    begin
        plog.debug (pkgctx, 'p_txmsg.TLID' || p_txmsg.TLID);
        l_txmsg.tlid        := p_txmsg.TLID;
    exception when others then
        l_txmsg.tlid        := systemnums.c_system_userid;
    end;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'DAY';
    l_txmsg.busdate     := p_txmsg.busdate;

    l_txmsg.txdate      := to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.reftxnum    := p_txmsg.txnum;
    l_txmsg.tltxcd      := '3387';

    -- Lay thong tin bang ke
    SELECT NVL(MAX(ODR)+1,1) into l_potxnum
    FROM (
            SELECT ROWNUM ODR, INVACCT
            FROM (SELECT TXNUM INVACCT FROM POMAST WHERE BRID = p_txmsg.brid ORDER BY TXNUM)
         );

    SELECT p_txmsg.brid || LPAD (l_potxnum, 6, '0')
        INTO l_potxnum
    FROM DUAL;

    l_potxnum := nvl(P_TXMSG.TXFIELDS('99').VALUE, l_potxnum);
    select codeid into v_codeid from sbsecurities where symbol =P_TXMSG.TXFIELDS('04').VALUE;
    -- BANG KE UNC
    INSERT INTO POMAST(TXDATE, TXNUM, AMT, BRID, STATUS, BANKID, BANKNAME, BANKACC, BANKACCNAME, GLACCTNO, FEETYPE, POTYPE, BENEFACCT, BENEFNAME, BENEFCUSTNAME, DESCRIPTION,CODEID)
    SELECT TO_DATE(P_TXMSG.TXDATE, SYSTEMNUMS.C_DATE_FORMAT) TXDATE, L_POTXNUM,
           P_TXMSG.TXFIELDS('10').VALUE AMT, P_TXMSG.BRID BRID, 'A' STATUS, P_TXMSG.TXFIELDS('05').VALUE BANKID,
           P_TXMSG.TXFIELDS('85').VALUE BANKNAME, P_TXMSG.TXFIELDS('08').VALUE BANKACC, P_TXMSG.TXFIELDS('86').VALUE BANKACCNAME,
           '' GLACCTNO, 'I' FEETYPE, '002' POTYPE, P_TXMSG.TXFIELDS('81').VALUE BENEFACCT, P_TXMSG.TXFIELDS('80').VALUE BENEFNAME,
           P_TXMSG.TXFIELDS('82').VALUE BENEFCUSTNAME, P_TXMSG.TXFIELDS('30').VALUE DESCRIPTION, v_codeid CODEID
    FROM DUAL;

    UPDATE tllogfld SET CVALUE = l_potxnum WHERE TXNUM = P_TXMSG.TXNUM AND FLDCD ='99';

    for rec in
    (
       SELECT  CA.AUTOID,cf.custodycd , CAMAST.CAMASTID,
                    CA.AFACCTNO, camast.codeid codeid_org, CAMAST.TOCODEID CODEID, A2.CDCONTENT CATYPE,
                    CA.BALANCE BALANCE, (CA.qtty + ca.sendqtty + ca.cutqtty - CA.TQTTY )  QTTY,
                    CA.NMQTTY,(CA.qtty + ca.sendqtty + ca.cutqtty  - CA.TQTTY - CA.NMQTTY )  MQTTY,
                    (CA.qtty+ca.sendqtty+ca.cutqtty  - CA.TQTTY) * CAMAST.EXPRICE AMT,
                    SYM.SYMBOL, A1.CDCONTENT STATUS, CA.AFACCTNO||CAMAST.TOCODEID SEACCTNO,
                    CA.AFACCTNO||CAMAST.OPTCODEID OPTSEACCTNO,SYM.PARVALUE PARVALUE,
                    CAMAST.REPORTDATE REPORTDATE, CAMAST.ACTIONDATE,CAMAST.EXPRICE,
                    (CASE WHEN SUBSTR(CF.custodycd,4,1) = 'F'
                        THEN to_char( 'Secondary-offer shares, '
                            ||SYM.SYMBOL ||', exdate on ' || to_char (camast.reportdate,'DD/MM/YYYY')
                            ||',ratio ' ||camast.RIGHTOFFRATE ||', quantity ' ||ca.pqtty ||', price '|| CAMAST.EXPRICE ||', ' || cf.fullname)
                        else to_char( 'Thuc cat tien dkqm, '||SYM.SYMBOL ||', ngay chot ' ||to_char (camast.reportdate,'DD/MM/YYYY')
                            ||', ty le ' ||camast.RIGHTOFFRATE ||', SL ' ||ca.pqtty ||', gia '|| CAMAST.EXPRICE ||', ' || cf.fullname ) end ) description,
                    SYM_ORG.symbol symbol_org, camast.isincode
            FROM  SBSECURITIES SYM, ALLCODE A1, CAMAST, CASCHD  CA, AFMAST AF , CFMAST CF , DDMAST DD, ALLCODE A2, SBSECURITIES SYM_ORG
            WHERE A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS AND CAMAST.TOCODEID = SYM.CODEID AND CAMAST.catype='014'
                    AND CAMAST.camastid  = CA.camastid AND CA.AFACCTNO = AF.ACCTNO AND CAMAST.catype ='014' AND CAMAST.CATYPE = A2.CDVAL AND A2.CDTYPE = 'CA'
                    AND A2.CDNAME = 'CATYPE' AND AF.CUSTID = CF.CUSTID AND CA.status IN('M','O') AND CA.status <>'Y' AND CA.Deltd <> 'Y'
                    AND CA.balance > 0 AND (CA.qtty+ ca.sendqtty+ca.cutqtty- CA.TQTTY)  > 0
                    and SYM_ORG.codeid=camast.codeid
                    AND DD.AFACCTNO = AF.ACCTNO AND DD.ISDEFAULT ='Y'
                    and camast.camastid = P_TXMSG.TXFIELDS('02').VALUE
    )
    loop
        -- CHI TIET BANG KE UNC
        INSERT INTO PODETAILS(AUTOID, POTXNUM, POTXDATE, AFACCTNO, CAMASTID)
        SELECT SEQ_PODETAILS.NEXTVAL, L_POTXNUM, TO_DATE(V_STRCURRDATE,SYSTEMNUMS.C_DATE_FORMAT) POTXDATE,
            REC.AFACCTNO, REC.CAMASTID FROM DUAL;



        --Set txnum
        SELECT systemnums.C_BATCH_PREFIXED
                         || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
                  INTO l_txmsg.txnum
                  FROM DUAL;
        --Set txtime
        select to_char(sysdate,'hh24:mi:ss') into l_txmsg.txtime from dual;
        --Set brid
        begin
            l_txmsg.brid        := p_txmsg.BRID;
        exception when others then
            l_txmsg.brid        := substr(rec.AFACCTNO,1,4);
        end;


        --Set cac field giao dich
        --01  AUTOID    C
        l_txmsg.txfields ('01').defname   := 'AUTOID';
        l_txmsg.txfields ('01').TYPE      := 'C';
        l_txmsg.txfields ('01').VALUE     := rec.AUTOID;
        --02  CAMASTID    C
        l_txmsg.txfields ('02').defname   := 'CAMASTID';
        l_txmsg.txfields ('02').TYPE      := 'C';
        l_txmsg.txfields ('02').VALUE     := rec.CAMASTID;
        --03  AFACCTNO    C
        l_txmsg.txfields ('03').defname   := 'AFACCTNO';
        l_txmsg.txfields ('03').TYPE      := 'C';
        l_txmsg.txfields ('03').VALUE     := rec.AFACCTNO;
        --04  SYMBOL      C
        l_txmsg.txfields ('04').defname   := 'SYMBOL';
        l_txmsg.txfields ('04').TYPE      := 'C';
        l_txmsg.txfields ('04').VALUE     := rec.SYMBOL;

        --22  CODEID      C
        l_txmsg.txfields ('22').defname   := 'CODEID';
        l_txmsg.txfields ('22').TYPE      := 'C';
        l_txmsg.txfields ('22').VALUE     := rec.CODEID;

        --71  CODEID      C
        l_txmsg.txfields ('71').defname   := 'CODEID';
        l_txmsg.txfields ('71').TYPE      := 'C';
        l_txmsg.txfields ('71').VALUE     := rec.CODEID_ORG;


        --06  SEACCTNO    C
        l_txmsg.txfields ('06').defname   := 'SEACCTNO';
        l_txmsg.txfields ('06').TYPE      := 'C';
        l_txmsg.txfields ('06').VALUE     := rec.SEACCTNO;

        --15  GLMAST    C
        l_txmsg.txfields ('15').defname   := 'GLMAST';
        l_txmsg.txfields ('15').TYPE      := 'C';
        l_txmsg.txfields ('15').VALUE     := '';

        --05 BANKID
        l_txmsg.txfields ('05').defname   := 'BANKID';
        l_txmsg.txfields ('05').TYPE      := 'C';
        l_txmsg.txfields ('05').VALUE     := L_TXMSG.TXFIELDS('05').VALUE;

        --08 BANKACC
        l_txmsg.txfields ('08').defname   := 'BANKACC';
        l_txmsg.txfields ('08').TYPE      := 'C';
        l_txmsg.txfields ('08').VALUE     := L_TXMSG.TXFIELDS('08').VALUE;

        --86 BANKACC
        l_txmsg.txfields ('85').defname   := 'BANKNAME';
        l_txmsg.txfields ('85').TYPE      := 'C';
        l_txmsg.txfields ('85').VALUE     := L_TXMSG.TXFIELDS('85').VALUE;

        --86 BANKACC
        l_txmsg.txfields ('86').defname   := 'BANKACCNAME';
        l_txmsg.txfields ('86').TYPE      := 'C';
        l_txmsg.txfields ('86').VALUE     := L_TXMSG.TXFIELDS('86').VALUE;

        --21  QTTY     N
        l_txmsg.txfields ('21').defname   := 'QTTY';
        l_txmsg.txfields ('21').TYPE      := 'C';
        l_txmsg.txfields ('21').VALUE     := rec.QTTY;

        --07  BALANCE     N
        l_txmsg.txfields ('07').defname   := 'BALANCE';
        l_txmsg.txfields ('07').TYPE      := 'C';
        l_txmsg.txfields ('07').VALUE     := rec.BALANCE;

        --10  AAMT     N
        l_txmsg.txfields ('10').defname   := 'AAMT';
        l_txmsg.txfields ('10').TYPE      := 'C';
        l_txmsg.txfields ('10').VALUE     := rec.AMT;

        --82 BENEFCUSTNAME
        l_txmsg.txfields ('82').defname   := 'BENEFCUSTNAME';
        l_txmsg.txfields ('82').TYPE      := 'C';
        l_txmsg.txfields ('82').VALUE     := L_TXMSG.TXFIELDS('82').VALUE;

        --81 BENEFACCT
        l_txmsg.txfields ('81').defname   := 'BENEFACCT';
        l_txmsg.txfields ('81').TYPE      := 'C';
        l_txmsg.txfields ('81').VALUE     := L_TXMSG.TXFIELDS('81').VALUE;

        --80 BENEFNAME
        l_txmsg.txfields ('80').defname   := 'BENEFNAME';
        l_txmsg.txfields ('80').TYPE      := 'C';
        l_txmsg.txfields ('80').VALUE     := L_TXMSG.TXFIELDS('80').VALUE;

        --09  OPTSEACCTNO    C
        l_txmsg.txfields ('09').defname   := 'OPTSEACCTNO';
        l_txmsg.txfields ('09').TYPE      := 'C';
        l_txmsg.txfields ('09').VALUE     := rec.OPTSEACCTNO;

        --98  POTXDATE    C
        l_txmsg.txfields ('98').defname   := 'POTXDATE';
        l_txmsg.txfields ('98').TYPE      := 'C';
        l_txmsg.txfields ('98').VALUE     := to_date(v_strCURRDATE,systemnums.c_date_format);

        --99  POTXDATE    C
        l_txmsg.txfields ('99').defname   := 'POTXNUM';
        l_txmsg.txfields ('99').TYPE      := 'C';
        l_txmsg.txfields ('99').VALUE     := l_potxnum;

        --30  DESC C camast.exerate , NULL TXDESC
        l_txmsg.txfields ('30').defname   := 'DESC';
        l_txmsg.txfields ('30').TYPE      := 'C';
        l_txmsg.txfields ('30').VALUE     := REC.description;

        --31  PODESC
        l_txmsg.txfields ('31').defname   := 'PODESC';
        l_txmsg.txfields ('31').TYPE      := 'C';
        l_txmsg.txfields ('31').VALUE     := 'UNC thuc cat quyen mua';

        --17  POTYPE
        l_txmsg.txfields ('17').defname   := 'POTYPE';
        l_txmsg.txfields ('17').TYPE      := 'C';
        l_txmsg.txfields ('17').VALUE     := '002';

        --32  IORO
        l_txmsg.txfields ('32').defname   := 'IORO';
        l_txmsg.txfields ('32').TYPE      := 'C';
        l_txmsg.txfields ('32').VALUE     := 'I';

        BEGIN
            IF txpks_#3387.fn_batchtxprocess (l_txmsg,
                                             p_err_code,
                                             l_err_param
               ) <> systemnums.c_success
            THEN
               plog.debug (pkgctx,
                           'got error 3387: ' || p_err_code
               );
               ROLLBACK;
               RETURN;
            END IF;
           --locpt: update trang thai moi: da thuc hien 3387-------
                    begin
                       UPDATE CASCHD SET STATUS ='F' WHERE AUTOID=rec.AUTOID;
                   --    select count(*) into v_count from CASCHD where CAMASTID=rec.CAMASTID and status = 'M' and deltd ='N' ;
                    --   if(v_count =0) then
                        -- cap nhat trang thai camast neu da cap nhat het caschd
                         UPDATE CAMAST SET STATUS ='F' WHERE CAMASTID=rec.CAMASTID;
                    --   end if;

                    exception when others then
                        plog.debug (pkgctx,
                               'update cashchd 3369 error: ' || p_err_code
                           );
                           ROLLBACK;
                           RETURN;
                    end;
                    -- end locpt--------------------------------------------

        END;
    end loop;

    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_3387_CUT_STOCK_EXCUTE');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_3387_CUT_STOCK_EXCUTE');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_3387_CUT_STOCK_EXCUTE');
      RAISE errnums.E_SYSTEM_ERROR;
  END CUT_STOCK_EXCUTE;


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
         plog.init ('TXPKS_#3369EX',
                    plevel => NVL(logrow.loglevel,30),
                    plogtable => (NVL(logrow.log4table,'N') = 'Y'),
                    palert => (NVL(logrow.log4alert,'N') = 'Y'),
                    ptrace => (NVL(logrow.log4trace,'N') = 'Y')
            );
END TXPKS_#3369EX;
/
