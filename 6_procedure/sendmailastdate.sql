SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendmailastdate (
p_camast_id varchar2, p_codeid varchar2, p_listtingdate date
       )
IS
    l_CATYPE varchar2(10);
    l_codeid varchar2(50);
    l_count number;
    l_data_source varchar2(3000);
    l_email varchar2(100);
    l_actiondate varchar2(20);
BEGIN
    --select count(*) into  l_count from securities_info  where listtingdate = getcurrdate and codeid=p_codeid;
    select count(*),max(catype) into  l_count, l_CATYPE from camast  where camastid = p_camast_id and codeid=p_codeid;
if l_count <> 0 then
    for rec in(
   select cf.custid, cf.custodycd, ca.afacctno, ca.actiondate, ca.camastid, ca.codeid, ca.tmpl, cf.fullname, cf.email, sb.symbol,
            iss.fullname symname,iss.en_fullname en_symname,a6.en_cdcontent encdcontent,
            a3.cdcontent tradeplace, ca.trade,ca.qtty,cf.cifid,ca.catype,ca.rate, ca.devidentshares,ca.frdatetransfer,ca.advdesc,
            ca.canceldate,ca.description,
            nvl(a1.cdcontent,'') FRTRADEPLACE, nvl(a2.cdcontent,'') TOTRADEPLACE,ca.exprice,ca.optsymbol,sb.isincode sbisincode,a4.isincode toisincode,
            ca.debitdate,
            ca.meetingplace, --chuyen san
            nvl(a4.symbol,'') symbol2, nvl(a4.fullname,'') symname2, nvl(a4.en_fullname,'') en_symname2, nvl(a4.tradeplace,'') TRADEPLACE2,
            ca.EXRATE, --chuyen doi CP thanh CP
             ca.interestrate, -- Rate for 015 (%)
             ca.devidentrate, -- Rate for 010 (%)
            ca.amountperbond,sb.expdate,
            ca.refcasaacct , -- credit securities account of fund
            ca.rightoffrate,ca.todatetransfer,ca.begindate,
            a4.isincode, sb.parvalue parvalue, iss.officename, iss.en_officename, iss.address,
            iss.en_address, iss.phone,ca.submissiondl,
            iss.fax, a5.cdcontent sectype, a5.en_cdcontent en_sectype, ca.duedate, ca.reportdate, ca.devidentvalue,ca.transfertimes,
            ca.insdeadline,ca.balance, ca.deltd --Giai the to chuc phat hanh
        from
            (--chi gui cho moi gioi
                select af.custid,sch.afacctno,ca.actiondate,ca.camastid,sch.qtty+decode(ca.catype,'027',sch.aqtty,0) qtty,sch.codeid,
                        case
                          when ca.catype in ('021','011','009') then '260E'
                          when ca.catype in ('026','020','017','018') then '261E'
                          when ca.catype in ('023') then '262E'
                          when ca.catype in  ('014') then '263E'
                          else '' end tmpl,
                       ca.FRTRADEPLACE, ca.TOTRADEPLACE, --chuyen san
                       ca.TOCODEID, ca.EXRATE, --chuyen doi CP thanh CP
                       ca.rightoffrate,ca.todatetransfer,ca.begindate,
                       ca.interestrate, -- Rate for 015 (%)
                       ca.devidentrate, -- Rate for 010 (%)
                       sch.intamt/sch.trade amountperbond,
                       ca.submissiondl,sch.trade,
                       dd.refcasaacct, -- credit securities account of fund
                       ca.isincode caisincode, ca.duedate, ca.reportdate, ca.devidentvalue, sch.afacctno||sch.codeid seacctno,--giai the to chuc PH
                       ca.rate, ca.catype,ca.devidentshares,ca.frdatetransfer, ca.advdesc, ca.canceldate,ca.description,ca.exprice,
                       ca.optsymbol,ca.transfertimes, ca.insdeadline, ca.debitdate, ca.meetingplace,sch.balance, ca.deltd
                from CASCHD sch, camast ca, afmast af,ddmast dd --, cfmast cf
                where ca.camastid=sch.camastid
                    --and ca.catype in ('019','027','017')
                    and af.custid=dd.custid
                    and dd.ccycd='VND'
                    and dd.isdefault='Y'
                    and sch.afacctno=af.acctno
                    --and sch.ISRECEIVE = 'N'
                    AND SCH.DELTD <> 'Y'
                    and ca.camastid = p_camast_id
            )ca, cfmast cf, sbsecurities sb, issuers iss,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
            ) a1,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
            ) a2,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='TRADEPLACE' and cdtype='OD'
            ) a3,
            (
                select sb.codeid, sb.symbol, iss.fullname,iss.en_fullname, a0.cdcontent tradeplace,sb.isincode
                from sbsecurities sb, issuers iss, allcode a0
                where sb.issuerid=iss.issuerid
                    and a0.cdname='TRADEPLACE' and a0.cdtype='OD' and sb.tradeplace=a0.cdval
            ) a4,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='SECTYPE' and cdtype='SA'
            ) a5,(
                select cdval, cdcontent,en_cdcontent from allcode where cdname='CATYPE'
            ) a6, templates t, (
                select se.acctno, sum(trade+mortage+blocked+emkqtty) trade
                from semast se, sbsecurities sb where se.codeid=sb.codeid and sb.sectype <> '004'
                group by se.acctno
            ) se
        where ca.custid=cf.custid
          and ca.tmpl=t.code and t.isactive='Y'
          and sb.codeid=ca.codeid
          and sb.issuerid=iss.issuerid
          and sb.tradeplace <> '003' --CK OTC
          and nvl(ca.FRTRADEPLACE,' ')=a1.cdval(+)
          and nvl(ca.TOTRADEPLACE,' ')=a2.cdval(+)
          and sb.tradeplace=a3.cdval
          and nvl(ca.TOCODEID,' ')=a4.codeid(+)
          and sb.sectype=a5.cdval
          and ca.catype =a6.cdval(+)
          and ca.seacctno=se.acctno
    ) loop

    if rec.deltd = 'N' then     --thangpv SHBVNEX-2764
        IF l_catype in ('009','011','021') then --- 260E 2.15.5.1    For Bonus issue, Stock dividend
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.encdcontent||''' p_eventtype,'''
            ||to_char(p_listtingdate,'DD/MM/RRRR')||''' p_trading_date, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.camastid ||''' p_event_ref_no, '''
            || rec.custodycd ||''' p_credit_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.qtty))||''' p_shares_received, '''
            || rec.cifid ||''' p_portfolio_no, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_recorddate, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date, '''
            ||rec.encdcontent||''' p_event_type from dual ';
         ELSIF l_catype in ('017','018','026','020') then --Email 261E 2.15.5.2    For Conversion mandatory
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.toisincode ||''' p_new_isin_code, '''
            || rec.cifid ||''' p_portfolio_no, '''
            ||rec.encdcontent||''' p_event_type, '''
            || rec.custodycd ||''' p_credit_account, '''
            ||to_char(p_listtingdate,'DD/MM/YYYY')||''' p_trading_date, '''
            ||rec.camastid||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.qtty))||''' p_shares_received, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(rec.canceldate,'DD/MM/RRRR')||''' p_delisting_date , '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF l_catype='023' then  --Email 262E
            l_data_source:='select '''|| rec.symbol||''' p_securitiesid, '''
            || rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode||''' p_new_isin_code, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.camastid||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            ||rec.exrate||''' p_conversion_ratio, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_conversion_period, '''
            ||to_char(p_listtingdate,'DD/MM/YYYY')||''' p_trading_date, '''
            ||to_char(rec.duedate,'DD/MM/RRRR')||''' p_conversion_deadline, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_conversion_date, '''
            || rec.custodycd ||''' p_credit_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.qtty))||''' p_shares_received, '''
            ||rec.cifid||''' p_portfolio_no, '''||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(rec.duedate,'DD/MM/RRRR')||''' p_payment_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amountperbond))||''' p_cash_amount, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding from dual ';
        ELSIF l_catype='014' then  --Email 263E For Right issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.optsymbol||''' p_right_code, '''
            || rec.symbol2 ||''' p_sub_securities_id, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            || rec.encdcontent ||''' p_event_type, '''
            || rec.camastid ||''' p_event_ref_no, '''
            || rec.custodycd ||''' p_credit_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.qtty))||''' p_shares_received, '''
            ||rec.cifid||''' p_portfolio_no, '''
            || rec.fullname ||''' p_portfolio_name, '''
            ||to_char(p_listtingdate,'DD/MM/YYYY')||''' p_trading_date, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
          end if;

    end if;


        --------
        /*l_email := '';
        --------
            select  temp.emailcs into  l_email
            From templateslnk lnk, tlprofiles tl, templates temp
            where tl.tlid=lnk.tlid and temp.code=lnk.templateid and tl.email is not null
                and lnk.templateid =rec.tmpl and tl.tlid=rec.makerid;
        --------
        nmpks_ems.InsertEmailLog(l_email, rec.tmpl, l_data_source, rec.afacctno);*/
        if l_data_source is not null then
        nmpks_ems.pr_sendInternalEmail(l_data_source, rec.tmpl, rec.afacctno);
        end if;
    end loop;
end if;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
