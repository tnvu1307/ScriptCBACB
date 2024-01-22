SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendmailauto (
p_camast_id varchar2, p_codeid varchar2

       )
IS
    l_CATYPE varchar2(10);
    l_codeid varchar2(50);
    l_count number;
    l_data_source varchar2(3000);
    l_email varchar2(100);
    l_actiondate varchar2(20);
    v_str1          clob;
    v_str2          clob;
    v_str3          clob;
    v_str4          clob;
    v_str5          clob;
    v_str6          clob;
    v_str7          clob;
    v_str8          clob;
    v_str9          clob;
    v_str10         clob;
    v_substr1       clob;
    v_substr2       clob;
    v_substr3       clob;
    v_substr4       clob;
    v_substr5       clob;
    v_substr6       clob;
    v_substr7       clob;
    v_substr8       clob;
    v_substr9       clob;
    v_substr10      clob;
    v_strRowchar    clob;
    l_group1        clob;
    l_group2        clob;
    l_group3        clob;
    l_group4        clob;
    l_group5        clob;
    l_group         clob;
    l_group6        clob;
    l_group7        clob;
    l_group8        clob;
    l_group9        clob;
    l_group10       clob;
    l_title1        clob;
    l_title2        clob;
    l_title3        clob;
    l_title4        clob;
    l_title5        clob;
    l_title         clob;
    l_title6        clob;
    l_title7        clob;
    l_title8        clob;
    l_title9        clob;
    l_title10       clob;
BEGIN
    for rec in(
        select cf.custid, cf.custodycd, ca.afacctno, ca.actiondate, ca.camastid, ca.codeid, ca.tmpl, cf.fullname, cf.email, sb.symbol,
            iss.fullname symname,iss.en_fullname en_symname,a6.en_cdcontent encdcontent,
            a3.cdcontent tradeplace, ca.trade,ca.qtty,cf.cifid,ca.catype,ca.rate, ca.devidentshares,ca.frdatetransfer,ca.advdesc,ca.RIGHTTRANSDL,
            ca.canceldate,ca.description,
            nvl(a1.cdcontent,'') FRTRADEPLACE, nvl(a2.cdcontent,'') TOTRADEPLACE,ca.exprice,ca.optsymbol,sb.isincode sbisincode,ca.caisincode,a4.isincode toisincode,
            ca.debitdate,
            ca.meetingplace, --chuyen san
            nvl(a4.symbol,'') symbol2, nvl(a4.fullname,'') symname2, nvl(a4.en_fullname,'') en_symname2, nvl(a4.tradeplace,'') TRADEPLACE2,
            ca.EXRATE, --chuyen doi CP thanh CP
             ca.interestrate, -- Rate for 015 (%)
             ca.devidentrate, -- Rate for 010 (%)
            ca.amountperbond,sb.expdate,
            ca.intamt,ca.pbalance,ca.pqtty,
            ca.rightoffrate,ca.todatetransfer,ca.begindate,
            sb.isincode, sb.parvalue parvalue, iss.officename, iss.en_officename, iss.address,
            iss.en_address, iss.phone,ca.submissiondl,
            iss.fax, a5.cdcontent sectype, a5.en_cdcontent en_sectype, ca.duedate, ca.reportdate, ca.devidentvalue,ca.transfertimes,
            ca.insdeadline,ca.balance, ca.deltd --Giai the to chuc phat hanh
        from
            (--chi gui cho moi gioi
                select af.custid,sch.afacctno,ca.actiondate,ca.camastid,sch.qtty+decode(ca.catype,'027',sch.aqtty,0) qtty,sch.codeid,
                        case
                          when ca.catype in ('023') then '238E' --Chuyen doi trai phieu nhan Cp hoac tien
                          when ca.catype in ('005','028','022') then '230E' --Quyen bo phieu 022 005 028
                          when ca.catype in ('006') then '234E'     --Lay y kien co dong
                          when ca.catype in ('014') then '235E'     --Quyen mua
                          else '' end tmpl,
                                     ca.FRTRADEPLACE, ca.TOTRADEPLACE, --chuyen san
                       ca.TOCODEID, ca.EXRATE, --chuyen doi CP thanh CP
                       ca.rightoffrate,ca.todatetransfer,ca.begindate,
                       ca.interestrate, -- Rate for 015 (%)
                       ca.devidentrate, -- Rate for 010 (%)
                       (case when ca.catype in ('023') and sch.trade <>0 then sch.intamt/sch.trade
                       when ca.catype not in ('023') and sch.balance <>0 then sch.intamt/sch.balance
                       else sch.intamt end) amountperbond,
                       sch.intamt,ca.submissiondl,sch.pbalance,sch.pqtty,sch.trade,
                       ca.isincode caisincode, ca.duedate, ca.reportdate, ca.devidentvalue, sch.afacctno||sch.codeid seacctno,--giai the to chuc PH
                       ca.rate, ca.catype,ca.devidentshares,ca.frdatetransfer, ca.advdesc, ca.canceldate,ca.description,ca.exprice,
                       ca.optsymbol,ca.transfertimes, ca.insdeadline, ca.debitdate, ca.meetingplace,sch.balance,
                       ca.RIGHTTRANSDL, ca.deltd
                from CASCHD sch, camast ca, afmast af --, cfmast cf
                where ca.camastid=sch.camastid
                    --and ca.catype in ('019','027','017')
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
          and sb.tradeplace <> '003'
          and nvl(ca.FRTRADEPLACE,' ')=a1.cdval(+)
          and nvl(ca.TOTRADEPLACE,' ')=a2.cdval(+)
          and sb.tradeplace=a3.cdval
          and nvl(ca.TOCODEID,' ')=a4.codeid(+)
          and sb.sectype=a5.cdval
          and ca.catype =a6.cdval(+)
          and ca.seacctno=se.acctno
    ) loop

if rec.deltd = 'N' then     --thangpv SHBVNEX-2764
    IF rec.catype in ('010','015','027') then--For Cash dividend, Bond (Interest) coupon, Fund liquidation
         --Thoai.tran 03/12/2019
            l_data_source:='select '''||(rec.symbol)||''' p_securitiesid, '''
            ||(rec.sbisincode)||''' p_isincode, '''
            ||rec.encdcontent||''' p_event_type, TO_CHAR(UTILS.SO_THANH_CHU2((case when '''||rec.catype||''' ='||'''010'''||' and '
            ||nvl(rec.devidentrate,0)||' <> 0 then  '||to_char(to_number(nvl(rec.devidentrate,'0'))*rec.parvalue/100)
            ||' when '''||rec.catype||''' ='||'''015'''||' and '||nvl(rec.interestrate,0)||' <> 0 then '||to_char(to_number(nvl(rec.interestrate,'0'))*rec.parvalue/100)
            ||'else '||rec.devidentvalue||' end )))'||' p_cash_per_share_bond, '''
            || (rec.fullname) ||''' p_portfolio_name, '''
            || (rec.camastid) ||''' p_event_ref_no, '
            || 'TO_CHAR(UTILS.SO_THANH_CHU((case when '''||rec.catype||''' ='||'''010'''||' and '
            ||nvl(rec.devidentrate,0)||' <> 0 then  '||to_char(to_number(nvl(rec.devidentrate,'0'))*rec.parvalue/100)
            ||' when '''||rec.catype||''' ='||'''015'''||' and '||nvl(rec.interestrate,0)||' <> 0 then '||to_char(to_number(nvl(rec.interestrate,'0'))*rec.parvalue/100)
            ||'else '||rec.devidentvalue||' end ) * '||NVL(rec.trade,0)
            ||')) p_cashamountpaid, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(NVL(rec.trade,0)))||''' p_current_holding, '''
            ||rec.custodycd||''' p_credit_account,  '''
            ||(rec.cifid)||''' p_portfolio_no, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.AMT))||''' p_cash_before_tax, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.DUTYAMT))||''' p_tax, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.AMT-rec.DUTYAMT))||''' p_cash_after_tax, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
      ELSIF rec.catype in ('009','011') then --Email 221E Stock dividend
            l_data_source:='select '''||rec.symbol
            ||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.encdcontent||''' p_event_type,'''
            ||rec.devidentshares||''' p_payment_ratio, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.camastid ||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            || rec.cifid ||''' p_portfolio_no, '''
            || rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            --||to_char(rec.tradedate,'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';

      ELSIF rec.catype in ('021') then --Email 221E    For Bonus issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode||''' p_new_isin_code, '''
            ||rec.encdcontent||''' p_event_type,'''
            ||rec.exrate||''' p_payment_ratio, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.camastid ||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            || rec.cifid ||''' p_portfolio_no, '''
            || rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            --||to_char(rec.tradedate,'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';

            --Thoai.tran 03/12/2019
          ELSIF rec.catype='023' then  --Email 223E
            l_data_source:='select '''|| rec.symbol||''' p_securitiesid, '''
            || rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            || rec.toisincode ||''' p_new_isin_code, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.camastid||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            ||rec.exrate||''' p_conversion_ratio, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_conversion_period, '''
            ||to_char(rec.duedate,'DD/MM/RRRR')||''' p_conversion_deadline, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_conversion_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(rec.duedate,'DD/MM/RRRR')||''' p_payment_date, '''
            ||to_char(rec.duedate,'DD/MM/RRRR')||''' p_exp_payment_date, '''
            ||to_char(UTILS.SO_THANH_CHU2(rec.amountperbond))||''' p_cash_per_share_bond, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            || rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            --||to_char(rec.tradedate,'DD/MM/RRRR')||''' p_trading_date, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding from dual ';
         ELSIF rec.catype in ('017','018') then --Email 222E
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            || rec.toisincode ||''' p_new_isin_code, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.cifid ||''' p_portfolio_no, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.exrate||''' p_conversion_ratio, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            --||to_char(rec.lasttradingd,'DD/MM/YYYY')||''' p_trading_date, '''
            ||rec.camastid||''' p_event_ref_no, '''
            || rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            --||to_char(rec.effecdeldate,'DD/MM/RRRR')||''' p_delisting_date , '''
             ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
     ELSIF rec.catype in ('026','020') then --Email 222E
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.toisincode ||''' p_new_isin_code, '''
            || rec.cifid ||''' p_portfolio_no, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.devidentshares||''' p_conversion_ratio, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            --||to_char(rec.lasttradingd,'DD/MM/YYYY')||''' p_trading_date, '''
            ||rec.camastid||''' p_event_ref_no, '''
            || rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            --||to_char(rec.effecdeldate,'DD/MM/RRRR')||''' p_delisting_date , '''
             ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
      ELSIF rec.catype in ('005','028','022') then --Email 224E For Proxy voting (AGM, EGM)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.camastid||''' p_event_ref_no, '''
            || rec.devidentshares ||''' p_exercise_ratio, '''
            || rec.meetingplace ||''' p_meeting_place, '''
            || to_char(rec.actiondate,'DD/MM/RRRR') ||''' p_voting_deadline, '''
            || rec.description ||''' p_meeting_content, '''
            ||rec.cifid||''' p_portfolio_no, '''
            || rec.fullname ||''' p_portfolio_name, '''
            --||to_char(rec.tradedate,'DD/MM/YYYY')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, to_char(UTILS.SO_THANH_CHU(floor(round('
            ||rec.trade||' / ('||rec.devidentshares||'),2)))) p_no_of_share, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_meeting_date from dual ';
         ELSIF rec.catype='006' then--For Proxy voting (Postal ballot)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            || rec.devidentshares ||''' p_exercise_ratio, '''
            || to_char(rec.submissiondl,'DD/MM/RRRR') ||''' p_submission_deadline, '''
            ||rec.camastid||''' p_event_ref_no, '''
            || to_char(rec.actiondate,'DD/MM/RRRR') ||''' p_voting_deadline, '''
            || rec.description ||''' p_ballot_content, '''
            ||rec.cifid||''' p_portfolio_no, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.custodycd ||''' CUSTODYCD, '''
            --||to_char(rec.tradedate,'DD/MM/YYYY')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '
            ||'to_char(UTILS.SO_THANH_CHU(floor(round('||rec.trade||'/('||rec.devidentshares||'),2))))'||' p_no_of_share, '''
            || rec.advdesc ||''' p_meeting_place, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_meeting_date from dual ';

         ELSIF rec.catype='016' then  --For Redemption (T226E)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.parvalue))||''' p_redemption_value, '''
            || rec.fullname ||''' p_portfolio_name, '''
            || rec.encdcontent ||''' p_event_type, '''
            || rec.camastid ||''' p_event_ref_no, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            || to_char(rec.expdate,'DD/MM/RRRR') ||''' p_maturity_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            --|| rec.refcasaacct ||''' p_credit_account, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.amt))||''' p_redemption_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF rec.catype='014' then  --Email 235E For Right issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.optsymbol||''' p_right_code, '''
            ||rec.caisincode||''' p_right_isin_code, '''
            ||rec.symbol ||''' p_sub_securities_id, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent ||''' p_event_type, '''
            ||rec.camastid ||''' p_event_ref_no, '''
            ||rec.exrate ||''' p_distribution_ratio, '''
            ||rec.rightoffrate ||''' p_exercise_ratio, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.exprice)) ||''' p_conversion_price, '''
            ||to_char(rec.frdatetransfer,'DD/MM/YYYY') || ' - ' || to_char(rec.todatetransfer,'DD/MM/YYYY') ||''' p_transfer_period, '''
            ||to_char(rec.RIGHTTRANSDL,'DD/MM/RRRR')||''' p_deadline_transfer, '''
            ||to_char(rec.begindate,'DD/MM/RRRR') || ' - ' || to_char(rec.duedate,'DD/MM/RRRR') ||''' p_sub_period, '''
            ||to_char(rec.duedate,'DD/MM/RRRR')||''' p_deadline_sub, '''
            ||to_char(rec.debitdate,'DD/MM/RRRR')||''' p_debit_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_exp_payment_date,'''
            || rec.fullname ||''' p_portfolio_name, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            || rec.custodycd ||''' p_credit_account, '''
            --||to_char(rec.tradedate,'DD/MM/YYYY')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.balance+rec.pbalance))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty+rec.pqtty))||''' p_no_of_rights, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual';
            END IF;
end if;


        --------
        /*select tl.email into l_email
        from tlprofiles tl , templateslnk lnk, camast ca
        where lnk.tlid = tl.tlid
            and ca.makerid = tl.tlid
            and ca.camastid = p_camast_id
            and lnk.templateid=rec.tmpl and rownum =1;*/
        --------

        if l_data_source is not null then
          --nmpks_ems.InsertEmailLog(l_email, rec.tmpl, l_data_source, rec.afacctno);

          nmpks_ems.pr_sendInternalEmail(l_data_source, rec.tmpl, rec.afacctno);
        end if;
    end loop;
EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
