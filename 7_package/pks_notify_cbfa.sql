SET DEFINE OFF;
CREATE OR REPLACE PACKAGE pks_notify_cbfa IS

  /** ----------------------------------------------------------------------------------------------------
  ** (c) 2019 by Financial Software Solutions. JSC.
  ** ?ng b? d? li?u CB sang FA
  ----------------------------------------------------------------------------------------------------*/

 PROCEDURE process_notify_cbfa;
 PROCEDURE process_msg_from_fa;
 PROCEDURE process_autorun_bankpayment;
 PROCEDURE pr_auto_6642(p_autoid number, p_err_code  OUT varchar2, p_err_message  OUT varchar2);
END pks_notify_cbfa;
/


CREATE OR REPLACE PACKAGE BODY pks_notify_cbfa IS
  -- Private variable declarations
  pkgctx plog.log_ctx;
  logrow tlogdebug%ROWTYPE;

PROCEDURE process_notify_cbfa
    AS
    l_sql CLOB ;
    l_autoid NUMBER ;
    l_CUSTODYCD VARCHAR2(100);
    l_CAMASTID VARCHAR2(100);
    l_EXDATE DATE ;
    l_REPORTDATE DATE ;
    l_TICKER VARCHAR2(100);
    l_TYPEOFACC VARCHAR2(100);
    l_txnum VARCHAR2(100);
    l_txdate DATE ;
    l_bankadv_banktxnum VARCHAR2(100);
    l_bankadv_wdrtype VARCHAR2(100);
    l_bankadv_ccycd VARCHAR2(100);
    l_bankadv_description VARCHAR2(500);
    l_bankadv_custodycd VARCHAR2(100);
    l_rbankadv_custodycd VARCHAR2(100);
    v_txnum             varchar2(100);
    v_txdate            date;
    v_tltxcd            varchar2(100);
    l_symbol VARCHAR2(100);
    l_codeid VARCHAR2(100);
    l_qtty NUMBER;
    l_otcacctno VARCHAR2(100);
    v_desc      varchar2(500);
    l_tltxcd    varchar2(100);
    l_currdate  date;
    l_bcustodycd        varchar2(100);
    l_scustodycd        varchar2(100);
    l_bfullname         varchar2(100);
    l_cfullname         varchar2(100);
    l_count number;
    l_tocustodycd varchar2(100);
    l_acctno      varchar2(20);
    l_transtype varchar2(20);
    l_refcontract  varchar2(20);
    l_instype varchar2(10);
    l_citad   varchar2(50);
    l_bankaccno varchar2(50);
    l_bankname varchar2(100);
    l_bankbranch varchar2(100);
    l_amt        NUMBER;
    l_desc       varchar2(500);
    l_exdividend date;
    v_etfamt     NUMBER;
    l_reftxnum    varchar2(100);
    l_dorc varchar2(1);
    l_feeamt number;
    l_taxamt number;
    pv_ref pkg_report.ref_cursor;
    v_payment number;
    v_statement number;
    refbankacct varchar2(100);
    v_reqcode   varchar2(100);
    v_objname   varchar2(100);
    v_reqtxnum  varchar2(100);
    v_catype    varchar2(20);
    v_globalid  varchar2(50);
    v_trfcode   varchar2(50);
    v_fee       number;
    v_tax       number;
    v_orderid   varchar2(50);
    v_ordertype varchar2(10);
    v_txtype    varchar2(10);
    v_dbcode    varchar2(10);
    v_strdata   varchar2(4000);
    v_etfqtty   number;
    v_etfapqtty number;
    v_etfholdfs number;
    v_etfprice  number;
    v_etfsymbol varchar2(50);
    v_etfcustodycd varchar2(50);
    v_memberid   varchar2(10);
    l_fundsymbol varchar2(50);
    l_refId     VARCHAR2(1000);
    l_refKey    VARCHAR2(1000);
    l_FEETYPE   VARCHAR2(1);
    l_desbankacct VARCHAR2(200);
    v_ddacctno    VARCHAR2(20);
    v_feedaily    VARCHAR2(1);
    l_exerciseratio   number;
    l_catype          varchar2(20);
    l_bankobj         varchar2(20);
    v_cancel          varchar2(20);
    p_err_code varchar2(50);
    p_err_msg varchar2(500);
    EXCETION_STR exception;
    EXCETION_NUMBER exception;
    pragma exception_init(excetion_str,-1438);
    pragma exception_init(excetion_number,-12899);
    v_blocked number;
    v_ward varchar2(20);
    v_busdate date;
    v_date date;
    v_custodycd varchar2(30);
    l_recordedate date;
    l_refbookingid number;
    l_exdividend_1 date;
    v_count number;
    v_countUSERLOGIN number;
    v_countSBSECURITIES number;
    v_countISSUERS number;
    v_holiday varchar(1);
    v_codeid varchar2(100);
 BEGIN
    plog.setBeginSection(pkgctx, 'process_notify_cbfa');

    SELECT TO_DATE(VARVALUE,systemnums.C_DATE_FORMAT) INTO l_currdate
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';

    --param online dung ban notify 1 lan ko theo ban notify trong for..loop
    SELECT count(1) into v_countUSERLOGIN   FROM log_notify_cbfa WHERE STATUS ='P' and objname ='USERLOGIN';
    SELECT count(1) into v_countSBSECURITIES   FROM log_notify_cbfa WHERE STATUS ='P' and objname ='SBSECURITIES';
  SELECT count(1) into v_countISSUERS   FROM log_notify_cbfa WHERE STATUS ='P' and objname ='ISSUERS';
    --end

    FOR REC IN (SELECT * FROM log_notify_cbfa WHERE STATUS ='P' order by autoid)
    LOOP
        BEGIN
            IF REC.objname = 'CAMAST' THEN
                BEGIN
                    SELECT REPORTDATE,CATYPE,codeid INTO l_REPORTDATE,l_catype,l_codeid FROM CAMAST WHERE CAMASTID = rec.keyvalue;

                    l_exdividend := getprevworkingdate(l_REPORTDATE);
                    l_exdividend_1:= getprevworkingdate(l_exdividend);
                    if l_catype = '024' then
                        select  to_number(SUBSTR(EXERCISERATIO,0,INSTR(EXERCISERATIO,'/') - 1))/to_number(SUBSTR(EXERCISERATIO,INSTR(EXERCISERATIO,'/')+1,LENGTH(EXERCISERATIO)))
                        into l_EXERCISERATIO
                        from sbsecurities
                        where codeid = l_codeid;
                    end if;

          begin
                    select tl.reftxnum into l_reftxnum from vw_tllog_all tl where tl.txnum = rec.txnum and tl.txdate = rec.txdate and tl.deltd = 'N';
              exception when others then l_reftxnum := null;
                    end;

                    if l_reftxnum is not null and length(l_reftxnum) > 0 then
                        begin
                            select tltxcd into v_tltxcd from vw_tllog_all where txnum = l_reftxnum and txdate = rec.txdate and deltd = 'N';
                        exception when others then v_tltxcd := null;
                        end;
                    else
                        v_tltxcd := null;
                    end if;
                    IF rec.tltxcd = '3322' THEN
                        BEGIN
                            IF (l_exdividend = rec.txdate) or (l_exdividend_1 = rec.txdate)  or (v_tltxcd = '8894' and length(v_tltxcd) > 0 and l_REPORTDATE = rec.txdate) THEN --Ngay hien tai la ngay lam viec lien truoc reportdate
                                for rec0 in (
                                SELECT rec.autoid refnotifyid,CAS.AUTOID AUTOID,CA.CODEID,CA.CATYPE,CA.REPORTDATE,CA.DUEDATE,CA.ACTIONDATE,CA.EXPRICE,CA.PRICE,CA.EXRATE,CA.RIGHTOFFRATE,
                                CA.DEVIDENTRATE,CA.DEVIDENTSHARES,CA.SPLITRATE,CA.INTERESTRATE,CA.INTERESTPERIOD
                                , case when SB.Tradeplace = '003' then 'T' else 'P' END STATUS,CA.CAMASTID,CA.DESCRIPTION,CA.EXCODEID,
                                CA.PSTATUS,CA.RATE,CA.DELTD,CA.TRFLIMIT,CA.PARVALUE,
                                CA.ROUNDTYPE,CA.OPTSYMBOL,CA.OPTCODEID,CA.TRADEDATE,CA.LASTDATE,CA.RETAILSHARE,CA.RETAILDATE,CA.FRDATERETAIL,CA.TODATERETAIL,
                                CA.FRTRADEPLACE,CA.TOTRADEPLACE,CA.TRANSFERTIMES,CA.FRDATETRANSFER,CA.TODATETRANSFER,CA.TASKCD,CA.TOCODEID,CA.LAST_CHANGE,CA.PITRATE,
                                CA.PITRATEMETHOD,CA.ISWFT,CA.PRICEACCOUNTING,CA.CAQTTY,CA.BEGINDATE,CA.PURPOSEDESC,CA.DEVIDENTVALUE,CA.ADVDESC,CA.TYPERATE,CA.CIROUNDTYPE,CA.PITRATESE,CA.INACTIONDATE,
                                CA.MAKERID,CA.APPRVID,CA.EXERATE,CA.CANCELDATE,CA.RECEIVEDATE,CA.CANCELSTATUS,CA.ISINCODE,CA.TRFFEEAMT,CA.CANCELSHARE,CA.EXFROMDATE,
                                CA.EXTODATE,CA.EXCANCELDATE,CA.EXRECVDATE,CA.DOMESTICCD,CA.VSDSTATUS,CA.EXADDRESS,CA.VSDID,CA.PARNAME,CA.CHANGECONTENT,CA.CONVERTDATE,
                                CA.MEETINGPLACE,CA.STOPTRANDATE,CA.INSDEADLINE,CA.DEBITDATE,CA.RIGHTTRANSDL,CA.SUBMISSIONDL,CA.LASTTRADINGD,CA.EFFECDELDATE--,CA.LISTINGORDER
                                ,CASE WHEN CA.CATYPE = '014' THEN CAS.TRADE
                                      ELSE CAS.BALANCE
                                 END BALANCE,
                                CAS.QTTY,
                                CAS.AMT -  CASE WHEN CF.VAT='Y'  THEN (
                                               CASE WHEN CA.CATYPE IN ('016')  THEN ROUND(CA.PITRATE*CAS.INTAMT/100)
                                                    WHEN CA.CATYPE = '024' THEN LEAST(CAS.AMT,CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/L_EXERCISERATIO)
                                                    WHEN CA.CATYPE = '023' THEN ROUND(CA.PITRATE*CAS.INTAMT/100) - CAS.BALANCE*CA.EXPRICE - CAS.INTAMT
                                                    ELSE ROUND(CA.PITRATE*CAS.AMT/100) END)
                                            ELSE 0 END AMT,
                                CF.CUSTODYCD,SB.SYMBOL,tocodeid.symbol tosymbol,
                                CAS.INTAMT  -  CASE WHEN CF.VAT='Y'  THEN (
                                                    CASE WHEN CA.CATYPE IN ('016')  THEN ROUND(CA.PITRATE*CAS.INTAMT/100)
                                                         WHEN CA.CATYPE IN ('015') THEN ROUND(CA.PITRATE*CAS.AMT/100)
                                                    ELSE 0 END)
                                               ELSE 0 END intamt,
                                'P' synstatus,l_exdividend exdividend,CAS.PBALANCE,CAS.PQTTY,
                                fnc_get_holdsell_etf(cf.custodycd,cas.afacctno,cas.camastid) nohold,
                                fnc_get_ap_etf(cf.custodycd,cas.afacctno,cas.camastid) apqtty --SL AP 8894 (Tru sl 9260 ben FA)
                                FROM CAMAST CA,CASCHD_LIST_FA CAS,AFMAST AF,CFMAST CF, sbsecurities SB,sbsecurities tocodeid
                                WHERE CA.CAMASTID = CAS.CAMASTID
                                AND CAS.AFACCTNO = AF.ACCTNO
                                AND AF.CUSTID = CF.CUSTID
                                AND CAS.CODEID = SB.CODEID
                                and ca.tocodeid = tocodeid.codeid(+)
                                AND ca.camastid = rec.keyvalue
                                AND CAS.DELTD ='N'
                                AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) >0 ) OR CF.SUPEBANK = 'Y')
                                AND SB.TRADEPLACE <> '003'
                                AND CA.CATYPE NOT IN ('005','006','028','031','032')
                                )
                                loop
                                INSERT INTO cbfa_camast@CBFALINK (refnotifyid,AUTOID,CODEID,CATYPE,REPORTDATE,DUEDATE,ACTIONDATE,EXPRICE,PRICE,EXRATE,RIGHTOFFRATE,
                                DEVIDENTRATE,DEVIDENTSHARES,SPLITRATE,INTERESTRATE,INTERESTPERIOD,STATUS,CAMASTID,DESCRIPTION,EXCODEID,PSTATUS,RATE,DELTD,
                                TRFLIMIT,PARVALUE,ROUNDTYPE,OPTSYMBOL,OPTCODEID,TRADEDATE,
                                LASTDATE,RETAILSHARE,RETAILDATE,FRDATERETAIL,TODATERETAIL,FRTRADEPLACE,TOTRADEPLACE,TRANSFERTIMES,FRDATETRANSFER,TODATETRANSFER,
                                TASKCD,TOCODEID,LAST_CHANGE,PITRATE,PITRATEMETHOD,ISWFT,PRICEACCOUNTING,CAQTTY,BEGINDATE,PURPOSEDESC,DEVIDENTVALUE,ADVDESC,TYPERATE,
                                CIROUNDTYPE,PITRATESE,INACTIONDATE,MAKERID,
                                APPRVID,EXERATE,CANCELDATE,RECEIVEDATE,CANCELSTATUS,ISINCODE,TRFFEEAMT,CANCELSHARE,EXFROMDATE,EXTODATE,EXCANCELDATE,EXRECVDATE,DOMESTICCD,
                                VSDSTATUS,EXADDRESS,VSDID,PARNAME,CHANGECONTENT,CONVERTDATE,MEETINGPLACE,STOPTRANDATE,INSDEADLINE,DEBITDATE,RIGHTTRANSDL,SUBMISSIONDL,
                                LASTTRADINGD,EFFECDELDATE,/*LISTINGORDER,*/BALANCE,QTTY,AMT,CUSTODYCD,SYMBOL,TOSYMBOL,INTAMT,SYNSTATUS,EXDIVIDEND,PBALANCE,PQTTY,NOHOLD,APQTTY)
                                SELECT rec0.refnotifyid,rec0.AUTOID,rec0.CODEID,rec0.CATYPE,rec0.REPORTDATE,rec0.DUEDATE,rec0.ACTIONDATE,rec0.EXPRICE,rec0.PRICE,rec0.EXRATE,rec0.RIGHTOFFRATE,
                                rec0.DEVIDENTRATE,rec0.DEVIDENTSHARES,rec0.SPLITRATE,rec0.INTERESTRATE,rec0.INTERESTPERIOD,rec0.STATUS,rec0.CAMASTID,rec0.DESCRIPTION,rec0.EXCODEID,
                                rec0.PSTATUS,rec0.RATE,rec0.DELTD,rec0.TRFLIMIT,rec0.PARVALUE,
                                rec0.ROUNDTYPE,rec0.OPTSYMBOL,rec0.OPTCODEID,rec0.TRADEDATE,rec0.LASTDATE,rec0.RETAILSHARE,rec0.RETAILDATE,rec0.FRDATERETAIL,rec0.TODATERETAIL,
                                rec0.FRTRADEPLACE,rec0.TOTRADEPLACE,rec0.TRANSFERTIMES,rec0.FRDATETRANSFER,rec0.TODATETRANSFER,rec0.TASKCD,rec0.TOCODEID,rec0.LAST_CHANGE,rec0.PITRATE,
                                rec0.PITRATEMETHOD,rec0.ISWFT,rec0.PRICEACCOUNTING,rec0.CAQTTY,rec0.BEGINDATE,rec0.PURPOSEDESC,rec0.DEVIDENTVALUE,rec0.ADVDESC,rec0.TYPERATE,rec0.CIROUNDTYPE,rec0.PITRATESE,rec0.INACTIONDATE,
                                rec0.MAKERID,rec0.APPRVID,rec0.EXERATE,rec0.CANCELDATE,rec0.RECEIVEDATE,rec0.CANCELSTATUS,rec0.ISINCODE,rec0.TRFFEEAMT,rec0.CANCELSHARE,rec0.EXFROMDATE,
                                rec0.EXTODATE,rec0.EXCANCELDATE,rec0.EXRECVDATE,rec0.DOMESTICCD,rec0.VSDSTATUS,rec0.EXADDRESS,rec0.VSDID,rec0.PARNAME,rec0.CHANGECONTENT,rec0.CONVERTDATE,
                                rec0.MEETINGPLACE,rec0.STOPTRANDATE,rec0.INSDEADLINE,rec0.DEBITDATE,rec0.RIGHTTRANSDL,rec0.SUBMISSIONDL,rec0.LASTTRADINGD,rec0.EFFECDELDATE,
                                rec0.BALANCE,rec0.QTTY,rec0.AMT,rec0.CUSTODYCD,rec0.SYMBOL,rec0.tosymbol,rec0.intamt,
                                rec0.synstatus,rec0.exdividend,rec0.PBALANCE,rec0.PQTTY, rec0.nohold,rec0.apqtty
                                from dual;
                                end loop;
                            END IF;
                        END;
                    ELSIF rec.tltxcd IN ('3370','3340') THEN
                        BEGIN
                           for rec0 in (
                                SELECT rec.autoid refnotifyid,CAS.AUTOID AUTOID,CA.CODEID,CA.CATYPE,CA.REPORTDATE,CA.DUEDATE,CA.ACTIONDATE,CA.EXPRICE,CA.PRICE,CA.EXRATE,CA.RIGHTOFFRATE,
                                CA.DEVIDENTRATE,CA.DEVIDENTSHARES,CA.SPLITRATE,CA.INTERESTRATE,CA.INTERESTPERIOD
                                , case when SB.Tradeplace = '003' then 'T' else 'P' END STATUS,CA.CAMASTID,CA.DESCRIPTION,CA.EXCODEID,
                                CA.PSTATUS,CA.RATE,CA.DELTD,CA.TRFLIMIT,CA.PARVALUE,
                                CA.ROUNDTYPE,CA.OPTSYMBOL,CA.OPTCODEID,CA.TRADEDATE,CA.LASTDATE,CA.RETAILSHARE,CA.RETAILDATE,CA.FRDATERETAIL,CA.TODATERETAIL,
                                CA.FRTRADEPLACE,CA.TOTRADEPLACE,CA.TRANSFERTIMES,CA.FRDATETRANSFER,CA.TODATETRANSFER,CA.TASKCD,CA.TOCODEID,CA.LAST_CHANGE,CA.PITRATE,
                                CA.PITRATEMETHOD,CA.ISWFT,CA.PRICEACCOUNTING,CA.CAQTTY,CA.BEGINDATE,CA.PURPOSEDESC,CA.DEVIDENTVALUE,CA.ADVDESC,CA.TYPERATE,CA.CIROUNDTYPE,CA.PITRATESE,CA.INACTIONDATE,
                                CA.MAKERID,CA.APPRVID,CA.EXERATE,CA.CANCELDATE,CA.RECEIVEDATE,CA.CANCELSTATUS,CA.ISINCODE,CA.TRFFEEAMT,CA.CANCELSHARE,CA.EXFROMDATE,
                                CA.EXTODATE,CA.EXCANCELDATE,CA.EXRECVDATE,CA.DOMESTICCD,CA.VSDSTATUS,CA.EXADDRESS,CA.VSDID,CA.PARNAME,CA.CHANGECONTENT,CA.CONVERTDATE,
                                CA.MEETINGPLACE,CA.STOPTRANDATE,CA.INSDEADLINE,CA.DEBITDATE,CA.RIGHTTRANSDL,CA.SUBMISSIONDL,CA.LASTTRADINGD,CA.EFFECDELDATE--,CA.LISTINGORDER
                                ,CASE WHEN CA.CATYPE = '014' THEN CAS.TRADE
                                      ELSE CAS.BALANCE
                                 END BALANCE,
                                CAS.QTTY,
                                CAS.AMT -  CASE WHEN CF.VAT='Y'  THEN (
                                               CASE WHEN CA.CATYPE IN ('016')  THEN ROUND(CA.PITRATE*CAS.INTAMT/100)
                                                    WHEN CA.CATYPE = '024' THEN LEAST(CAS.AMT,CAS.BALANCE*CA.EXPRICE*CA.PITRATE/100/L_EXERCISERATIO)
                                                    WHEN CA.CATYPE = '023' THEN ROUND(CA.PITRATE*CAS.INTAMT/100) - CAS.BALANCE*CA.EXPRICE - CAS.INTAMT
                                                    ELSE ROUND(CA.PITRATE*CAS.AMT/100) END)
                                            ELSE 0 END AMT,
                                CF.CUSTODYCD,SB.SYMBOL,tocodeid.symbol tosymbol,
                                CAS.INTAMT  -  CASE WHEN CF.VAT='Y'  THEN (
                                                    CASE WHEN CA.CATYPE IN ('016')  THEN ROUND(CA.PITRATE*CAS.INTAMT/100)
                                                         WHEN CA.CATYPE IN ('015') THEN ROUND(CA.PITRATE*CAS.AMT/100)
                                                    ELSE 0 END)
                                               ELSE 0 END intamt,
                                'P' synstatus,l_exdividend exdividend,CAS.PBALANCE,CAS.PQTTY,
                                fnc_get_holdsell_etf(cf.custodycd,cas.afacctno,cas.camastid) nohold,
                                fnc_get_ap_etf(cf.custodycd,cas.afacctno,cas.camastid) apqtty --SL AP 8894 (Tru sl 9260 ben FA)
                                FROM CAMAST CA,CASCHD_LIST_FA CAS,AFMAST AF,CFMAST CF, sbsecurities SB,sbsecurities tocodeid
                                WHERE CA.CAMASTID = CAS.CAMASTID
                                AND CAS.AFACCTNO = AF.ACCTNO
                                AND AF.CUSTID = CF.CUSTID
                                AND CAS.CODEID = SB.CODEID
                                and ca.tocodeid = tocodeid.codeid(+)
                                AND ca.camastid = rec.keyvalue
                                AND CAS.DELTD ='N'
                                AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) >0 ) OR CF.SUPEBANK = 'Y')
                                AND SB.TRADEPLACE <> '003'
                                AND CA.CATYPE NOT IN ('005','006','028','031','032')
                                )
                                loop
                                INSERT INTO cbfa_camast@CBFALINK (refnotifyid,AUTOID,CODEID,CATYPE,REPORTDATE,DUEDATE,ACTIONDATE,EXPRICE,PRICE,EXRATE,RIGHTOFFRATE,
                                DEVIDENTRATE,DEVIDENTSHARES,SPLITRATE,INTERESTRATE,INTERESTPERIOD,STATUS,CAMASTID,DESCRIPTION,EXCODEID,PSTATUS,RATE,DELTD,
                                TRFLIMIT,PARVALUE,ROUNDTYPE,OPTSYMBOL,OPTCODEID,TRADEDATE,
                                LASTDATE,RETAILSHARE,RETAILDATE,FRDATERETAIL,TODATERETAIL,FRTRADEPLACE,TOTRADEPLACE,TRANSFERTIMES,FRDATETRANSFER,TODATETRANSFER,
                                TASKCD,TOCODEID,LAST_CHANGE,PITRATE,PITRATEMETHOD,ISWFT,PRICEACCOUNTING,CAQTTY,BEGINDATE,PURPOSEDESC,DEVIDENTVALUE,ADVDESC,TYPERATE,
                                CIROUNDTYPE,PITRATESE,INACTIONDATE,MAKERID,
                                APPRVID,EXERATE,CANCELDATE,RECEIVEDATE,CANCELSTATUS,ISINCODE,TRFFEEAMT,CANCELSHARE,EXFROMDATE,EXTODATE,EXCANCELDATE,EXRECVDATE,DOMESTICCD,
                                VSDSTATUS,EXADDRESS,VSDID,PARNAME,CHANGECONTENT,CONVERTDATE,MEETINGPLACE,STOPTRANDATE,INSDEADLINE,DEBITDATE,RIGHTTRANSDL,SUBMISSIONDL,
                                LASTTRADINGD,EFFECDELDATE,/*LISTINGORDER,*/BALANCE,QTTY,AMT,CUSTODYCD,SYMBOL,TOSYMBOL,INTAMT,SYNSTATUS,EXDIVIDEND,PBALANCE,PQTTY,NOHOLD,APQTTY)
                                SELECT rec0.refnotifyid,rec0.AUTOID,rec0.CODEID,rec0.CATYPE,rec0.REPORTDATE,rec0.DUEDATE,rec0.ACTIONDATE,rec0.EXPRICE,rec0.PRICE,rec0.EXRATE,rec0.RIGHTOFFRATE,
                                rec0.DEVIDENTRATE,rec0.DEVIDENTSHARES,rec0.SPLITRATE,rec0.INTERESTRATE,rec0.INTERESTPERIOD,rec0.STATUS,rec0.CAMASTID,rec0.DESCRIPTION,rec0.EXCODEID,
                                rec0.PSTATUS,rec0.RATE,rec0.DELTD,rec0.TRFLIMIT,rec0.PARVALUE,
                                rec0.ROUNDTYPE,rec0.OPTSYMBOL,rec0.OPTCODEID,rec0.TRADEDATE,rec0.LASTDATE,rec0.RETAILSHARE,rec0.RETAILDATE,rec0.FRDATERETAIL,rec0.TODATERETAIL,
                                rec0.FRTRADEPLACE,rec0.TOTRADEPLACE,rec0.TRANSFERTIMES,rec0.FRDATETRANSFER,rec0.TODATETRANSFER,rec0.TASKCD,rec0.TOCODEID,rec0.LAST_CHANGE,rec0.PITRATE,
                                rec0.PITRATEMETHOD,rec0.ISWFT,rec0.PRICEACCOUNTING,rec0.CAQTTY,rec0.BEGINDATE,rec0.PURPOSEDESC,rec0.DEVIDENTVALUE,rec0.ADVDESC,rec0.TYPERATE,rec0.CIROUNDTYPE,rec0.PITRATESE,rec0.INACTIONDATE,
                                rec0.MAKERID,rec0.APPRVID,rec0.EXERATE,rec0.CANCELDATE,rec0.RECEIVEDATE,rec0.CANCELSTATUS,rec0.ISINCODE,rec0.TRFFEEAMT,rec0.CANCELSHARE,rec0.EXFROMDATE,
                                rec0.EXTODATE,rec0.EXCANCELDATE,rec0.EXRECVDATE,rec0.DOMESTICCD,rec0.VSDSTATUS,rec0.EXADDRESS,rec0.VSDID,rec0.PARNAME,rec0.CHANGECONTENT,rec0.CONVERTDATE,
                                rec0.MEETINGPLACE,rec0.STOPTRANDATE,rec0.INSDEADLINE,rec0.DEBITDATE,rec0.RIGHTTRANSDL,rec0.SUBMISSIONDL,rec0.LASTTRADINGD,rec0.EFFECDELDATE,
                                rec0.BALANCE,rec0.QTTY,rec0.AMT,rec0.CUSTODYCD,rec0.SYMBOL,rec0.tosymbol,rec0.intamt,
                                rec0.synstatus,rec0.exdividend,rec0.PBALANCE,rec0.PQTTY, rec0.nohold, rec0.APQTTY
                                from dual;
                                end loop;
                        END;
                    END IF;
                END;
            ELSIF REC.objname = 'USERLOGIN' THEN
                BEGIN
                    INSERT INTO cbfa_userlogin@CBFALINK (refnotifyid,AUTOID,USERNAME,HANDPHONE,LOGINPWD,TRADINGPWD,AUTHTYPE,STATUS,LOGINSTATUS,
                    LASTCHANGED,NUMBEROFDAY,LASTLOGIN,ISRESET,ISMASTER,TOKENID,OTPPWD,EXPSTATUS,LOGINDATETIME,
                    EXPDATETIME,ROLECD,PSTATUS,EMAIL,listcustodycd)
                    SELECT rec.autoid, seq_cbfa_userlogin.NEXTVAL@CBFALINK,
                    USERNAME,HANDPHONE,LOGINPWD,TRADINGPWD,AUTHTYPE,STATUS,LOGINSTATUS,
                    LASTCHANGED,NUMBEROFDAY,LASTLOGIN,ISRESET,ISMASTER,TOKENID,OTPPWD,EXPSTATUS,LOGINDATETIME,
                    EXPDATETIME,ROLECD,PSTATUS,EMAIL,NVL(listcustodycd,custodycd) FROM userlogin WHERE username = rec.keyvalue;
                    --notify cho web
                    /*
                    OPEN pv_ref for
                    SELECT 'S' MSGTYPE, 'USER' DATATYPE, SYSTIMESTAMP|| '' REFID From dual;
                    txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');

                     --notify cho web
                    OPEN pv_ref for
                    SELECT 'S' MSGTYPE, 'RIGHT' DATATYPE, SYSTIMESTAMP|| '' REFID From dual;
                    txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');
                    */
                END;
            ELSIF REC.objname = 'ISSUERS' THEN
                --trung.luu: 03-07-2020 update gi?m thoai.tran
                /*BEGIN
                    INSERT INTO CBFA_ISSUER@CBFALINK (refnotifyid,autoid,shortname,fullname,en_fullname,businesstype,econimic)
                    SELECT rec.autoid, seq_cbfa_issuer.NEXTVAL@CBFALINK,i.SHORTNAME,i.FULLNAME,i.FULLNAME,
                          CASE WHEN i.businesstype ='001' THEN '002' WHEN i.businesstype ='002' THEN '001'
                               WHEN i.businesstype ='004' THEN '003' WHEN i.businesstype ='008' THEN '000' ELSE '000' END businesstype,
                          CASE WHEN i.econimic ='001' THEN '9500' WHEN i.econimic ='002' THEN '4500'
                               WHEN i.econimic ='003' THEN '000' else '000' END econimic
                    FROM issuers i WHERE i.issuerid = rec.keyvalue AND i.status ='A';
                END;*/
                BEGIN
                    INSERT INTO CBFA_ISSUER@CBFALINK (refnotifyid,autoid,shortname,fullname,en_fullname,businesstype,econimic,licenseno,licensedate,fax,phone,address,status)
                    SELECT rec.autoid, seq_cbfa_issuer.NEXTVAL@CBFALINK,i.SHORTNAME,i.FULLNAME,i.EN_FULLNAME,
                    CASE WHEN i.businesstype ='001' THEN '002' WHEN i.businesstype ='002' THEN '001'
                               WHEN i.businesstype ='004' THEN '003' WHEN i.businesstype ='008' THEN '000' ELSE '000' END businesstype
                               ,CASE WHEN i.econimic ='001' THEN '9500' WHEN i.econimic ='002' THEN '4500'
                               WHEN i.econimic ='003' THEN '000' else econimic END econimic,licenseno,licensedate,fax,phone,address,'P'
                    FROM issuers i WHERE i.issuerid = rec.keyvalue AND i.status ='A';
                END;
                 --trung.luu: 03-07-2020 update gi?m thoai.tran
            ELSIF REC.objname = 'SBSECURITIES' THEN
                BEGIN
                    INSERT INTO CBFA_SBSECURITIES@CBFALINK (refnotifyid,autoid,symbol,isfullname_vn,board,intrate,intperiod,
                           issuedate,expdate,parvalue,status,isincode,marketcap,srcmrktprice,issuercd,isfullname_en,tickercd,cficode,exchange,stocktype,currencycd,intyearcd,intperiodcd,pstrike)
                    SELECT rec.autoid, seq_cbfa_sbsecurities.NEXTVAL@CBFALINK,rec.keyvalue,s.bondname,null,s.intcoupon,s.intperiod, --SHBVNEX-2295
                           s.issuedate,s.expdate,s.parvalue,'P',s.isincode,null,null,i.shortname,i.en_fullname,rec.keyvalue,
                           (CASE WHEN s.sectype = '006' AND s.bondtype = '005' THEN 'DB'
                                 WHEN s.sectype = '006' AND s.bondtype = '001' THEN 'GB'
                                 WHEN s.sectype = '006' AND s.bondtype = '002' THEN 'MB'
                                 WHEN s.sectype = '006' AND s.bondtype = '003' THEN 'GO'
                                 WHEN s.sectype = '006' AND s.bondtype = '004' THEN 'DC'
                                 WHEN s.sectype = '015' AND s.coveredwarranttype ='C' THEN 'CC'
                                 WHEN s.sectype = '015' AND s.coveredwarranttype ='P' THEN 'CP'
                                 WHEN s.sectype = '001' THEN 'ES'
                                 WHEN s.sectype = '002' THEN 'EP'
                                 WHEN s.sectype = '008' THEN 'EF'
                                 WHEN s.sectype = '009' THEN 'TD'
                                 WHEN s.sectype = '011' THEN 'CW'
                                 WHEN s.sectype = '012' THEN 'BB'
                                 WHEN s.sectype = '013' THEN 'CD'
                                 WHEN s.sectype = '005' THEN 'FF'
                                 ELSE 'ES'
                           END) cficode,
                           (CASE WHEN INSTR(rec.keyvalue,'_WFT') >0 THEN
                                    (CASE WHEN sb_ref.tradeplace = '001' THEN 'HSX'
                                          WHEN sb_ref.tradeplace = '002' THEN 'HNX'
                                          WHEN sb_ref.tradeplace = '003' THEN 'OTC'
                                          WHEN sb_ref.tradeplace = '005' THEN 'UPCOM'
                                          WHEN sb_ref.tradeplace = '006' THEN 'WFT'
                                          WHEN sb_ref.tradeplace = '010' THEN 'GBX'
                                          WHEN sb_ref.tradeplace = '099' THEN 'TPRL'
                                          ELSE 'HNX'
                                    END)
                                ELSE
                                    (CASE WHEN s.tradeplace = '001' THEN 'HSX'
                                          WHEN s.tradeplace = '002' THEN 'HNX'
                                          WHEN s.tradeplace = '003' THEN 'OTC'
                                          WHEN s.tradeplace = '005' THEN 'UPCOM'
                                          WHEN s.tradeplace = '006' THEN 'WFT'
                                          WHEN s.tradeplace = '010' THEN 'GBX'
                                          WHEN s.tradeplace = '099' THEN 'TPRL'
                                          ELSE 'HNX'
                                    END)
                           END) exchange,
                           CASE WHEN s.sectype IN ('006','444','222') THEN 'C' ELSE 'D' END stocktype,decode(sb.shortcd,'USD','USD','VND'),
                           CASE WHEN s.interestdate = '365' THEN 'E' ELSE 'A' END intyearcd,
                           CASE WHEN S.PERIODINTEREST = '001' THEN 'D'
                                WHEN S.PERIODINTEREST = '002' THEN 'M'
                                WHEN S.PERIODINTEREST = '003' THEN 'Q'
                                WHEN S.PERIODINTEREST = '004' THEN 'H'
                                WHEN S.PERIODINTEREST = '005' THEN 'Y'
                                WHEN S.PERIODINTEREST = '999' THEN 'O'
                                ELSE 'Y' END intperiodcd,
                                nvl(s.exerciseprice,0) PSTRIKE
                    FROM sbsecurities s,issuers i,sbcurrency sb, sbsecurities sb_ref
                    WHERE s.issuerid = i.issuerid
                    AND ((s.symbol = replace(rec.keyvalue,'_WFT','') and rec.action in ('ADD')) or (s.symbol = replace(rec.keyvalue,'_WFT','') and rec.action in ('DELETE','EDIT')))
                    and s.ccycd = sb.ccycd and sb_ref.symbol (+) = rec.keyvalue;--and sb_ref.codeid(+) = s.refcodeid;

              --notify cho web
                   -- OPEN pv_ref for
                  --  SELECT 'S' MSGTYPE, 'STOCK' DATATYPE, SYSTIMESTAMP|| '' REFID,rec.keyvalue value  From dual;
                   -- txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');
                END;
            ELSIF REC.objname = 'CATRANSFERCONFIRM' THEN
                BEGIN
                    select ca.custodycd, ca.toacctno  into l_CUSTODYCD, l_tocustodycd
                    from catransfer ca where   ca.txdate = rec.txdate AND ca.txnum = rec.txnum;

                    if substr(l_CUSTODYCD,1,3) = 'SHV' then
                    --ben chuyen
                        v_globalid := 'CB.S.' || TO_CHAR(rec.txdate,'rrrrmmdd.') || rec.txnum;
                        INSERT INTO CBFA_GLMASTEXT@CBFALINK (refnotifyid,AUTOID,ACCTNO,ACEXTTYPE,BALANCE,QTTY,PVALUATION,CRAMT,DRAMT,
                        price,CONTRACTNO,CUSTODYCD,carefid,txdealtype,buyer,seller,busdate,refsymbol,fee,tax,notes,TXDATE,STATUS,GLOBALID)
                        select rec.autoid, seq_cbfaconfirmca.NEXTVAL@CBFALINK, null, 'RT', ca.amt*ca.transferprice,
                        ca.amt, 0,0,0,ca.transferprice,ca.notransct,ca.custodycd,ca.camastid,'S',ca.custname2,'',ca.txdate,SB2.symbol,
                        NVL(ca.feeamt,0), NVL(ca.taxamt,0),tl.txdesc,ca.txdate,'P', v_globalid
                        from catransfer ca, sbsecurities SB2, tllog tl, cfmast cf
                        where ca.txdate = rec.txdate AND ca.txdate = tl.txdate
                        AND ca.txnum = rec.txnum AND ca.txnum= tl.txnum
                        AND ca.optcodeid = sb2.codeid
                        and ca.custodycd = cf.custodycd
                        and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');
                    end if;

                    if substr(l_tocustodycd,1,3) = 'SHV' then
                    --ben nhan
                        v_globalid := 'CB.B.' || TO_CHAR(rec.txdate,'rrrrmmdd.') || rec.txnum;
                        INSERT INTO CBFA_GLMASTEXT@CBFALINK (refnotifyid,AUTOID,ACCTNO,ACEXTTYPE,BALANCE,QTTY,PVALUATION,CRAMT,DRAMT,
                        price,CONTRACTNO,CUSTODYCD,carefid,txdealtype,buyer,seller,busdate,refsymbol,fee,tax,notes,TXDATE,STATUS,GLOBALID)
                        select rec.autoid, seq_cbfaconfirmca.NEXTVAL@CBFALINK, null, 'RT', ca.amt*ca.transferprice,
                        ca.amt, 0,0,0,ca.transferprice,ca.notransct,ca.toacctno,ca.camastid,'B','',ca.custname,ca.txdate,SB2.symbol,
                        NVL(ca.feeamt,0), NVL(ca.taxamt,0),tl.txdesc,ca.txdate,'P', v_globalid
                        from catransfer ca, sbsecurities SB2, tllog tl,cfmast cf
                        where ca.txdate = rec.txdate AND ca.txdate = tl.txdate
                        AND ca.txnum = rec.txnum AND ca.txnum= tl.txnum
                        AND ca.optcodeid = sb2.codeid
                        and ca.toacctno = cf.custodycd
                        and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');
                    end if;
                END;
            ELSIF REC.objname = 'ODMAST' THEN
                BEGIN
                -- 08.03.2020
                /*INSERT INTO cbfa_fasfnoticetx@CBFALINK  (refnotifyid,AUTOID,REFKEY,TXDATE,TXNUM,TXBORS,FUNDCODEID,CUSTODYCD,
                            REFSYMBOL,TXDESC,TXAMT,TXQTTY,FEEAMT,DELTD,STATUS,INTLASTDT,TRANSDATE,
                            TRADEDATE,TRANSACTIONTYPE)
                SELECT REC.AUTOID,seq_cbfaconfirmca.NEXTVAL@CBFALINK,ORDERID,to_date(OD.TXDATE,'DD/MM/RRRR'),TXNUM,TXBORS,OD.CODEID,OD.CUSTODYCD,
                       OD.SYMBOL,'Stock trading result',execamt,execqtty,od.feeamt,'N','P',to_date(OD.CLEARDATE,'DD/MM/RRRR'),null,
                       to_date(OD.TXDATE,'DD/MM/RRRR'),TRANSACTIONTYPE
                FROM
                (SELECT OC.custodycd||sec_id||trans_type||OC.trade_date||OC.AP ORDERID,MAX(oc.Trade_Date) TXDATE,OD.TXNUM,
                       (CASE WHEN OC.TRANS_TYPE ='NB' THEN 'B'
                             WHEN OC.TRANS_TYPE ='NS' THEN 'S' END) TXBORS, OD.CODEID, OC.CUSTODYCD, OD.SYMBOL,
                        sum(price) execamt,sum(quantity) execqtty,sum(commission_fee) feeamt,MAX(OC.SETTLE_DATE) CLEARDATE,OC.TRANSACTIONTYPE
                 FROM odmastcust OC, odmast OD
                 WHERE OC.DELTD <> 'Y' AND OC.CUSTODYCD = OD.CUSTODYCD AND to_date(OC.TRADE_DATE,'DD/MM/RRRR') = to_date(OD.TXDATE,'DD/MM/RRRR')
                       AND OC.ISODMAST ='Y'
                 GROUP BY OC.custodycd,trans_type,oc.trade_date,OC.AP,sec_id,TXNUM,CODEID,SYMBOL,OC.TRANSACTIONTYPE) OD;*/
                    FOR rec0 IN (
                        select d.orderid --into v_orderid
                        from ODMAST D, cfmast cf
                        where d.txnum = rec.txnum and d.txdate = rec.txdate
                        and d.custodycd = cf.custodycd
                        and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y')
                    ) LOOP
                        INSERT INTO cbfa_fasfnoticetx@CBFALINK  (refnotifyid,AUTOID,REFKEY,TXDATE,TXNUM,TXBORS,FUNDCODEID,CUSTODYCD,
                        REFSYMBOL,TXDESC,TXAMT,TXQTTY,FEEAMT,DELTD,STATUS,INTLASTDT,TRANSDATE,
                        TRADEDATE,TRANSACTIONTYPE,APACCT,ETFDATE,TAXAMT)

                        SELECT REC.AUTOID,seq_cbfaconfirmca.NEXTVAL@CBFALINK,OD.ORDERID,
                        TO_DATE(OD.TXDATE,'DD/MM/RRRR'),OD.TXNUM,OC.TXBORS, OC.BROKER_CODE, OD.CUSTODYCD, OD.SYMBOL, 'Stock trading result',
                        OC.TXAMT, OC.TXQTTY, OC.FEEAMT,'N','P',TO_DATE(OC.CLEARDATE,'DD/MM/RRRR'),TO_DATE(OC.CLEARDATE,'DD/MM/RRRR'),TO_DATE(OC.TRADEDATE,'DD/MM/RRRR'),OC.SUBTXBORC,
                        OC.APACCT, OC.ETFDATE, OC.TAXAMT
                        FROM (
                            SELECT D.ORDERID, MAX(D.TRADE_DATE) TRADEDATE, MAX(D.SETTLE_DATE) CLEARDATE, D.SEC_ID,D.CUSTODYCD, D.TRANSACTIONTYPE SUBTXBORC, D.APACCT APACCT, D.ETFDATE ETFDATE, D.BROKER_CODE,
                                   SUM(NVL(D.QUANTITY,0)) TXQTTY,
                                   SUM(NVL(D.GROSS_AMOUNT,0)) TXAMT,
                                   SUM(NVL(D.COMMISSION_FEE,0)) FEEAMT,
                                   SUM(NVL(D.TAX,0)) TAXAMT,
                                   (CASE WHEN D.TRANS_TYPE = 'NB' THEN 'B' ELSE 'S' END) TXBORS
                            FROM ODMASTCUST D
                            WHERE D.ISODMAST = 'Y'
                            AND D.ORDERID = rec0.orderid
                            AND D.DELTD <> 'Y'
                            GROUP BY D.ORDERID,D.TRANS_TYPE,D.TRADE_DATE,D.SEC_ID,D.CUSTODYCD,D.TRANSACTIONTYPE,D.APACCT,D.ETFDATE,D.BROKER_CODE

                            UNION ALL

                            SELECT D.ORDERID, MAX(D.TRADE_DATE) TRADEDATE, MAX(D.SETTLE_DATE) CLEARDATE, D.SEC_ID, D.CUSTODYCD,
                                   (CASE WHEN SB.TRADEPLACE <> '003' OR (SB.TRADEPLACE = '003' AND SB.DEPOSITORY='001') THEN 'O' ELSE 'R' END) SUBTXBORC, NULL APACCT, NULL ETFDATE, D.BROKER_CODE,
                                   SUM(NVL(D.QUANTITY,0)) TXQTTY,
                                   SUM(NVL(D.GROSS_AMOUNT,0)) TXAMT,
                                   SUM(NVL(D.COMMISSION_FEE,0)) FEEAMT,
                                   SUM(NVL(D.TAX,0)) TAXAMT,
                                   (CASE WHEN D.TRANS_TYPE = 'NB' THEN 'B' ELSE 'S' END) TXBORS
                            FROM ODMASTCMP D, SBSECURITIES SB
                            WHERE D.ISODMAST = 'Y'
                            AND D.DELTD <> 'Y'
                            AND D.SEC_ID = SB.SYMBOL
                            AND D.ORDERID = REC0.ORDERID
                            AND NOT EXISTS (SELECT 1 FROM ODMASTCUST WHERE ISODMAST = 'Y' AND DELTD <> 'Y' AND ORDERID = REC0.ORDERID)
                            GROUP BY D.ORDERID,D.TRANS_TYPE,D.TRADE_DATE,D.SEC_ID,D.CUSTODYCD,D.BROKER_CODE,SB.TRADEPLACE,SB.DEPOSITORY

                        ) OC, ODMAST OD
                        WHERE OC.ORDERID = OD.ORDERID;
                    END LOOP;
                END;
            ELSIF REC.objname = 'ODMASTETF' THEN
                BEGIN
                    BEGIN
                        select d.orderid, d.symbol,d.custodycd,d.ap
                        into v_orderid, l_symbol,l_CUSTODYCD,l_autoid
                        from ODMAST D, cfmast cf
                        where d.txnum = rec.txnum and d.txdate = rec.txdate
                        and d.custodycd = cf.custodycd
                        and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');
                    exception when others then
                        v_orderid :='';l_symbol :='';l_CUSTODYCD :='';l_CUSTODYCD :='';l_autoid :='';
                    END;
                    BEGIN
                        select fundcode into l_fundsymbol from cfmast where custodycd = l_CUSTODYCD;
                    exception when others then
                        l_fundsymbol :='';
                    END;
                    BEGIN
                        select f.depositmember into v_memberid from famembers f where f.autoid = l_autoid;
                    exception when others then
                        v_memberid:='';
                    END;

                    v_desc := 'Enter the result of the ETF swap transaction';
                    v_etfamt:= 0;
                    v_strdata := '';
                    FOR REC IN (
                        SELECT s.symbol,nvl(E.Qtty,0) QTTY,nvl(E.APQtty,0) APQTTY,nvl(E.HOLDFS,0) HOLDFS,nvl(E.PRICE,0) PRICE,nvl(E.Apaccount,'$$') CUSTODYCD
                        FROM ETFWSAP E,SBSECURITIES S WHERE E.ORDERID = v_orderid AND E.CODEID = S.CODEID
                    ) LOOP
                        v_etfsymbol := rec.symbol;
                        v_etfqtty:= rec.qtty;
                        v_etfapqtty:= rec.APQTTY;
                        v_etfholdfs:=rec.HOLDFS;
                        v_etfprice := rec.price;
                        v_etfcustodycd := rec.custodycd;
                        v_etfamt := v_etfamt + (v_etfqtty+v_etfapqtty+v_etfholdfs)*v_etfprice;

                        v_strdata := v_strdata || v_etfsymbol || '|' || v_etfqtty || '|' || v_etfapqtty || '|' || v_etfholdfs
                        || '|' || v_etfprice || '|' || (v_etfqtty+v_etfapqtty+v_etfholdfs)*v_etfprice || '|' || v_etfcustodycd || '#';

                    END LOOP;

                    INSERT INTO cbfa_fatanoticetx@CBFALINK (refnotifyid,AUTOID, REFKEY, FUNDSYMBOL, TXDATE, TXNUM,
                    BUSDATE, TXTYPE, MBCODE,CUSTODYCD,TRANSDATE,TXDESC, TXAMT, TXQTTY, DELTD, STATUS,
                    REFTXDATE, REFTXNUM, NAVAMT, TRADINGID, TAX, ISCHANGE, TXAMTEX, TXQTTYEX,
                    FEEAMTEX, TAXEX, FEEDXX, FEEFUND, FEEAMC, DIFFERENCE, FEEAMT, CLEARDATE,TRADEDATE,STRDATA)
                    SELECT REC.AUTOID,seq_cbfaconfirmca.NEXTVAL@CBFALINK,OD.ORDERID ,l_fundsymbol,OD.TXDATE,OD.TXNUM,OD.TXDATE,
                    CASE WHEN OD.EXECTYPE ='NB' THEN 'S'
                         WHEN OD.EXECTYPE ='NS' THEN 'R'
                         END,v_memberid,OD.CUSTODYCD,OD.TXDATE,
                    v_desc,execamt,execqtty,'N','P',NULL,NULL,od.nav,l_symbol||'|'||to_char(OD.TRADE_DATE,'YYYYMMDD'),
                    OD.TAXAMT,NULL, od.execamt - v_etfamt,NULL,
                    '0',NULL,NULL,NULL,NULL,NULL,od.feeamt,OD.CLEARDATE,OD.TRADE_DATE,v_strdata
                    FROM odmast OD
                    WHERE OD.Orderid = v_orderid;
                END;
            ELSIF REC.objname = 'AUTOCALL3322' THEN
                IF REC.TLTXCD = '8894' THEN
                    BEGIN
                        FOR RECOD IN (
                            SELECT OD.CLEARDATE, NVL(ETF.APQTTY, 0) APQTTY
                            FROM
                            (
                                SELECT * FROM ODMAST WHERE TXNUM = REC.TXNUM AND TXDATE = TO_DATE(REC.TXDATE, SYSTEMNUMS.C_DATE_FORMAT)
                            )OD,
                            (
                                SELECT ORDERID, SUM(APQTTY) APQTTY
                                FROM ETFWSAP
                                WHERE TXNUM = REC.TXNUM
                                AND TXDATE = TO_DATE(REC.TXDATE, SYSTEMNUMS.C_DATE_FORMAT)
                                GROUP BY ORDERID
                            ) ETF
                            WHERE OD.ORDERID = ETF.ORDERID(+)
                        ) LOOP
                            FOR RECCA IN (
                                SELECT * FROM CAMAST
                                WHERE STATUS = 'N'
                                AND CODEID IN (
                                    SELECT DISTINCT SUBSTR(ACCTNO,11,6)
                                    FROM SETRAN
                                    WHERE TXNUM = REC.TXNUM AND DELTD <> 'Y'
                                    AND TXDATE = TO_DATE(REC.TXDATE, SYSTEMNUMS.C_DATE_FORMAT)
                                )
                                AND (REPORTDATE = RECOD.CLEARDATE OR GETPREVWORKINGDATE(REPORTDATE) = RECOD.CLEARDATE)
                                /*
                                (CASE WHEN RECOD.APQTTY > 0 THEN
                                               (CASE WHEN TO_DATE(REC.TXDATE, SYSTEMNUMS.C_DATE_FORMAT) <= GETPREVWORKINGDATE(REPORTDATE) THEN 1 ELSE 0 END)
                                          ELSE (CASE WHEN REPORTDATE = RECOD.CLEARDATE OR GETPREVWORKINGDATE(REPORTDATE) = RECOD.CLEARDATE THEN 1 ELSE 0 END)
                                     END) = 1*/
                            )LOOP
                                CA_AUTOCALL3322(RECCA.CAMASTID, REC.TXNUM);
                            END LOOP;
                        END LOOP;
                    EXCEPTION WHEN OTHERS THEN
                        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                    END;
                ELSIF REC.TLTXCD = '8895' THEN
                    BEGIN
                        FOR RECOD IN (
                            SELECT OD.CLEARDATE, NVL(ETF.APQTTY, 0) APQTTY
                            FROM ODMAST OD,
                            (
                                SELECT CVALUE ORDERID
                                FROM TLLOGFLD
                                WHERE TXNUM = REC.TXNUM
                                AND TXDATE = TO_DATE(REC.TXDATE, SYSTEMNUMS.C_DATE_FORMAT)
                                AND FLDCD ='22'
                            ) TLF,
                            (
                                SELECT ORDERID, SUM(APQTTY) APQTTY
                                FROM ETFWSAP
                                WHERE TXNUM = REC.TXNUM
                                AND TXDATE = TO_DATE(REC.TXDATE, SYSTEMNUMS.C_DATE_FORMAT)
                                GROUP BY ORDERID
                            ) ETF
                            WHERE OD.ORDERID = TLF.ORDERID
                            AND OD.ORDERID = ETF.ORDERID(+)
                        ) LOOP
                            FOR RECCA IN (
                                SELECT * FROM CAMAST
                                WHERE STATUS = 'N'
                                AND CODEID IN (
                                    SELECT DISTINCT SUBSTR(ACCTNO,11,6)
                                    FROM SETRAN
                                    WHERE TXNUM = REC.TXNUM AND DELTD <> 'Y'
                                    AND TXDATE = TO_DATE(REC.TXDATE, SYSTEMNUMS.C_DATE_FORMAT)
                                )
                                AND (REPORTDATE = RECOD.CLEARDATE OR GETPREVWORKINGDATE(REPORTDATE) = RECOD.CLEARDATE)
                            )LOOP
                                CA_AUTOCALL3322(RECCA.CAMASTID, REC.TXNUM);
                            END LOOP;
                        END LOOP;
                    EXCEPTION WHEN OTHERS THEN
                        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                    END;
                END IF;
            ELSIF REC.objname = 'CANCELETF' THEN
              v_orderid:= FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'22','C');
              INSERT INTO cbfa_canceletf@CBFALINK(autoid ,globalid, refkey, txnum,txdate,logtime,status,refnotifyid)
              SELECT seq_cbfa_canceletf.nextval@cbfalink,rec.globalid,v_orderid,rec.txnum, rec.txdate,sysdate,'P',rec.autoid from dual;
            ELSIF REC.objname = 'OTCODMAST' THEN
                BEGIN
                    --l_bcustodycd :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'88','C');
                    --l_scustodycd :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'78','C');
    /*              l_bfullname  :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'89','C');
                    l_cfullname  :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'79','C');*/
                    /*INSERT INTO CBFA_GLMASTEXT@CBFALINK (refnotifyid,AUTOID,ACCTNO,ACEXTTYPE,REFSYMBOL,BALANCE,QTTY,PVALUATION,CRAMT,DRAMT,
                    TERMVAL,TERMCD,INTRATE,INTPERIOD,INTYEARCD,FRDATE,TODATE,INTPAID,INTACCRUED,BUSDATE,TXDATE,TXNUM,STATUS,LASTCHANGE,
                    TXDEALTYPE,INTACCRDT,PRICE,NOTES,FUNDCODEID,ORGQTTY,ISAUTO,CLOSEDATE,DEVIDENTSHARES,PRODUCTCD,CONTRACTNO,
                    CUSTODYCD,REVERSEDATE,EXRATE,CURRENCY,INTACCRSPE,INTACCRSPEDT,BANKCD,CAREFID,BUYER,SELLER,IDOBJECT,FEE,TAX)
                    SELECT rec.autoid,seq_cbfaconfirmca.NEXTVAL@CBFALINK,NULL,'US',ot.symbol,ot.amt,ot.qtty,ot.price,NULL,NULL,
                    NULL,NULL,NULL,NULL,NULL,ot.txdate,ot.effdate,NULL,NULL,ot.txdate,ot.txdate,'','P',NULL,
                    CASE WHEN OT.EXECTYPE ='NB' THEN 'B'
                         WHEN OT.EXECTYPE ='NS' THEN 'S' END,NULL,NULL,tl.txdesc,'',NULL,NULL,NULL,NULL,NULL,OT.OTCODID,
                    CASE WHEN OT.EXECTYPE ='NB' THEN OT.BCUSTODYCD
                         WHEN OT.EXECTYPE ='NS' THEN OT.SCUSTODYCD END,NULL,NULL,CU.SHORTCD,NULL,NULL,NULL,NULL,DECODE(OT.EXECTYPE,'NS',OT.BFULLNAME,''),DECODE(OT.EXECTYPE,'NB',OT.SFULLNAME,''),NULL,fee,0
                    FROM OTCODMAST ot, tllog tl,SBSECURITIES SE,SBCURRENCY CU,CFMAST CF
                    WHERE TL.AUTOID = REC.KEYVALUE
                    AND OT.CODEID = SE.CODEID
                    AND SE.CCYCD = CU.CCYCD
                    AND  ot.txdate = tl.txdate
                    AND ot.txnum = tl.txnum
                    AND CF.CUSTODYCD LIKE (CASE WHEN OT.EXECTYPE ='NB' THEN OT.BCUSTODYCD
                                                WHEN OT.EXECTYPE ='NS' THEN OT.SCUSTODYCD END)
                    AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');*/

                    IF REC.TLTXCD = '1407' THEN
                        INSERT INTO CBFA_GLMASTEXT@CBFALINK (REFNOTIFYID,AUTOID,ACCTNO,ACEXTTYPE,REFSYMBOL,BALANCE,QTTY,PVALUATION,CRAMT,DRAMT,
                            TERMVAL,TERMCD,INTRATE,INTPERIOD,INTYEARCD,FRDATE,TODATE,INTPAID,INTACCRUED,BUSDATE,TXDATE,TXNUM,STATUS,LASTCHANGE,
                            TXDEALTYPE,INTACCRDT,PRICE,NOTES,FUNDCODEID,ORGQTTY,ISAUTO,CLOSEDATE,DEVIDENTSHARES,PRODUCTCD,CONTRACTNO,CUSTODYCD,
                            REVERSEDATE,EXRATE,CURRENCY,INTACCRSPE,INTACCRSPEDT,BANKCD,CAREFID,BUYER,SELLER,IDOBJECT,FEE,TAX,ROLLID,GLOBALID)
                        SELECT REC.AUTOID,SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK,NULL,'US',
                            OT.SYMBOL,OT.CLVALUE,OT.QTTY,OT.CLVALUE,NULL,NULL,
                            SB.TERM,SB.TYPETERM,SB.INTCOUPON,NULL,SB.INTERESTDATE,OT.EFFDATE,SB.EXPDATE,NULL,NULL,rec.busdate,rec.txdate,NULL,'P',NULL,
                            'B',NULL,NULL,OT.NAME,'',NULL,NULL,NULL,NULL,NULL,OT.NO,OT.CUSTODYCD,
                            NULL,0,S.SHORTCD,NULL,NULL,I.SHORTNAME,NULL,NULL,NULL,NULL,0,0,NULL,REC.GLOBALID
                        FROM CRPHYSAGREE OT, SBSECURITIES SB, ISSUERS I, SBCURRENCY S,CFMAST CF
                        WHERE OT.CODEID = SB.CODEID
                        AND SB.ISSUERID = I.ISSUERID
                        AND S.CCYCD= SB.CCYCD
                        AND OT.TXNUM = REC.TXNUM
                        AND OT.TXDATE = REC.TXDATE
                        AND OT.CUSTODYCD = CF.CUSTODYCD
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y')
                        AND SB.TRADEPLACE IN ('003');
                    ELSE
                        INSERT INTO CBFA_GLMASTEXT@CBFALINK (REFNOTIFYID,AUTOID,ACCTNO,ACEXTTYPE,REFSYMBOL,BALANCE,QTTY,PVALUATION,CRAMT,DRAMT,
                            TERMVAL,TERMCD,INTRATE,INTPERIOD,INTYEARCD,FRDATE,TODATE,INTPAID,INTACCRUED,BUSDATE,TXDATE,TXNUM,STATUS,LASTCHANGE,
                            TXDEALTYPE,INTACCRDT,PRICE,NOTES,FUNDCODEID,ORGQTTY,ISAUTO,CLOSEDATE,DEVIDENTSHARES,PRODUCTCD,CONTRACTNO,CUSTODYCD,
                            REVERSEDATE,EXRATE,CURRENCY,INTACCRSPE,INTACCRSPEDT,BANKCD,CAREFID,BUYER,SELLER,IDOBJECT,FEE,TAX,ROLLID,GLOBALID)
                        SELECT REC.AUTOID,SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK,NULL,'US',CR.SYMBOL,
                            --SHBVNEX-2379 Thoai.tran 28/06/2021
                            CASE WHEN REC.TLTXCD ='1400' THEN LOG.AMT ELSE A.CLVALUE END,A.AQTTY,
                            CASE WHEN REC.TLTXCD ='1400' THEN LOG.AMT ELSE A.CLVALUE END,NULL,NULL,
                            SB.TERM,SB.TYPETERM,SB.INTCOUPON,NULL,SB.INTERESTDATE,A.EFFDATE,SB.EXPDATE,NULL,NULL,rec.busdate,rec.txdate,NULL,'P',NULL,
                            'S',NULL,NULL,TL.TXDESC,'',NULL,NULL,NULL,NULL,NULL,A.AUTOID,CR.CUSTODYCD,
                            NULL,0,S.SHORTCD,NULL,NULL,I.SHORTNAME,NULL, LOG.FULLNAME,NULL,NULL,0,0,NULL,REC.GLOBALID
                        FROM APPENDIX A,CRPHYSAGREE_SELL_LOG LOG, CRPHYSAGREE CR, TLLOG TL,SBSECURITIES SB, SBCURRENCY S, CFMAST CF, ISSUERS I
                        WHERE A.TXNUM = REC.TXNUM AND A.TXDATE = REC.TXDATE
                        AND A.TXNUM = LOG.TXNUM AND A.TXDATE = LOG.TXDATE
                        AND A.TXNUM = TL.TXNUM AND A.TXDATE = TL.TXDATE AND TL.DELTD = 'N'
                        AND A.CRPHYSAGREEID = CR.CRPHYSAGREEID
                        AND CR.CUSTODYCD = CF.CUSTODYCD
                        AND A.CODEID = SB.CODEID
                        AND S.CCYCD= SB.CCYCD
                        AND SB.ISSUERID = I.ISSUERID
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y')
                        AND SB.TRADEPLACE IN ('003');
                    END IF;
                END;
            ELSIF REC.objname = 'CDGLMAST' THEN
                BEGIN
                    INSERT INTO CBFA_GLMASTEXT@CBFALINK (refnotifyid,AUTOID,ACCTNO,ACEXTTYPE,REFSYMBOL,BALANCE,QTTY,PVALUATION,CRAMT,DRAMT,
                    TERMVAL,TERMCD,INTRATE,INTPERIOD,INTYEARCD,FRDATE,TODATE,INTPAID,INTACCRUED,BUSDATE,TXDATE,TXNUM,STATUS,LASTCHANGE,
                    TXDEALTYPE,INTACCRDT,PRICE,NOTES,FUNDCODEID,ORGQTTY,ISAUTO,CLOSEDATE,DEVIDENTSHARES,PRODUCTCD,CONTRACTNO,CUSTODYCD,
                    REVERSEDATE,EXRATE,CURRENCY,INTACCRSPE,INTACCRSPEDT,BANKCD,CAREFID,BUYER,SELLER,IDOBJECT,FEE,TAX,ROLLID,GLOBALID)
                    SELECT rec.autoid,seq_cbfaconfirmca.NEXTVAL@CBFALINK,NULL,
                    CASE WHEN sb.sectype ='009' THEN 'TD'
                         WHEN sb.sectype ='013' THEN 'CD' END,
                    ot.symbol,OT.CLVALUE,ot.qtty,ot.CLVALUE,NULL,NULL,
                    SB.TERM,SB.TYPETERM,SB.INTCOUPON,NULL,SB.INTERESTDATE,SB.ISSUEDATE,SB.EXPDATE,NULL,NULL,ot.effdate,ot.effdate,NULL,'P',NULL,
                    'B',NULL,NULL,ot.name,ot.codeid,'0',NULL,NULL,NULL,NULL,OT.CRPHYSAGREEID,ot.CUSTODYCD,
                    NULL,0,s.shortcd,NULL,NULL,I.SHORTNAME,NULL,NULL,NULL,NULL,0,0,OT.ROLLID,REC.GLOBALID
                    FROM CRPHYSAGREE ot, sbsecurities sb, issuers i, sbcurrency s,cfmast cf
                    WHERE ot.codeid = sb.codeid
                    and sb.issuerid = i.issuerid
                    and s.ccycd= sb.ccycd
                    and ot.txnum = rec.txnum
                    and ot.txdate = rec.txdate
                    and ot.custodycd = cf.custodycd
                    and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y')
                    and sb.sectype IN ('009','013');
                END;
            ELSIF REC.objname = 'DOCSTRANFER' THEN
                BEGIN
                    INSERT INTO CBFA_DOCSTRANSFER@CBFALINK (REFNOTIFYID,AUTOID,OPNDATE,CLSDATE,CRPHYSAGREEID,QTTY,OPNTXNUM,DELTD,STATUS,OPNSENDER,OPNRECEIVER,ACEXTTYPE,
                    OPNTXDATE,REFNO,CLSTXDATE,CLSTXNUM,CLSSENDER,CLSRECEIVER,CUSTODYCD,SYMBOL)
                    SELECT REC.AUTOID,SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK,OT.OPNDATE,OT.CLSDATE,OT.CRPHYSAGREEID,OT.QTTY,OT.OPNTXNUM,OT.DELTD,OT.STATUS,OT.OPNSENDER,OT.OPNRECEIVER,
                    CASE WHEN SB.SECTYPE ='009' THEN 'TD'
                         WHEN SB.SECTYPE ='013' THEN 'CD'
                         --WHEN SB.TRADEPLACE = '003' THEN 'OTC' END, --trung.luu 03-12-2020 SHBVNEX-1853
                         when SB.SECTYPE ='006' and SB.TRADEPLACE ='003' THEN 'UB'
                         when SB.SECTYPE <> '006' and SB.TRADEPLACE ='003' THEN 'US' END,
                    OT.OPNTXDATE,OT.REFNO,OT.CLSTXDATE,OT.CLSTXNUM,OT.CLSSENDER,OT.CLSRECEIVER,OT.CUSTODYCD,OT.SYMBOL
                    FROM DOCSTRANSFER OT, SBSECURITIES SB, CFMAST CF
                    WHERE OT.SYMBOL = SB.SYMBOL
                    AND (case when rec.tltxcd = '1405' then OT.OPNTXNUM else OT.clstxnum end) = REC.TXNUM
                    AND (case when rec.tltxcd = '1405' then OT.OPNTXDATE else OT.clstxdate end) = REC.TXDATE
                    AND OT.CUSTODYCD=CF.CUSTODYCD
                    AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                END;
            ELSIF REC.objname = 'FASERETAIL' THEN
                BEGIN
                    INSERT INTO CBFA_SERETAIL@CBFALINK (ID,FULLNAME,CUSTODYCD,REFCASAACCT,PRICE,QTTY,FEEAMT,TAXAMT)
                    SELECT ser.txnum || TO_CHAR (txdate ,'DD/MM/YYYY') ID, CF.fullname,CF.custodycd, DD.refcasaacct, SER.price, SER.qtty ,feeamt, taxamt
                    FROM seretail ser,afmast af, cfmast cf,ddmast dd
                    WHERE ser.acctno = af.acctno
                    AND af.custid = cf.custid
                    AND af.acctno = dd.afacctno
                    and dd.status <> 'C'
                    AND isdefault ='Y'
                    AND ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');
                END;
            ELSIF REC.objname = 'CRPHYSAGREE' THEN
                BEGIN
                    INSERT INTO CBFA_CRPHYSAGREE@CBFALINK  (BANKACCTNO,NAME,CUSTODYCD,NO,CREATDATE,EFFDATE,INTCOUPON,MATURITYDATE,QTTY,PARVALUE,AMT)
                    SELECT cr.bankacctno,NAME,cr.custodycd,cr.no,cr.creatdate,cr.effdate,sb.intcoupon, SB.maturitydate, CR.QTTY, sb.parvalue, CR.QTTY*sb.parvalue AMT
                    FROM  CRPHYSAGREE cr,sbsecurities sb, cfmast cf
                    WHERE cr.symbol =sb.symbol
                    AND  CR.NO = rec.keyvalue
                    AND cr.custodycd = cf.custodycd
                    AND ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');
                END;
            ELSIF REC.objname = 'OTCCONFIRM' THEN
                BEGIN
                    SELECT seq_cbfa_confirmotc.NEXTVAL@CBFALINK INTO l_autoid FROM dual ;
                    l_CUSTODYCD :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'88','C');

                    select count(*) into l_count
                    from cfmast cf
                    where cf.custodycd = l_CUSTODYCD
                    and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');

                    if l_count > 0 then
                        l_codeid    :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'01','C');
                        l_otcacctno :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'02','C');
                        l_qtty      :=FN_GET_TLLOGFLD_VALUE(rec.txnum,rec.txdate,'10','N');
                        SELECT symbol INTO l_symbol FROM sbsecurities WHERE codeid = l_codeid;

                        SELECT  TLTXCD, TXDESC   INTO v_tltxcd,v_desc
                        FROM tllog
                        WHERE TLTXCD in ('2227','2228') AND AUTOID =REC.keyvalue ;
                        IF v_tltxcd ='2227' then
                            INSERT INTO CBFA_CONFIRMOTC@CBFALINK (refnotifyid,autoid, contractno, refsymbol, qtty, txdesc ,status,type,custodycd)
                            VALUES(rec.autoid,l_autoid,l_otcacctno,l_symbol,l_qtty,v_desc,'P','C',l_CUSTODYCD) ;
                        ELSE
                            INSERT INTO CBFA_CONFIRMOTC@CBFALINK (refnotifyid,autoid, contractno, refsymbol, qtty, txdesc ,status,type,custodycd)
                            VALUES(rec.autoid,l_autoid,l_otcacctno,l_symbol,l_qtty,v_desc,'P','D',l_CUSTODYCD) ;
                        END IF;
                    end if;
                END;
            ELSIF REC.OBJNAME = 'CBFAODDEXCHANGE' THEN--oddlot - off exchange
                BEGIN
                    l_tltxcd := rec.tltxcd;
                    v_txdate := rec.txdate;
                    v_txnum := rec.txnum;
                    v_desc := fn_get_tllogfld_value(v_txnum,v_txdate,'30','C');
                    select busdate into v_busdate from vw_tllog_all where txnum = v_txnum and txdate = v_txdate;
                    IF l_tltxcd = '2245' THEN
                        v_blocked := to_number(fn_get_tllogfld_value(v_txnum,v_txdate,'06','N'));
                        v_fee := to_number(fn_get_tllogfld_value(v_txnum,v_txdate,'45','N'));
                        v_tax := 0;
                        v_ward := fn_get_tllogfld_value(v_txnum,v_txdate,'03','C');

                        INSERT INTO CBFA_ODDEXCHANGETX@CBFALINK(AUTOID,CUSTODYCD,SEACCTNO,TXQTTY,TXBLOCK,CAQTTY,PARVALUE,
                        FEEAMT,TAXAMT,TXDORC,REFSYMBOL,TOCUSTODYCD,TOSEACCTNO,TXDATE,
                        BUSDATE,TXNUM,DESCRIPTION,STATUS,GLOBALID,INWARD,OUTWARD,refnotifyid)
                        SELECT seq_cbfa_oddexchagetx.nextval@CBFALINK,g.custodycd,g.acctno,g.trade,v_blocked,0,s.parvalue,
                        v_fee, v_tax,'C',g.symbol,null,null,v_txdate,v_busdate,v_txnum,v_desc,'P',rec.globalid,
                        v_ward, null, rec.autoid
                        FROM (
                            select v.CUSTODYCD,v.ACCTNO,v.SYMBOL,SUM(NAMT) TRADE,v.TXNUM,v.TXDATE
                            from vw_setran_gen v,cfmast c
                            where tltxcd = '2245' and v.FIELD in('TRADE','BLOCKED','EMKQTTY') and txtype = 'C'
                            and c.custodycd = v.CUSTODYCD and c.supebank = 'Y'
                            and v.txnum = v_txnum and v.txdate = v_txdate
                            and ((c.fundcode is not null and length(c.fundcode) > 0) or c.supebank = 'Y')
                            group by v.CUSTODYCD,v.ACCTNO,v.SYMBOL,v.TXNUM,v.TXDATE
                        ) g,sbsecurities s
                        where s.symbol = g.symbol;
                    elsif l_tltxcd = '2242' THEN
                        v_blocked := to_number(fn_get_tllogfld_value(v_txnum,v_txdate,'06','N'));
                        v_fee := 0;
                        v_tax := 0;
                        v_ward := '407';

                        INSERT INTO CBFA_ODDEXCHANGETX@CBFALINK(AUTOID,CUSTODYCD,SEACCTNO,TXQTTY,TXBLOCK,CAQTTY,PARVALUE,
                        FEEAMT,TAXAMT,TXDORC,REFSYMBOL,TOCUSTODYCD,TOSEACCTNO,TXDATE,
                        BUSDATE,TXNUM,DESCRIPTION,STATUS,GLOBALID,INWARD,OUTWARD,refnotifyid)
                        SELECT seq_cbfa_oddexchagetx.nextval@CBFALINK,g.custodycd,g.acctno,g.trade,v_blocked,0,s.parvalue,
                        v_fee, v_tax,g.txtype,g.symbol,null,null,v_txdate,v_busdate,v_txnum,v_desc,'P',rec.globalid,
                        v_ward, null, rec.autoid
                        FROM (
                            select v.CUSTODYCD,v.ACCTNO,v.SYMBOL,SUM(NAMT) TRADE,v.TXNUM,v.TXDATE,v.txtype
                            from vw_setran_gen v, cfmast c
                            where tltxcd = '2242'
                            and v.FIELD in('TRADE','BLOCKED')
                            and v.txtype = 'D'
                            and c.custodycd = v.CUSTODYCD
                            and c.supebank = 'Y'
                            and v.txnum = v_txnum and v.txdate = v_txdate
                            and ((c.fundcode is not null and length(c.fundcode) > 0) or c.supebank = 'Y')
                            group by v.CUSTODYCD,v.ACCTNO,v.SYMBOL,v.TXNUM,v.TXDATE,v.txtype
                        ) g,sbsecurities s
                        where s.symbol = g.symbol;
                    ELSE
                        l_autoid := to_number(fn_get_tllogfld_value(v_txnum,v_txdate,'18','N'));
                        l_qtty := to_number(fn_get_tllogfld_value(v_txnum,v_txdate,'10','N')) + to_number(fn_get_tllogfld_value(v_txnum,v_txdate,'06','N'));
                        v_blocked := to_number(fn_get_tllogfld_value(v_txnum,v_txdate,'06','N'));
                        INSERT INTO CBFA_ODDEXCHANGETX@CBFALINK(AUTOID,CUSTODYCD,SEACCTNO,TXQTTY,TXBLOCK,CAQTTY,PARVALUE,
                        FEEAMT,TAXAMT,TXDORC,REFSYMBOL,TOCUSTODYCD,TOSEACCTNO,TXDATE,
                        BUSDATE,TXNUM,DESCRIPTION,STATUS,GLOBALID,INWARD,OUTWARD,refnotifyid)
                        SELECT seq_cbfa_oddexchagetx.nextval@CBFALINK,g.custodycd,g.acctno, l_qtty,v_blocked,0,g.price,
                        g.fee,g.tax,'D',g.symbol,g.recustodycd,null,v_txdate, v_busdate,v_txnum,v_desc,
                        'P',rec.globalid,null,g.outward,rec.autoid
                        FROM (
                            select t.*, cf.custodycd,s.symbol,s.parvalue from sesendout t, semast se, cfmast cf, sbsecurities s
                            where t.acctno = se.acctno and se.custid = cf.custid and s.codeid = t.codeid
                            and t.autoid = l_autoid and t.status = 'C' and t.trtype IN ('001','018')
                            and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y')
                        ) g;
                    END IF;
                END;
            ELSIF REC.OBJNAME = 'CBFAODDEXCHANGE_DELETE' THEN
                UPDATE CBFA_ODDEXCHANGETX@CBFALINK SET STATUS = 'D' WHERE TXNUM = rec.txnum AND TXDATE = rec.txdate;
            ELSIF REC.OBJNAME = 'CAALLOCATE' THEN
                BEGIN
                    SELECT  TL.MSGACCT, CASE WHEN TL.TLTXCD IN ('3341','3345') THEN '' ELSE TL.TXNUM END, TXDATE, TLTXCD,
                    CASE WHEN TL.TLTXCD IN ('3341','3345') THEN TL.TXNUM ELSE TL.REFTXNUM END
                    INTO L_CAMASTID, L_TXNUM, L_TXDATE, L_TLTXCD, L_REFTXNUM
                    FROM TLLOG TL
                    WHERE TL.TLTXCD IN('3356','3333','3337','3385','3341','3345')
                    AND TL.AUTOID = REC.KEYVALUE ;

                    IF L_TLTXCD = '3333' THEN
                        SELECT TL.CVALUE INTO L_CAMASTID FROM TLLOGFLD TL WHERE TL.TXDATE = L_TXDATE AND TL.TXNUM = L_TXNUM AND TL.FLDCD = '02';
                    ELSIF L_TLTXCD = '3385' THEN
                        SELECT TL.CVALUE INTO L_CAMASTID FROM TLLOGFLD TL WHERE TL.TXDATE = L_TXDATE AND TL.TXNUM = L_TXNUM AND TL.FLDCD = '06';
                    END IF;

                    l_refId := '';
                    IF l_tltxcd = '3337' THEN
                        l_refKey := fn_get_tllogfld_value(rec.txnum,rec.txdate,'01','C'); -- catransfer.autoid
                        FOR rec_trf IN (SELECT * FROM catransfer WHERE autoid = l_refKey)
                        LOOP
                            l_refId := rec_trf.notransct;
                        END LOOP;
                    ELSIF l_tltxcd = '3385' THEN
                        l_refKey := fn_get_tllogfld_value(rec.txnum,rec.txdate,'50','C'); -- catransfer.txdate || txnum
                        FOR rec_trf IN (SELECT * FROM catransfer WHERE TO_CHAR(TXDATE,'DDMMRRRR') || TXNUM = l_refKey)
                        LOOP
                            l_refId := rec_trf.notransct;
                        END LOOP;
                    END IF;

                    SELECT REPORTDATE, ACTIONDATE INTO L_REPORTDATE,L_EXDATE FROM CAMAST WHERE CAMASTID= L_CAMASTID;
                    v_globalid := 'CB.' || TO_CHAR(rec.txdate, 'rrrrmmdd.') || rec.txnum;

                    INSERT INTO CBFA_CONFIRMCA@CBFALINK (REFNOTIFYID,AUTOID,CUSTODYCD,CAMASTID,EXDATE,REPORTDATE,CATYPECF,TICKER,TYPEOFACC,NOTE,STATUS,DELTD,QTTY,GLOBALID,CONTRACTNO)
                    SELECT REC.AUTOID,SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK, SE.CUSTODYCD, L_CAMASTID,L_EXDATE,L_REPORTDATE,
                    CASE WHEN L_TLTXCD IN('3356', '3341','3345') THEN 'A'
                         WHEN L_TLTXCD = '3333' THEN 'C'
                         WHEN L_TLTXCD IN('3337','3385') THEN 'T' END,
                    SE.SYMBOL,
                    CASE WHEN L_TLTXCD IN('3356', '3385') THEN 'C'
                         WHEN L_TLTXCD IN('3333','3337','3341','3345') THEN 'D' END,
                    SE.TXDESC,'P','N',SE.NAMT, v_globalid, l_refId
                    FROM VW_SETRAN_GEN SE, TLLOG TL, CFMAST CF
                    WHERE ((L_TXNUM IS NULL AND TL.Reftxnum = l_reftxnum)
                    OR (L_TXNUM IS NOT NULL AND TL.Txnum = L_TXNUM))
                    AND TL.Txdate = L_TXDATE
                    AND SE.TXDATE = TL.Txdate
                    AND SE.TXNUM = TL.Txnum
                    AND SE.FIELD = 'TRADE'
                    AND((TL.Tltxcd = '3333')
                    OR (TL.Tltxcd IN ('3385','3356') AND SE.TXTYPE = 'C')
                    OR (TL.Tltxcd IN ('3351','3337') AND SE.TXTYPE = 'D'))
                    AND SE.CUSTODYCD = CF.CUSTODYCD
                    AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                END;
            ELSIF REC.OBJNAME = 'CAALLOCATE_SWITH' THEN
                BEGIN
                    INSERT INTO CBFA_CONFIRMCA@CBFALINK (REFNOTIFYID,AUTOID,CUSTODYCD,CAMASTID,EXDATE,REPORTDATE,CATYPECF,TICKER,TYPEOFACC,NOTE,STATUS,DELTD,QTTY,AMT,INTAMT)
                    SELECT REC.AUTOID, SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK, CF.CUSTODYCD, CA.CAMASTID,null ,CA.REPORTDATE, 'R', SE.SYMBOL , 'C', CA.DESCRIPTION, 'P','N',CHD.QTTY,
                    ROUND(CHD.AMT - CHD.INTAMT,0) AMT, ROUND(CHD.INTAMT - CHD.INTAMT*CA.PITRATE/100, 0) INTAMT
                    FROM CAMAST CA, CASCHD CHD,CFMAST CF, AFMAST AF, SBSECURITIES SE
                    WHERE CA.CATYPE = '023'
                    AND CA.DUEDATE = L_CURRDATE
                    AND CA.CAMASTID = CHD.CAMASTID
                    AND CHD.DELTD <> 'Y'
                    AND CHD.AFACCTNO = AF.ACCTNO
                    AND AF.CUSTID = CF.CUSTID
                    AND CHD.QTTY > 0
                    AND SE.CODEID = CA.TOCODEID
                    AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                END;
            ELSIF REC.OBJNAME = 'CAALLOCATE_RIGHT' THEN
                BEGIN
                    INSERT INTO CBFA_CONFIRMCA@CBFALINK (REFNOTIFYID,AUTOID,CUSTODYCD,CAMASTID,EXDATE,REPORTDATE,CATYPECF,TICKER,TYPEOFACC,NOTE,STATUS,DELTD,QTTY,GLOBALID)
                    SELECT REC.AUTOID, SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK, CAR.CUSTODYCD, CAR.CAMASTID, null, CA.REPORTDATE, 'R', CA.OPTSYMBOL, 'C', CA.DESCRIPTION, 'P','N',CAR.QTTY, 'CB.CAREGISTER.' || car.autoid
                    FROM CAMAST CA, CAREGISTER CAR,CFMAST CF
                    WHERE CA.CAMASTID = CAR.CAMASTID AND CA.DEBITDATE = L_CURRDATE
                    AND CAR.AUTOID = REC.KEYVALUE AND CAR.MSGSTATUS = 'P' AND CAR.QTTY > 0
                    AND CAR.CUSTODYCD = CF.CUSTODYCD
                    AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                END;
            ELSIF REC.OBJNAME = 'RIGHT_CAALLOCATE' THEN
                BEGIN
                    IF REC.TLTXCD = '3300' THEN
                        INSERT INTO CBFA_CONFIRMCA@CBFALINK (REFNOTIFYID,AUTOID,CUSTODYCD,CAMASTID,EXDATE,REPORTDATE,CATYPECF,TICKER,TYPEOFACC,NOTE,STATUS,DELTD,QTTY,GLOBALID)
                        SELECT REC.AUTOID, SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK, CAR.CUSTODYCD, CAR.CAMASTID, NULL, CA.REPORTDATE, 'C', CA.OPTSYMBOL, 'D', CA.DESCRIPTION, 'P','N',CAR.QTTY,'CB.CARIGHTCANCEL.' || CAR.AUTOID
                        FROM CAMAST CA, CACANCEL CAR, CFMAST CF
                        WHERE CA.CAMASTID = CAR.CAMASTID
                        AND CAR.TXNUM = REC.TXNUM
                        AND CAR.TXDATE = REC.TXDATE
                        AND CAR.QTTY > 0
                        AND CAR.CUSTODYCD = CF.CUSTODYCD
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                    ELSE
                        INSERT INTO CBFA_CONFIRMCA@CBFALINK (REFNOTIFYID,AUTOID,CUSTODYCD,CAMASTID,EXDATE,REPORTDATE,CATYPECF,TICKER,TYPEOFACC,NOTE,STATUS,DELTD,QTTY,GLOBALID)
                        SELECT REC.AUTOID, SEQ_CBFACONFIRMCA.NEXTVAL@CBFALINK, CAR.CUSTODYCD, CAR.CAMASTID, null, CA.REPORTDATE, 'E', CA.OPTSYMBOL, 'C', CA.DESCRIPTION, 'P','N',CAR.QTTY,'CB.CARIGHT.' || car.autoid
                        FROM CAMAST CA, CAREGISTER CAR,CFMAST CF
                        WHERE CA.CAMASTID = CAR.CAMASTID AND CAR.TXNUM = REC.TXNUM AND CAR.QTTY > 0
                        AND CAR.CUSTODYCD = CF.CUSTODYCD
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                    END IF;

                END;
            ELSIF REC.OBJNAME = 'RIGHT_CANCEL' THEN
                BEGIN
                    UPDATE log_notify_cbfa SET status ='C', err_code=systemnums.c_success  WHERE AUTOID = REC.AUTOID;
                END;
            ELSIF REC.OBJNAME IN ('CBFA_FACAMAST', 'CBFA_FACAMAST_DELETE') THEN
                BEGIN
                    SELECT getprevworkingdate(REPORTDATE) INTO l_exdividend FROM CAMAST WHERE CAMASTID = rec.keyvalue;
                    INSERT INTO CBFA_FACAMAST@CBFALINK (AUTOID, CODEID, CATYPE, REPORTDATE, DUEDATE, ACTIONDATE, EXPRICE,
                                PRICE, EXRATE, RIGHTOFFRATE, DEVIDENTRATE, DEVIDENTSHARES, SPLITRATE, INTERESTRATE,
                                INTERESTPERIOD, STATUS, CAMASTID, DESCRIPTION, EXCODEID, PSTATUS, RATE, DELTD, TRFLIMIT,
                                PARVALUE, ROUNDTYPE, OPTSYMBOL, OPTCODEID, TRADEDATE, LASTDATE, RETAILSHARE, RETAILDATE,
                                FRDATERETAIL, TODATERETAIL, FRTRADEPLACE, TOTRADEPLACE, TRANSFERTIMES, FRDATETRANSFER,
                                TODATETRANSFER, TASKCD, TOCODEID, LAST_CHANGE, PITRATE, PITRATEMETHOD, ISWFT, PRICEACCOUNTING,
                                CAQTTY, BEGINDATE, PURPOSEDESC, DEVIDENTVALUE, ADVDESC, TYPERATE, CIROUNDTYPE, PITRATESE,
                                INACTIONDATE, MAKERID, APPRVID, EXERATE, CANCELDATE, RECEIVEDATE, CANCELSTATUS, ISINCODE,
                                TRFFEEAMT, CANCELSHARE, EXFROMDATE, EXTODATE, EXCANCELDATE, EXRECVDATE, DOMESTICCD, VSDSTATUS,
                                EXADDRESS, VSDID, PARNAME, CHANGECONTENT, CONVERTDATE, MEETINGPLACE, STOPTRANDATE, INSDEADLINE,
                                DEBITDATE, RIGHTTRANSDL, SUBMISSIONDL, LASTTRADINGD, EFFECDELDATE, SYMBOL, OPTISINCODE, ROUNDMETHOD,
                                REFNOTIFYID,EXDIVIDEND)
                    SELECT      SEQ_CBFA_FACAMAST.NEXTVAL@CBFALINK, SE.SYMBOL, CA.CATYPE, CA.REPORTDATE, CA.DUEDATE, CA.ACTIONDATE,
                                CA.EXPRICE, CA.PRICE, CA.EXRATE, CA.RIGHTOFFRATE, CA.DEVIDENTRATE, CA.DEVIDENTSHARES, CA.SPLITRATE,
                                CA.INTERESTRATE, CA.INTERESTPERIOD, CA.STATUS, CA.CAMASTID, CA.DESCRIPTION, CA.EXCODEID, CA.PSTATUS,
                                CA.RATE, CA.DELTD, CA.TRFLIMIT, CA.PARVALUE, CA.ROUNDTYPE, CA.OPTSYMBOL, CA.OPTCODEID, CA.TRADEDATE,
                                CA.LASTDATE, CA.RETAILSHARE, CA.RETAILDATE, CA.FRDATERETAIL, CA.TODATERETAIL, CA.FRTRADEPLACE,
                                CA.TOTRADEPLACE, CA.TRANSFERTIMES, CA.FRDATETRANSFER, CA.TODATETRANSFER, CA.TASKCD, SE1.SYMBOL,
                                CA.LAST_CHANGE, CA.PITRATE, CA.PITRATEMETHOD, CA.ISWFT, CA.PRICEACCOUNTING, CA.CAQTTY, CA.BEGINDATE,
                                CA.PURPOSEDESC, CA.DEVIDENTVALUE, CA.ADVDESC, CA.TYPERATE, CA.CIROUNDTYPE, CA.PITRATESE,
                                CA.INACTIONDATE, CA.MAKERID, CA.APPRVID, CA.EXERATE, CA.CANCELDATE, CA.RECEIVEDATE, CA.CANCELSTATUS,
                                CA.ISINCODE, CA.TRFFEEAMT, CA.CANCELSHARE, CA.EXFROMDATE, CA.EXTODATE, CA.EXCANCELDATE, CA.EXRECVDATE,
                                CA.DOMESTICCD, CA.VSDSTATUS, CA.EXADDRESS, CA.VSDID, CA.PARNAME, CA.CHANGECONTENT, CA.CONVERTDATE,
                                CA.MEETINGPLACE, CA.STOPTRANDATE, CA.INSDEADLINE, CA.DEBITDATE, CA.RIGHTTRANSDL, CA.SUBMISSIONDL,
                                CA.LASTTRADINGD, CA.EFFECDELDATE, SE.SYMBOL, CA.OPTISINCODE, CA.ROUNDMETHOD, REC.AUTOID,l_exdividend
                               FROM CAMAST CA, SBSECURITIES SE,SBSECURITIES SE1
                               WHERE CA.CAMASTID = REC.KEYVALUE
                               AND CA.CODEID = SE.CODEID
                               AND CA.TOCODEID = SE1.CODEID(+);
                END;
            ELSIF REC.OBJNAME = 'CBFA_CANCELOTC' THEN
                -- Thoai.tran 06/07/2021
                -- SHBVNEX-2386 Dong bo them cancel GD 1400/1407 (Dung tam key)
                IF REC.TLTXCD = '1400' THEN
                    BEGIN
                        INSERT INTO CBFA_CANCELOTC@CBFALINK
                        (AUTOID,REFNOTIFYID,CONTRACTID,EXECTYPE,TYPE,QTTY,PRICE,AMT,FEE,TAX,NETAMOUNT,TXDATE,TXNUM,STATUS,SYMBOL)
                        SELECT SEQ_CBFA_CANCELOTC.NEXTVAL@CBFALINK,REC.AUTOID,A.AUTOID,'S','OTC'
                        ,LOG.QTTY,SB.PARVALUE,CR.CLVALUE,LOG.FEE,LOG.TAX,LOG.AMT
                        ,rec.txdate,rec.txnum,'P',SB.SYMBOL
                        FROM APPENDIX A,CRPHYSAGREE_SELL_LOG LOG, CRPHYSAGREE CR, TLLOG TL,SBSECURITIES SB, SBCURRENCY S, CFMAST CF
                        WHERE A.TXNUM = REC.TXNUM AND A.TXDATE = REC.TXDATE
                        AND A.TXNUM = LOG.TXNUM AND A.TXDATE = LOG.TXDATE
                        AND A.TXNUM = TL.TXNUM AND A.TXDATE = TL.TXDATE AND TL.DELTD = 'N'
                        AND A.CRPHYSAGREEID = CR.CRPHYSAGREEID
                        AND CR.CUSTODYCD = CF.CUSTODYCD
                        AND A.CODEID = SB.CODEID
                        AND S.CCYCD= SB.CCYCD
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y')
                        AND SB.TRADEPLACE IN ('003');
                    END;
                ELSIF REC.TLTXCD = '1444' THEN
                    BEGIN
                        INSERT INTO CBFA_CANCELOTC@CBFALINK
                        (AUTOID,REFNOTIFYID,CONTRACTID,EXECTYPE,TYPE,QTTY,PRICE,AMT,FEE,TAX,NETAMOUNT,TXDATE,TXNUM,STATUS,SYMBOL)
                        SELECT SEQ_CBFA_CANCELOTC.NEXTVAL@CBFALINK,REC.AUTOID,A.AUTOID,'S','OTC'
                        ,LOG.QTTY,SB.PARVALUE,CR.CLVALUE,LOG.FEE,LOG.TAX,LOG.AMT
                        ,rec.txdate,rec.txnum,'P',SB.SYMBOL
                        FROM APPENDIX A,CRPHYSAGREE_SELL_LOG LOG, CRPHYSAGREE CR,/* TLLOG TL,*/SBSECURITIES SB, SBCURRENCY S, CFMAST CF
                        WHERE A.AUTOID=REC.KEYVALUE
                        AND A.TXNUM = LOG.TXNUM AND A.TXDATE = LOG.TXDATE
                        --AND A.TXNUM = TL.TXNUM AND A.TXDATE = TL.TXDATE AND TL.DELTD = 'N'
                        AND A.CRPHYSAGREEID = CR.CRPHYSAGREEID
                        AND CR.CUSTODYCD = CF.CUSTODYCD
                        AND A.CODEID = SB.CODEID
                        AND S.CCYCD= SB.CCYCD
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y')
                        AND SB.TRADEPLACE IN ('003');
                    END;
                ELSIF REC.TLTXCD = '1407' THEN
                    BEGIN
                        INSERT INTO CBFA_CANCELOTC@CBFALINK
                        (AUTOID,REFNOTIFYID,CONTRACTID,EXECTYPE,TYPE,QTTY,PRICE,AMT,FEE,TAX,NETAMOUNT,TXDATE,TXNUM,STATUS,SYMBOL)
                        SELECT SEQ_CBFA_CANCELOTC.NEXTVAL@CBFALINK,REC.AUTOID,
                        CASE WHEN sb.sectype IN ('009','013') THEN OT.CRPHYSAGREEID
                        ELSE OT.NO END ,'B','OTC',OT.QTTY,SB.PARVALUE,OT.CLVALUE,
                        0,0,0,rec.txdate,rec.txnum,'P',OT.SYMBOL
                        FROM CRPHYSAGREE OT, SBSECURITIES SB, ISSUERS I, SBCURRENCY S,CFMAST CF
                        WHERE OT.CODEID = SB.CODEID
                        AND SB.ISSUERID = I.ISSUERID
                        AND S.CCYCD= SB.CCYCD
                        AND OT.TXNUM = REC.TXNUM
                        AND OT.TXDATE = REC.TXDATE
                        AND OT.CUSTODYCD = CF.CUSTODYCD
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y')
                        AND (SB.TRADEPLACE IN ('003') OR sb.sectype IN ('009','013'));
                        -- CDGLMAST : SECTYPE 009 013
                        -- OTCODMAST : TRADEPLACE 003
                    END;
                ELSE
                    BEGIN
                        INSERT INTO CBFA_CANCELOTC@CBFALINK (AUTOID,REFNOTIFYID,CONTRACTID,EXECTYPE,TYPE,QTTY,PRICE,AMT,FEE,TAX,NETAMOUNT,TXDATE,TXNUM,STATUS,SYMBOL)
                        SELECT SEQ_CBFA_CANCELOTC.NEXTVAL@CBFALINK,REC.AUTOID,OTC.OTCODID,
                               CASE WHEN OTC.EXECTYPE = 'NB' THEN 'B' ELSE 'S' END,
                               'OTC',OTC.QTTY,OTC.PRICE,OTC.AMT,OTC.FEE,OTC.TAX,OTC.AMT,REC.TXDATE,REC.TXNUM,'P', OTC.SYMBOL
                        FROM OTCODMAST OTC, TLLOGFLD TLL,CFMAST CF
                        WHERE OTC.DELTD = 'Y'
                        AND TLL.TXNUM = REC.TXNUM AND TLL.TXDATE = REC.TXDATE AND TLL.FLDCD = '01'
                        AND OTC.AUTOID = NVL(TLL.CVALUE,TLL.NVALUE)
                        AND CF.CUSTODYCD LIKE (CASE WHEN OTC.EXECTYPE ='NB' THEN OTC.BCUSTODYCD
                                                    WHEN OTC.EXECTYPE ='NS' THEN OTC.SCUSTODYCD END)
                        AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                    END;
                END IF;
            ELSIF REC.OBJNAME = 'CBFA_CANCELLISTED' THEN
                BEGIN
                    INSERT INTO CBFA_CANCELOTC@CBFALINK (AUTOID,REFNOTIFYID,CONTRACTID,EXECTYPE,TYPE,QTTY,PRICE,AMT,FEE,TAX,NETAMOUNT,TXDATE,TXNUM,STATUS,SYMBOL)
                    SELECT SEQ_CBFA_CANCELOTC.NEXTVAL@CBFALINK,REC.AUTOID,OD.ORDERID,
                           CASE WHEN OD.EXECTYPE = 'NB' THEN 'B' ELSE 'S' END,
                           'LISTED',OD.ORDERQTTY,OD.ORDERPRICE,OD.EXECAMT,OD.FEEAMT,OD.TAXAMT,OD.NETAMOUNT,
                           REC.TXDATE,REC.TXNUM,'P',OD.SYMBOL
                    FROM ODMAST OD, TLLOGFLD TLL,CFMAST CF
                    WHERE OD.DELTD = 'Y'
                    AND TLL.TXNUM = REC.TXNUM AND TLL.TXDATE = REC.TXDATE AND TLL.FLDCD = '06'
                    AND OD.ORDERID = NVL(TLL.CVALUE,TLL.NVALUE)
                    AND CF.CUSTODYCD = OD.CUSTODYCD
                    AND ((CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y');
                END;
/*            ELSIF REC.objname = 'SEMAST' THEN
                BEGIN
                    insert into CBFA_SEMAST@CBFALINK (AUTOID, REFNOTIFYID, ACCTNO, AFACCTNO, CUSTODYCD, CODEID, SYMBOL, TRADE, RECEIVING, NETTING, BLOCKED, MORTAGE, EMKQTTY, TXDATE, STATUS)
                    SELECT seq_cbfaconfirmca.NEXTVAL@CBFALINK,rec.autoid,
                           r.ACCTNO,r.AFACCTNO,r.CUSTODYCD,r.CODEID,r.SYMBOL,
                           r.TRADE,r.RECEIVING,r.NETTING, r.BLOCKED, r.MORTAGE, r.EMKQTTY, r.TXDATE, 'P'
                    FROM
                    (SELECT DISTINCT se.acctno, se.afacctno, cf.CUSTODYCD,
                          se.codeid, sb.symbol,se.Trade, se.Receiving,
                          se.netting, se.blocked, se.mortage, se.emkqtty,
                          t.CURRDATE TXDATE
                     FROM SEMAST se, sbsecurities sb,cfmast cf,
                          (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') CURRDATE  FROM SYSVAR
                                WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE') t
                     WHERE cf.custid = se.afacctno
                           and se.codeid = sb.codeid) r;
                END;
            ELSIF REC.objname = 'DDMAST' THEN
                BEGIN
                     insert into CBFA_DDMAST@CBFALINK (ACCTNO, CUSTODYCD, BANKACCT, BALANCE, TXDATE, AFACCTNO, REFNOTIFYID, AUTOID)
                     SELECT r.ACCTNO,r.CUSTODYCD, r.BANKACCT, r.BALANCE, r.TXDATE, r.AFACCTNO,
                            rec.autoid,seq_cbfaconfirmca.NEXTVAL@CBFALINK
                     FROM
                     (SELECT ci.AFACCTNO, ci.ACCTNO, ci.Custodycd,
                             (ci.Balance + ci.pendinghold + ci.pendingunhold + ci.holdbalance) BALANCE,
                              ci.refcasaacct bankacct, t.CURRDATE TXDATE
                     FROM DDMAST ci, CFMAST cf,
                          (SELECT TO_DATE(VARVALUE,'DD/MM/YYYY') CURRDATE  FROM SYSVAR
                                WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE') t
                     WHERE ci.Custodycd = cf.custodycd ) r;
                END;*/
            ELSIF REC.OBJNAME IN ('DDSEMAST_CURRENT','DDSEMAST_BATCH') THEN
                BEGIN
                    v_custodycd := CASE WHEN REC.OBJNAME = 'DDSEMAST_CURRENT' THEN REC.KEYVALUE ELSE '%%' END;

                    INSERT INTO CBFA_DDMAST@CBFALINK (ACCTNO, CUSTODYCD, BANKACCT, BALANCE, TXDATE, AFACCTNO, REFNOTIFYID, AUTOID, AITHERSTATUS)
                    SELECT DD.ACCTNO, DD.CUSTODYCD, DD.REFCASAACCT BANKACCT,
                           (DD.BALANCE + DD.PENDINGHOLD + DD.PENDINGUNHOLD + DD.HOLDBALANCE - NVL(TRAN.BALANCE_TR,0) - NVL(TRAN.PENDINGHOLD_TR,0) - NVL(TRAN.PENDINGUNHOLD_TR,0) - NVL(TRAN.HOLDBALANCE_TR,0)) BALANCE,
                           REC.TXDATE, DD.AFACCTNO, REC.AUTOID, SEQ_CBFA_DDMAST.NEXTVAL@CBFALINK,
                           (CASE WHEN NVL(RQ.STATUS,'-') IN ('E','R') THEN 'E'
                                WHEN NVL(RQ.STATUS,'-') = 'C' THEN (CASE WHEN RQ.BANKBALANCE = RQ.BALANCE AND RQ.BANKHOLDBALANCE = RQ.HOLDBALANCE THEN 'Y' ELSE 'N' END)
                                WHEN NVL(RQ.STATUS,'-') = '-' THEN 'ZZ'
                                ELSE 'P'
                            END) AITHERSTATUS
                    FROM DDMAST DD, CFMAST CF,
                    (
                        SELECT * FROM INQACCT_LOG WHERE TXDATE IN (SELECT MAX(TXDATE) FROM INQACCT_LOG) --CASE WHEN REC.TXDATE > L_CURRDATE THEN L_CURRDATE ELSE REC.TXDATE END)
                    ) RQ,
                    (
                        SELECT SUM(CASE WHEN TXTYPE ='C' AND FIELD ='BALANCE' THEN NAMT
                                         WHEN TXTYPE ='D' AND FIELD ='BALANCE' THEN -NAMT
                                    ELSE 0 END) BALANCE_TR,
                        SUM(CASE WHEN TXTYPE ='C' AND FIELD ='PENDINGHOLD' THEN NAMT
                                 WHEN TXTYPE ='D' AND FIELD ='PENDINGHOLD' THEN -NAMT
                            ELSE 0 END) PENDINGHOLD_TR,
                        SUM(CASE WHEN TXTYPE ='C' AND FIELD ='PENDINGUNHOLD' THEN NAMT
                                 WHEN TXTYPE ='D' AND FIELD ='PENDINGUNHOLD' THEN -NAMT
                            ELSE 0 END) PENDINGUNHOLD_TR,
                        SUM(CASE WHEN TXTYPE ='C' AND FIELD ='HOLDBALANCE' THEN NAMT
                                 WHEN TXTYPE ='D' AND FIELD ='HOLDBALANCE' THEN -NAMT
                            ELSE 0 END) HOLDBALANCE_TR
                        ,ACCTNO
                        FROM VW_DDTRAN_GEN WHERE DELTD <>'Y' AND BUSDATE > REC.TXDATE
                        GROUP BY ACCTNO
                    ) TRAN
                    WHERE CF.CUSTID = DD.CUSTID
                    AND CF.SUPEBANK = 'Y'
                    AND CF.CUSTODYCD LIKE V_CUSTODYCD
                    AND DD.ACCTNO = RQ.AFACCTNO(+)
                    AND DD.ACCTNO = TRAN.ACCTNO(+);

                     --S? DU CH?NG KHO?N
                     INSERT INTO CBFA_SEMAST@CBFALINK (AUTOID, REFNOTIFYID,
                     ACCTNO, AFACCTNO, CUSTODYCD, CODEID, SYMBOL,
                     TRADE, RECEIVING, NETTING, BLOCKED, MORTAGE, EMKQTTY, TXDATE, STATUS)
                     SELECT SEQ_CBFA_SEMAST.NEXTVAL@CBFALINK,REC.AUTOID,
                            R.ACCTNO,R.AFACCTNO,R.CUSTODYCD,R.CODEID,R.SYMBOL,
                            R.TRADE ,R.RECEIVING,R.NETTING, R.BLOCKED, R.MORTAGE, R.EMKQTTY, R.TXDATE, 'P'
                     FROM
                     (SELECT DISTINCT SE.ACCTNO, SE.AFACCTNO, CF.CUSTODYCD,
                          SE.CODEID, SB.SYMBOL,
                          SE.TRADE - NVL(TRAN.TRADE_TR,0) TRADE,
                          SE.RECEIVING - NVL(TRAN.RECEIVING_TR,0)  RECEIVING,
                          SE.NETTING - NVL(TRAN.NETTING_TR,0) NETTING,
                          SE.BLOCKED - NVL(TRAN.BLOCKED_TR,0) BLOCKED,
                          SE.MORTAGE - NVL(TRAN.MORTAGE_TR,0)  MORTAGE,
                          SE.EMKQTTY - NVL(TRAN.EMKQTTY_TR,0) EMKQTTY,
                          REC.TXDATE TXDATE
                     FROM SEMAST SE, SBSECURITIES SB,CFMAST CF,AFMAST AF,
                         (SELECT  SUM( CASE WHEN TXTYPE ='C' AND FIELD ='TRADE' THEN NAMT
                                            WHEN TXTYPE ='D' AND FIELD ='TRADE' THEN -NAMT
                                            ELSE 0 END ) TRADE_TR,
                                  SUM( CASE WHEN TXTYPE ='C' AND FIELD ='RECEIVING' THEN NAMT
                                            WHEN TXTYPE ='D' AND FIELD ='RECEIVING' THEN -NAMT
                                            ELSE 0 END ) RECEIVING_TR,
                                  SUM( CASE WHEN TXTYPE ='C' AND FIELD ='NETTING' THEN NAMT
                                            WHEN TXTYPE ='D' AND FIELD ='NETTING' THEN -NAMT
                                            ELSE 0 END ) NETTING_TR,
                                  SUM( CASE WHEN TXTYPE ='C' AND FIELD ='BLOCKED' THEN NAMT
                                            WHEN TXTYPE ='D' AND FIELD ='BLOCKED' THEN -NAMT
                                            ELSE 0 END ) BLOCKED_TR,
                                  SUM( CASE WHEN TXTYPE ='C' AND FIELD ='MORTAGE' THEN NAMT
                                            WHEN TXTYPE ='D' AND FIELD ='MORTAGE' THEN -NAMT
                                            ELSE 0 END ) MORTAGE_TR,
                                  SUM( CASE WHEN TXTYPE ='C' AND FIELD ='EMKQTTY' THEN NAMT
                                            WHEN TXTYPE ='D' AND FIELD ='EMKQTTY' THEN -NAMT
                                            ELSE 0 END ) EMKQTTY_TR
                                  , ACCTNO
                         FROM VW_SETRAN_GEN WHERE DELTD <>'Y' AND BUSDATE > REC.TXDATE
                         GROUP BY ACCTNO) TRAN
                     WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = SE.AFACCTNO
                         AND SE.CODEID = SB.CODEID
                         AND CF.CUSTODYCD LIKE v_custodycd
                         AND CF.CUSTODYCD IN (SELECT CUSTODYCD FROM CFMAST CF WHERE (CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y')
                         AND SE.ACCTNO = TRAN.ACCTNO(+)) R;

                     --Ph?sinh giao d?ch
                     INSERT INTO CBFA_SETRAN@CBFALINK (TXNUM, TXDATE, ACCTNO, FIELD, NAMT, CAMT,
                         REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC, TXTYPE, REFNOTIFYID, LOGTIME,SYMBOL,CUSTODYCD)
                     SELECT A.TXNUM, A.TXDATE, A.ACCTNO, A.FIELD, A.NAMT, A.CAMT,
                         A.REF,A.DELTD, SEQ_CBFA_SETRAN.NEXTVAL@CBFALINK,A.ACCTREF,TL.TLTXCD,TL.BUSDATE,
                         CASE WHEN TL.TLID ='6868' THEN TRIM(TL.TXDESC) || ' (Online)' ELSE TL.TXDESC END TRDESC,
                         A.TXTYPE,REC.AUTOID,SYSDATE,A.SYMBOL,V_CUSTODYCD
                     FROM VW_SETRAN_GEN A, VW_TLLOG_ALL TL
                     WHERE A.TXNUM = TL.TXNUM AND A.TXDATE = TL.TXDATE
                     AND A.DELTD <> 'Y'
                     AND A.TLTXCD NOT IN ('2212','2213')
                     AND (A.TXDATE = REC.TXDATE OR A.BUSDATE = REC.TXDATE)
                     AND A.CUSTODYCD LIKE v_custodycd
                     AND A.CUSTODYCD IN (SELECT CUSTODYCD FROM CFMAST CF WHERE (CF.FUNDCODE IS NOT NULL AND LENGTH(CF.FUNDCODE) > 0) OR CF.SUPEBANK = 'Y')
                     AND A.FIELD IN('TRADE', 'RECEIVING', 'NETTING')
                     AND A.NAMT <> 0;

                     IF REC.OBJNAME IN ('DDSEMAST_BATCH') THEN
                        INSERT INTO CRBTXREQHIST
                        SELECT * FROM CRBTXREQ WHERE STATUS IN ('R','E','C') AND OBJNAME <> '6690' AND REQCODE IN ('INQACCT');
                        DELETE FROM CRBTXREQ WHERE STATUS IN ('R','E','C') AND OBJNAME <> '6690' AND REQCODE IN ('INQACCT');
                     END IF;

                END;
            ELSIF REC.OBJNAME IN ('CBFA_BUSDATE') THEN
                BEGIN
                    --Ph?sinh giao d?ch
                    INSERT INTO CBFA_SETRAN@CBFALINK (TXNUM, TXDATE, ACCTNO, FIELD, NAMT, CAMT,
                         REF, DELTD, AUTOID, ACCTREF, TLTXCD, BKDATE, TRDESC, TXTYPE, REFNOTIFYID, LOGTIME,SYMBOL,CUSTODYCD)
                    SELECT TR.TXNUM, TR.TXDATE, TR.ACCTNO, AP.FIELD, TR.NAMT, TR.CAMT,
                          TR.REF,TR.DELTD, SEQ_CBFA_SETRAN.NEXTVAL@CBFALINK,TR.ACCTREF,TL.TLTXCD,TL.BUSDATE,
                          CASE WHEN TL.TLID ='6868' THEN TRIM(TL.TXDESC) || ' (Online)' ELSE TL.TXDESC END TRDESC,
                          AP.TXTYPE,REC.AUTOID,SYSDATE,SB.SYMBOL,CF.CUSTODYCD
                    FROM SETRAN TR, TLLOG TL, SBSECURITIES SB, SEMAST SE, CFMAST CF, APPTX AP
                    WHERE TR.TXDATE = TL.TXDATE AND TR.TXNUM = TL.TXNUM
                        AND TR.ACCTNO = SE.ACCTNO
                        AND SB.CODEID = SE.CODEID
                        AND SE.CUSTID = CF.CUSTID
                        AND TR.TXCD = AP.TXCD AND AP.APPTYPE = 'SE' AND AP.TXTYPE IN ('D','C')
                        AND TR.DELTD <> 'Y' AND TR.NAMT <> 0
                        AND TL.TLTXCD NOT IN ('2212','2213')
                        AND TR.TXNUM = REC.TXNUM AND TR.TXDATE = REC.TXDATE
                        AND AP.FIELD IN('TRADE', 'RECEIVING', 'NETTING')
                        AND EXISTS (SELECT CUSTODYCD FROM CFMAST T WHERE T.CUSTODYCD = CF.CUSTODYCD AND ((T.FUNDCODE IS NOT NULL AND LENGTH(T.FUNDCODE) > 0) OR T.SUPEBANK = 'Y'));
                END;
            ELSIF REC.objname = 'REVERTTRAN' THEN
                BEGIN
                     plog.error('REVERTTRAN '||rec.txdate||rec.txnum);
                END;
            ELSIF REC.objname = 'CBFABANKPAYMENT' THEN
               BEGIN
                    insert into CBFA_BANKPAYMENT@CBFALINK(AUTOID,FUNDCODEID,TRADINGID,ACCTNO,TXDATE,TRANSTYPE,REFCONTRACT,INSTRUCTTYPE,
                    TRANSFERTYPE,CITAD,BANKACCTNO,BANKNAME,BRANCH,CUSTNAME,AMOUNT,CHARGE,NOTES,RERKEY,GLOBALID,
                    SBSTATUS,STATUS,REFNOTIFYID,TLTXCD,REFBANKACCT,FEETYPE,VALUEDATE)
                    select seq_cbfaconfirmca.NEXTVAL@CBFALINK, null,f.CUSTODYCD,f.ACCTNO,TO_DATE(REC.txdate),'T',f.REFCONTRACT,
                    F.TXTYPE,
                    f.transtype, f.citad,f.beneficiaryaccount,f.bankname,f.bankbrach,F.CUSTNAME,f.TXAMT,null,F.NOTES, rec.txnum, rec.globalid,
                    'P', 'P',rec.autoid,f.Tltxcd,f.REFBANKACCT,f.FEETYPE,F.VALUEDATE
                    from CBFA_BANKPAYMENT F, CFMAST CF
                    where globalid = rec.globalid
                    and f.custodycd = cf.custodycd
                    and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');
                END;
            ELSIF REC.objname = 'CRBTXREQ_RESULT' THEN
              select cr.reqcode,cr.objname,cr.reqtxnum,cr.trfcode into v_reqcode,v_objname,v_reqtxnum,v_trfcode
              from crbtxreq cr where cr.reqid = rec.keyvalue;

              IF REC.ACTION = 'C' THEN
                BEGIN
                    IF v_reqcode IN ('OUTTRFCACASH') THEN--3350,3354
                        BEGIN
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            select c.catype, v.TLTXCD,v.MSGACCT into v_catype,l_tltxcd,l_CAMASTID from camast c, vw_tllog_all v
                            where v.TXNUM = v_txnum and v.TXDATE = v_txdate and v.DELTD = 'N'
                            and v.MSGACCT = c.camastid;

                            v_globalid := v_reqtxnum;

                            IF v_catype IN ('015','016','017','023','020') THEN
                                l_bankadv_wdrtype := 'CAREB'; -- ca receive cash bond
                            ELSE
                                l_bankadv_wdrtype := 'CAREC'; -- ca receive cash
                            END IF;

                            SELECT cr.currency, cr.notes, nvl(cr.dorc,'C'), cr.txamt,nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.bankacct, cr.afacctno
                            INTO l_bankadv_ccycd,l_bankadv_description, l_dorc, l_amt, l_feeamt, l_taxamt, l_bankaccno, l_acctno
                            FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                            SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                            INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                ccycd,description,custodycd,txdorc,feeamt,taxamt)
                            SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                v_globalid banktxnum,
                                l_bankadv_wdrtype wdrtype,l_amt,
                                l_bankadv_ccycd ccycd,
                                l_bankadv_description description,
                                l_bankadv_custodycd custodycd,l_dorc,
                                l_feeamt,l_taxamt
                            FROM DUAL;

                            INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                            SELECT REC.AUTOID,'CAMASTID',l_CAMASTID,0,v_globalid FROM DUAL;

                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'CACASH_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                        END;
                    elsif v_reqcode IN ('6651') and v_trfcode = 'CITAD' THEN
                        begin
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            --tai khoan gui
                            begin
                                l_dorc := 'D';
                                l_FEETYPE := '3';
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'06','C');

                                -- HACH TOAN GIAM CHO TAI KHOAN GUI cr.bankacct / l_dorc(D)
                                SELECT cr.currency, cr.notes, nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.rbankaccount, cr.afacctno, cr.bankacct
                                    INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno,refbankacct
                                    FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                    SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                                    --tien mua
                                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                    ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                            v_globalid banktxnum,
                                            'OTHERS' wdrtype,l_amt,
                                            l_bankadv_ccycd ccycd,
                                            l_bankadv_description description,
                                            l_bankadv_custodycd custodycd,l_dorc,
                                            l_feeamt, l_taxamt,L_FEETYPE
                                    FROM DUAL;
                                INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'BANKACCTNO',refbankacct,0,REC.GLOBALID FROM DUAL;
                            end;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                        end;
                    elsif v_reqcode IN ('6650') and v_trfcode = 'ITRANSFER' THEN
                        begin
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            --tai khoan gui
                            begin
                                l_dorc := 'D';
                                l_FEETYPE := '3';
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'06','C');

                                -- HACH TOAN GIAM CHO TAI KHOAN GUI cr.bankacct / l_dorc(D)
                                SELECT cr.currency, cr.notes, nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.rbankaccount, cr.afacctno, cr.bankacct
                                    INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno,refbankacct
                                    FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                    SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno  and status <> 'C';

                                    --tien mua
                                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                    ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                            v_globalid banktxnum,
                                            'OTHERS' wdrtype,l_amt,
                                            l_bankadv_ccycd ccycd,
                                            l_bankadv_description description,
                                            l_bankadv_custodycd custodycd,l_dorc,
                                            l_feeamt, l_taxamt,L_FEETYPE
                                    FROM DUAL;
                                INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'BANKACCTNO',refbankacct,0,REC.GLOBALID FROM DUAL;
                            end;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                        end;
                    elsif v_reqcode IN ('6621') and v_trfcode = 'OTRANSFER' THEN
                        begin
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            --tai khoan gui
                            begin
                                l_dorc := 'D';
                                l_FEETYPE := '3';
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'06','C');

                                -- HACH TOAN GIAM CHO TAI KHOAN GUI cr.bankacct / l_dorc(D)
                                SELECT cr.currency, cr.notes, nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.rbankaccount, cr.afacctno, cr.bankacct
                                    INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno,refbankacct
                                    FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                    SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                                    --tien mua
                                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                    ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                            v_globalid banktxnum,
                                            'OTHERS' wdrtype,l_amt,
                                            l_bankadv_ccycd ccycd,
                                            l_bankadv_description description,
                                            l_bankadv_custodycd custodycd,l_dorc,
                                            l_feeamt, l_taxamt,L_FEETYPE
                                    FROM DUAL;
                                INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'BANKACCTNO',refbankacct,0,REC.GLOBALID FROM DUAL;
                            end;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                        end;
                    elsif v_objname = '6620' and v_trfcode = 'ITRANSFER' THEN
                        begin
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            --tai khoan gui
                            begin
                                l_dorc := 'D';
                                l_FEETYPE := '3';
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'06','C');

                                -- HACH TOAN GIAM CHO TAI KHOAN GUI cr.bankacct / l_dorc(D)
                                SELECT cr.currency, cr.notes, nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.rbankaccount, cr.afacctno, cr.bankacct
                                INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno, refbankacct
                                FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                SELECT DD.CUSTODYCD INTO L_BANKADV_CUSTODYCD
                                FROM DDMAST DD
                                WHERE DD.REFCASAACCT = REFBANKACCT
                                AND DD.STATUS NOT IN ('C');

                                SELECT COUNT(1) INTO L_COUNT
                                FROM CFMAST
                                WHERE SUPEBANK = 'Y'
                                AND CUSTODYCD = L_BANKADV_CUSTODYCD;

                                IF L_COUNT > 0 THEN
                                    --tien mua
                                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                    ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                            v_globalid banktxnum,
                                            'TATFS' wdrtype,l_amt, --TRUNG.LUU 12-03-2021 SHBVNEX-1721   DOI WDRTYPE THANH TATFS
                                            l_bankadv_ccycd ccycd,
                                            l_bankadv_description description,
                                            l_bankadv_custodycd custodycd,l_dorc,
                                            l_feeamt, l_taxamt,L_FEETYPE
                                    FROM DUAL;
                                    INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'BANKACCTNO',refbankacct,0,REC.GLOBALID FROM DUAL;
                                END IF;
                            EXCEPTION WHEN OTHERS THEN
                                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                            end;

                            --tai khoan nhan
                            begin
                                l_dorc := 'C';
                                l_FEETYPE := '3';
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'81','C');

                                -- HACH TOAN TANG CHO TAI KHOAN NHAN cr.rbankaccount / l_dorc(C)
                                SELECT cr.currency, cr.notes,nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.bankacct, cr.afacctno, cr.rbankaccount
                                INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno, refbankacct
                                FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                SELECT DD.CUSTODYCD INTO L_RBANKADV_CUSTODYCD
                                FROM DDMAST DD
                                WHERE DD.REFCASAACCT = REFBANKACCT
                                AND DD.STATUS NOT IN ('C');

                                IF L_BANKADV_CUSTODYCD <> L_RBANKADV_CUSTODYCD THEN
                                    SELECT COUNT(1) INTO L_COUNT
                                    FROM CFMAST
                                    WHERE SUPEBANK = 'Y'
                                    AND CUSTODYCD = L_RBANKADV_CUSTODYCD;

                                    IF L_COUNT > 0 THEN
                                        --tien nhan
                                        INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt, ccycd,description,custodycd,txdorc,feeamt,taxamt)
                                        SELECT  rec.autoid ,'' bankid ,refbankacct,
                                                v_globalid banktxnum,
                                                'TATFS' wdrtype,l_amt, --TRUNG.LUU 12-03-2021 SHBVNEX-1721   DOI WDRTYPE THANH TATFS
                                                l_bankadv_ccycd ccycd,
                                                l_bankadv_description description,
                                                l_rbankadv_custodycd custodycd,l_dorc,
                                                l_feeamt, l_taxamt
                                        FROM DUAL;
                                    END IF;
                                END IF;
                            EXCEPTION WHEN OTHERS THEN
                                plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                            end;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                        end;
                    ELSIF v_reqcode IN ('PAYMENTSELLORDER','PAYMENTBUYORDER') and v_trfcode = 'WTRANSFER' THEN
                        BEGIN
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            select TLTXCD into l_tltxcd from vw_tllog_all where txdate = v_txdate and txnum = v_txnum;

                            IF l_tltxcd = '8818' THEN --8818 debit
                                BEGIN
                                    l_dorc := 'D';
                                    l_FEETYPE := '3';
                                    l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                    v_fee := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'11','N'));
                                    v_tax := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'27','N'));
                                    v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'04','C');
                                    l_codeid := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'02','C');

                                    select symbol into l_symbol from sbsecurities where codeid = l_codeid;

                                    select trim(cf.feedaily) into v_feedaily from cfmast cf,ddmast dd
                                    where cf.custodycd = dd.custodycd and dd.acctno = v_ddacctno and dd.status <> 'C';

                                    SELECT cr.currency, cr.notes, nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.rbankaccount, cr.afacctno, cr.bankacct
                                    INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno,refbankacct
                                    FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                    SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                                    --tien mua
                                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                    ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                            v_globalid banktxnum,
                                            'LICLSED' wdrtype,l_amt,
                                            l_bankadv_ccycd ccycd,
                                            l_bankadv_description description,
                                            l_bankadv_custodycd custodycd,l_dorc,
                                            l_feeamt, l_taxamt,L_FEETYPE
                                    FROM DUAL;
                                    --phi -> di co di tien va phi
                                    IF v_fee + v_tax > 0 AND v_feedaily = 'Y'  THEN
                                        INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                              ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                        SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                               v_globalid banktxnum,
                                               'LISEFEED' wdrtype,v_fee+v_tax,
                                               l_bankadv_ccycd ccycd,
                                               l_bankadv_description description,
                                               l_bankadv_custodycd custodycd,l_dorc,0,0,L_FEETYPE
                                        FROM DUAL;
                                    END IF;
                                    INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'BANKACCTNO',refbankacct,0,REC.GLOBALID FROM DUAL;

                                    INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'TICKER',l_symbol,0,REC.GLOBALID FROM DUAL;
                                END;
                            ELSE --8820 credit
                                BEGIN
                                    l_dorc := 'C';
                                    l_FEETYPE := '3';
                                    l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                    v_fee := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'11','N'));
                                    v_tax := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'27','N'));
                                    v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'04','C');
                                    l_codeid := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'02','C');

                                    select symbol into l_symbol from sbsecurities where codeid = l_codeid;

                                    select trim(cf.feedaily) into v_feedaily from cfmast cf,ddmast dd
                                    where cf.custodycd = dd.custodycd and dd.acctno = v_ddacctno and dd.status <> 'C';

                                    SELECT cr.currency, cr.notes,nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.bankacct, cr.afacctno, cr.rbankaccount
                                    INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno, refbankacct
                                    FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                    SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                                    --tien nhan
                                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt, ccycd,description,custodycd,txdorc,feeamt,taxamt)
                                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                            v_globalid banktxnum,
                                            'LICLSEC' wdrtype,l_amt,
                                            l_bankadv_ccycd ccycd,
                                            l_bankadv_description description,
                                            l_bankadv_custodycd custodycd,l_dorc,
                                            l_feeamt, l_taxamt
                                    FROM DUAL;

                                    --phi
                                    IF v_fee + v_tax > 0 AND v_feedaily = 'Y' THEN
                                        INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,
                                        wdrtype,amt,ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                        SELECT  rec.autoid ,'' bankid ,refbankacct,
                                                v_globalid banktxnum,
                                                'LISEFEEC' wdrtype,v_fee + v_tax,
                                                l_bankadv_ccycd ccycd,
                                                l_bankadv_description description,
                                                l_bankadv_custodycd custodycd,'D',0,0,L_FEETYPE
                                        FROM DUAL;
                                    END IF;
                                    INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'BANKACCTNO',l_bankaccno,0,REC.GLOBALID FROM DUAL;

                                    INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                    SELECT REC.AUTOID,'TICKER',l_symbol,0,REC.GLOBALID FROM DUAL;
                                END;
                            END IF;

                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                        END;
                    ELSIF v_reqcode IN ('PAYMENTBUYORDERTPRL') and v_trfcode = 'WTRANSFER' THEN
                        BEGIN
                            FOR REC_TPRL IN (
                                SELECT *
                                FROM
                                (
                                    SELECT * FROM VSTP_SETTLE_LOG
                                    UNION ALL
                                    SELECT * FROM VSTP_SETTLE_LOGHIST
                                )
                                WHERE TO_CHAR(AUTOID) = SUBSTR(V_REQTXNUM, INSTR(V_REQTXNUM, '.') + 1)
                            )
                            LOOP
                                v_txnum := REC_TPRL.TXNUM;
                                v_txdate := REC_TPRL.TXDATE;
                                v_globalid := v_reqtxnum;

                                l_dorc := 'D';
                                l_FEETYPE := '3';
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'10','N'));
                                v_fee := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'11','N'));
                                v_tax := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'27','N'));
                                v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'04','C');
                                l_codeid := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'02','C');

                                select symbol into l_symbol from sbsecurities where codeid = l_codeid;

                                select trim(cf.feedaily) into v_feedaily from cfmast cf,ddmast dd
                                where cf.custodycd = dd.custodycd and dd.acctno = v_ddacctno and dd.status <> 'C';

                                SELECT cr.currency, cr.notes, nvl(cr.feeamt,0), nvl(cr.taxamt,0), cr.rbankaccount, cr.afacctno, cr.bankacct
                                INTO l_bankadv_ccycd,l_bankadv_description, l_feeamt, l_taxamt, l_bankaccno, l_acctno,refbankacct
                                FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                                SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                                --tien mua
                                INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                        v_globalid banktxnum,
                                        'LICLSED' wdrtype,l_amt,
                                        l_bankadv_ccycd ccycd,
                                        l_bankadv_description description,
                                        l_bankadv_custodycd custodycd,l_dorc,
                                        l_feeamt, l_taxamt,L_FEETYPE
                                FROM DUAL;
                                --phi -> di co di tien va phi
                                IF v_fee + v_tax > 0 AND v_feedaily = 'Y'  THEN
                                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                          ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                           v_globalid banktxnum,
                                           'LISEFEED' wdrtype,v_fee+v_tax,
                                           l_bankadv_ccycd ccycd,
                                           l_bankadv_description description,
                                           l_bankadv_custodycd custodycd,l_dorc,0,0,L_FEETYPE
                                    FROM DUAL;
                                END IF;
                                INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                SELECT REC.AUTOID,'BANKACCTNO',refbankacct,0,REC.GLOBALID FROM DUAL;

                                INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                                SELECT REC.AUTOID,'TICKER',l_symbol,0,REC.GLOBALID FROM DUAL;

                                INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                                VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                            END LOOP;
                        END;
                    ELSIF v_reqcode = 'OUTTRFODSELL' THEN--3334
                        BEGIN
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            UPDATE CBFA_BANKPAYMENT SET PSTATUS=PSTATUS || BANKSTATUS,BANKSTATUS = REC.ACTION, REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                            WHERE globalid = v_globalid;
                        END;
                    ELSIF v_reqcode = 'BANKTRANSFEROUT8869' THEN --8869
                        BEGIN
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            select TLTXCD into l_tltxcd from vw_tllog_all where txdate = v_txdate and txnum = v_txnum;
                            l_FEETYPE := '3';
                            v_orderid := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'25','C');

                            select nvl(v.transactiontype,''),codeid into v_ordertype,v_codeid
                            from vw_odmast_all v where v.ORDERID = v_orderid;

                            select symbol into l_symbol from sbsecurities where codeid = v_codeid;
                            l_dorc := 'D';
                            --so tien
                            SELECT  cr.currency, cr.notes,cr.txamt,
                                    nvl(cr.feeamt,0), nvl(cr.taxamt,0),
                                    cr.bankacct, cr.afacctno, cr.rbankaccount
                            INTO l_bankadv_ccycd,l_bankadv_description,
                                 l_amt,l_feeamt, l_taxamt,
                                 l_bankaccno, l_acctno, refbankacct
                            FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');
                            --so phi
                            SELECT nvl(sum(cr.txamt),0) INTO v_fee FROM CRBTXREQ cr
                            where  cr.reqtxnum = v_globalid and cr.reqcode = 'PAYMENTFEE' and status = 'C';

                            SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                            /*IF v_ordertype = 'RE' THEN --type REPO

                              --Tien mua
                              INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                              SELECT  rec.autoid ,'' bankid ,refbankacct,
                                v_globalid banktxnum,
                                'REPOB' wdrtype,l_amt,
                                l_bankadv_ccycd ccycd,
                                l_bankadv_description description,
                                l_bankadv_custodycd custodycd,l_dorc,
                                l_feeamt, l_taxamt,L_FEETYPE
                              FROM DUAL;

                              --Phi
                              IF v_fee > 0 THEN
                                 INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                   ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                 SELECT  rec.autoid ,'' bankid ,refbankacct,
                                 v_globalid banktxnum,
                                 'LISEFEECD' wdrtype,v_fee,
                                 l_bankadv_ccycd ccycd,
                                 l_bankadv_description description,
                                 l_bankadv_custodycd custodycd,l_dorc,0,0,L_FEETYPE
                                FROM DUAL;
                              END IF;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD)
                            VALUES(rec.autoid,'REPO_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd);

                            ELSE*/ --type LISTED
                              --tien mua
                            INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                            SELECT  rec.autoid ,'' bankid ,refbankacct,
                                    v_globalid banktxnum,
                                    'LICLSED' wdrtype,l_amt,
                                    l_bankadv_ccycd ccycd,
                                    l_bankadv_description description,
                                    l_bankadv_custodycd custodycd,l_dorc,
                                    l_feeamt,l_taxamt,L_FEETYPE
                            FROM DUAL;

                            --phi
                            IF v_fee > 0 THEN
                                INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                SELECT  rec.autoid ,'' bankid ,refbankacct,
                                        v_globalid banktxnum,
                                        'LISEFEED' wdrtype,v_fee,
                                        l_bankadv_ccycd ccycd,
                                        l_bankadv_description description,
                                        l_bankadv_custodycd custodycd,l_dorc,0,0,L_FEETYPE
                                FROM DUAL;
                            END IF;
                            INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                            SELECT REC.AUTOID,'BANKACCTNO',l_bankaccno,0,REC.GLOBALID FROM DUAL;
                            INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                            SELECT REC.AUTOID,'TICKER',l_symbol,0,REC.GLOBALID FROM DUAL;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                            --END IF;
                        END;
                    ELSIF v_reqcode = 'PAYMENT_NOSTROWTRANFER' THEN --8880 credit
                        BEGIN
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;
                            l_FEETYPE := '3';

                            select TLTXCD into l_tltxcd from vw_tllog_all where txdate = v_txdate and txnum = v_txnum;

                            v_orderid := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'35','C');
                            v_ddacctno := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'04','C');
                            l_symbol := FN_GET_TLLOGFLD_VALUE(v_txnum,v_txdate,'07','C');
                            select trim(cf.feedaily) into v_feedaily from cfmast cf,ddmast dd
                            where cf.custodycd = dd.custodycd and dd.acctno = v_ddacctno and dd.status <> 'C';

                            select v.EXECAMT, v.FEEAMT,v.TAXAMT, v.transactiontype
                            into l_amt,v_fee,v_tax,v_ordertype
                            from vw_odmast_all v where v.ORDERID = v_orderid;

                            l_dorc := 'C';

                            SELECT cr.currency, cr.notes,nvl(cr.feeamt,0), nvl(cr.taxamt,0),cr.bankacct, cr.afacctno,cr.rbankaccount
                            INTO l_bankadv_ccycd,l_bankadv_description,l_feeamt, l_taxamt,l_bankaccno, l_acctno, refbankacct
                            FROM CRBTXREQ cr WHERE cr.reqid = rec.keyvalue AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                            SELECT custodycd into l_bankadv_custodycd from ddmast where acctno = l_acctno and status <> 'C';

                            /*IF v_ordertype = 'RE' THEN --type REPO

                              --Tien ban
                              INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                ccycd,description,custodycd,txdorc,feeamt,taxamt)
                              SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                v_globalid banktxnum,
                                'REPOS' wdrtype,l_amt,
                                l_bankadv_ccycd ccycd,
                                l_bankadv_description description,
                                l_bankadv_custodycd custodycd,l_dorc,
                                l_feeamt, l_taxamt
                              FROM DUAL;

                              --Phi
                            IF v_fee + v_tax > 0 AND v_feedaily = 'Y' THEN
                              INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                              SELECT  rec.autoid ,'' bankid ,refbankacct,
                                v_globalid banktxnum,
                                'LISEFEECD' wdrtype,v_fee,
                                l_bankadv_ccycd ccycd,
                                l_bankadv_description description,
                                l_bankadv_custodycd custodycd,'D',0,0,L_FEETYPE
                              FROM DUAL;
                            END IF;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD)
                            VALUES(rec.autoid,'REPO_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd);

                            ELSE --type LISTED*/
                            --tien ban
                            INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                            ccycd,description,custodycd,txdorc,feeamt,taxamt)
                            SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                    v_globalid banktxnum,
                                    'LICLSEC' wdrtype,l_amt,
                                    l_bankadv_ccycd ccycd,
                                    l_bankadv_description description,
                                    l_bankadv_custodycd custodycd,l_dorc,
                                    l_feeamt, l_taxamt
                            FROM DUAL;

                            --phi
                            IF v_fee + v_tax > 0 AND v_feedaily = 'Y' THEN
                                INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,
                                ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                                SELECT  rec.autoid ,'' bankid ,refbankacct,
                                        v_globalid banktxnum,
                                        'LISEFEEC' wdrtype,v_fee,
                                        l_bankadv_ccycd ccycd,
                                        l_bankadv_description description,
                                        l_bankadv_custodycd custodycd,'D',0,0,L_FEETYPE
                                FROM DUAL;
                            END IF;
                            INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                            SELECT REC.AUTOID,'BANKACCTNO',l_bankaccno,0,REC.GLOBALID FROM DUAL;
                            INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                            SELECT REC.AUTOID,'TICKER',l_symbol,0,REC.GLOBALID FROM DUAL;
                            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
                            VALUES(rec.autoid,'LISTED_RESULT','AUTOID',rec.autoid,rec.ACTION,'P',SYSDATE,NULL,v_txnum,v_txdate,v_globalid,l_tltxcd,rec.BUSDATE);
                            -- END IF;
                        END;
                    ELSIF v_reqcode = 'INTRFCARIGHT' and v_trfcode = 'WTRANSFER' THEN--3339
                        BEGIN
                            v_globalid := v_reqtxnum;
                            UPDATE CBFA_BANKPAYMENT SET PSTATUS = PSTATUS || BANKSTATUS,BANKSTATUS = REC.ACTION, REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                            where globalid = v_globalid;
                        END;
                    ELSE
                        BEGIN
                            select count(*) into v_payment from CBFA_BANKPAYMENT where globalid = v_reqtxnum;
                            select count(*) into v_statement from FACB_STATEMENTGROUP where globalid = v_reqtxnum;

                            IF v_payment > 0 THEN
                                UPDATE CBFA_BANKPAYMENT SET PSTATUS = PSTATUS || BANKSTATUS, BANKSTATUS = REC.ACTION, REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                                where globalid = v_reqtxnum;
                            END IF;

                            IF v_statement > 0 THEN
                                UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = REC.ACTION,REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                                where globalid = v_reqtxnum;
                            END IF;
                             
                        END;
                    END IF;
                END;
              ELSE --ACTION = 'R'
                 IF v_reqcode = 'OUTTRFODSELL' THEN--3334
                        BEGIN
                            v_txnum := SUBSTR(v_reqtxnum,13,10);
                            v_txdate := TO_DATE(SUBSTR(v_reqtxnum,4,8),'RRRRMMDD');

                            v_globalid := v_reqtxnum;

                            UPDATE CBFA_BANKPAYMENT SET PSTATUS=PSTATUS || BANKSTATUS, BANKSTATUS = REC.ACTION, REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                            WHERE globalid = v_globalid;
                        END;
                 ELSIF v_reqcode = 'INTRFCARIGHT' and v_trfcode = 'WTRANSFER' THEN--3339
                        BEGIN
                            v_globalid := v_reqtxnum;
                            UPDATE CBFA_BANKPAYMENT SET PSTATUS=PSTATUS || BANKSTATUS,BANKSTATUS = REC.ACTION, REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                            where globalid = v_globalid;
                        END;
                 ELSE
                    BEGIN
                        select count(*) into v_payment from CBFA_BANKPAYMENT where globalid = v_reqtxnum;
                        select count(*) into v_statement from FACB_STATEMENTGROUP where globalid = v_reqtxnum;

                        IF v_payment > 0 THEN
                            UPDATE CBFA_BANKPAYMENT SET PSTATUS=PSTATUS || BANKSTATUS,BANKSTATUS = REC.ACTION, REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                            where globalid = v_reqtxnum;
                        END IF;

                        IF v_statement > 0 THEN
                            UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = REC.ACTION,REFTXNUM = REC.TXNUM, REFTXDATE = REC.TXDATE, REFTLTXCD = REC.TLTXCD
                            where globalid = v_reqtxnum;
                        END IF;
                         
                    END;
                 END IF;
              END IF;
            ELSIF REC.objname = 'FEE_BOOKING_RESULT' THEN  -- case bang ke theo fee_booking
                  BEGIN
                      SELECT objkey, txdate, objname into l_txnum,l_txdate,l_tltxcd
                      from crbtxreq where TRFCODE = 'FEEINVOICE' AND REQTXNUM = rec.keyvalue;
                  EXCEPTION WHEN OTHERS THEN
                    l_txnum := '';
                    l_txdate:= getcurrdate;
                    l_tltxcd:= '';
                  END;

                  BEGIN
                      SELECT BANKGLOBALID into v_globalid from fee_booking_result where autoid = rec.keyvalue;
                      UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = REC.ACTION,REFTXNUM = l_txnum, REFTXDATE = l_txdate, REFTLTXCD = l_tltxcd
                      where globalid = v_globalid;
                  END;
            ELSIF REC.objname = 'FACBSTATEMENT_RESULT' THEN
                BEGIN
                    IF REC.ACTION = 'C' THEN -- success
                        l_bankadv_banktxnum := REC.GLOBALID;
                        SELECT AUTOID, TXTYPE, REFTXNUM, REFTLTXCD into l_autoid, v_txtype, l_reftxnum, l_tltxcd FROM FACB_STATEMENTGROUP WHERE GLOBALID = rec.GLOBALID;
                        IF v_txtype IN ('SEVFEE','OPN','CLS') AND l_tltxcd = 'FEEINVOICE' THEN
                           select autoid into l_refbookingid from fee_booking_result where bankglobalid = rec.globalid;
                          ---sinh 6642 cat tien phi + thue
                          pr_auto_6642(l_autoid,p_err_code, p_err_msg);
                          IF p_err_code <> systemnums.C_SUCCESS THEN
                             UPDATE log_notify_cbfa SET status ='R', err_code=p_err_code, err_message=p_err_msg
                             WHERE AUTOID = REC.AUTOID;
                          ELSE
                             SELECT cr.currency, cr.notes, nvl(cr.dorc,'D'),
                                 cr.txamt + nvl(cr.taxamt,0), v_txtype, 0, 0
                             INTO l_bankadv_ccycd,l_bankadv_description, l_dorc, l_amt,
                                   l_bankadv_wdrtype, l_feeamt, l_taxamt
                             FROM CRBTXREQ cr
                             WHERE cr.reqtxnum = to_char(l_refbookingid) AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                             SELECT CUSTODYCD,FEETYPE
                             INTO l_bankadv_custodycd,l_FEETYPE
                             FROM FACB_STATEMENTGROUP WHERE GLOBALID = REC.GLOBALID;

                             l_bankaccno := '';
                          END IF;
                        ELSE
                          SELECT cr.currency, cr.notes, nvl(cr.dorc,'D'),
                                 cr.txamt, cr.reqcode, nvl(cr.feeamt,0), nvl(cr.taxamt,0)
                          INTO l_bankadv_ccycd,l_bankadv_description, l_dorc, l_amt,
                               l_bankadv_wdrtype, l_feeamt, l_taxamt
                          FROM CRBTXREQ cr
                          WHERE cr.reqtxnum = rec.globalid AND cr.trfcode NOT IN ('HOLD','UNHOLD');

                          SELECT CUSTODYCD,BENEFICIARYACCOUNT,FEETYPE
                          INTO l_bankadv_custodycd,l_bankaccno,l_FEETYPE
                          FROM FACB_STATEMENTGROUP WHERE GLOBALID = REC.GLOBALID;
                        END IF;

                        IF l_bankadv_wdrtype = 'TADFS' THEN
                            l_dorc := 'C';
                        ELSE
                            l_dorc := 'D';
                        END IF;

                        INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                        SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                l_bankadv_banktxnum banktxnum,
                                l_bankadv_wdrtype wdrtype,l_amt,
                                l_bankadv_ccycd ccycd,
                                l_bankadv_description description,
                                l_bankadv_custodycd custodycd,l_dorc,
                                l_feeamt, l_taxamt,
                                CASE WHEN l_bankadv_wdrtype = 'TADFS' THEN NULL ELSE L_FEETYPE END
                        FROM DUAL;
                    END IF;
                    UPDATE FACB_STATEMENTGROUP SET RESPONSE = 'Y' WHERE GLOBALID = REC.GLOBALID;
                END;
            ELSIF REC.objname = 'CBFABANKPAYMENT_RESULT' THEN
                BEGIN
                    IF REC.ACTION = 'C' THEN -- success
                        l_bankadv_banktxnum := REC.GLOBALID;

                        SELECT D.REFCASAACCT INTO refbankacct
                        FROM DDMAST D, CBFA_BANKPAYMENT B
                        WHERE B.GLOBALID = REC.GLOBALID
                        AND D.ACCTNO = B.ACCTNO
                         and d.status <> 'C'
                        ;

                        SELECT cr.currency, cr.notes, nvl(cr.dorc,'D'),cr.txamt, nvl(cr.feeamt,0), nvl(cr.taxamt,0)
                        INTO l_bankadv_ccycd,l_bankadv_description, l_dorc, l_amt,l_feeamt, l_taxamt
                        FROM CRBTXREQ cr
                        WHERE cr.reqtxnum = rec.globalid and cr.trfcode not in ('HOLD','UNHOLD');

                        SELECT CUSTODYCD,BENEFICIARYACCOUNT,TXTYPE,FEETYPE
                        INTO l_bankadv_custodycd,l_bankaccno,l_bankadv_wdrtype,l_FEETYPE
                        FROM CBFA_BANKPAYMENT
                        WHERE GLOBALID = REC.GLOBALID;

                        INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                        SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                                l_bankadv_banktxnum banktxnum,
                                l_bankadv_wdrtype wdrtype,l_amt,
                                l_bankadv_ccycd ccycd,
                                l_bankadv_description description,
                                l_bankadv_custodycd custodycd,l_dorc,
                                l_feeamt, l_taxamt,L_FEETYPE
                        FROM DUAL;

                        INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                        SELECT REC.AUTOID,'BANKACCTNO',refbankacct,0,REC.GLOBALID FROM DUAL;

                    END IF;
                    UPDATE CBFA_BANKPAYMENT SET RESPONSE = 'Y' WHERE GLOBALID = REC.GLOBALID;
                END;
            ELSIF REC.objname = 'CRBTXREQ_CITAD_REVERT' then --trung.luu : 07-08-2020 Citad revert
                begin
                     
                    insert into cbfa_CITAD_REVERT@CBFALINK (   transactionnumber, txdate, status, errordesc, refno,addinfo, cardno, transactiondescription, theirrefno,trandate,
                                                                currency, amount, benefitaccountname, applcaccountno, applcaccountname, interfacetype,sendingbankname, revbankname,
                                                                valuedate,fundtranferfilename, reqid ,benefitaccountno,transferorder)
                    select  transactionnumber, txdate, status, errordesc, refno,addinfo, cardno, transactiondescription, theirrefno,trandate,
                                                                currency, amount, benefitaccountname, applcaccountno, applcaccountname, interfacetype,sendingbankname, revbankname,
                                                                valuedate,fundtranferfilename, reqid ,benefitaccountno,transferorder from CITAD_REVERT where transactionnumber = rec.keyvalue;-- and status = 'P';

                    update CITAD_REVERT set status = 'C' where transactionnumber = rec.keyvalue and status = 'P';
                end;
            ELSIF REC.objname = 'CRBBANKREQUEST_RESULT' THEN
                BEGIN
                    select c.desbankaccount,c.transactiondescription,c.dorc,c.amount,c.bankobj
                    into l_desbankacct,l_bankadv_description,l_dorc,l_amt,l_bankobj from CRBBANKREQUEST c
                    where autoid = rec.keyvalue;

                    l_bankadv_banktxnum := rec.globalid;
                    l_bankadv_wdrtype := 'OTHERS';

                    SELECT nvl(dd.ccycd,'VND')
                    into l_bankadv_ccycd
                    from ddmast dd where dd.refcasaacct = l_desbankacct and status = 'A';

                    select max(case when fldname = 'CANCEL' then cval else '' end) CANCEL
                    into  v_cancel
                    from crbbankrequestdtl
                    where reqid = rec.keyvalue;

                    if l_bankobj = '11D' then -- khac 10 => gd cancel => goi gd hach toan nguoc lai
                        if trim(v_cancel) = '10' then
                            l_dorc := 'D';
                        else
                            l_dorc := 'C';
                        end if;
                    else
                        if trim(v_cancel) = '10' then
                            l_dorc := 'C';
                        else
                            l_dorc := 'D';
                        end if;
                    end if;

                    IF l_dorc = 'D' THEN
                        l_bankaccno := ''; -- TK bank chuyen den
                        INSERT INTO CBFA_SYNCREFINFO@CBFALINK(autoid,refname,refcval,refnval,globalid)
                        SELECT REC.AUTOID,'BANKACCTNO',l_desbankacct,0,REC.GLOBALID FROM DUAL;
                    ELSE
                        l_bankaccno := l_desbankacct;
                    END IF;

                    INSERT INTO cbfa_bankadvicetx@CBFALINK(autoid,bankid,bankacctno,banktxnum,wdrtype,amt,ccycd,description,custodycd,txdorc,feeamt,taxamt,feetype)
                    SELECT  rec.autoid ,'' bankid ,l_bankaccno,
                            l_bankadv_banktxnum banktxnum,
                            l_bankadv_wdrtype wdrtype,l_amt,
                            l_bankadv_ccycd ccycd,
                            l_bankadv_description description,
                            '' custodycd,l_dorc,0,0,'3'
                    FROM DUAL;
                END;
            ELSIF REC.objname = 'RSE0087' THEN
                INSERT INTO CBFA_LOG_SE0087@CBFALINK(AUTOID,FILENAME,TLID,BUSDATE,COMPARE_DATE,TXTIME,DELTD,ACCOUNTTYPE,SY_CUSTODYCD,SY_SYMBOL,SY_QTTY,VSD_CUSTODYCD,VSD_SYMBOL,VSD_QTTY,FULLNAME,MAKERID)
                SELECT L.AUTOID, L.FILENAME, L.TLID, L.BUSDATE, L.COMPARE_DATE, L.TXTIME, L.DELTD, L.ACCOUNTTYPE, L.SY_CUSTODYCD, L.SY_SYMBOL, L.SY_QTTY, L.VSD_CUSTODYCD, L.VSD_SYMBOL, L.VSD_QTTY, L.FULLNAME, L.MAKERID
                FROM LOG_SE0087 L
                WHERE L.AUTOID = REC.KEYVALUE;
            ELSE
                BEGIN
                    p_err_code := '-930003';
                    p_err_msg := 'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace;
                    UPDATE log_notify_cbfa SET status ='R',err_code=p_err_code, err_message = p_err_msg WHERE  AUTOID = REC.AUTOID;
                END;
            END IF;

            INSERT INTO cbfa_log_notify@CBFALINK (AUTOID,OBJNAME,KEYNAME,KEYVALUE,ACTION,STATUS,LOGTIME,APPLYTIME,TXNUM,TXDATE,GLOBALID,TLTXCD,BUSDATE)
            SELECT rec.autoid,rec.OBJNAME,rec.KEYNAME,rec.KEYVALUE,rec.ACTION,'P',SYSDATE,NULL,REC.TXNUM,REC.TXDATE,REC.GLOBALID,REC.tltxcd,REC.BUSDATE FROM DUAL
            WHERE rec.OBJNAME not in ('FEE_BOOKING_RESULT');

            UPDATE log_notify_cbfa SET status ='C', err_code=systemnums.c_success  WHERE AUTOID = REC.AUTOID;
        EXCEPTION
            WHEN EXCETION_STR OR EXCETION_NUMBER OR NO_DATA_FOUND
                 OR DUP_VAL_ON_INDEX OR TOO_MANY_ROWS OR ZERO_DIVIDE THEN
                 p_err_code:='-930000';
                 p_err_msg := 'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace;
                 UPDATE log_notify_cbfa SET status ='R',err_code=p_err_code,err_message= p_err_msg WHERE AUTOID = REC.AUTOID;
                 plog.error(pkgctx, SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
                 plog.setEndSection(pkgctx, 'process_notify_cbfa');
            WHEN OTHERS THEN
                  p_err_code:='-930004';
                  p_err_msg := 'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace;
                  UPDATE log_notify_cbfa SET status ='R',err_code=p_err_code,err_message= p_err_msg WHERE AUTOID = REC.AUTOID;
                  plog.error(pkgctx, SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
                  plog.setEndSection(pkgctx, 'process_notify_cbfa');
        END ;
    END LOOP;
    --

        --notify cho web
    /*
    if v_countUSERLOGIN>0 then
         BEGIN
        OPEN pv_ref for
            SELECT 'S' MSGTYPE, 'USER' DATATYPE, SYSTIMESTAMP|| '' REFID From dual;
            txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');

        OPEN pv_ref for
            SELECT 'S' MSGTYPE, 'RIGHT' DATATYPE, SYSTIMESTAMP|| '' REFID From dual;
            txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');
        END;
    end if;
    */
     if v_countSBSECURITIES >0 or v_countISSUERS>0 then
        OPEN pv_ref for
            SELECT 'S' MSGTYPE, 'ALLSTOCKS' DATATYPE, SYSTIMESTAMP|| '' REFID From dual;
            txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');

    end if;
    plog.setEndSection(pkgctx, 'process_notify_cbfa');
    EXCEPTION
    WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'process_notify_cbfa');
END process_notify_cbfa;

PROCEDURE process_msg_from_fa
  AS
  l_currdate DATE;
  l_action varchar2(1);
  l_txnum varchar2(20);
  l_txdate date;
  l_globalid varchar2(50);
  l_TLTXCD varchar2(4);
  l_sbaction varchar2(1);
  l_tlid     varchar2(10);
  l_status varchar2(1);
  p_err_code varchar2(20);
  l_autoid number;

  l_CUSTODYCD varchar2(20);
  l_acctno varchar2(20);
  l_transtype varchar2(1);
  l_refcontract varchar2(20);
  l_instype varchar2(10);
  l_citad  varchar2(20);
  l_citad_shinhan number;
  l_bankaccno varchar2(20);
  l_bankname varchar2(500);
  l_bankbranch varchar2(500);
  l_amt varchar2(100);
  l_desc varchar2(500);
  l_trfcode  varchar2(50);
  l_sddacctno varchar2(50);
  l_checkInternal number;
  l_otcodid       varchar2(20);
  v_scustodycd    varchar2(20);
  v_refcasaacct   varchar2(20);
  l_sumamt        number;
  l_clvalue       number;
  l_crphysagreeid varchar2(20);
  l_faceamt       varchar2(20);
  l_ddacctno_issuer varchar2(50);
  l_bankacctname varchar2(500);
  pv_ref pkg_report.ref_cursor;
  l_feetype varchar2(1);
  l_vat     number;
  l_taxamt  number;
  v_autoid varchar2(10);
  l_custnamecr varchar2(50);
  l_reqtxnum varchar2(50);
  v_camastid varchar2(50);
  v_err_code varchar2(50);
  v_err_msg  varchar2(500);
  v_count number;
  EXCETION_STR exception;
  EXCETION_NUMBER exception;
  pragma exception_init(excetion_str,-1438);
  pragma exception_init(excetion_number,-12899);
  L_VALUEDATE DATE;
  v_toacctno varchar2(50);
  l_contracttype varchar2(50);
  l_cstd varchar2(50);
  v_mcifid varchar2(250);
BEGIN
    plog.setBeginSection(pkgctx, 'process_msg_from_fa');

    SELECT TO_DATE(VARVALUE,systemnums.C_DATE_FORMAT) INTO l_currdate
    FROM SYSVAR
    WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';

    FOR REC IN (SELECT * FROM syn_facb_log_notify WHERE STATUS ='P' order by autoid)
    LOOP
        BEGIN
            IF REC.OBJNAME = 'CBFABANKPAYMENT_APPRSB' THEN--1. dong bo chi thi thanh toan
                BEGIN
                    l_sbaction := SUBSTR(REC.Action,1,1);
                    l_globalid := rec.globalid;
                    SELECT C.CUSTODYCD,C.ACCTNO,C.TRANSTYPE,C.TXTYPE,C.CITAD,
                           C.CUSTNAME,C.BANKBRACH,C.BENEFICIARYACCOUNT,C.TXAMT,
                           C.TXNUM, C.TXDATE, C.FEETYPE,C.VALUEDATE
                    INTO L_CUSTODYCD,L_ACCTNO,L_TRANSTYPE,L_INSTYPE,L_CITAD,L_BANKNAME,
                         L_BANKBRANCH,L_BANKACCNO,L_AMT,L_TXNUM, L_TXDATE, L_FEETYPE, L_VALUEDATE
                    FROM CBFA_BANKPAYMENT C WHERE C.GLOBALID = REC.GLOBALID;

                    l_instype  := SUBSTR(REC.Action,3,length(REC.Action)-2);

                    SELECT TLID, TLTXCD INTO l_tlid, l_TLTXCD FROM VW_TLLOG_ALL where txnum = l_txnum and txdate = l_txdate;
                    l_desc := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'30','C');
                    IF l_sbaction = 'A' THEN-- 1.1 SB approved
                        UPDATE CBFA_BANKPAYMENT SET ISAPPRSB = 'Y', TXTYPE =l_instype  WHERE GLOBALID = l_globalid;
                        UPDATE syn_facb_log_notify SET STATUS = 'C', err_code = systemnums.C_SUCCESS WHERE autoid = rec.autoid;
                        --goi bank api
                        IF l_TLTXCD = '6639' THEN
                            BEGIN
                                --lay thong so giao dich
                                --SELECT txdesc INTO l_desc FROM tltx WHERE tltxcd = '6639';
                                --dat lich voi tat ca cac type chi thi
                                IF L_VALUEDATE is not null AND L_VALUEDATE <= TRUNC(SYSDATE) THEN --goi bank
                                    IF l_transtype = 'D' THEN--chuyen tien ra ngoai
                                        pck_bankapi.Bank_Tranfer_Out_fa(l_acctno,l_bankname,l_bankaccno,l_citad,L_FEETYPE,l_amt,L_INSTYPE,l_globalid,l_desc,l_tlid,p_err_code);
                                        IF p_err_code <> systemnums.c_success THEN
                                            v_err_code := p_err_code;
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',err_code =v_err_code   WHERE GLOBALID = l_globalid;
                                             
                                        ELSE
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = l_globalid;
                                        END IF;
                                    ELSE-- chuyen tien noi bo
                                        select count(*) into v_count from ddmast d where d.refcasaacct = l_bankaccno  and d.status = 'A';
                                        IF v_count = 0 THEN
                                            pck_bankapi.Bank_Internal_Tranfer_fa(
                                                l_acctno,
                                                l_bankname, ---ten tk nhan
                                                l_bankaccno, --- so tk nhan
                                                l_amt,  --- so tien
                                                L_INSTYPE, --request code cua nghiep vu trong allcode
                                                l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                                l_desc,  -- dien giai
                                                l_tlid, -- nguoi tao giao dich
                                                p_err_code);
                                            IF p_err_code <> systemnums.c_success THEN
                                                v_err_code := p_err_code;
                                                UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',err_code =v_err_code   WHERE GLOBALID = l_globalid;
                                                 
                                            ELSE
                                                UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = l_globalid;
                                            END IF;
                                        ELSE
                                            select acctno into v_toacctno from ddmast where refcasaacct = l_bankaccno and status <> 'C';
                                            pck_bankapi.Bank_Internal_Tranfer(
                                                l_acctno,
                                                l_bankname, ---ten tk nhan
                                                v_toacctno, --- so tk nhan
                                                l_amt,  --- so tien
                                                L_INSTYPE, --request code cua nghiep vu trong allcode
                                                l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                                l_desc,  -- dien giai
                                                l_tlid, -- nguoi tao giao dich
                                                p_err_code);
                                            IF p_err_code <> systemnums.c_success THEN
                                                v_err_code := p_err_code;
                                                UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',err_code =v_err_code   WHERE GLOBALID = l_globalid;
                                                 
                                            ELSE
                                                UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = l_globalid;
                                            END IF;
                                         END IF;
                                    END IF;
                                ELSE  -- cho vao hang cho goi bank
                                    --UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'K' WHERE GLOBALID = l_globalid;
                                    FOR REC IN (
                                        SELECT TLF.TXNUM, TLF.TXDATE, MAX(TL.TLID) TLID,
                                               MAX(DECODE(TLF.FLDCD, '01', TLF.CVALUE, NULL)) POSTINGDATE,
                                               MAX(DECODE(TLF.FLDCD, '02', TLF.CVALUE, NULL)) CUSTODYCD,
                                               MAX(DECODE(TLF.FLDCD, '03', TLF.CVALUE, NULL)) DDACCTNO,
                                               MAX(DECODE(TLF.FLDCD, '04', TLF.CVALUE, NULL)) PORFOLIO,
                                               MAX(DECODE(TLF.FLDCD, '05', TLF.NVALUE, 0)) BALANCE,
                                               MAX(DECODE(TLF.FLDCD, '06', TLF.NVALUE, 0)) AVAILABLE,
                                               MAX(DECODE(TLF.FLDCD, '07', TLF.CVALUE, NULL)) INSTRUCTION,
                                               MAX(DECODE(TLF.FLDCD, '08', TLF.CVALUE, NULL)) TRANSTYPE,
                                               MAX(DECODE(TLF.FLDCD, '09', TLF.CVALUE, NULL)) CITAD,
                                               MAX(DECODE(TLF.FLDCD, '11', TLF.CVALUE, NULL)) BANKNAME,
                                               MAX(DECODE(TLF.FLDCD, '12', TLF.CVALUE, NULL)) BANKBRANCH,
                                               MAX(DECODE(TLF.FLDCD, '13', TLF.CVALUE, NULL)) BANKACC,
                                               MAX(DECODE(TLF.FLDCD, '14', TLF.CVALUE, NULL)) CUSTNAME,
                                               MAX(DECODE(TLF.FLDCD, '10', TLF.NVALUE, 0)) TXAMT,
                                               MAX(DECODE(TLF.FLDCD, '15', TLF.CVALUE, NULL)) REFCONTRACT,
                                               MAX(DECODE(TLF.FLDCD, '16', TLF.CVALUE, NULL)) FEETYPE,
                                               MAX(DECODE(TLF.FLDCD, '19', TLF.NVALUE, 0)) FEE,
                                               MAX(DECODE(TLF.FLDCD, '20', TLF.NVALUE, 0)) NETAMT,
                                               MAX(DECODE(TLF.FLDCD, '17', TLF.CVALUE, NULL)) VALUEDATE,
                                               MAX(DECODE(TLF.FLDCD, '30', TLF.CVALUE, NULL)) DESCRIPTION
                                        FROM CBFA_BANKPAYMENT PAY, VW_TLLOGFLD_ALL TLF, VW_TLLOG_ALL TL
                                        WHERE PAY.GLOBALID = L_GLOBALID
                                        AND PAY.TXDATE = TLF.TXDATE
                                        AND PAY.TXNUM = TLF.TXNUM
                                        AND PAY.TXDATE = TL.TXDATE
                                        AND PAY.TXNUM = TL.TXNUM
                                        GROUP BY TLF.TXNUM, TLF.TXDATE
                                    )
                                    LOOP
                                        INSERT INTO LOG_FUTURE6639(AUTOID, POSTINGDATE, TRADINGACCT, ACCTNO, PORFOLIO, BALANCE, AVAILABLE, INSTRUCTION, TRANSFER, CITAD,
                                            BANK, BANKBRANCH, BANKACCTNO, FULLNAME, AMT, REFCONTRACT,
                                            FEETYPE, FEE, NETAMT, VALUEDATE, DESCRIPTION, TXNUM, TXDATE, STATUS, SOURCE)
                                        VALUES (SEQ_LOG_FUTURE6639.NEXTVAL, TO_DATE(REC.POSTINGDATE, 'DD/MM/RRRR'), REC.CUSTODYCD, REC.DDACCTNO, REC.PORFOLIO, REC.BALANCE, REC.AVAILABLE, REC.INSTRUCTION, REC.TRANSTYPE, REC.CITAD,
                                            REC.BANKNAME, REC.BANKBRANCH, REC.BANKACC, REC.CUSTNAME, REC.TXAMT, REC.REFCONTRACT,
                                            REC.FEETYPE, REC.FEE, REC.NETAMT, TO_DATE(REC.VALUEDATE, 'DD/MM/RRRR'), REC.DESCRIPTION, REC.TXNUM, REC.TXDATE, 'P', (CASE WHEN REC.TLID = '6868' THEN 'SB-Online' ELSE 'SB-Manual' END));
                                    END LOOP;
                                END IF;
                            END;
                        ELSIF l_TLTXCD = '2211' THEN
                            BEGIN
                                l_CUSTODYCD := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'02','C');
                                l_acctno := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'03','C');
                                l_otcodid := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'01','C');
                                l_citad   := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'16','C');
                                --l_bankaccno := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'13','C');
                                l_bankname := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'90','C');
                                --l_bankbranch := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'12','C');
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'10','N'));
                                l_desc := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'30','C');

                                v_scustodycd := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'88','C');
                                v_refcasaacct := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'15','C');
                                begin
                                    select count(*), max(acctno) into l_checkInternal, l_sddacctno from ddmast where custodycd = v_scustodycd and REFCASAACCT = v_refcasaacct and status <> 'C';
                                exception when others then
                                    l_checkInternal := 0;
                                    l_sddacctno:='';
                                end;
                                if l_checkInternal > 0 then -- chuyen tien noi bo
                                    select  trfcode into l_trfcode from CRBTRFCODE where objname = '2211' and BANKREFCODE = 'ITRANSFER';
                                    begin
                                        PCK_BANKAPI.Bank_Internal_Tranfer(
                                            l_acctno,  --- tk ddmast tk chuyen
                                            l_bankname, ---ten tk nhan
                                            l_sddacctno, --- so tk nhan
                                            l_amt,  --- so tien
                                            L_INSTYPE, --request code cua nghiep vu trong allcode
                                            l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                            l_desc,  -- dien giai
                                            l_tlid, -- nguoi tao giao dich
                                            p_err_code);

                                        if p_err_code <> systemnums.C_SUCCESS then
                                            v_err_code := p_err_code;
                                             
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'I',err_code = v_err_code  WHERE GLOBALID = l_globalid;
                                        else
                                            update OTCODMAST
                                            set trfreqid = to_char(l_txdate,'DD/MM/RRRR')||l_txnum, ddstatus = 'C', last_change = CURRENT_TIMESTAMP
                                            where OTCODID = l_otcodid and deltd = 'N';
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'I'  WHERE GLOBALID = l_globalid;
                                        end if;
                                    exception when others then
                                        plog.error (pkgctx, 'BANK_TRANFER_IN:  OTCODID:'||l_otcodid||', l_bddacctno:'||l_acctno||'. Error:'||SQLERRM || dbms_utility.format_error_backtrace);
                                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'I',err_code = v_err_code  WHERE GLOBALID = l_globalid;
                                    end;
                                else -- chuyen tien ra ngoai
                                    begin
                                        PCK_BANKAPI.BANK_TRANFER_OUT_fa(
                                            l_acctno,  --- tk ddmast tk chuyen
                                            l_bankname, ---ten tk nhan
                                            v_refcasaacct, --- so tk nhan
                                            l_citad,       --- so citad ngan hang nhan
                                            L_FEETYPE,
                                            l_amt,  --- so tien
                                            L_INSTYPE, --request code cua nghiep vu trong allcode
                                            l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                            l_desc,  -- dien giai
                                            l_tlid, -- nguoi tao giao dich
                                            p_err_code);

                                        if p_err_code <> systemnums.C_SUCCESS then
                                            v_err_code := p_err_code;
                                             
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'D',err_code = v_err_code  WHERE GLOBALID = l_globalid;
                                        else
                                            update OTCODMAST
                                            set trfreqid = to_char(l_txdate,'DD/MM/RRRR')||l_txnum, ddstatus = 'C', last_change = CURRENT_TIMESTAMP
                                            where OTCODID = l_otcodid and deltd = 'N';
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'D'  WHERE GLOBALID = l_globalid;
                                        end if;
                                    exception when others then
                                        v_err_code := p_err_code;
                                        plog.error (pkgctx, SQLERRM || dbms_utility.format_error_backtrace);
                                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'D',err_code = v_err_code  WHERE GLOBALID = l_globalid;
                                    end;
                                end if;
                            END;
                        ELSIF l_TLTXCD = '1401' THEN
                            BEGIN
                                l_CUSTODYCD := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'18','C');
                                l_citad   := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'06','C');
                                l_bankaccno := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'02','C');
                                l_bankname := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'32','C');
                                l_amt := TO_NUMBER(FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'10','N'));
                                l_desc := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'30','C');
                                l_crphysagreeid := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'88','C');
                                l_faceamt       := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'12','N');

                                select max(dd.acctno) into l_acctno from ddmast dd
                                where dd.custodycd = l_CUSTODYCD and dd.status <> 'C' and dd.isdefault = 'Y';

                                if (l_acctno is not null) then
                                    if l_citad is not null then
                                        PCK_BANKAPI.BANK_TRANFER_OUT_fa(l_acctno,
                                            l_bankname,
                                            l_bankaccno,
                                            l_citad,
                                            L_FEETYPE,
                                            l_amt,
                                            L_INSTYPE,
                                            l_globalid,
                                            l_desc,
                                            l_tlid,
                                            p_err_code);
                                        if p_err_code <> systemnums.c_success then
                                            v_err_code := p_err_code;
                                             
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'D',ACCTNO = l_acctno,err_code = v_err_code WHERE GLOBALID = l_globalid;
                                        else
                                            insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                                            values (l_txdate, l_txnum, 'T', null, l_crphysagreeid, to_number(l_faceamt), to_number(l_amt), null, null, 'A', 'N',  l_desc);

                                            select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.crphysagreeid = l_crphysagreeid and cr.type = 'T' and cr.deltd <> 'Y';

                                            select cr.clvalue
                                            into l_clvalue
                                            from crphysagree cr
                                            where cr.crphysagreeid = l_crphysagreeid;
                                            if l_sumamt >= l_clvalue then
                                                update crphysagree cr set cr.paystatus = 'T'
                                                where cr.crphysagreeid = l_crphysagreeid;
                                            end if;
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'C',TRANSTYPE = 'D',ACCTNO = l_acctno  WHERE GLOBALID = l_globalid;
                                        end if;
                                    else
                                        select dd.acctno into l_ddacctno_issuer from ddmast dd where dd.refcasaacct = l_bankaccno and dd.status <> 'C';
                                        pck_bankapi.Bank_Internal_Tranfer(
                                            l_acctno,
                                            l_bankname, ---ten tk nhan
                                            l_ddacctno_issuer, --- so tk nhan
                                            l_amt,  --- so tien
                                            L_INSTYPE, --request code cua nghiep vu trong allcode
                                            l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                            l_desc,  -- dien giai
                                            l_tlid, -- nguoi tao giao dich
                                            P_ERR_CODE);
                                        if p_err_code <> systemnums.c_success THEN
                                            v_err_code := p_err_code;
                                             
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'I',ACCTNO = l_acctno,err_code = v_err_code   WHERE GLOBALID = l_globalid;
                                        else
                                            insert into CRPHYSAGREE_LOG (TXDATE, TXNUM, TYPE, APPENDIXID, CRPHYSAGREEID, AMTFACE, AMT, REQTTY, QTTY, STATUS, DELTD, TXDESC)
                                            values (l_txdate, l_txnum, 'T', null, l_crphysagreeid, to_number(l_faceamt), to_number(l_amt), null, null, 'A', 'N',  l_desc);

                                            select sum(cr.amt) into l_sumamt from CRPHYSAGREE_LOG CR where cr.crphysagreeid = l_crphysagreeid and cr.type = 'T' and cr.deltd <> 'Y';

                                            select cr.clvalue
                                            into l_clvalue
                                            from crphysagree cr
                                            where cr.crphysagreeid = l_crphysagreeid;
                                            if l_sumamt >= l_clvalue then
                                                update crphysagree cr set cr.paystatus = 'T'
                                                where cr.crphysagreeid = l_crphysagreeid;
                                            end if;
                                            UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'I',ACCTNO = l_acctno WHERE GLOBALID = l_globalid;
                                        end if;
                                    end if;
                                end if;
                            END;
                        ELSIF l_TLTXCD = '3334' THEN
                            BEGIN
                                v_autoid := FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'01','C');
                                select custname into l_custnamecr from catransfer where autoid=v_autoid;
                                select count(*) into v_count from ddmast where refcasaacct =l_bankaccno  and status <> 'C';
                                IF l_acctno is not null and v_count > 0 then
                                    select acctno into v_toacctno from ddmast where refcasaacct = l_bankaccno and status <> 'C';
                                    pck_bankapi.Bank_Internal_Tranfer(
                                        l_acctno,  --- tk ddmast tk chuyen
                                        l_custnamecr, ---ten tk nhan
                                        v_toacctno, --- so tk nhan
                                        l_amt,  --- so tien
                                        'OUTTRFODSELL', --request code cua nghiep vu trong allcode
                                        l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                        l_desc,  -- dien giai
                                        '0000', -- nguoi tao giao dich
                                        P_ERR_CODE);
                                    if p_err_code <> systemnums.c_success then
                                        v_err_code := p_err_code;
                                         
                                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'I',err_code = v_err_code WHERE GLOBALID = l_globalid;
                                    else
                                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'I' WHERE GLOBALID = l_globalid;
                                        update catransfer set status='P', errcode=p_err_code, reqtxnum=to_char(l_txdate,systemnums.C_DATE_FORMAT)||l_txnum
                                        where autoid=v_autoid and status='H';
                                    end if;
                                ELSIF l_acctno is not null and v_count = 0 THEN
                                    pck_bankapi.Bank_Tranfer_Out_fa(
                                        l_acctno,  --- tk ddmast tk chuyen
                                        l_custnamecr, ---ten tk nhan
                                        l_bankaccno, --- so tk nhan
                                        L_CITAD,--- so citad ngan hang nhan
                                        L_FEETYPE,
                                        l_amt,  --- so tien
                                        'OUTTRFODSELL', --request code cua nghiep vu trong allcode
                                        l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                        l_desc,  -- dien giai
                                        '0000', -- nguoi tao giao dich
                                        P_ERR_CODE)  ;
                                    if p_err_code <> systemnums.c_success then
                                        v_err_code := p_err_code;
                                         
                                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',TRANSTYPE = 'D',err_code = v_err_code WHERE GLOBALID = l_globalid;
                                    else
                                        UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S',TRANSTYPE = 'D' WHERE GLOBALID = l_globalid;
                                        update catransfer set status='P', errcode=p_err_code, reqtxnum=to_char(l_txdate,systemnums.C_DATE_FORMAT)||l_txnum
                                        where autoid=v_autoid and status='H';
                                    end if;
                                END IF;
                            END;
                        ELSIF l_TLTXCD = '3339' THEN
                            BEGIN
                                p_err_code:=0;
                                v_camastid := replace(FN_GET_TLLOGFLD_VALUE(l_txnum,l_txdate,'02','C'),'.');
                                select reqtxnum into l_reqtxnum from caregister
                                where camastid=v_camastid
                                and custodycd=l_CUSTODYCD
                                and trfacctno=l_acctno
                                and msgstatus='A'
                                and rownum=1;

                                select  BANKACCTNO INTO l_bankaccno
                                from BANKNOSTRO where BANKTRANS='INTRFCARIGHT';

                                pck_bankapi.Bank_NostroWtransfer(l_acctno,  --- tk ddmast tk doi ung (ca nhan)
                                    l_bankaccno, --- so tk nostro (tu doanh )
                                    'INTRFCAREG', ---ma loai nghiep vu trong table BANKNOSTRO.BANKTRANS
                                    'D',  -- Debit or credit
                                    l_amt,  --- so tien
                                    'INTRFCAREG', --request code cua nghiep vu trong allcode
                                    l_globalid,  --requestkey duy nhat de truy lai giao dich goc
                                    l_desc,  -- dien giai
                                    '0000', -- nguoi tao giao dich
                                    P_ERR_CODE);
                                IF p_err_code <> systemnums.c_success THEN
                                    v_err_code := p_err_code;
                                     
                                    UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',err_code = v_err_code WHERE GLOBALID = l_globalid;
                                ELSE
                                    update caregister set msgstatus='P', errcode=p_err_code, banktxnum=l_globalid, banktxdate=TO_DATE(l_txdate, systemnums.C_DATE_FORMAT)
                                    where camastid=v_camastid
                                    and custodycd=l_CUSTODYCD
                                    and trfacctno=l_acctno
                                    and msgstatus='A';
                                    commit;
                                    UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = l_globalid;
                                END IF;
                            END;
                        END IF;
                    ELSE--1.2 SB rejected
                        UPDATE CBFA_BANKPAYMENT SET ISAPPRSB = 'R', TXTYPE =l_instype WHERE GLOBALID = l_globalid;
                        UPDATE syn_facb_log_notify SET STATUS = 'C', err_code = systemnums.C_SUCCESS WHERE autoid = rec.autoid;
                    END IF;
                END;
            elsif rec.objname ='FUND' then --.2 Xu ly tin hieu dong bo fund tu FA sang
                BEGIN
                    if rec.action ='D' then
                        --Xoa fund
                        delete from cbfafund where symbol = rec.keyvalue;
                    else
                        delete from cbfafund where symbol = rec.keyvalue;

                        insert into cbfafund(fundcodeid,symbol,custodycd)
                        select fundcodeid,symbol,custodycd
                        from syn_facb_fund where refnotifyid = rec.autoid;
                    end if;

                    --Dong bo fund
                    OPEN pv_ref for
                        SELECT 'S' MSGTYPE, 'FUND' DATATYPE, SYSTIMESTAMP|| '' REFID From dual;
                        txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');
                    --Dong bo user
                    OPEN pv_ref for
                        SELECT 'S' MSGTYPE, 'USER' DATATYPE, SYSTIMESTAMP|| '' REFID From dual;
                        txpks_NOTIFY.PR_NOTIFYEVENT2FO(PV_REFCURSOR=>pv_ref, queue_name=>'PUSH2FO');

                        UPDATE syn_facb_log_notify SET STATUS = 'C',err_code = systemnums.C_SUCCESS WHERE autoid = rec.autoid;
                END;
            elsif rec.objname ='FACB_BALANCE' THEN
                BEGIN
                    select count(*) into v_count
                    from cfmast cf
                    where cf.custodycd = rec.keyvalue
                    and ((cf.fundcode is not null and length(cf.fundcode) > 0) or cf.supebank = 'Y');

                    if v_count > 0 then
                        insert into log_notify_cbfa(autoid,objname,keyname,keyvalue,action,txnum,txdate,tltxcd)
                        values (seq_log_notify_cbfa.nextval,'DDSEMAST_CURRENT','ACCTNO',rec.keyvalue,null,null,rec.txdate,null);
                    end if;

                    UPDATE syn_facb_log_notify SET STATUS = 'C',err_code = systemnums.C_SUCCESS WHERE autoid = rec.autoid;
                END;
            elsif rec.objname = 'FACB_NAVINFO' THEN

                FOR REC_NAVINFO IN (
                        SELECT IND.*, TT.AUTOID INF_AUTOID, TT.NAV INF_NAV, TT.NAVCCQ INF_NAVCCQ, TT.FUNDUNIT INF_FUNDUNIT
                        FROM SYN_FACB_NAV_INFO IND, NAV_INFO TT
                        WHERE IND.AUTOID = REC.KEYVALUE
                        AND IND.FUNDCODE = TT.FUNDCODE(+)
                        AND IND.NAVDATE = TT.NAVDATE(+)
                )LOOP
                    UPDATE NAV_INFO SET REFAUTOID = REC_NAVINFO.AUTOID
                    WHERE AMC = REC_NAVINFO.AMC
                    AND FUNDCODE = REC_NAVINFO.FUNDCODE
                    AND NAVDATE = REC_NAVINFO.NAVDATE;

                    IF REC.ACTION IN ('D') THEN
                        DELETE FROM NAV_INFO WHERE REFAUTOID = REC_NAVINFO.AUTOID;
                    ELSE
                        IF REC_NAVINFO.INF_AUTOID IS NOT NULL THEN
                            IF REC_NAVINFO.NAV <> REC_NAVINFO.INF_NAV AND REC_NAVINFO.NAVCCQ <> REC_NAVINFO.INF_NAVCCQ AND REC_NAVINFO.NAVCCQ <> REC_NAVINFO.INF_NAVCCQ THEN
                                UPDATE NAV_INFO SET
                                AMC = REC_NAVINFO.AMC,
                                FUNDCODE = REC_NAVINFO.FUNDCODE,
                                FTYPE = REC_NAVINFO.FTYPE,
                                NAVDATE = REC_NAVINFO.NAVDATE,
                                NAV = REC_NAVINFO.NAV,
                                NAVCCQ = REC_NAVINFO.NAVCCQ,
                                FUNDUNIT = REC_NAVINFO.FUNDUNIT,
                                LASTCHANGE = SYSTIMESTAMP,
                                REQSTATUS = 'P'
                                WHERE AUTOID = REC_NAVINFO.INF_AUTOID;
                            END IF;
                        ELSE
                            INSERT INTO NAV_INFO(AUTOID, AMC, FUNDCODE, FTYPE, NAVDATE, NAV, NAVCCQ, FUNDUNIT, REFAUTOID, DESCRIPTION)
                            VALUES(SEQ_NAV_INFO.NEXTVAL, REC_NAVINFO.AMC, REC_NAVINFO.FUNDCODE, REC_NAVINFO.FTYPE, REC_NAVINFO.NAVDATE, REC_NAVINFO.NAV, REC_NAVINFO.NAVCCQ, REC_NAVINFO.FUNDUNIT, REC_NAVINFO.AUTOID, 'Sync NAV from FA');
                        END IF;
                    END IF;

                END LOOP;

                UPDATE SYN_FACB_LOG_NOTIFY SET STATUS = 'C',ERR_CODE = SYSTEMNUMS.C_SUCCESS WHERE AUTOID = REC.AUTOID;
            elsif rec.objname ='FACBSTATEMENT' THEN --3.Dong bo bang ke
                BEGIN
                    --Insert bang ke vao FACB_STATEMENTGROUP
                    INSERT INTO FACB_STATEMENTGROUP (AUTOID,REFFASTID,TXTYPE,SETTLEMENTDATE,FUNDACCOUNT,TXAMT,SYNSTATUS,DELTD,
                                                      REFTXNUM,REFTXDATE,CREATETIME,APPLYTIME,ARRREFAUTOID,SYMBOL,
                                                      BENEFICIARYACCOUNT,BENEFICIARYNAME,BENEFICIARYBANK,FXTXAMT,REFNOTIFYID,
                                                      GLOBALID,BANKSTATUS,CUSTODYCD,VAT,TAXAMT,FEETYPE,CONTRACTTYPE,DESCRIPTION,FEENAME,FEECODE)
                    SELECT SEQ_FACBSTATEMENT.NEXTVAL,T.REFFASTID,T.TXTYPE,T.SETTLEMENTDATE,T.FUNDACCOUNT,T.TXAMT,'C',
                            T.DELTD,NULL,NULL,T.CREATETIME,T.APPLYTIME,T.ARRREFAUTOID,T.SYMBOL,T.BENEFICIARYACCOUNT,
                            T.BENEFICIARYNAME,T.BENEFICIARYBANK,T.FXTXAMT,T.REFNOTIFYID,T.GLOBALID,'P',T.CUSTODYCD,T.VAT,
                            T.TAXAMT,T.FEETYPE,T.CONTRACTTYPE,T.DESCRIPTION,T.FEENAME,T.FEECODE
                    FROM SYN_FACB_STATEMENT T WHERE REFNOTIFYID = REC.AUTOID;

                    SELECT AUTOID,CUSTODYCD,TXAMT+TAXAMT,TXTYPE,GLOBALID,BENEFICIARYACCOUNT,BENEFICIARYNAME,BENEFICIARYBANK,
                            VAT,TAXAMT,FEETYPE,CONTRACTTYPE,DESCRIPTION
                    INTO l_autoid,l_CUSTODYCD, l_amt, l_instype,l_globalid, l_bankaccno, l_bankacctname, l_bankname,
                        l_vat,l_taxamt,l_FEETYPE,l_contracttype,l_desc
                    FROM FACB_STATEMENTGROUP WHERE REFNOTIFYID = REC.AUTOID AND BANKSTATUS = 'P';

                    l_citad := fn_getcitadbykeyword(l_bankname);

                    BEGIN
                        SELECT DD.ACCTNO, DD.REFCASAACCT BANKACCOUNT
                        INTO L_ACCTNO, V_REFCASAACCT
                        FROM CFMAST CF,
                        (
                            SELECT * FROM DDMAST WHERE STATUS <> 'C' AND ISDEFAULT = 'Y'
                        ) DD
                        WHERE CF.CUSTID = DD.CUSTID
                        AND CF.CUSTODYCD = L_CUSTODYCD
                        AND ROWNUM = 1;

                    EXCEPTION WHEN OTHERS THEN
                        L_ACCTNO := '';
                        V_REFCASAACCT := '';
                    END;

                    l_tlid := '0001';
                    IF l_acctno is null or length(l_acctno) = 0 THEN --khong tim thay ddmast chuyen
                        v_err_code := '-930007';
                        UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'R',err_code = v_err_code WHERE autoid = l_autoid ;
                    ELSE
                        BEGIN
                            SELECT count(1) INTO l_citad_shinhan FROM crbbanklist
                            WHERE citad = l_citad AND bankname like '%SHINHANBANK%';
                        EXCEPTION WHEN OTHERS THEN
                            l_citad_shinhan:= 0;
                        END;
                    END IF;

                    --Cap nhat trang thai dong bo
                    UPDATE syn_facb_log_notify SET STATUS = 'C',err_code = systemnums.C_SUCCESS WHERE AUTOID = REC.AUTOID;
                    UPDATE SYN_FACB_STATEMENT SET SYNSTATUS = 'C' WHERE REFNOTIFYID = REC.AUTOID;

                    -- type phi insert fee_booking_result
                    IF (l_instype = 'SEVFEE' and l_contracttype IN('005','006','007','015','016')) OR (l_instype IN ('OPN','CLS') ) THEN

                        v_autoid := seq_fee_booking_result.nextval;

                        --trung.luu: 18-02-2021 SHBVNEX-2067 lay so cifid cua tai khoan me

                        --trung.luu: 18-03-2021 SHBVNEX-2161 khong dung cifid cua tai khoan me nua, dung master cifid
                        BEGIN
                            --select cifid into v_mcifid from cfmast where custodycd in(select CF.MCUSTODYCD from SYN_FACB_STATEMENT syn,cfmast cf where syn.REFNOTIFYID = REC.AUTOID AND SYN.custodycd = CF.CUSTODYCD);
                            --trung.luu: 28-04-2021 SHBVNEX-2161 khong co mastercif thi de null
                            select mcifid into v_mcifid from cfmast where custodycd in(select syn.custodycd from SYN_FACB_STATEMENT syn where syn.REFNOTIFYID = REC.AUTOID );
                        EXCEPTION WHEN NO_DATA_FOUND
                            THEN
                            v_mcifid := '';
                        END;

                        INSERT INTO FEE_BOOKING_RESULT (AUTOID,GRAUTOID,BANKACCOUNT,CIFID,CURRENCY,REMARK,FEEAMOUNT,
                                     FXRATE,FXAMOUNT,NOSTROACCOUNT,STATUS,BANKGLOBALID,TRANSDATE,SETTLEDATE,
                                     FEETYPE,FEECODE,FEETXDATE,FEETXNUM,TXDATE,TAXAMOUNT,FEENAME,SETTLETYPE,BRANCH,MCIFID)
                        SELECT v_autoid,v_autoid,v_refcasaacct,c.cifid,'VND',A.DESCRIPTION,
                                A.TXAMT,0,0,A.BENEFICIARYACCOUNT,'N',A.GLOBALID,null,null,
                                A.FEECODE,A.FEECODE,TO_DATE(SUBSTR(A.GLOBALID,4,8),'RRRRMMDD'),SUBSTR(A.GLOBALID,13,10),TO_DATE(SUBSTR(A.GLOBALID,4,8),'RRRRMMDD'),
                                A.TAXAMT,A.FEENAME,'50','7906',v_mcifid
                        FROM SYN_FACB_STATEMENT A, CFMAST C WHERE A.REFNOTIFYID = REC.AUTOID AND C.CUSTODYCD = A.CUSTODYCD;

                        pck_bankflms.sp_auto_gen_fee_invoice(v_autoid);

                        UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'S' WHERE autoid = l_autoid;

                    ELSE --goi bank binh thuong

                        IF l_citad is null or length(l_citad) = 0 THEN
                            v_err_code := '-930006';
                            UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'R',err_code = v_err_code WHERE autoid = l_autoid ;
                        ELSE
                        IF l_citad_shinhan > 0 THEN --citad SHINHAN -> noi bo
                            select count(*) into v_count from ddmast where refcasaacct =l_bankaccno and status <> 'C';
                            IF v_count = 0 THEN
                            PCK_BANKAPI.Bank_Internal_Tranfer_fa(
                                l_acctno ,       --- tk ddmast tk chuyen
                                l_bankacctname,  ---ten tk nhan
                                l_bankaccno,     --- so tk nhan
                                l_amt,           --- so tien
                                l_instype,       --request code cua nghiep vu trong allcode
                                l_globalid,      --requestkey duy nhat de truy lai giao dich goc
                                l_desc,          -- dien giai
                                l_tlid,          -- nguoi tao giao dich
                                P_ERR_CODE);
                            if p_err_code <> systemnums.c_success THEN -- loi -> 'E', thanh cong -> 'S'
                                v_err_code := '-930005';
                                 
                                UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'E',err_code = v_err_code WHERE autoid = l_autoid;
                            else
                                UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'S' WHERE autoid = l_autoid;
                            end if;
                        ELSE
                            select acctno into v_toacctno from ddmast where refcasaacct = l_bankaccno and status <> 'C';
                            PCK_BANKAPI.Bank_Internal_Tranfer(
                                l_acctno ,       --- tk ddmast tk chuyen
                                l_bankacctname,  ---ten tk nhan
                                v_toacctno,     --- so tk nhan
                                l_amt,           --- so tien
                                l_instype,       --request code cua nghiep vu trong allcode
                                l_globalid,      --requestkey duy nhat de truy lai giao dich goc
                                l_desc,          -- dien giai
                                l_tlid,          -- nguoi tao giao dich
                                P_ERR_CODE);
                            if p_err_code <> systemnums.c_success THEN -- loi -> 'E', thanh cong -> 'S'
                                v_err_code := '-930005';
                                
                                UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'E',err_code = v_err_code WHERE autoid = l_autoid;
                            else
                                UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'S' WHERE autoid = l_autoid;
                            end if;
                        END IF;
           ELSE
              pck_bankapi.Bank_Tranfer_Out_fa(l_acctno,
                                                l_bankname,
                                                l_bankaccno,
                                                l_citad,
                                                L_FEETYPE,
                                                l_amt,
                                                L_INSTYPE,
                                                l_globalid,
                                                l_desc,
                                                l_tlid,
                                                p_err_code);
              if p_err_code <> systemnums.c_success THEN -- loi -> 'E', thanh cong -> 'S'
                 v_err_code := '-930005';
                  
                 UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'E',err_code = v_err_code WHERE autoid = l_autoid;
             else
                 UPDATE FACB_STATEMENTGROUP SET BANKSTATUS = 'S' WHERE autoid = l_autoid;
             end if;
            END IF;
           END IF;
                    END IF;
                END;
            END IF;
        EXCEPTION WHEN EXCETION_STR OR EXCETION_NUMBER OR NO_DATA_FOUND OR DUP_VAL_ON_INDEX OR TOO_MANY_ROWS OR ZERO_DIVIDE THEN
            v_err_code:='-930000';
            v_err_msg := 'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace;
            plog.error(pkgctx, SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
            UPDATE syn_facb_log_notify SET STATUS = 'R',err_code=v_err_code,err_msg=v_err_msg WHERE autoid = rec.autoid;
            plog.setEndSection(pkgctx, 'process_msg_from_fa');
        WHEN OTHERS THEN
            v_err_code:='-930004';
            v_err_msg := 'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace;
            plog.error(pkgctx, SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
            UPDATE syn_facb_log_notify SET STATUS = 'R',err_code=v_err_code,err_msg=v_err_msg WHERE autoid = rec.autoid;
            plog.setEndSection(pkgctx, 'process_msg_from_fa');
        END;
    END LOOP;

    plog.setEndSection(pkgctx, 'process_msg_from_fa');
    EXCEPTION
    WHEN OTHERS THEN
    plog.error(pkgctx, SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'process_msg_from_fa');
END process_msg_from_fa;

PROCEDURE process_autorun_bankpayment
  AS
  l_currdate date;
  l_desc varchar2(500);
  l_tlid varchar2(20);
  p_err_code varchar2(20);
  v_err_code varchar2(50);
  v_count number;
  v_toacctno varchar2(50);
  BEGIN
     plog.setBeginSection(pkgctx, 'process_autorun_bankpayment');
    SELECT TO_DATE(VARVALUE,systemnums.C_DATE_FORMAT) INTO l_currdate
                    FROM SYSVAR
                    WHERE GRNAME = 'SYSTEM' AND VARNAME ='CURRDATE';
    FOR rec IN (
      SELECT C.CUSTODYCD,C.ACCTNO,C.TRANSTYPE,C.TXTYPE,C.CITAD,
                   C.CUSTNAME,C.BANKBRACH,C.BENEFICIARYACCOUNT,C.TXAMT,
                   C.TXNUM, C.TXDATE, C.FEETYPE,C.TLTXCD,C.GLOBALID
      FROM CBFA_BANKPAYMENT C WHERE C.BANKSTATUS = 'K' AND C.VALUEDATE  = to_date(getcurrdate,'dd/MM/RRRR') --trung.luu: SHBVNEX-2345 check sysdate, vi ngay nghi thi currdate nhay sang ngay ke tiep, thoa dieu kien
    )
    LOOP
       --SELECT en_txdesc INTO l_desc FROM tltx WHERE tltxcd = rec.TLTXCD;
       SELECT TLID INTO l_tlid FROM VW_TLLOG_ALL where txnum = rec.txnum and txdate = rec.txdate;
       l_desc := FN_GET_TLLOGFLD_VALUE(rec.txnum, rec.txdate,'30','C');
       IF rec.transtype = 'D' THEN--chuyen tien ra ngoai
              pck_bankapi.Bank_Tranfer_Out_fa(rec.Acctno,
                                            rec.CUSTNAME,
                                            rec.beneficiaryaccount,
                                            rec.citad,
                                            rec.Feetype,
                                            rec.Txamt,
                                            rec.Txtype,
                                            rec.Globalid,
                                            l_desc,
                                            l_tlid,
                                            p_err_code);
               IF p_err_code <> systemnums.c_success THEN
                  v_err_code := '-930005';
                  UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',err_code = v_err_code  WHERE GLOBALID = rec.globalid;
                   
               ELSE
                  UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = rec.globalid;
               END IF;
            ELSE-- chuyen tien noi bo
                 select count(*) into v_count from ddmast d where d.refcasaacct = rec.Beneficiaryaccount  and status = 'A';
                 IF v_count = 0 THEN
                     pck_bankapi.Bank_Internal_Tranfer_fa(
                         rec.Acctno,
                         rec.CUSTNAME, ---ten tk nhan
                         rec.Beneficiaryaccount, --- so tk nhan
                         rec.txamt,  --- so tien
                         rec.txtype, --request code cua nghiep vu trong allcode
                         rec.globalid,  --requestkey duy nhat de truy lai giao dich goc
                         l_desc,  -- dien giai
                         l_tlid, -- nguoi tao giao dich
                         p_err_code);
                     IF p_err_code <> systemnums.c_success THEN
                         v_err_code := p_err_code;
                         UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',err_code = v_err_code WHERE GLOBALID = rec.globalid;
                          
                     ELSE
                         UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = rec.globalid;
                     END IF;
                 ELSE
                     select acctno into v_toacctno from ddmast where refcasaacct = rec.Beneficiaryaccount and status <> 'C';
                     pck_bankapi.Bank_Internal_Tranfer(
                         rec.Acctno,
                         rec.CUSTNAME, ---ten tk nhan
                         v_toacctno, --- so tk nhan
                         rec.txamt,  --- so tien
                         rec.txtype, --request code cua nghiep vu trong allcode
                         rec.globalid,  --requestkey duy nhat de truy lai giao dich goc
                         l_desc,  -- dien giai
                         l_tlid, -- nguoi tao giao dich
                         p_err_code);
                     IF p_err_code <> systemnums.c_success THEN
                         v_err_code := p_err_code;
                         UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'E',err_code = v_err_code WHERE GLOBALID = rec.globalid;
                          
                     ELSE
                         UPDATE CBFA_BANKPAYMENT SET BANKSTATUS = 'S' WHERE GLOBALID = rec.globalid;
                     END IF;
                 END IF;
          END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
    plog.error(pkgctx,'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'process_autorun_bankpayment');
END process_autorun_bankpayment;

PROCEDURE pr_auto_6642(p_autoid number, p_err_code  OUT varchar2, p_err_message  OUT varchar2)
AS
 l_currdate DATE;
 v_tlxcd varchar2(10);
 l_txmsg       tx.msg_rectype;
 V_STRDESC VARCHAR2(100);
 V_STREN_DESC VARCHAR2(100);
 v_globalid varchar2(50);
 l_acctno varchar2(50);
BEGIN
    plog.setBeginSection(pkgctx, 'pr_auto_6642');

    l_currdate:= getcurrdate();
    l_txmsg.msgtype := 'T';
    l_txmsg.local := 'N';
    l_txmsg.tlid := systemnums.c_system_userid;

    SELECT TXDESC, EN_TXDESC INTO V_STRDESC, V_STREN_DESC
         FROM TLTX WHERE TLTXCD = '6642';

    SELECT SYS_CONTEXT('USERENV', 'HOST'),
               SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
    INTO L_TXMSG.WSNAME, L_TXMSG.IPADDRESS
    FROM DUAL;

    l_txmsg.off_line := 'N';
    l_txmsg.deltd := txnums.c_deltd_txnormal;
    l_txmsg.txstatus := txstatusnums.c_txcompleted;
    l_txmsg.msgsts := '0';
    l_txmsg.ovrsts := '0';
    L_TXMSG.BATCHNAME  := 'DAY';
    L_TXMSG.TXDATE     := TO_DATE(l_currdate, SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.BUSDATE    := TO_DATE(l_currdate, SYSTEMNUMS.C_DATE_FORMAT);
    L_TXMSG.TLTXCD := '6642';

    select max(acctno),max(description) into l_acctno,V_STREN_DESC from ddmast d,facb_statementgroup g
    where d.custodycd = g.custodycd
    and d.isdefault = 'Y'
    and d.status <> 'C'
    and g.autoid = p_autoid;

    FOR REC IN (
             select g.globalid,g.custodycd, g.txamt + g.taxamt amount,
                    l_acctno acctno, a.acctno afacctno, d.balance, d.ccycd,
                    cf.CIFID, cf.fullname
             from facb_statementgroup g, afmast a, ddmast d, cfmast cf
             where g.autoid = p_autoid
                   and d.acctno = l_acctno and d.custodycd = g.custodycd
                   and d.afacctno = a.acctno
                   and cf.custodycd = g.custodycd
                    and d.status <> 'C'
         )
    LOOP
             SELECT systemnums.C_BATCH_PREFIXED || LPAD(seq_batchtxnum.NEXTVAL, 8, '0')
             INTO L_TXMSG.TXNUM
             FROM DUAL;
             --CATXNUM
             l_txmsg.txfields('02').defname := 'CATXNUM';
             l_txmsg.txfields('02').TYPE := 'C';
             l_txmsg.txfields('02').VALUE := REC.globalid;

             --SECACCOUNT
             l_txmsg.txfields('03').defname := 'SECACCOUNT';
             l_txmsg.txfields('03').TYPE := 'C';
             l_txmsg.txfields('03').VALUE := REC.afacctno;

             --DESACCTNO
             l_txmsg.txfields('05').defname := 'DESACCTNO';
             l_txmsg.txfields('05').TYPE := 'C';
             l_txmsg.txfields('05').VALUE := l_acctno;

             --TRFTYPE
             l_txmsg.txfields('06').defname := 'TRFTYPE';
             l_txmsg.txfields('06').TYPE := 'C';
             l_txmsg.txfields('06').VALUE := 'TRFCICAMT';

             ----AMT
             l_txmsg.txfields('09').defname := 'WDRTYPE';
             l_txmsg.txfields('09').TYPE := 'C';
             l_txmsg.txfields('09').VALUE := '031';

             ----AMOUNT
             l_txmsg.txfields('10').defname := 'AMOUNT';
             l_txmsg.txfields('10').TYPE := 'N';
             l_txmsg.txfields('10').VALUE := REC.AMOUNT;

             ----BALANCE
             l_txmsg.txfields('11').defname := 'BALANCE';
             l_txmsg.txfields('11').TYPE := 'N';
             l_txmsg.txfields('11').VALUE := REC.BALANCE;

             --CCYCD
             l_txmsg.txfields('21').defname := 'CCYCD';
             l_txmsg.txfields('21').TYPE := 'C';
             l_txmsg.txfields('21').VALUE := REC.CCYCD;

              --DESC
             l_txmsg.txfields('30').defname := 'DESC';
             l_txmsg.txfields('30').TYPE := 'C';
             l_txmsg.txfields('30').VALUE := V_STREN_DESC;

             --CUSTODYCD
             l_txmsg.txfields('88').defname := 'CUSTODYCD';
             l_txmsg.txfields('88').TYPE := 'C';
             l_txmsg.txfields('88').VALUE := rec.CUSTODYCD;

             --CIFID
             l_txmsg.txfields('89').defname := 'CIFID';
             l_txmsg.txfields('89').TYPE := 'C';
             l_txmsg.txfields('89').VALUE := REC.CIFID;

             --CUSTNAME
             l_txmsg.txfields('90').defname := 'CUSTNAME';
             l_txmsg.txfields('90').TYPE := 'C';
             l_txmsg.txfields('90').VALUE := REC.fullname;

             IF TXPKS_#6642.fn_AutoTxProcess(l_txmsg, p_err_code, p_err_message) <>
                 SYSTEMNUMS.C_SUCCESS THEN
                 PLOG.ERROR(PKGCTX,
                     ' run ' || '6642' || ' got ' || p_err_code || ':' ||
                     p_err_code);
                 p_err_message := 'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace;
                 ROLLBACK;
                 plog.setEndSection(pkgctx, 'pr_auto_6642');
                 RETURN;
             END IF;
         END LOOP;
    p_err_code:=0;
    plog.setEndSection(pkgctx, 'pr_auto_6642');
    EXCEPTION
    WHEN OTHERS THEN
    plog.error(pkgctx,'Err: ' || SQLERRM || ' Trace: ' || dbms_utility.format_error_backtrace );
    plog.setEndSection(pkgctx, 'pr_auto_6642');
END pr_auto_6642;

BEGIN
  -- Initialization
  FOR i IN (SELECT * FROM tlogdebug)
  LOOP
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  END LOOP;

  pkgctx := plog.init('pks_notify_cbfa',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));

END pks_notify_cbfa;
/
