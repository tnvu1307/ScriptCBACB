SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendmailall (
p_camast_id varchar2,p_tltxcd varchar2
       )
IS
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_data_source varchar2(4000);
   -- l_tltxcd    varchar2(10);
    l_txcdindex number;
    l_template  varchar2(5);
    l_STATUS varchar2(1);
    l_voting varchar2(4000);
    l_catype varchar2(5);
    l_isexec varchar2(2);
    l_isci varchar(2);
    l_isse varchar2(2);
    l_taxvatamount number;
    l_vat varchar(1);
    l_iscancel varchar(1);
    l_deltd varchar(1);
BEGIN
    plog.setBeginSection(pkgctx, 'sendmailall');
    select instr('3345/3332/3327/3312/3315/3340/3341/3342/3370/3389/3391/BATC',p_tltxcd) into l_txcdindex from dual;

    select max(case when ca.catype in ('010','015','027')
        then substr('    /    /    /210E/250E/220E/    /240E/    /250E/    /    ',
        l_txcdindex,4) --dua ham nay ra 1 bien number
        --------------------------------------------------------------------------------------------
        when ca.catype in ('021','011','009')
        then substr('    /    /    /211E/251E/221E/242E/242E/    /251E/260E/    ',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------
        when ca.catype in ('026','020','017','018')
        then substr('243E/    /    /212E/252E/222E/243E/243E/    /252E/261E/    ',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------thunt:add skq 023, them mau 223E cho 3370,119E,129E-3327vs3332
        when ca.catype in ('023')
        then substr('245E/    /    /213E/253E/119E/244E/245E/223E/253E/262E/238E',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------
        when ca.catype in ('005','028','022')
        then substr('    /    /    /214E/254E/224E/    /    /    /254E/    /230E',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------
        when ca.catype in ('006')
        then substr('    /    /    /215E/255E/225E/    /    /    /255E/    /234E',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------
        when ca.catype in ('016')
        then substr('    /    /    /216E/256E/226E/241E/241E/    /256E/    /    ',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------
        when ca.catype in ('014')
        then substr('    /    /    /217E/257E/246E/246E/    /227E/257E/263E/235E',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------
        when ca.catype in ('003','029','031','032','019')
        then substr('    /    /    /218E/258E/    /    /    /    /258E/    /    ',
        l_txcdindex,4)
        --------------------------------------------------------------------------------------------
        when ca.catype in ('024')
        then substr('    /    /    /    /    /266E/    /267E/    /    /    /    ',
        l_txcdindex,4)--TriBui: 21/07/2020 them email cho Covered warrant payment event
        --------------------------------------------------------------------------------------------
        else '' end) into l_template from camast ca,caschd cas
        where ca.camastid=cas.camastid and ca.camastid like p_camast_id;
        ---------------------------
        /*thunt-13/01/2020: lay thong tin voting cho 3340*/
        select nvl(get_voting_list(p_camast_id),null) into l_voting from dual;
        ---------------------------

    for rec in(
            select cf.custid, cf.custodycd, ca.afacctno, ca.actiondate, ca.camastid, ca.codeid, ca.tmpl, cf.fullname, cf.email, sb.symbol,
            iss.fullname symname,iss.en_fullname en_symname,a6.en_cdcontent encdcontent,ca.instruction,ca.status,
            a3.cdcontent tradeplace, ca.trade,ca.qtty,cf.cifid,ca.catype,ca.rate, ca.devidentshares,ca.frdatetransfer,ca.advdesc,
            ca.canceldate,ca.description,CA.PITRATE,
            nvl(a1.cdcontent,'') FRTRADEPLACE, nvl(a2.cdcontent,'') TOTRADEPLACE,ca.exprice,ca.optsymbol,sb.isincode sbisincode,ca.caisincode,a4.isincode toisincode,
            ca.debitdate,
            replace(ca.meetingplace,'''','''''') meetingplace, --chuyen san
            case when (ca.exprice=0 and ca.catype not in ('023')) or (ca.fractionalshare=0 and ca.ciroundtype=0 and ca.catype ='023') or (ca.fractionalshare=0 and ca.catype ='023')
            then 'Fractional shares will be dropped.'
                 when ca.catype in ('023') and ca.fractionalshare <> 0 then 'Fractional shares will be paid at VND '||TO_CHAR(UTILS.SO_THANH_CHU2(ca.fractionalshare))||' per share'
                 else 'Fractional shares will be paid at VND '||TO_CHAR(UTILS.SO_THANH_CHU(ca.exprice))||' per share' end Fractionalshares,
            nvl(a4.symbol,'') symbol2, nvl(a4.fullname,'') symname2, nvl(a4.en_fullname,'') en_symname2, nvl(a4.tradeplace,'') TRADEPLACE2,
            ca.EXRATE, --chuyen doi CP thanh CP
            ca.interestrate, -- Rate for 015 (%)
            ca.devidentrate, -- Rate for 010 (%)
            ca.formofpayment,
            case when ca.formofpayment='001' then round(sb.parvalue*ca.interestrate/100,6) else round(sb.parvalue*(1+(ca.interestrate/100)),6)  end cashamountperbond,--tra lai~ hoac goc va lai~
            trunc( (ca.trade) * to_number(substr((CA.devidentshares),instr((CA.devidentshares),'/') + 1,length((CA.devidentshares))))/to_number(substr((ca.devidentshares),0,instr((ca.devidentshares),'/') - 1)),(ca.ciroundtype)) devidentshares2,
            trunc( (ca.trade) * to_number(substr((CA.EXRATE),instr((CA.EXRATE),'/') + 1,length((CA.EXRATE))))/to_number(substr((ca.EXRATE),0,instr((ca.EXRATE),'/') - 1)),(ca.ciroundtype)) totalbond2,
            trunc( (ca.trade) * to_number(substr((CA.EXRATE),instr((CA.EXRATE),'/') + 1,length((CA.EXRATE))))/to_number(substr((ca.EXRATE),0,instr((ca.EXRATE),'/') - 1))) totalbond,
            ca.intamt*(ca.pitrate/100) taxvatamount,
            ca.amountperbond,sb.expdate,ca.refcasaacct,ca.tradedate,ca.optisincode,ca.ciroundtype,ca.rqtty,
            ca.intamt,ca.lasttradingd,ca.effecdeldate,ca.amt,ca.changecontent,ca.inactiondate,ca.receivedate,
            ca.rightoffrate,ca.todatetransfer,ca.begindate,ca.pbalance,ca.pqtty,ca.meetingdatetime,ca.righttransdl,
            sb.parvalue, iss.officename, iss.en_officename, iss.address,ca.purposedesc ,ca.INQTTY,ca.cancelstatus,
            case when ca.catype ='030' then nvl(a7.en_cdcontent,'') else nvl(a6.en_cdcontent,'') end  CASUBTYPE,
            case when ca.rqtty=0 then round(ca.qtty+ca.pqtty,ca.ciroundtype) else ca.rqtty end noofshare,
            iss.en_address, iss.phone,ca.submissiondl,nvl(ca.DUTYAMT,0) DUTYAMT,ca.isexec,ca.isci,ca.isse,nvl(ca.changecontent,ca.content) additionaltext,
            iss.fax, a5.cdcontent sectype, a5.en_cdcontent en_sectype, ca.duedate, ca.reportdate, ca.devidentvalue,ca.transfertimes,
            ca.insdeadline,ca.balance,ca.typerate,ca.deltd --Giai the to chuc phat hanh
        from
            (--chi gui cho moi gioi
                select af.custid,sch.afacctno,ca.actiondate,ca.camastid,sch.qtty+decode(ca.catype,'027',sch.aqtty,0) qtty,sch.codeid,
                        case
                            when p_tltxcd ='3340' and ca.catype ='023' and sch.qtty > 0 then '130E' --Da dang ky 3327
                            when p_tltxcd ='3340' and ca.catype ='023' and sch.qtty = 0 then '119E' --Chua dang ky 3327
                            when p_tltxcd ='3342' and ca.catype ='023' and sch.qtty > 0 then '244E' --Da dang ky 3327
                            when p_tltxcd ='3342' and ca.catype ='023' and sch.qtty = 0 then '245E' --Chua dang ky 3327
                            else l_template
                        end tmpl, --TriBui 02/07/2020 GD 3340 gui mail cho nhung tk da dang ky or chua dang ky buoc 3327
                         ca.status,ca.meetingdatetime,ca.inactiondate,ca.receivedate,
                         case when (ca.catype = '027' ) then sch.aqtty else sch.qtty end rqtty,
                       ca.FRTRADEPLACE, ca.TOTRADEPLACE, --chuyen san
                       ca.TOCODEID, ca.EXRATE, --chuyen doi CP thanh CP
                       ca.rightoffrate,ca.todatetransfer,ca.begindate,ca.righttransdl,
                       ca.interestrate, -- Rate for 015 (%)
                       ca.devidentrate, -- Rate for 010 (%)
                       ca.formofpayment,
                       (case when ca.catype in ('023') and sch.balance <>0 then sch.amt1/sch.balance
                       when ca.catype not in ('023') and sch.balance <>0 then sch.intamt/sch.balance
                       else sch.intamt end) amountperbond,
                       sch.intamt,sch.amt1 amt,ca.tradedate,
                       ca.submissiondl,dd.refcasaacct,
                       --thoai.tran 21/08/2020 sua doi vs kh la To chuc => Withheld tax=0
                       (case when l_template='240E' and cf.custtype='B' and ca.catype = '010' then 0
                        when cf.vat='Y'
                            then (case when /*ca.pitratemethod='IS' or*/ ca.pitratemethod='NO' then 0 else
                                    (case when ca.catype in ('016','023','033')  then round(ca.pitrate*sch.intamt/100)
                                       when ca.catype = '024' then
                                       sch.balance*ca.exprice*ca.pitrate/100/(to_number(substr(sb.exerciseratio,0,instr(sb.exerciseratio,'/') - 1))/to_number(substr(sb.exerciseratio,instr(sb.exerciseratio,'/')+1,length(sb.exerciseratio)))) --t9/2019 cw_phaseii
                                       when ca.catype = '010'
                                            then round(ca.pitrate*sch.amt1/100)
                                       else round(ca.pitrate*sch.amt1/100)
                                 end)
                              end)
                            else 0 end
                        ) DUTYAMT,ca.optisincode,ca.purposedesc,CA.PITRATE,sch.inqtty,ca.fractionalshare,ca.ciroundtype,ca.cancelstatus,
                       nvl(ca.lasttradingd,ca.tradedate) lasttradingd,ca.effecdeldate,sch.trade,sch.pbalance,sch.pqtty,ca.changecontent,sch.isexec,sch.isci,sch.isse,
                       ca.isincode caisincode, ca.duedate, ca.reportdate, ca.devidentvalue, sch.afacctno||sch.codeid seacctno,--giai the to chuc PH
                       ca.rate, ca.catype,ca.devidentshares,ca.frdatetransfer, ca.advdesc, ca.canceldate,ca.description,ca.exprice,ca.content,
                       ca.optsymbol,ca.transfertimes, ca.insdeadline, ca.debitdate, ca.meetingplace,sch.balance, ca.instruction,ca.casubtype,ca.typerate, ca.deltd
                from camast ca, afmast af,ddmast dd,SBSECURITIES SB, cfmast cf,
                (
                    SELECT CHS.*, NVL(CHD.AMT, CHS.AMT) AMT1
                    FROM CASCHD CHS,
                    (
                        SELECT *
                        FROM CASCHDDTL
                        WHERE AUTOID IN (
                            SELECT MAX(AUTOID) FROM CASCHDDTL WHERE DELTD = 'N' AND STATUS = 'C' GROUP BY AUTOID_CASCHD
                        )
                    ) CHD
                    WHERE CHS.AUTOID = CHD.AUTOID_CASCHD(+)
                ) SCH
                where ca.camastid=sch.camastid
                    AND CA.CODEID = SB.CODEID
                    and sch.afacctno=af.acctno
                    and af.custid=dd.custid
                    AND AF.CUSTID = CF.CUSTID
                    and dd.ccycd='VND'
                    and dd.isdefault='Y'
                    --and ((sch.isregis = 'C' AND ca.catype <> '023')or (ca.catype = '023') ) --TriBui 02/07/2020 GD 3340 gui mail cho nhung tk da dang ky or chua dang ky buoc 3327
                    --Thoai.tran: Check lai giup viec dang ky skq "C" la da dang ky
                    and (sb.tradeplace <> '003' or (sb.tradeplace = '003' AND SB.depository='001'))--CK unlisted    SHBVNEX-1887 Thoai.tran 20210312
                    and dd.status<>'C'
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
                select cdval, cdcontent,en_cdcontent from allcode where cdname='CATYPE' and cduser='Y'
            ) a6,
            (
                select cdval, cdcontent,en_cdcontent from allcode where cdname='CASUBTYPE'
            ) a7,
            templates t,
            (
                select se.acctno, sum(trade+mortage+blocked+emkqtty) trade
                from semast se, sbsecurities sb where se.codeid=sb.codeid and sb.sectype <> '004'
                group by se.acctno
            ) se
        where ca.custid=cf.custid
          and ca.tmpl=t.code and t.isactive='Y'
          and sb.codeid=ca.codeid
          and sb.issuerid=iss.issuerid
          and nvl(ca.FRTRADEPLACE,' ')=a1.cdval(+)
          and nvl(ca.TOTRADEPLACE,' ')=a2.cdval(+)
          and sb.tradeplace=a3.cdval
          and nvl(ca.TOCODEID,' ')=a4.codeid(+)
          and sb.sectype=a5.cdval
          and ca.catype =a6.cdval(+)
          and ca.seacctno=se.acctno
          and ca.CASUBTYPE = a7.cdval(+)
    )
     loop
/*==========================================================*/

         l_STATUS:=rec.status;
         l_catype:=rec.catype;
         l_isexec:=rec.isexec;
         l_isci:=rec.isci;
         l_isse:=rec.isse;
         l_taxvatamount:= ROUND(rec.taxvatamount);
         l_iscancel:=rec.cancelstatus;
         l_deltd:=rec.deltd;

         IF l_catype in ('016','020','017','011','021') and (l_isci='N' or l_isse='N') THEN
            if l_iscancel = 'Y' then
                if p_tltxcd in ('3342','3341','3345') and (INSTR('IHG',l_STATUS) > 0) then
                    l_catype:=-1;
                    
                end if;
            else--khong thuc hien 3345, chieu nguoc lai di phan bo tien truoc
                if p_tltxcd in ('3342','3341','3345') and (INSTR('IHG',l_STATUS) > 0) then
                    l_catype:=-1;
                    
                end if;
            end if;
         end if;
         if p_tltxcd='3391' then
            if not INSTR('HJ',l_STATUS) > 0 then
                l_catype:=-1;
                
            end if;
         end if;
         select vat into l_vat from cfmast where custid=rec.custid;
         if l_vat = 'N' then
            l_taxvatamount:=0;
            
         end if;

         --SHBVNEX-1240
         IF l_catype in ('023') then
            -- co lam 3327 nhung lam 1 phan thi phai lam tiep 3342 moi send mail
            if p_tltxcd = '3341' and rec.qtty > 0 and rec.pqtty > 0 and l_STATUS<>'J' then
                l_catype:=-1;
            end if;
            -- khong lam 3327 nhung lam 3341 thi k gui mail o 3341 ma gui o 3342
            if p_tltxcd = '3341' and rec.qtty = 0 then
                l_catype:=-1;
            end if;
            -- khong gui nhung tai khoan da gui luc lam 3341
            if p_tltxcd = '3342' and rec.pqtty = 0 then
                l_catype:=-1;
            end if;
            -- Lam xong 3327 neu so dk chuyen doi < holding => phai lam du 3 buoc 3345, 3346, 3342
            if p_tltxcd = '3342' and rec.trade-rec.balance >0 and rec.balance >0 and l_STATUS<>'J' then
                l_catype:=-1;
            end if;
         end if;

/*==========================================================*/
        l_data_source := null;
        if l_deltd = 'N' then   --thangpv SHBVNEX-2764
            IF l_catype in ('010','015','027') then--For Cash dividend, Bond (Interest) coupon, Fund liquidation
         --Thoai.tran 03/12/2019
            l_data_source:='select '''||(rec.symbol)||''' p_securitiesid, '''
            ||(rec.sbisincode)||''' p_isincode, '''
            ||rec.encdcontent||''' p_event_type, TO_CHAR(UTILS.SO_THANH_CHU2((case when '''||rec.catype||''' in ('||'''010'','||'''027'''||') and '
            ||nvl(rec.devidentrate,0)||' <> 0 then  '||to_char(to_number(nvl(rec.devidentrate,'0'))*rec.parvalue/100)
            ||' when '''||rec.catype||''' ='||'''015'''||' and '||nvl(rec.interestrate,0)||' <> 0 then '||to_char(to_number(nvl(rec.interestrate,'0'))*rec.parvalue/100)
            ||'else '||nvl(rec.devidentvalue,0)||' end )))'||' p_cash_per_share_bond, '''
            ||(rec.fullname) ||''' p_portfolio_name, '''
            ||(p_camast_id) ||''' p_event_ref_no, '
            ||'TO_CHAR(UTILS.SO_THANH_CHU((case when '''||rec.catype||''' in ('||'''010'','||'''027'''||') and '
            ||nvl(rec.devidentrate,0)||' <> 0 then  '||to_char(to_number(nvl(rec.devidentrate,'0'))*rec.parvalue/100)
            ||' when '''||rec.catype||''' ='||'''015'''||' and '||nvl(rec.interestrate,0)||' <> 0 then '||to_char(to_number(nvl(rec.interestrate,'0'))*rec.parvalue/100)
            ||'else '||nvl(rec.devidentvalue,0)||' end ) * '||NVL(rec.trade,0)
            ||')) p_cashamountpaid, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(NVL(rec.trade,0)))||''' p_current_holding, '''
            ||rec.custodycd||''' p_credit_account,  '''
            ||rec.refcasaacct||''' p_cash_account, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||(rec.cifid)||''' p_portfolio_no, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.AMT))||''' p_cash_before_tax, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.DUTYAMT))||''' p_tax, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.AMT-rec.DUTYAMT))||''' p_cash_after_tax, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
         ELSIF l_catype in ('009','011') then --Email 221E Stock dividend
            l_data_source:='select '''||rec.symbol
            ||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.encdcontent||''' p_event_type,'''
            ||rec.devidentshares||''' p_payment_ratio, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||p_camast_id ||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.refcasaacct||''' p_cash_account, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
         ELSIF l_catype in ('021') then --Email 221E    For Bonus issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode||''' p_new_isin_code, '''
            ||rec.encdcontent||''' p_event_type,'''
            ||rec.exrate||''' p_payment_ratio, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||p_camast_id ||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            ||rec.refcasaacct||''' p_cash_account, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU((rec.totalbond2-rec.totalbond)*rec.exprice))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
            --Thoai.tran 03/12/2019
          ELSIF l_catype='023' then  --Email 223E
            l_data_source:='select '''|| rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode ||''' p_new_isin_code, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camast_id||''' p_event_ref_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.exprice)) ||''' p_conversion_price, '''
            ||rec.exrate||''' p_conversion_ratio, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(round(rec.interestrate*rec.parvalue/100)))||''' p_ratio, '''
            ||to_char(to_date(rec.begindate,'DD/MM/RRRR'),'DD/MM/RRRR')||'-'||to_char(to_date(rec.duedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_conversion_period, '''
            ||to_char(to_date(rec.duedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_conversion_deadline, '''
            ||to_char(to_date(rec.debitdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_conversion_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(to_date(rec.inactiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date, '''
            ||to_char(to_date(rec.receivedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_exp_payment_date, '''
            ||to_char(UTILS.SO_THANH_CHU2(rec.cashamountperbond))||''' p_cash_per_share_bond, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.noofshare))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share_receive, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amt))||''' p_total_amount_before, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.DUTYAMT))||''' p_total_tax, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amt-rec.DUTYAMT))||''' p_total_amount, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.balance))||''' p_unregistered_bond_quantity, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade - rec.balance))||''' p_registered_bond_quantity, '''
            ||rec.custodycd ||''' p_credit_account, '''
            ||rec.refcasaacct||''' p_cash_account, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.AMT))||''' p_cash_before_tax, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.DUTYAMT))||''' p_tax, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding from dual ';
         ELSIF l_catype in ('017','018') then --Email 222E
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode ||''' p_new_isin_code, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.exrate||''' p_conversion_ratio, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||p_camast_id||''' p_event_ref_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            ||rec.refcasaacct||''' p_cash_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(to_date(rec.effecdeldate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_delisting_date , '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF l_catype in ('026','020') then --Email 222E
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.toisincode ||''' p_new_isin_code, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.devidentshares||''' p_conversion_ratio, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.parvalue)) ||''' p_conversion_price, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||p_camast_id||''' p_event_ref_no, '''
            ||rec.custodycd ||''' p_credit_account, '''
            ||rec.refcasaacct||''' p_cash_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.qtty))||''' p_no_of_share, '''
            ||to_char(to_date(rec.effecdeldate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_delisting_date , '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
         ELSIF l_catype in ('005','028','022') then --Email 224E For Proxy voting (AGM, EGM)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camast_id||''' p_event_ref_no, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.devidentshares ||''' p_exercise_ratio, '''
            ||rec.meetingplace ||''' p_meeting_place, '''
            ||to_char(to_date(rec.instruction,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_voting_deadline, '''
            ||rec.description|| '<br/>' ||l_voting||''' p_meeting_content, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.devidentshares2))||''' p_current_holding, '''
            ||rec.meetingdatetime||''' p_meeting_date from dual ';
         ELSIF l_catype='006' then--For Proxy voting (Postal ballot)-225E
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||rec.devidentshares ||''' p_exercise_ratio, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||to_char(to_date(rec.submissiondl,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_submission_deadline, '''
            ||p_camast_id||''' p_event_ref_no, '''
            ||to_char(to_date(rec.instruction,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_voting_deadline, '''
            ||rec.description|| '<br/>' ||l_voting||''' p_ballot_content, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.devidentshares2))||''' p_no_of_share, '''
            ||rec.advdesc ||''' p_meeting_place, '''
            ||rec.meetingdatetime||''' p_meeting_date from dual ';
            --thunt:09/01/2020- them truong
         ELSIF l_catype='016' then  --For Redemption (T226E)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.parvalue))||''' p_redemption_value, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.encdcontent ||''' p_event_type, '''
            ||p_camast_id ||''' p_event_ref_no, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.expdate,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_maturity_date, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU2(NVL(TO_NUMBER(rec.interestrate)/100,'0')*rec.parvalue))||''' p_interest_coupon_bond, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.amt - rec.intamt))||''' p_principal_amount, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.intamt))||''' p_interest_amount, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(l_taxvatamount))||''' p_tax_amount, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(rec.intamt-l_taxvatamount))||''' p_interest_afteramount, '''
            ||rec.refcasaacct ||''' p_credit_account, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amt-l_taxvatamount))||''' p_redemption_amount, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.amt-l_taxvatamount))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual ';
        ELSIF l_catype='014' then  --Email 235E For Right issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.optsymbol||''' p_right_code, '''
            ||rec.optisincode||''' p_right_isin_code, '''
            ||rec.symbol2 ||''' p_sub_securities_id, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent ||''' p_event_type, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||p_camast_id ||''' p_event_ref_no, '''
            ||rec.exrate ||''' p_distribution_ratio, '''
            ||rec.rightoffrate ||''' p_exercise_ratio, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.exprice)) ||''' p_conversion_price, '''
            --Thoai.tran 2021-03-19 --SHBVNEX-2030
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
            ||to_char(UTILS.SO_THANH_CHU(rec.balance+rec.pbalance))||''' p_no_of_rights, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.noofshare))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual';
        ELSIF l_catype in ('003','031','032','019') then   --Email 218E 258E 3312
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.CASUBTYPE||''' p_event_type, '''
            ||p_camast_id ||''' p_event_ref_no, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.additionaltext||''' p_additional_text, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_effective_date from dual ';
         ELSIF l_catype in ('029') then   --Email 218E 258E 3312
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camast_id ||''' p_event_ref_no, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||rec.changecontent||''' p_additional_text, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_effective_date from dual ';
         ELSIF l_catype in ('024') then   --TriBui: 21/07/2020 them email cho Covered warrant payment event
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||p_camast_id ||''' p_event_ref_no, '''
            ||to_char(UTILS.SO_THANH_CHU2(case when rec.typerate ='V' then rec.devidentvalue else rec.exprice*rec.devidentrate/100 end ))||''' p_cash_per_cw, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date, '''
            ||rec.cifid ||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||rec.refcasaacct||''' p_cash_account, '''
            ||TO_CHAR(UTILS.SO_THANH_CHU(nvl(rec.amt,0)))||''' p_cashamountpaid, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.AMT))||''' p_cash_before_tax, '''
            ||to_char(UTILS.SO_THANH_CHU(round(rec.balance*rec.EXPRICE*rec.pitrate/100/(to_number(SUBSTR(rec.exrate ,0,INSTR(rec.exrate ,'/') - 1))/ to_number(SUBSTR(rec.exrate ,INSTR(rec.exrate ,'/')+1,LENGTH(rec.exrate )))))))||''' p_tax, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.AMT-round(rec.balance*rec.EXPRICE*rec.pitrate/100/(to_number(SUBSTR(rec.exrate ,0,INSTR(rec.exrate ,'/') - 1))/ to_number(SUBSTR(rec.exrate ,INSTR(rec.exrate ,'/')+1,LENGTH(rec.exrate )))))))||''' p_cash_after_tax, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_effective_date from dual ';
         END IF;
        end if;

        if l_data_source is not null  then
            IF REC.TMPL IN ('240E','241E','242E','243E','244E','245E','246E','267E') AND (REC.AMT > 0 OR REC.QTTY > 0) THEN
                NMPKS_EMS.PR_SENDINTERNALEMAIL(L_DATA_SOURCE, REC.TMPL, REC.AFACCTNO);
            ELSIF REC.TMPL NOT IN ('240E','241E','242E','243E','244E','245E','246E','267E') THEN
                NMPKS_EMS.PR_SENDINTERNALEMAIL(L_DATA_SOURCE, REC.TMPL, REC.AFACCTNO);
            END IF;
            
        end if;

    end loop;
    

exception
when others then
  plog.error(pkgctx,'p_camastid: ' || p_camast_id ||', Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
  plog.setEndSection(pkgctx, 'sendmailall');
end;
/
