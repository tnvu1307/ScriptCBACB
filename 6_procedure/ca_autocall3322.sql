SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca_autocall3322 (p_camastid IN VARCHAR2, p_txnum IN VARCHAR2)
IS
    pkgctx            plog.log_ctx;
    logrow            tlogdebug%ROWTYPE;
    l_txmsg           tx.msg_rectype;
    v_strcurrdate     VARCHAR2 (20);
    v_strprevdate     VARCHAR2 (20);
    v_strnextdate     VARCHAR2 (20);
    v_strdesc         VARCHAR2 (1000);
    v_stren_desc      VARCHAR2 (1000);
    v_blnvietnamese   BOOLEAN;
    v_dblprofit       NUMBER (20, 0);
    v_dblloss         NUMBER (20, 0);
    v_dblavlrcvamt    NUMBER (20, 0);
    v_dblvatrate      NUMBER (20, 0);
    p_err_code        VARCHAR2 (100);
    l_err_param       VARCHAR2 (300);
    l_maxrow          NUMBER (20, 0);
BEGIN
    p_err_code := systemnums.c_success;
    plog.setbeginsection (pkgctx, 'ca_autocall3322');

    l_err_param := 'SUCCESS';

    SELECT txdesc, en_txdesc
      INTO v_strdesc, v_stren_desc
      FROM tltx
     WHERE tltxcd = '3322';

    SELECT varvalue
      INTO v_strcurrdate
      FROM sysvar
     WHERE grname = 'SYSTEM' AND varname = 'CURRDATE';

    l_txmsg.msgtype := 'T';
    l_txmsg.local := 'N';
    l_txmsg.tlid := systemnums.c_system_userid;

    SELECT SYS_CONTEXT ('USERENV', 'HOST'),
           SYS_CONTEXT ('USERENV', 'IP_ADDRESS', 15)
      INTO l_txmsg.wsname, l_txmsg.ipaddress
      FROM DUAL;

    l_txmsg.off_line := 'N';
    l_txmsg.deltd := txnums.c_deltd_txnormal;
    l_txmsg.txstatus := txstatusnums.c_txcompleted;
    l_txmsg.msgsts := '0';
    l_txmsg.ovrsts := '0';
    --l_txmsg.batchname   := p_bchmdl;
    l_txmsg.txdate := TO_DATE (v_strcurrdate, systemnums.c_date_format);
    l_txmsg.busdate := TO_DATE (v_strcurrdate, systemnums.c_date_format);
    l_txmsg.reftxnum := p_txnum;
    l_txmsg.tltxcd := '3322';

    FOR rec IN (SELECT v_strcurrdate,
                       VALUE camastid,
                       symbol,
                       codeid,
                       catype,
                       formofpayment,
                       catypeval,
                       tocodeid,
                       duedate,
                       begindate,
                       reportdate,
                       frdatetransfer,
                       todatetransfer,
                       actiondate,
                       rate,
                       rightoffrate,
                       trade,
                       tvprice,
                       meetingdatetime,
                       roprice,
                       status,
                       v_stren_desc description,
                       'U' ltype
                  FROM (SELECT VALUE,
                               autoid,
                               symbol,
                               camastid,
                               codeid,
                               excodeid,
                               typeid,
                               a1.cdcontent catype,
                               khqdate,
                               reportdate,
                               duedate,
                               actiondate,
                               begindate,
                               exprice,
                               exrate,
                               rightoffrate,
                               meetingdatetime,
                               optcodeid,
                               devidentshares,
                               splitrate,
                               interestrate,
                               description,
                               contents,
                               formofpayment,
                               interestperiod,
                               a2.cdcontent status,
                               frdateretail,
                               todateretail,
                               trflimit,
                               roprice,
                               tvprice,
                               (CASE
                                    WHEN catype = '011' AND devidentrate <> 0
                                    THEN
                                        TO_CHAR (devidentrate)
                                    WHEN catype = '011' AND devidentrate = 0
                                    THEN
                                        devidentshares
                                    ELSE
                                        rate
                                END)
                                   rate,
                               pitrate,
                               pitratemethod_cd,
                               a3.cdcontent pitratemethod,
                               catypeval,
                               frdatetransfer,
                               todatetransfer,
                               pitratese,
                               inactiondate,
                               amt,
                               qtty,
                               taxamt,
                               amtafter,
                               statusval,
                               ischangestt,
                               makerid,
                               apprvid,
                               isrightoff,
                               trade,
                               trade3375,
                               tosymbol,
                               tocodeid,
                               caqtty,
                               canceldate,
                               receivedate,
                               isincode,
                               advdesc,
                               typerate,
                               devidentrate,
                               devidentvalue,
                               remaindevidentrate,
                               remaindevidentvalue,
                               tradedate,
                               rate1,
                               status1
                          FROM v_camast ca,
                               allcode a1,
                               allcode a2,
                               allcode a3
                         WHERE     a1.cdtype = 'CA'
                               AND a1.cdname = 'CATYPE'
                               AND a1.cdval = ca.catype
                               AND a3.cdtype = 'CA'
                               AND a3.cdname = 'PITRATEMETHOD'
                               AND ca.pitratemethod = a3.cdval
                               AND a2.cdtype = 'CA'
                               AND a2.cdname = 'CASTATUS'
                               AND ca.status = a2.cdval
                               AND ca.status = 'N'
                               AND ca.VALUE = p_camastid))
    LOOP
        SELECT systemnums.c_batch_prefixed
               || LPAD (seq_batchtxnum.NEXTVAL, 8, '0')
          INTO l_txmsg.txnum
          FROM DUAL;
        L_TXMSG.CCYUSAGE := rec.codeid;

        --Set cac field giao dich
        --03  CAMASTID
        l_txmsg.txfields ('03').defname := 'CAMASTID';
        l_txmsg.txfields ('03').TYPE := 'C';
        l_txmsg.txfields ('03').VALUE := rec.camastid;
        --04  SYMBOL
        l_txmsg.txfields ('04').defname := 'SYMBOL';
        l_txmsg.txfields ('04').TYPE := 'C';
        l_txmsg.txfields ('04').VALUE := rec.symbol;
        --16  CODEID
        l_txmsg.txfields ('16').defname := 'CODEID';
        l_txmsg.txfields ('16').TYPE := 'C';
        l_txmsg.txfields ('16').VALUE := rec.codeid;
        --05  CATYPE
        l_txmsg.txfields ('05').defname := 'CATYPE';
        l_txmsg.txfields ('05').TYPE := 'C';
        l_txmsg.txfields ('05').VALUE := rec.catype;
        --08  FORMOFPAYMENT
        l_txmsg.txfields ('08').defname := 'FORMOFPAYMENT';
        l_txmsg.txfields ('08').TYPE := 'C';
        l_txmsg.txfields ('08').VALUE := rec.formofpayment;
        --09  CATYPEVAL
        l_txmsg.txfields ('09').defname := 'CATYPEVAL';
        l_txmsg.txfields ('09').TYPE := 'C';
        l_txmsg.txfields ('09').VALUE := rec.catypeval;
        --40  TOCODEID
        l_txmsg.txfields ('40').defname := 'TOCODEID';
        l_txmsg.txfields ('40').TYPE := 'C';
        l_txmsg.txfields ('40').VALUE := rec.tocodeid;

        --01  DUEDATE
            l_txmsg.txfields ('01').defname := 'DUEDATE';
            l_txmsg.txfields ('01').TYPE := 'C';
        BEGIN
            l_txmsg.txfields ('01').VALUE := TO_CHAR(rec.duedate,'DD/MM/RRRR');
        EXCEPTION WHEN OTHERS THEN
            l_txmsg.txfields ('01').VALUE := rec.duedate;
        END;

        --02  BEGINDATE
        l_txmsg.txfields ('02').defname := 'BEGINDATE';
        l_txmsg.txfields ('02').TYPE := 'C';
        BEGIN
            l_txmsg.txfields ('02').VALUE := TO_CHAR(rec.begindate,'DD/MM/RRRR');
        EXCEPTION WHEN OTHERS THEN
            l_txmsg.txfields ('02').VALUE := rec.begindate;
        END;

        --06  REPORTDATE
        l_txmsg.txfields ('06').defname := 'REPORTDATE';
        l_txmsg.txfields ('06').TYPE := 'C';
        BEGIN
            l_txmsg.txfields ('06').VALUE := TO_CHAR(rec.reportdate,'DD/MM/RRRR');
        EXCEPTION WHEN OTHERS THEN
            l_txmsg.txfields ('06').VALUE := rec.reportdate;
        END;

        --12  FRDATETRANSFER
        l_txmsg.txfields ('12').defname := 'FRDATETRANSFER';
        l_txmsg.txfields ('12').TYPE := 'D';
        l_txmsg.txfields ('12').VALUE := rec.frdatetransfer;
        --13  TODATETRANSFER
        l_txmsg.txfields ('13').defname := 'TODATETRANSFER';
        l_txmsg.txfields ('13').TYPE := 'D';
        l_txmsg.txfields ('13').VALUE := rec.todatetransfer;

        --07  ACTIONDATE
        l_txmsg.txfields ('07').defname := 'ACTIONDATE';
        l_txmsg.txfields ('07').TYPE := 'C';
        BEGIN
            l_txmsg.txfields ('07').VALUE := TO_CHAR(rec.actiondate,'DD/MM/RRRR');
        EXCEPTION WHEN OTHERS THEN
            l_txmsg.txfields ('07').VALUE := rec.actiondate;
        END;
        --10  RATE
        l_txmsg.txfields ('10').defname := 'RATE';
        l_txmsg.txfields ('10').TYPE := 'C';
        l_txmsg.txfields ('10').VALUE := rec.rate;
        --11  RIGHTOFFRATE
        l_txmsg.txfields ('11').defname := 'RIGHTOFFRATE';
        l_txmsg.txfields ('11').TYPE := 'T';
        l_txmsg.txfields ('11').VALUE := rec.rightoffrate;
        --23  TRADE
        l_txmsg.txfields ('23').defname := 'TRADE';
        l_txmsg.txfields ('23').TYPE := 'N';
        l_txmsg.txfields ('23').VALUE := fn_getseamt_3322(rec.codeid, rec.reportdate);
        --15  TVPRICE
        l_txmsg.txfields ('15').defname := 'TVPRICE';
        l_txmsg.txfields ('15').TYPE := 'T';
        l_txmsg.txfields ('15').VALUE := rec.tvprice;

        --17  MEETINGDATETIME
        l_txmsg.txfields ('17').defname := 'MEETINGDATETIME';
        l_txmsg.txfields ('17').TYPE := 'C';
        BEGIN
            l_txmsg.txfields ('17').VALUE := TO_CHAR(rec.actiondate,'DD/MM/RRRR');
        EXCEPTION WHEN OTHERS THEN
            l_txmsg.txfields ('17').VALUE := rec.actiondate;
        END;

        --14  ROPRICE
        l_txmsg.txfields ('14').defname := 'ROPRICE';
        l_txmsg.txfields ('14').TYPE := 'T';
        l_txmsg.txfields ('14').VALUE := rec.roprice;
        --20  STATUS
        l_txmsg.txfields ('20').defname := 'STATUS';
        l_txmsg.txfields ('20').TYPE := 'C';
        l_txmsg.txfields ('20').VALUE := rec.status;
        --30  DESC
        l_txmsg.txfields ('30').defname := 'DESC';
        l_txmsg.txfields ('30').TYPE := 'C';
        l_txmsg.txfields ('30').VALUE := rec.description;
        --21  LTYPE
        l_txmsg.txfields ('21').defname := 'LTYPE';
        l_txmsg.txfields ('21').TYPE := 'C';
        l_txmsg.txfields ('21').VALUE := rec.ltype;

        BEGIN
            IF txpks_#3322.fn_batchtxprocess (l_txmsg,
                                              p_err_code,
                                              l_err_param) <>
                   systemnums.c_success
            THEN
              --  ROLLBACK;
                plog.error (
                    pkgctx,
                       SQLERRM
                    || DBMS_UTILITY.format_error_backtrace
                    || '  Or CAMASTID:'
                    || rec.camastid);
                plog.setendsection (pkgctx, 'ca_autocall3322');
                CONTINUE;
            END IF;
        END;
    END LOOP;

    plog.setendsection (pkgctx, 'ca_autocall3322');
EXCEPTION
    WHEN OTHERS
    THEN
        plog.error (pkgctx, SQLERRM || DBMS_UTILITY.format_error_backtrace);
        RETURN;
END;
/
