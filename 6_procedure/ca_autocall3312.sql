SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca_autocall3312(
    p_camastid in varchar2
   )
IS
  pkgctx   plog.log_ctx;
  logrow   tlogdebug%ROWTYPE;
  l_txmsg tx.msg_rectype;
  v_strCURRDATE varchar2(20);
  v_strPREVDATE varchar2(20);
  v_strNEXTDATE varchar2(20);
  v_strDesc varchar2(1000);
  v_strEN_Desc varchar2(1000);
  v_blnVietnamese BOOLEAN;
  v_dblProfit number(20,0);
  v_dblLoss number(20,0);
  v_dblAVLRCVAMT  number(20,0);
  v_dblVATRATE number(20,0);
  p_err_code varchar2(100);
  l_err_param varchar2(300);
  l_MaxRow number(20,0);
BEGIN
    p_err_code := systemnums.C_SUCCESS;
    plog.setbeginsection(pkgctx, 'ca_autocall3312');

    l_err_param:='SUCCESS';
    SELECT TXDESC,EN_TXDESC into v_strDesc, v_strEN_Desc FROM  TLTX WHERE TLTXCD='3312';
     SELECT varvalue
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
    --l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate      := to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.busdate     := to_date(v_strCURRDATE,systemnums.c_date_format);
    l_txmsg.tltxcd      := '3312';

    for rec in (
        SELECT
        V_STRCURRDATE ,
        VALUE CAMASTID,
        SYMBOL,
        CODEID,
        CATYPE,
        FORMOFPAYMENT,
        CATYPEVAL,
        TOCODEID,
        DUEDATE,
        BEGINDATE,
        REPORTDATE,
        FRDATETRANSFER,
        TODATETRANSFER,
        ACTIONDATE,
        RATE,
        RIGHTOFFRATE,
        TRADE,
        TVPRICE,
        MEETINGDATETIME,
        ROPRICE,
        STATUS,
        v_strEN_Desc DESCRIPTION,
        'N' LTYPE
        FROM
        (
            SELECT VALUE, AUTOID, SYMBOL, CAMASTID, CODEID, EXCODEID, TYPEID, A1.CDCONTENT CATYPE, KHQDATE,
            REPORTDATE, DUEDATE, ACTIONDATE, BEGINDATE, EXPRICE, EXRATE, RIGHTOFFRATE,MEETINGDATETIME,
            OPTCODEID, DEVIDENTSHARES, SPLITRATE, INTERESTRATE, DESCRIPTION, CONTENTS,FORMOFPAYMENT,
            INTERESTPERIOD, A2.CDCONTENT STATUS, FRDATERETAIL, TODATERETAIL, TRFLIMIT, ROPRICE,
            TVPRICE,
            (CASE WHEN CATYPE ='011' AND DEVIDENTRATE <> 0 THEN TO_CHAR(DEVIDENTRATE)
                WHEN CATYPE ='011' AND DEVIDENTRATE = 0 THEN DEVIDENTSHARES ELSE  RATE END ) RATE,
            PITRATE, PITRATEMETHOD_CD, A3.CDCONTENT PITRATEMETHOD, CATYPEVAL, FRDATETRANSFER,
            TODATETRANSFER, PITRATESE, INACTIONDATE, AMT, QTTY, TAXAMT, AMTAFTER,
            STATUSVAL, ISCHANGESTT, MAKERID, APPRVID, ISRIGHTOFF, TRADE, TRADE3375,
            TOSYMBOL, TOCODEID, CAQTTY, CANCELDATE, RECEIVEDATE, ISINCODE, ADVDESC,
            TYPERATE, DEVIDENTRATE, DEVIDENTVALUE, REMAINDEVIDENTRATE, REMAINDEVIDENTVALUE,
            TRADEDATE, RATE1, STATUS1
            FROM V_CAMAST CA, ALLCODE A1, ALLCODE A2, ALLCODE A3
            WHERE A1.CDTYPE = 'CA'
            AND A1.CDNAME = 'CATYPE' AND A1.CDVAL = CA.CATYPE
            AND A3.CDTYPE = 'CA' AND A3.CDNAME = 'PITRATEMETHOD'
            AND CA.PITRATEMETHOD = A3.CDVAL
            AND A2.CDTYPE = 'CA' AND A2.CDNAME = 'CASTATUS'
            AND CA.STATUS = A2.CDVAL
            AND CA.STATUS='N'
            AND CA.VALUE = p_camastid

        )
    )
    loop
        SELECT systemnums.C_BATCH_PREFIXED || LPAD (seq_BATCHTXNUM.NEXTVAL, 8, '0')
          INTO l_txmsg.txnum
          FROM DUAL;
           --Set cac field giao dich
      --03  CAMASTID
      l_txmsg.txfields ('03').defname   := 'CAMASTID';
      l_txmsg.txfields ('03').TYPE      := 'C';
      l_txmsg.txfields ('03').VALUE     := rec.CAMASTID;
      --04  SYMBOL
      l_txmsg.txfields ('04').defname   := 'SYMBOL';
      l_txmsg.txfields ('04').TYPE      := 'C';
      l_txmsg.txfields ('04').VALUE     := rec.SYMBOL;
      --16  CODEID
      l_txmsg.txfields ('16').defname   := 'CODEID';
      l_txmsg.txfields ('16').TYPE      := 'C';
      l_txmsg.txfields ('16').VALUE     := rec.CODEID;
      --05  CATYPE
      l_txmsg.txfields ('05').defname   := 'CATYPE';
      l_txmsg.txfields ('05').TYPE      := 'C';
      l_txmsg.txfields ('05').VALUE     := rec.CATYPE;
      --08  FORMOFPAYMENT
      l_txmsg.txfields ('08').defname   := 'FORMOFPAYMENT';
      l_txmsg.txfields ('08').TYPE      := 'C';
      l_txmsg.txfields ('08').VALUE     := REC.FORMOFPAYMENT;
      --09  CATYPEVAL
      l_txmsg.txfields ('09').defname   := 'CATYPEVAL';
      l_txmsg.txfields ('09').TYPE      := 'C';
      l_txmsg.txfields ('09').VALUE     := REC.CATYPEVAL;
      --40  TOCODEID
      l_txmsg.txfields ('40').defname   := 'TOCODEID';
      l_txmsg.txfields ('40').TYPE      := 'C';
      l_txmsg.txfields ('40').VALUE     := REC.TOCODEID;
      --01  DUEDATE
      l_txmsg.txfields ('01').defname   := 'DUEDATE';
      l_txmsg.txfields ('01').TYPE      := 'C';
      l_txmsg.txfields ('01').VALUE     := rec.DUEDATE;
      --02  BEGINDATE
      l_txmsg.txfields ('02').defname   := 'BEGINDATE';
      l_txmsg.txfields ('02').TYPE      := 'C';
      l_txmsg.txfields ('02').VALUE     := rec.BEGINDATE;
      --06  REPORTDATE
      l_txmsg.txfields ('06').defname   := 'REPORTDATE';
      l_txmsg.txfields ('06').TYPE      := 'C';
      l_txmsg.txfields ('06').VALUE     := REC.REPORTDATE;
      --12  FRDATETRANSFER
      l_txmsg.txfields ('12').defname   := 'FRDATETRANSFER';
      l_txmsg.txfields ('12').TYPE      := 'D';
      l_txmsg.txfields ('12').VALUE     := REC.FRDATETRANSFER;
      --13  TODATETRANSFER
      l_txmsg.txfields ('13').defname   := 'TODATETRANSFER';
      l_txmsg.txfields ('13').TYPE      := 'D';
      l_txmsg.txfields ('13').VALUE     := REC.TODATETRANSFER;
       --07  ACTIONDATE
      l_txmsg.txfields ('07').defname   := 'ACTIONDATE';
      l_txmsg.txfields ('07').TYPE      := 'C';
      l_txmsg.txfields ('07').VALUE     := REC.ACTIONDATE;
       --10  RATE
      l_txmsg.txfields ('10').defname   := 'RATE';
      l_txmsg.txfields ('10').TYPE      := 'C';
      l_txmsg.txfields ('10').VALUE     := REC.RATE;
       --11  RIGHTOFFRATE
      l_txmsg.txfields ('11').defname   := 'RIGHTOFFRATE';
      l_txmsg.txfields ('11').TYPE      := 'T';
      l_txmsg.txfields ('11').VALUE     := REC.RIGHTOFFRATE;
       --23  TRADE
      l_txmsg.txfields ('23').defname   := 'TRADE';
      l_txmsg.txfields ('23').TYPE      := 'N';
      l_txmsg.txfields ('23').VALUE     := REC.TRADE;
       --15  TVPRICE
      l_txmsg.txfields ('15').defname   := 'TVPRICE';
      l_txmsg.txfields ('15').TYPE      := 'T';
      l_txmsg.txfields ('15').VALUE     := REC.TVPRICE;
      --17  MEETINGDATETIME
      l_txmsg.txfields ('17').defname   := 'MEETINGDATETIME';
      l_txmsg.txfields ('17').TYPE      := 'C';
      l_txmsg.txfields ('17').VALUE     := REC.MEETINGDATETIME;
       --14  ROPRICE
      l_txmsg.txfields ('14').defname   := 'ROPRICE';
      l_txmsg.txfields ('14').TYPE      := 'T';
      l_txmsg.txfields ('14').VALUE     := REC.ROPRICE;
       --20  STATUS
      l_txmsg.txfields ('20').defname   := 'STATUS';
      l_txmsg.txfields ('20').TYPE      := 'C';
      l_txmsg.txfields ('20').VALUE     := REC.STATUS;
       --30  DESC
      l_txmsg.txfields ('30').defname   := 'DESC';
      l_txmsg.txfields ('30').TYPE      := 'C';
      l_txmsg.txfields ('30').VALUE     := REC.DESCRIPTION;
      --21  LTYPE
      l_txmsg.txfields ('21').defname   := 'LTYPE';
      l_txmsg.txfields ('21').TYPE      := 'C';
      l_txmsg.txfields ('21').VALUE     := REC.LTYPE;

      BEGIN
          IF txpks_#3312.fn_BatchTxProcess (l_txmsg,
                                           p_err_code,
                                           l_err_param) <> systemnums.c_success
          THEN
             ROLLBACK;
             plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace || '  Or CAMASTID:' || rec.CAMASTID);
             plog.setendsection(pkgctx, 'ca_autocall3312');
             continue;
          END IF;
      END;
    end loop;

    plog.setendsection(pkgctx, 'ca_autocall3312');

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
      RETURN;
END;
/
