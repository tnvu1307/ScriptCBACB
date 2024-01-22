SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE sendmailreminder (p_date date)
IS
    pkgctx plog.log_ctx;
    logrow tlogdebug%rowtype;
    l_data_source varchar2(4000);
    l_template  varchar2(5);
    l_voting varchar2(4000);
    l_catype varchar2(5);
    v_prevdate2 date;
    v_prevdate5 date;
    l_camast_id varchar(50);
BEGIN
    plog.setBeginSection(pkgctx, 'sendmailreminder');

    v_prevdate5 := getnextdate2(p_date,5);
    v_prevdate2 := getnextdate2(p_date,2);

    for rec in(
        SELECT CA.CAMASTID, CA.CUSTODYCD, CA.FULLNAME, CA.EMAIL, CA.CIFID,
            CA.SBSYMBOL SYMBOL, CA.SBISINCODE, CA.SBPARVALUE PARVALUE,
            CA.SB2ISINCODE TOISINCODE, CA.SB2SYMBOL SYMBOL2,
            CA.AFACCTNO, CA.ACTIONDATE, CA.INSTRUCTION, CA.RIGHTOFFRATE, CA.TODATETRANSFER, CA.BEGINDATE, CA.PBALANCE, CA.MEETINGDATETIME, CA.RIGHTTRANSDL,
            CA.TRADE, CA.QTTY ,CA.CATYPE, CA.DEVIDENTSHARES, CA.FRDATETRANSFER, CA.ADVDESC, CA.INTAMT, CA.AMT, CA.INACTIONDATE, CA.RECEIVEDATE,
            CA.DESCRIPTION, CA.EXPRICE, CA.OPTSYMBOL, CA.DEBITDATE,
            REPLACE(CA.MEETINGPLACE,'''','''''') MEETINGPLACE,
            CA.SUBMISSIONDL, NVL(CA.DUTYAMT,0) DUTYAMT, CA.DUEDATE, CA.REPORTDATE,
            CA.EXRATE, CA.INTERESTRATE, CA.REFCASAACCT, CA.TRADEDATE, CA.OPTISINCODE, CA.INSDEADLINE, CA.BALANCE,
            TRUNC((CA.TRADE) * TO_NUMBER(SUBSTR((CA.DEVIDENTSHARES),INSTR((CA.DEVIDENTSHARES),'/') + 1,LENGTH((CA.DEVIDENTSHARES))))/TO_NUMBER(SUBSTR((CA.DEVIDENTSHARES),0,INSTR((CA.DEVIDENTSHARES),'/') - 1)),(CA.CIROUNDTYPE)) DEVIDENTSHARES2,
            A6.EN_CDCONTENT ENCDCONTENT,
            (CASE WHEN CA.FORMOFPAYMENT = '001' THEN ROUND(CA.SBPARVALUE*CA.INTERESTRATE/100,6) ELSE ROUND(CA.SBPARVALUE*(1+(CA.INTERESTRATE/100)),6) END) CASHAMOUNTPERBOND,
            (CASE WHEN CA.RQTTY=0 THEN ROUND(CA.QTTY+CA.PQTTY,CA.CIROUNDTYPE) ELSE CA.RQTTY END) NOOFSHARE,
            (CASE WHEN (CA.EXPRICE=0 AND CA.CATYPE NOT IN ('023')) OR (CA.FRACTIONALSHARE=0 AND CA.CIROUNDTYPE=0 AND CA.CATYPE ='023') OR (CA.FRACTIONALSHARE=0 AND CA.CATYPE ='023')
                    THEN 'FRACTIONAL SHARES WILL BE DROPPED.'
                 WHEN CA.CATYPE IN ('023') AND CA.FRACTIONALSHARE <> 0
                    THEN 'FRACTIONAL SHARES WILL BE PAID AT VND ' || TO_CHAR(UTILS.SO_THANH_CHU2(CA.FRACTIONALSHARE))|| ' PER SHARE'
                 ELSE 'FRACTIONAL SHARES WILL BE PAID AT VND ' || TO_CHAR(UTILS.SO_THANH_CHU(CA.EXPRICE)) || ' PER SHARE' END
             ) FRACTIONALSHARES, ca.deltd
        FROM (
                SELECT CA.CAMASTID, SCH.AFACCTNO, CA.ACTIONDATE, SCH.QTTY+DECODE(CA.CATYPE,'027',SCH.AQTTY,0) QTTY,
                       CA.MEETINGDATETIME,CA.INACTIONDATE,CA.RECEIVEDATE,
                      (CASE WHEN (CA.CATYPE = '027' ) THEN SCH.AQTTY ELSE SCH.QTTY END) RQTTY,
                       CA.EXRATE, CA.TOCODEID, CA.CODEID,
                       CA.RIGHTOFFRATE,CA.TODATETRANSFER,CA.BEGINDATE,CA.RIGHTTRANSDL,
                       CA.INTERESTRATE,
                       CA.FORMOFPAYMENT,
                       SCH.INTAMT,SCH.AMT1 AMT,CA.TRADEDATE,
                       CA.SUBMISSIONDL,DD.REFCASAACCT,
                       (CASE WHEN CF.VAT='Y'THEN (
                                    CASE WHEN CA.PITRATEMETHOD='NO' THEN 0 ELSE (
                                        CASE WHEN CA.CATYPE IN ('016','023','033') THEN ROUND(CA.PITRATE*SCH.INTAMT/100)
                                             WHEN CA.CATYPE = '024' THEN
                                                SCH.BALANCE*CA.EXPRICE*CA.PITRATE/100/(TO_NUMBER(SUBSTR(SB.EXERCISERATIO,0,INSTR(SB.EXERCISERATIO,'/') - 1))/TO_NUMBER(SUBSTR(SB.EXERCISERATIO,INSTR(SB.EXERCISERATIO,'/')+1,LENGTH(SB.EXERCISERATIO))))
                                             WHEN CA.CATYPE = '010' THEN ROUND(CA.PITRATE*SCH.AMT1/100)
                                             ELSE ROUND(CA.PITRATE*SCH.AMT1/100)
                                        END)
                                    END)
                             ELSE 0 END
                        ) DUTYAMT,CA.OPTISINCODE,CA.FRACTIONALSHARE,CA.CIROUNDTYPE,
                       SCH.TRADE,SCH.PBALANCE,SCH.PQTTY,
                       CA.DUEDATE, CA.REPORTDATE,
                       CA.CATYPE,CA.DEVIDENTSHARES,CA.FRDATETRANSFER, CA.ADVDESC, CA.DESCRIPTION,CA.EXPRICE,
                       CA.OPTSYMBOL, CA.INSDEADLINE, CA.DEBITDATE, CA.MEETINGPLACE,SCH.BALANCE, CA.INSTRUCTION,
                       CF.CUSTODYCD, CF.FULLNAME, CF.EMAIL, CF.CIFID,
                       SB.SYMBOL SBSYMBOL, SB.ISINCODE SBISINCODE, SB.PARVALUE SBPARVALUE,
                       NVL(SB2.SYMBOL,'') SB2SYMBOL, NVL(SB2.ISINCODE, '') SB2ISINCODE, ca.deltd

                FROM CAMAST CA, AFMAST AF, SBSECURITIES SB, SBSECURITIES SB2, CFMAST CF,
                (
                    SELECT CAS.*, NVL(CHD.AMT, CAS.AMT) AMT1
                    FROM CASCHD CAS, CAMAST CA,
                    (
                        SELECT *
                        FROM CASCHDDTL
                        WHERE AUTOID IN (
                            SELECT MAX(AUTOID) FROM CASCHDDTL WHERE DELTD = 'N' AND STATUS = 'C' GROUP BY AUTOID_CASCHD
                        )
                    ) CHD,
                    (
                        SELECT VT.CAMASTID, AF.ACCTNO AFACCTNO
                        FROM CFMAST CF,AFMAST AF, VOTINGDETAIL VT
                        WHERE CF.CUSTID = AF.CUSTID
                        AND AF.ACCTNO = VT.AFACCTNO
                    )VT
                    WHERE CA.CAMASTID = CAS.CAMASTID
                    AND CAS.AUTOID = CHD.AUTOID_CASCHD(+)
                    AND CAS.CAMASTID = VT.CAMASTID(+)
                    AND CAS.AFACCTNO = VT.AFACCTNO(+)
                    AND CA.CATYPE IN ('005','028','022','006','014','023')
                    AND (
                        CASE WHEN CA.CATYPE IN ('005','028','006') AND (V_PREVDATE5 = TO_DATE(CA.INSTRUCTION,'DD/MM/RRRR') OR V_PREVDATE2 = TO_DATE(CA.INSTRUCTION,'DD/MM/RRRR'))
                                  AND NVL(VT.CAMASTID, 'X') = 'X'
                                  AND CA.STATUS IN ('S')
                               THEN 1
                             WHEN CA.CATYPE IN ('023','014') AND (V_PREVDATE5=CA.INSDEADLINE OR V_PREVDATE2=CA.INSDEADLINE) AND CAS.ISREGIS NOT IN ('C') THEN 1
                        ELSE 0 END
                    ) = 1
                ) SCH,
                (
                    SELECT * FROM DDMAST WHERE CCYCD = 'VND' AND ISDEFAULT = 'Y' AND STATUS <> 'C'
                ) DD
                WHERE CA.CAMASTID = SCH.CAMASTID
                AND CA.CODEID = SB.CODEID
                AND SCH.AFACCTNO = AF.ACCTNO
                AND AF.CUSTID = DD.CUSTID
                AND AF.CUSTID = CF.CUSTID
                AND (SB.TRADEPLACE <> '003' OR (SB.TRADEPLACE = '003' AND SB.DEPOSITORY='001'))--CK UNLISTED    SHBVNEX-1887 THOAI.TRAN 20210312
                AND SCH.DELTD <> 'Y'
                AND NVL(CA.TOCODEID,' ') = SB2.CODEID(+)
            )CA,
            (
                SELECT CDVAL, CDCONTENT,EN_CDCONTENT FROM ALLCODE WHERE CDNAME='CATYPE' AND CDUSER='Y'
            ) A6
            WHERE CA.CATYPE =A6.CDVAL(+)
    )
     loop
/*==========================================================*/

    l_catype := rec.catype;
    l_camast_id := rec.camastid;
    l_template := '';
    l_voting := '';
    l_data_source := null;

    select (case when l_catype in ('023') then '238E'
                 when l_catype in ('014') then '235E'
                 when l_catype in ('006') then '234E'
                 when l_catype in ('005','028','022') then '230E'
                 else ''
            end) into l_template
    from dual;
    IF l_catype IN ('005','006','028') THEN
        select nvl(get_voting_list(l_camast_id),null) into l_voting from dual;
    END IF;

/*==========================================================*/

if rec.deltd = 'N' then     --thangpv SHBVNEX-2764
    IF l_catype='023' then  --Email 223E
            l_data_source:='select '''|| rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.symbol2||''' p_new_securities_id, '''
            ||rec.toisincode ||''' p_new_isin_code, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||l_camast_id||''' p_event_ref_no, '''
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
    ELSIF l_catype in ('005','028','022') then --Email 224E For Proxy voting (AGM, EGM)
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||to_char(to_date(rec.reportdate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent||''' p_event_type, '''
            ||l_camast_id||''' p_event_ref_no, '''
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
            ||l_camast_id||''' p_event_ref_no, '''
            ||to_char(to_date(rec.instruction,'DD/MM/RRRR'),'DD/MM/RRRR') ||''' p_voting_deadline, '''
            ||rec.description|| '<br/>' ||l_voting||''' p_ballot_content, '''
            ||rec.cifid||''' p_portfolio_no, '''
            ||rec.fullname ||''' p_portfolio_name, '''
            ||to_char(to_date(rec.tradedate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_trading_date, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.trade))||''' p_current_holding, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.devidentshares2))||''' p_no_of_share, '''
            ||rec.advdesc ||''' p_meeting_place, '''
            ||rec.meetingdatetime||''' p_meeting_date from dual ';
    ELSIF l_catype='014' then  --Email 235E For Right issue
            l_data_source:='select '''||rec.symbol||''' p_securitiesid, '''
            ||rec.sbisincode||''' p_isincode, '''
            ||rec.optsymbol||''' p_right_code, '''
            ||rec.optisincode||''' p_right_isin_code, '''
            ||rec.symbol2 ||''' p_sub_securities_id, '''
            ||to_char(rec.reportdate,'DD/MM/RRRR')||''' p_record_date, '''
            ||rec.encdcontent ||''' p_event_type, '''
            ||rec.Fractionalshares || ''' p_fractionalshares, '''
            ||l_camast_id ||''' p_event_ref_no, '''
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
            ||to_char(UTILS.SO_THANH_CHU(rec.balance+rec.pbalance))||''' p_no_of_rights, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.noofshare))||''' p_no_of_share, '''
            ||to_char(UTILS.SO_THANH_CHU(rec.intamt))||''' p_total_amount, '''
            ||to_char(to_date(rec.actiondate,'DD/MM/RRRR'),'DD/MM/RRRR')||''' p_payment_date from dual';
    END IF;
end if;



    if l_data_source is not null  then
        nmpks_ems.pr_sendInternalEmail(l_data_source, l_template, rec.afacctno);
    end if;

    end loop;
    plog.setEndSection(pkgctx, 'sendmailreminder');

exception
when others then
  plog.error(pkgctx,'Err: ' || sqlerrm || ' Trace: ' || dbms_utility.format_error_backtrace );
  plog.setEndSection(pkgctx, 'sendmailreninder');
end;
/
