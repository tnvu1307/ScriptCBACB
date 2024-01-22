SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendmailafter3312 (p_camastid varchar2, p_err_code in out varchar2)
IS
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_data_source varchar2(4000);
    l_camastid varchar2(200);
    l_voting varchar(4000);
BEGIN
    plog.setBeginSection(pkgctx, 'sendmailafter3312');
    p_err_code  := systemnums.C_SUCCESS;
    l_camastid :=  p_camastid;
    /*thunt-13/01/2020: lay thong tin voting cho 3340*/
    select nvl(get_voting_list(l_camastid),null) into l_voting from dual;
    for rec in(
        select cf.custid, cf.custodycd, ca.afacctno, ca.actiondate, ca.camastid, ca.codeid, ca.tmpl, cf.fullname, cf.email, sb.symbol,
            iss.fullname symname,iss.en_fullname en_symname,a6.en_cdcontent encdcontent,
            a3.cdcontent tradeplace, ca.trade,ca.qtty,cf.cifid,ca.catype,ca.rate, ca.devidentshares,ca.frdatetransfer,ca.advdesc,
            case when ca.content is not null then ca.content else nvl(ca.changecontent,ca.description) end changecontent,
            ca.canceldate,ca.description,
            nvl(a1.cdcontent,'') FRTRADEPLACE, nvl(a2.cdcontent,'') TOTRADEPLACE,ca.exprice,ca.optsymbol,sb.isincode sbisincode,a4.isincode toisincode,
            ca.debitdate,ca.caisincode,
            replace(ca.meetingplace,'''','''''') meetingplace, --chuyen san
            case when (ca.exprice=0 and ca.catype not in ('023')) or (ca.fractionalshare=0 and ca.ciroundtype=0 and ca.catype ='023') or (ca.fractionalshare=0 and ca.catype ='023')
            then 'Fractional shares will be dropped.'
                 when ca.catype in ('023') and ca.fractionalshare <> 0 then 'Fractional shares will be paid at VND '||TO_CHAR(UTILS.SO_THANH_CHU(ca.fractionalshare))||' per share'
                 else 'Fractional shares will be paid at VND '||TO_CHAR(UTILS.SO_THANH_CHU(ca.exprice))||' per share' end Fractionalshares,
            nvl(a4.symbol,'') symbol2, nvl(a4.fullname,'') symname2, nvl(a4.en_fullname,'') en_symname2, nvl(a4.tradeplace,'') TRADEPLACE2,
            ca.EXRATE, --chuyen doi CP thanh CP
            ca.interestrate, -- Rate for 015 (%)
            ca.devidentrate, -- Rate for 010 (%)
            ca.formofpayment,
            case when ca.formofpayment='001' then round(sb.parvalue*ca.interestrate/100,6) else round(sb.parvalue*(1+(ca.interestrate/100)),6) end cashamountperbond,--tra lai~ hoac goc va lai~
            ca.amountperbond,sb.expdate,ca.tradedate,ca.pbalance,ca.pqtty,replace(ca.meetingdatetime,'''','''''')meetingdatetime,
            ca.rightoffrate,ca.todatetransfer,ca.begindate,ca.optisincode,ca.fractionalshare,ca.purposedesc,
            a4.isincode, sb.parvalue parvalue, iss.officename, iss.en_officename, iss.address,ca.instruction,ca.righttransdl,
            iss.en_address, iss.phone,ca.submissiondl,ca.lasttradingd,ca.effecdeldate,ca.receivedate,ca.inactiondate,
            case when ca.catype='030' then nvl(a7.en_cdcontent,'') when ca.catype='030' and ca.actiontype = 'U' then nvl(a6.en_cdcontent,'') else nvl(a6.en_cdcontent,'') end  CASUBTYPE,   --thangpv SHBVNEX-2672
            iss.fax, a5.cdcontent sectype, a5.en_cdcontent en_sectype, ca.duedate, ca.reportdate, ca.devidentvalue,ca.transfertimes,
            ca.insdeadline,ca.balance,ca.typerate, ca.deltd --Giai the to chuc phat hanh
        from
            (--chi gui cho moi gioi
                select af.custid,sch.afacctno,ca.actiondate,ca.camastid,sch.qtty+decode(ca.catype,'027',sch.aqtty,0) qtty,sch.codeid,
                        case
                            --Chot moi / New
                          when ca.catype in ('010','015','027') and sch.actiontype = 'N' then '210E'
                          when ca.catype in ('021','011','009') and sch.actiontype = 'N' then '211E'
                          when ca.catype in ('026','020','017','018') and sch.actiontype = 'N' then '212E'
                          when ca.catype in ('023') and sch.actiontype = 'N'then '213E'
                          when ca.catype in ('005','028','022')and sch.actiontype = 'N' then '214E'
                          when ca.catype in ('006') and sch.actiontype = 'N'then '215E'
                          when ca.catype in ('016') and sch.actiontype = 'N'then '216E'
                          when ca.catype in ('014') and sch.actiontype = 'N'then '217E'
                          when ca.catype in ('003','029','031','032','030','019')and sch.actiontype = 'N' then '218E'
                          when ca.catype in ('024')and sch.actiontype = 'N' then '264E' --TriBui: 21/07/2020 them email cho Covered warrant payment event
                           ---- Chot dieu chinh / Update
                          when ca.catype in ('010','015','027') and sch.actiontype = 'U' then '250E'
                          when ca.catype in ('021','011','009') and sch.actiontype = 'U' then '251E'
                          when ca.catype in ('026','020','017','018') and sch.actiontype = 'U' then '252E'
                          when ca.catype in ('023') and sch.actiontype = 'U'then '253E'
                          when ca.catype in ('005','028','022')and sch.actiontype = 'U' then '254E'
                          when ca.catype in ('006') and sch.actiontype = 'U'then '255E'
                          when ca.catype in ('016') and sch.actiontype = 'U'then '256E'
                          when ca.catype in ('014') and sch.actiontype = 'U'then '257E'
                          when ca.catype in ('003','029','031','032','030','019')and sch.actiontype = 'U' then '258E'
                          when ca.catype in ('024')and sch.actiontype = 'U' then '265E' --TriBui: 21/07/2020 them email cho Covered warrant payment event
                          else '' end tmpl,
                       ca.FRTRADEPLACE, ca.TOTRADEPLACE, --chuyen san
                       ca.TOCODEID, ca.EXRATE, --chuyen doi CP thanh CP
                       ca.rightoffrate,ca.todatetransfer,ca.begindate,ca.optisincode,ca.righttransdl,
                       ca.interestrate, -- Rate for 015 (%)
                       ca.devidentrate, -- Rate for 010 (%)
                       ca.formofpayment,
                       (case when ca.catype in ('023') and sch.trade <>0 then sch.intamt/sch.trade
                       when ca.catype not in ('023') and sch.balance <>0 then sch.intamt/sch.balance
                       else sch.intamt end) amountperbond,sch.trade,ca.tradedate,sch.pbalance,sch.pqtty,ca.purposedesc,ca.receivedate,ca.ciroundtype,
                       ca.submissiondl,ca.changecontent,ca.lasttradingd,ca.effecdeldate,ca.content,ca.instruction,ca.meetingdatetime,ca.inactiondate,
                       ca.isincode caisincode, ca.duedate, ca.reportdate, ca.devidentvalue, sch.afacctno||sch.codeid seacctno,--giai the to chuc PH
                       ca.rate, ca.catype,ca.devidentshares,ca.frdatetransfer, ca.purposedesc advdesc, ca.canceldate,ca.description,ca.exprice,
                       ca.optsymbol,ca.transfertimes, ca.insdeadline, ca.debitdate, ca.meetingplace,sch.balance,ca.CASUBTYPE, ca.fractionalshare,ca.typerate
                       ,sch.actiontype      --thangpv SHBVNEX-2672
                       , ca.deltd
                from CASCHD_LIST sch, camast ca, afmast af --, cfmast cf
                where ca.camastid=sch.camastid
                    and sch.afacctno=af.acctno
                    and sch.ISRECEIVE = 'N'
                    and ((sch.isreceive = 'N' AND sch.actiontype = 'N') OR sch.actiontype = 'U')
                    AND SCH.DELTD <> 'Y'
                    and ca.camastid = p_camastid
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
            ) a5,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='CATYPE' and cduser='Y'
            ) a6,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='CASUBTYPE'
            ) a7,
            templates t,
            (
                select se.acctno, sum(trade+mortage+blocked+emkqtty) trade
                from semast se, sbsecurities sb
                where se.codeid=sb.codeid
                and sb.sectype <> '004'
                group by se.acctno
            ) se
        where ca.custid=cf.custid
          and ca.tmpl=t.code and t.isactive='Y'
          and sb.codeid=ca.codeid
          and sb.issuerid=iss.issuerid
          and (sb.tradeplace <> '003' or (sb.tradeplace = '003' AND SB.depository='001'))--CK unlisted    SHBVNEX-1887 Thoai.tran 20210312
          and nvl(ca.FRTRADEPLACE,' ')=a1.cdval(+)
          and nvl(ca.TOTRADEPLACE,' ')=a2.cdval(+)
          and sb.tradeplace=a3.cdval
          and nvl(ca.TOCODEID,' ')=a4.codeid(+)
          and sb.sectype=a5.cdval
          and ca.catype =a6.cdval(+)
          and ca.seacctno=se.acctno
          and ca.CASUBTYPE = a7.cdval(+)
    ) loop

    if rec.deltd = 'N' then     --thangpv SHBVNEX-2764
        IF rec.catype in ('010','015','027') then--For Cash dividend, Bond (Interest) coupon, Fund liquidation
         --Thoai.tran 03/12/2019
            l_data_source:='select '''||(rec.symbol)||''' p_securitiesid, '''
            ||(rec.sbisincode)||''' p_isincode, '''
            ||rec.encdcontent||''' p_event_type, TO_CHAR(UTILS.SO_THANH_CHU2((case when '''||rec.catype||''' in ('||'''010'','||'''027'''||') and '
            ||nvl(rec.devidentrate,0)||' <> 0 then  '||to_char(to_number(nvl(rec.devidentrate,'0'))*rec.parvalue/100)
            ||' when '''||rec.catype||''' ='||'''015'''||' and '||nvl(rec.interestrate,0)||' <> 0 then '||to_char(to_number(nvl(rec.interestrate,'0'))*rec.parvalue/100)
            ||'else '||nvl(rec.devidentvalue,0)||' end )))'||' p_cash_per_share_bond, '''
            ||(rec.fullname) ||''' p_portfolio_name, '''
            ||(p_camastid) ||''' p_event_ref_no, '
            ||'TO_CHAR(UTILS.SO_THANH_CHU((case when '''||rec.catype||''' in ('||'''010'','||'''027'''||') and '
            ||nvl(rec.devidentrate,0)||' <> 0 then  '||to_char(to_number(nvl(rec.devidentrate,'0'))*rec.parvalue/100)
            ||' when '''||rec.catype||''' ='||'''015'''||' and '||nvl(rec.interestrate,0)||' <> 0 then '||to_char(to_number(nvl(rec.interestrate,'0'))*rec.parvalue/100)
            ||'else '||nvl(rec.devidentvalue,0)||' end ) * '||NVL(rec.trade,0)
            ||')) p_cashamountpaid, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(NVL(rec.trade,0)))||''' p_current_holding, '''
            ||rec.custodycd||''' p_credit_account,  '''
            ||(rec.cifid)||''' p_portfolio_no, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.AMT))||''' p_cash_before_tax, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.DUTYAMT))||''' p_tax, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.AMT-rec.DUTYAMT))||''' p_cash_after_tax, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF rec.catype in ('009','011') then --Email 221E Stock dividend
            l_data_source:='select '''||rec.symbol
            ||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.encdcontent||''' p_event_type,'''
            ||rec.devidentshares||''' p_payment_ratio, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||p_camastid ||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';

        ELSIF rec.catype in ('021') then --Email 221E    For Bonus issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode||''' p_new_isin_code, '''
            ||rec.encdcontent||''' p_event_type,'''
            ||rec.exrate||''' p_payment_ratio, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||p_camastid ||''' p_event_ref_no, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
            --thunt:17/01/2020--them truong tai skq 023
            --Thoai.tran 03/12/2019
        ELSIF rec.catype='023' then  --Email 223E
            l_data_source:='select '''|| rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode ||''' p_new_isin_code, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camastid||''' p_event_ref_no, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.exprice)) ||''' p_conversion_price, '''
            ||rec.exrate||''' p_conversion_ratio, '''
            ||to_char(to_date(rec.begindate,'DD/MM/RRRR'),'DD/MM/RRRR')||'-'||to_char(to_date(rec.duedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_conversion_period, '''
            ||to_char(to_date(rec.duedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_conversion_deadline, '''
            ||to_char(to_date(rec.debitdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_conversion_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(to_date(rec.inactiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date, '''
            ||to_char(to_date(rec.receivedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_exp_payment_date, '''
            ||to_char(UTILS.SO_THANH_CHU2(rec.cashamountperbond))||''' p_cash_per_share_bond, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            || rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding from dual ';
        ELSIF rec.catype in ('017','018') then --Email 222E
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode ||''' p_new_isin_code, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.exrate||''' p_conversion_ratio, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||p_camastid||''' p_event_ref_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(to_date(rec.effecdeldate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_delisting_date , '''
             --||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF rec.catype in ('026','020') then --Email 222E
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.toisincode ||''' p_new_isin_code, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.devidentshares||''' p_conversion_ratio, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            ||to_char(to_date(rec.lasttradingd,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||p_camastid||''' p_event_ref_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            --|| rec.refcasaacct||''' p_cash_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(to_date(rec.effecdeldate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_delisting_date , '''
             --||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF rec.catype in ('005','028','022') then --Email 224E For Proxy voting (AGM, EGM)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camastid||''' p_event_ref_no, '''
            ||rec.devidentshares ||''' p_exercise_ratio, '''
            ||rec.meetingplace ||''' p_meeting_place, '''
            ||to_char(to_date(rec.instruction,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_voting_deadline, '''
            ||rec.description|| '<br/>' ||l_voting||''' p_meeting_content, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            --||to_char(UTILS.SO_THANH_CHU(floor(round(rec.trade/(rec.devidentshares),2))))||''' p_no_of_share, '''
            ||rec.meetingdatetime||''' p_meeting_date from dual ';
        ELSIF rec.catype='006' then--For Proxy voting (Postal ballot)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.devidentshares ||''' p_exercise_ratio, '''
            ||to_char(to_date(rec.submissiondl,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_submission_deadline, '''
            ||p_camastid||''' p_event_ref_no, '''
            ||to_char(to_date(rec.instruction,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_voting_deadline, '''
            ||rec.description|| '<br/>' ||l_voting||''' p_ballot_content, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.custodycd ||''' CUSTODYCD, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding,'''
            --||to_char(UTILS.SO_THANH_CHU(floor(round(rec.trade/(rec.devidentshares),2))))||' p_no_of_share, '''
            ||rec.advdesc ||''' p_meeting_place, '''
            ||rec.meetingdatetime||''' p_meeting_date from dual ';
        ELSIF rec.catype='016' then  --For Redemption (T226E)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.parvalue))||''' p_redemption_value, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.encdcontent ||''' p_event_type, '''
            ||p_camastid ||''' p_event_ref_no, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.expdate,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_maturity_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU2(NVL(TO_NUMBER(rec.interestrate)/100,'0')*rec.parvalue))||''' p_interest_coupon_bond, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.amt))||''' p_redemption_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF rec.catype='014' then  --Email 235E For Right issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.optsymbol||''' p_right_code, '''
            ||rec.optisincode||''' p_right_isin_code, '''
            ||rec.symbol2 ||''' p_sub_securities_id, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent ||''' p_event_type, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||p_camastid ||''' p_event_ref_no, '''
            ||rec.exrate ||''' p_distribution_ratio, '''
            ||rec.rightoffrate ||''' p_exercise_ratio, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.exprice)) ||''' p_conversion_price, '''
             ||to_char(to_date(rec.frdatetransfer,'DD/MM/RRRR'),'DD/MM/RRRR')||' - ' || to_char(to_date(rec.todatetransfer,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_transfer_period, '''
            ||to_char(to_date(rec.righttransdl,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_deadline_transfer, '''
            ||to_char(to_date(rec.begindate,'DD/MM/RRRR'),'DD/MM/RRRR')||' - ' || to_char(to_date(rec.duedate,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_sub_period, '''
            ||to_char(to_date(rec.insdeadline,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_deadline_sub, '''
            ||to_char(to_date(rec.debitdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_debit_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_exp_payment_date,'''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||rec.custodycd ||''' p_credit_account, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.balance+rec.pbalance))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty+rec.pqtty))||''' p_no_of_rights, '''
            --||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(rec.actiondate,'DD/MM/RRRR')||''' p_payment_date from dual';
        ELSIF rec.catype in ('003','031','032','030','019') then   --Email 218E 258E 3312
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.CASUBTYPE||''' p_event_type, '''
            ||p_camastid ||''' p_event_ref_no, '''
            ||rec.changecontent||''' p_additional_text, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_effective_date from dual ';
        ELSIF rec.catype in ('029') then   --Email 218E 258E 3312
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camastid ||''' p_event_ref_no, '''
            ||rec.changecontent||''' p_additional_text, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_effective_date from dual ';
        ELSIF rec.catype='024' then  --Email 264E,265E --TriBui 20/07/2020 Covered warrant payment event
            l_data_source:='select '''|| rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camastid||''' p_event_ref_no, '''
            ||to_char(UTILS.SO_THANH_CHU2(case when rec.typerate ='V' then rec.devidentvalue else rec.exprice*rec.devidentrate/100 end ))||''' p_cash_per_cw, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding from dual ';
        END IF;
    end if;



        IF l_data_source IS NOT NULL  THEN
            nmpks_ems.pr_sendInternalEmail(l_data_source, rec.tmpl, rec.afacctno);
            -- Ghi nhan trang thai da gui email
            UPDATE CASCHD_LIST set ISRECEIVE='Y',ACTIONTYPE='U' where camastid= rec.camastid and afacctno = rec.afacctno;
        END IF;
    END LOOP;

    plog.setEndSection(pkgctx, 'sendmailafter3312');
exception
when others then
  p_err_code := errnums.C_SYSTEM_ERROR;
  plog.error(pkgctx,'p_camastid: ' || p_camastid ||', Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
  plog.setEndSection(pkgctx, 'sendmailafter3312');
end;
/
