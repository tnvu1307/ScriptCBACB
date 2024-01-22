SET DEFINE OFF;
CREATE OR REPLACE PACKAGE txpks_auto
IS

    PROCEDURE pr_init (p_level number);
    PROCEDURE pr_RightoffRegiter(p_camastid varchar,p_account varchar,p_qtty number,p_desc varchar2,p_err_code  OUT varchar2,p_txdate  OUT varchar2,p_txnum  OUT varchar2);

END;
/


CREATE OR REPLACE PACKAGE BODY txpks_auto
-- Refactored procedure pr_autotxprocess

IS
   pkgctx   plog.log_ctx:= plog.init ('txpks_txpks_auto',
                 plevel => 30,
                 plogtable => true,
                 palert => false,
                 ptrace => false);
   logrow   tlogdebug%ROWTYPE;

CURSOR curs_build_msg
   IS
      SELECT --'' fld09,                                    --custodycd   fld09,
            a.codeid fld01,
             a.symbol fld07,
             DECODE (a.exectype, 'MS', '1', '0') fld60, --ismortage   fld60, -- FOR 8885
             a.actype fld02,
             a.afacctno || a.codeid fld06,                --seacctno    fld06,
             a.afacctno fld03,
             --'' fld50,                            --a.CUSTNAME        fld50,
             a.timetype fld20,
             a.effdate fld19,
             --a.expdate fld21,
             getcurrdate fld21,
             a.exectype fld22,
             a.outpriceallow fld34,
             a.nork fld23,
             a.matchtype fld24,
             a.via fld25,
             a.clearday fld10,
             a.clearcd fld26,
             'O' fld72,                                       --puttype fld72,
             (CASE WHEN a.exectype IN ('AB','AS') AND a.pricetype='MTL' THEN 'LO' ELSE a.pricetype END ) fld27,
              -- PhuongHT edit for sua lenh MTL
             a.quantity fld12,                      --a.ORDERQTTY       fld12,
             a.quoteprice fld11,
             0 fld18,                               --a.ADVSCRAMT       fld18,
             0 fld17,                               --a.ORGQUOTEPRICE   fld17,
             0 fld16,                               --a.ORGORDERQTTY    fld16,
             0 fld31,                               --a.ORGSTOPPRICE    fld31,
             a.bratio fld13,
             a.limitprice fld14,                               --a.LIMITPRICE      fld14,
             0 fld40,                                                -- FEEAMT
             --'' fld28,                           --a.VOUCHER         fld28,
             --'' fld29,                           --a.CONSULTANT      fld29,
             --'' fld04,                           --a.ORDERID         fld04,
             a.reforderid fld08,
             b.parvalue fld15,
             a.dfacctno fld95,
             100 fld99,                             --a.HUNDRED         fld99,
             c.tradeunit fld98,
             1 fld96,                                                   -- GTC
             '' fld97,                                                  --mode
             '' fld33,                                              --clientid
             '' fld73,                                            --contrafirm
             '' fld32,                                              --traderid
             '' fld71,                                             --contracus
             a.acctno,                              -- only for test mktstatus
             '' fld30,                              --a.DESC            fld30,
             a.refacctno,
             a.orgacctno,
             a.refprice,
             a.refquantity,
             c.ceilingprice,
             c.floorprice,
             c.marginprice,
             c.marginrefprice,
             b.tradeplace,
             b.sectype,
             c.tradelot,
             c.securedratiomin,
             c.securedratiomax,
             a.SPLOPT,
             a.SPLVAL,
             a.ISDISPOSAL,
             a.username username,
             a.SSAFACCTNO fld94,
             '' fld35,
             a.tlid tlid,
             a.quoteqtty fld80
      FROM fomast a, sbsecurities b, securities_info c
      WHERE     a.book = 'A'
            AND a.timetype <> 'G'
            AND a.status = 'P'
            and a.direct='N'
            and ((a.pricetype = 'LO' and a.quoteprice <> 0) or (a.pricetype <> 'LO'))
            and a.quantity <> 0
            AND a.codeid = b.codeid
            AND a.codeid = c.codeid;


   PROCEDURE pr_init (p_level number)
   IS
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
      plog.init ('txpks_txpks_auto',
                 plevel => NVL (logrow.loglevel, 30),
                 plogtable => (NVL (logrow.log4table, 'N') = 'Y'),
                 palert => (NVL (logrow.log4alert, 'N') = 'Y'),
                 ptrace => (NVL (logrow.log4trace, 'N') = 'Y')
      );
   
   END;

  ---------------------------------pr_RightoffRegiter------------------------------------------------
  PROCEDURE pr_RightoffRegiter(p_camastid varchar,p_account varchar,p_qtty number,p_desc varchar2,p_err_code  OUT varchar2,p_txdate  OUT varchar2,p_txnum  OUT varchar2)
  IS
      l_txmsg               tx.msg_rectype;
      v_strCURRDATE varchar2(20);
      l_err_param varchar2(300);
      l_symbol  varchar2(20);
      l_codeid   varchar2(20);
      l_exprice number;
      l_optcodeid varchar2(20);
      l_iscorebank  number;
      l_balance number;
      l_caschdautoid NUMBER;
    l_maxqtty NUMBER;
    l_parvalue NUMBER;
  BEGIN
    plog.setbeginsection(pkgctx, 'pr_RightoffRegiter');
    SELECT TO_DATE (varvalue, systemnums.c_date_format)
               INTO v_strCURRDATE
               FROM sysvar
               WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';
    l_txmsg.msgtype:='T';
    l_txmsg.local:='N';
    l_txmsg.tlid        := systemnums.c_system_userid;
    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
             SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
    FROM DUAL;
    l_txmsg.off_line    := 'N';
    l_txmsg.deltd       := txnums.c_deltd_txnormal;
    l_txmsg.txstatus    := txstatusnums.c_txcompleted;
    l_txmsg.msgsts      := '0';
    l_txmsg.ovrsts      := '0';
    l_txmsg.batchname   := 'INT';
    l_txmsg.txdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate:=to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd:='3384';

    --Set txnum
    SELECT systemnums.C_BATCH_PREFIXED
                     || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
              INTO l_txmsg.txnum
              FROM DUAL;
    l_txmsg.brid        := substr(p_account,1,4);

  p_txnum:=l_txmsg.txnum;
  p_txdate:=l_txmsg.txdate;

  select ca.autoid, b.SYMBOL,a.exprice,a.codeid,optcodeid,CA.balance + CA.pbalance balance, ca.pqtty,a.parvalue,
        (case when af.corebank ='Y' then 0 else 1 end) iscorebank
    into l_caschdautoid,l_symbol,l_exprice , l_codeid,l_optcodeid,l_balance,l_maxqtty, l_parvalue,l_iscorebank
  from camast a, caschd ca, sbsecurities b,afmast af
        where a.codeid = b.codeid
        and a.camastid=p_camastid and ca.camastid=a.camastid
        and ca.afacctno=p_account
        and af.acctno=ca.afacctno;

    --Set cac field giao dich
    --01   AUTOID      C
    l_txmsg.txfields ('01').defname   := 'AUTOID';
    l_txmsg.txfields ('01').TYPE      := 'C';
    l_txmsg.txfields ('01').VALUE     := to_char(nvl(l_caschdautoid,''));
    --02   CAMASTID      C
    l_txmsg.txfields ('02').defname   := 'CAMASTID';
    l_txmsg.txfields ('02').TYPE      := 'C';
    l_txmsg.txfields ('02').VALUE     := p_camastid;
    --03   AFACCTNO      C
    l_txmsg.txfields ('03').defname   := 'AFACCTNO';
    l_txmsg.txfields ('03').TYPE      := 'C';
    l_txmsg.txfields ('03').VALUE     := p_account;
    --06   SEACCTNO      C
    l_txmsg.txfields ('06').defname   := 'SEACCTNO';
    l_txmsg.txfields ('06').TYPE      := 'C';
    l_txmsg.txfields ('06').VALUE     := p_account || l_codeid;
    --08   FULLNAME      C
    l_txmsg.txfields ('08').defname   := 'FULLNAME';
    l_txmsg.txfields ('08').TYPE      := 'C';
    l_txmsg.txfields ('08').VALUE     := '';
    --09   OPTSEACCTNO   C
    l_txmsg.txfields ('09').defname   := 'OPTSEACCTNO';
    l_txmsg.txfields ('09').TYPE      := 'C';
    l_txmsg.txfields ('09').VALUE     := p_account || l_optcodeid;
    --04   SYMBOL        C
    l_txmsg.txfields ('04').defname   := 'SYMBOL';
    l_txmsg.txfields ('04').TYPE      := 'C';
    l_txmsg.txfields ('04').VALUE     := l_symbol;
    --05   EXPRICE       N
    l_txmsg.txfields ('05').defname   := 'EXPRICE';
    l_txmsg.txfields ('05').TYPE      := 'N';
    l_txmsg.txfields ('05').VALUE     := l_exprice;
    --07   BALANCE       N
    l_txmsg.txfields ('07').defname   := 'BALANCE';
    l_txmsg.txfields ('07').TYPE      := 'N';
    l_txmsg.txfields ('07').VALUE     := 0;
    --20   MAXQTTY          N
    l_txmsg.txfields ('20').defname   := 'MAXQTTY';
    l_txmsg.txfields ('20').TYPE      := 'N';
    l_txmsg.txfields ('20').VALUE     := l_maxqtty;
    --21   QTTY          N
    l_txmsg.txfields ('21').defname   := 'QTTY';
    l_txmsg.txfields ('21').TYPE      := 'N';
    l_txmsg.txfields ('21').VALUE     := p_qtty;
    --22   PARVALUE          N
    l_txmsg.txfields ('22').defname   := 'PARVALUE';
    l_txmsg.txfields ('22').TYPE      := 'N';
    l_txmsg.txfields ('22').VALUE     := l_parvalue;
    --23   REPORTDATE          N
    l_txmsg.txfields ('23').defname   := 'REPORTDATE';
    l_txmsg.txfields ('23').TYPE      := 'C';
    l_txmsg.txfields ('23').VALUE     := '';
    --30   DESCRIPTION   C
    l_txmsg.txfields ('30').defname   := 'DESCRIPTION';
    l_txmsg.txfields ('30').TYPE      := 'C';
    l_txmsg.txfields ('30').VALUE :=p_desc;
    --16   TASKCD        C
    l_txmsg.txfields ('16').defname   := 'TASKCD';
    l_txmsg.txfields ('16').TYPE      := 'C';
    l_txmsg.txfields ('16').VALUE     := '';
    --40   STATUS        C
    l_txmsg.txfields ('40').defname   := 'STATUS';
    l_txmsg.txfields ('40').TYPE      := 'C';
    l_txmsg.txfields ('40').VALUE :='M';
    --60   ISCOREBANK        C
    l_txmsg.txfields ('60').defname   := 'ISCOREBANK';
    l_txmsg.txfields ('60').TYPE      := 'N';
    l_txmsg.txfields ('60').VALUE :=l_iscorebank;
    --90   CUSTNAME    C
    l_txmsg.txfields ('90').defname   := 'CUSTNAME';
    l_txmsg.txfields ('90').TYPE      := 'C';
    l_txmsg.txfields ('90').VALUE :='';
    --91   ADDRESS     C
    l_txmsg.txfields ('91').defname   := 'ADDRESS';
    l_txmsg.txfields ('91').TYPE      := 'C';
    l_txmsg.txfields ('91').VALUE :='';
    --92   LICENSE     C
    l_txmsg.txfields ('92').defname   := 'LICENSE';
    l_txmsg.txfields ('92').TYPE      := 'C';
    l_txmsg.txfields ('92').VALUE :='';
    --93   IDDATE    C
    l_txmsg.txfields ('93').defname   := 'IDDATE';
    l_txmsg.txfields ('93').TYPE      := 'C';
    l_txmsg.txfields ('93').VALUE :='';
    --94   IDPLACE    C
    l_txmsg.txfields ('94').defname   := 'IDPLACE';
    l_txmsg.txfields ('94').TYPE      := 'C';
    l_txmsg.txfields ('94').VALUE :='';
    --95   ISSNAME    C
    l_txmsg.txfields ('95').defname   := 'ISSNAME';
    l_txmsg.txfields ('95').TYPE      := 'C';
    l_txmsg.txfields ('95').VALUE :='';
    --96   CUSTODYCD    C
    l_txmsg.txfields ('96').defname   := 'CUSTODYCD';
    l_txmsg.txfields ('96').TYPE      := 'C';
    l_txmsg.txfields ('96').VALUE :='';
    --10   AMT          N
    l_txmsg.txfields ('10').defname   := 'AMT';
    l_txmsg.txfields ('10').TYPE      := 'N';
    l_txmsg.txfields ('10').VALUE     := round(nvl(p_qtty,0) * nvl(l_exprice,0),0);

    BEGIN
        IF txpks_#3384.fn_autotxprocess (l_txmsg,
                                         p_err_code,
                                         l_err_param
           ) <> systemnums.c_success
        THEN
           plog.debug (pkgctx,
                       'got error 3384: ' || p_err_code
           );
           ROLLBACK;
           RETURN;
        END IF;
    END;
    p_err_code:=0;
    plog.setendsection(pkgctx, 'pr_RightoffRegiter');
  EXCEPTION
  WHEN OTHERS
   THEN
      plog.debug (pkgctx,'got error on pr_RightoffRegiter');
      ROLLBACK;
      p_err_code := errnums.C_SYSTEM_ERROR;
      plog.error (pkgctx, SQLERRM);
      plog.setendsection (pkgctx, 'pr_RightoffRegiter');
      RAISE errnums.E_SYSTEM_ERROR;
  END pr_RightoffRegiter;
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
      plog.init ('txpks_txpks_auto',
                 plevel => NVL (logrow.loglevel, 30),
                 plogtable => (NVL (logrow.log4table, 'N') = 'Y'),
                 palert => (NVL (logrow.log4alert, 'N') = 'Y'),
                 ptrace => (NVL (logrow.log4trace, 'N') = 'Y')
      );
   

END txpks_auto;
/
