SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca_autocall3375(
    p_camastid in varchar2
   )
IS
l_txmsg          tx.msg_rectype;
v_strDesc        tltx.txdesc%TYPE;
v_strEN_Desc     tltx.en_txdesc%TYPE;
v_strCURRDATE    VARCHAR2(10);
l_err_param      VARCHAR2(2000);
l_tltxcd tltx.tltxcd%TYPE := '3375';
p_err_code       VARCHAR2(10);
  pkgctx plog.log_ctx;
  p_bchmdl    VARCHAR2(2000);
BEGIN
  plog.setBeginSection (pkgctx, 'ca_autocall3375');
  v_strCURRDATE := cspks_system.fn_get_sysvar('SYSTEM', 'CURRDATE');
  p_err_code := systemnums.C_SUCCESS;

    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM TLTX WHERE TLTXCD = l_tltxcd;
  SELECT varvalue INTO v_strCURRDATE
  FROM sysvar
  WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

  l_txmsg.msgtype:='T';
  l_txmsg.local:='N';
  l_txmsg.tlid        := systemnums.C_HO_HOID;
  plog.debug(pkgctx, 'l_txmsg.tlid' || l_txmsg.tlid);
  SELECT SYS_CONTEXT ('USERENV', 'HOST'), SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
    INTO l_txmsg.wsname, l_txmsg.ipaddress
  FROM DUAL;
  l_txmsg.off_line    := 'N';
  l_txmsg.deltd       := txnums.c_deltd_txnormal;
  l_txmsg.txstatus    := txstatusnums.c_txcompleted;
  l_txmsg.msgsts      := '0';
  l_txmsg.ovrsts      := '0';
  l_txmsg.batchname   := p_bchmdl;
  l_txmsg.txdate      :=  to_date(v_strCURRDATE,systemnums.c_date_format);
  l_txmsg.busdate     :=  to_date(v_strCURRDATE,systemnums.c_date_format);
  l_txmsg.tltxcd      :=  l_tltxcd;
  l_txmsg.brid        := systemnums.C_BATCH_BRID;
  plog.debug(pkgctx, 'Begin loop');

  for rec IN (
         select ca.DUEDATE, ca.BEGINDATE, ca.CAMASTID, sym.symbol,  A1.cdcontent CATYPE, ca.REPORTDATE, ca.ACTIONDATE, ca.FORMOFPAYMENT,
        ca.CATYPE CATYPEVAL, ca.RATE, ca.RIGHTOFFRATE, ca.FRDATETRANSFER, ca.TODATETRANSFER,
        (CASE WHEN ca.CATYPE='014' THEN ca.EXPRICE END) ROPRICE,
        (CASE WHEN ca.CATYPE IN ('011','021','017','020') THEN ca.EXPRICE END)  TVPRICE, ca.CODEID,
        case when ca.deltd='Y' then 'Cancelled' else A2.cdcontent end STATUS,fn_getseamt_3375(ca.CODEID,CA.reportdate) TRADE, ca.description  DESCRIPTION,
        ca.TOCODEID
        from v_camast_cancelled ca, SBSECURITIES sym, ALLCODE A1, ALLCODE A2
        where ca.CODEID=sym.CODEID
        and A1.CDTYPE = 'CA'
        AND A1.CDNAME = 'CATYPE' AND A1.CDVAL = CA.CATYPE
        AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CASTATUS'
        AND CA.STATUS = A2.CDVAL
        AND CA.VALUE = p_camastid
        AND getnextworkingdate(CA.reportdate) = GETCURRDATE AND CA.status = 'N'
  )Loop
      SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
      INTO l_txmsg.txnum
      FROM DUAL;
      l_txmsg.ccyusage := REC.CODEID;
      --Set cac field giao dich
      --01  DUEDATE
      l_txmsg.txfields ('01').defname   := 'DUEDATE';
      l_txmsg.txfields ('01').TYPE      := 'C';
      l_txmsg.txfields ('01').VALUE     := rec.DUEDATE;
      --02  BEGINDATE
      l_txmsg.txfields ('02').defname   := 'BEGINDATE';
      l_txmsg.txfields ('02').TYPE      := 'C';
      l_txmsg.txfields ('02').VALUE     := rec.BEGINDATE;
      --03  CAMASTID
      l_txmsg.txfields ('03').defname   := 'CAMASTID';
      l_txmsg.txfields ('03').TYPE      := 'C';
      l_txmsg.txfields ('03').VALUE     := REPLACE(rec.CAMASTID,'.','');
      --04  SYMBOL
      l_txmsg.txfields ('04').defname   := 'SYMBOL';
      l_txmsg.txfields ('04').TYPE      := 'C';
      l_txmsg.txfields ('04').VALUE     := rec.SYMBOL;
      --05  CATYPE
      l_txmsg.txfields ('05').defname   := 'CATYPE';
      l_txmsg.txfields ('05').TYPE      := 'C';
      l_txmsg.txfields ('05').VALUE     := rec.CATYPE;
      --06  ACTIONDATE
      l_txmsg.txfields ('06').defname   := 'REPORTDATE';
      l_txmsg.txfields ('06').TYPE      := 'C';
      l_txmsg.txfields ('06').VALUE     := TO_CHAR(rec.REPORTDATE, systemnums.C_DATE_FORMAT);
      --07  ACTIONDATE
      l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
      l_txmsg.txfields ('07').TYPE      := 'C';
      l_txmsg.txfields ('07').VALUE     := TO_CHAR(rec.ACTIONDATE, systemnums.C_DATE_FORMAT);
      --08  FORMOFPAYMENT
      l_txmsg.txfields ('08').defname   := 'FORMOFPAYMENT';
      l_txmsg.txfields ('08').TYPE      := 'T';
      l_txmsg.txfields ('08').VALUE     := rec.FORMOFPAYMENT;
      --09  CATYPEVAL
      l_txmsg.txfields ('09').defname   := 'CATYPEVAL';
      l_txmsg.txfields ('09').TYPE      := 'C';
      l_txmsg.txfields ('09').VALUE     := rec.CATYPEVAL;
      --10  RATE
      l_txmsg.txfields ('10').defname   := 'RATE';
      l_txmsg.txfields ('10').TYPE      := 'C';
      l_txmsg.txfields ('10').VALUE     := rec.RATE;
      --11  RIGHTOFFRATE
      l_txmsg.txfields ('11').defname   := 'RIGHTOFFRATE';
      l_txmsg.txfields ('11').TYPE      := 'T';
      l_txmsg.txfields ('11').VALUE     := rec.RIGHTOFFRATE;
      --12  FRDATETRANSFER
      l_txmsg.txfields ('12').defname   := 'FRDATETRANSFER';
      l_txmsg.txfields ('12').TYPE      := 'D';
      l_txmsg.txfields ('12').VALUE     := rec.FRDATETRANSFER;
      --13  TODATETRANSFER
      l_txmsg.txfields ('13').defname   := 'TODATETRANSFER';
      l_txmsg.txfields ('13').TYPE      := 'D';
      l_txmsg.txfields ('13').VALUE     := rec.TODATETRANSFER;
      --14  ROPRICE
      l_txmsg.txfields ('14').defname   := 'ROPRICE';
      l_txmsg.txfields ('14').TYPE      := 'T';
      l_txmsg.txfields ('14').VALUE     := rec.ROPRICE;
      --15  TVPRICE
      l_txmsg.txfields ('15').defname   := 'TVPRICE';
      l_txmsg.txfields ('15').TYPE      := 'T';
      l_txmsg.txfields ('15').VALUE     := rec.TVPRICE;
      --16  CODEID
      l_txmsg.txfields ('16').defname   := 'CODEID';
      l_txmsg.txfields ('16').TYPE      := 'C';
      l_txmsg.txfields ('16').VALUE     := rec.CODEID;
      --20  STATUS
      l_txmsg.txfields ('20').defname   := 'STATUS';
      l_txmsg.txfields ('20').TYPE      := 'C';
      l_txmsg.txfields ('20').VALUE     := rec.STATUS;
      --23  TRADE
      l_txmsg.txfields ('23').defname   := 'TRADE';
      l_txmsg.txfields ('23').TYPE      := 'N';
      l_txmsg.txfields ('23').VALUE     := rec.TRADE;
      --30  DESC
      l_txmsg.txfields ('30').defname   := 'DESC';
      l_txmsg.txfields ('30').TYPE      := 'N';
      l_txmsg.txfields ('30').VALUE     := rec.DESCRIPTION;
      --40  TOCODEID
      l_txmsg.txfields ('40').defname   := 'TOCODEID';
      l_txmsg.txfields ('40').TYPE      := 'N';
      l_txmsg.txfields ('40').VALUE     := rec.TOCODEID;

      BEGIN
          IF txpks_#3375.fn_batchtxprocess (l_txmsg,
                                           p_err_code,
                                           l_err_param) <> systemnums.c_success
          THEN
              ROLLBACK;
             plog.setEndSection (pkgctx, 'ca_autocall3375');
             RETURN;
          END IF;
      END;
  end loop;
  plog.setEndSection (pkgctx, 'ca_autocall3375');

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
