SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca600101(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2, /*Tu ngay */
   P_GCBCODE              IN       VARCHAR2,
   P_AMCCODE              IN       VARCHAR2,
   P_CIFID                IN       VARCHAR2, /*Ma KH tai ngan hang */
   PV_TXNUM               IN       VARCHAR2 /*SO CHUNG TU*/
   )
IS
    -- Report on the day become/is no longer major shareholder, investors holding 5% or more of shares
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- du.phan    23-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
--
    v_InDate            date;
    v_CurrDate          date;
    v_issuedate         date;
    v_expdate           date;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_IDCODE           varchar2(200);
    v_OFFICE           varchar2(200);
    v_REFNAME          varchar2(200);
    v_shvstc           varchar2(200);
    v_shvcustodycd     varchar2(200);
    v_shvcifid         varchar2(200);
--
    v_tltitle          varchar2(200);
    v_tlfullname       varchar2(200);
    V_CIFID            varchar2(200);
    V_GCBCODE          varchar2(20);
    V_AMCCODE          varchar2(20);
    v_TXNUM             VARCHAR2(10);
BEGIN
     V_STROPTION := OPT;
     v_CurrDate   := getcurrdate;
     if v_stroption = 'A' then
        v_strbrid := '%';
     elsif v_stroption = 'B' then
        v_strbrid := substr(brid,1,2) || '__' ;
     else
        v_strbrid:=brid;
     end if;
     IF P_GCBCODE = 'ALL' THEN
        V_GCBCODE := '%';
     ELSE V_GCBCODE := P_GCBCODE;
     END IF;

     IF P_AMCCODE = 'ALL' THEN
        V_AMCCODE := '%';
     ELSE V_AMCCODE := P_AMCCODE;
     END IF;
    v_InDate  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_TXNUM         :=     PV_TXNUM;
if P_CIFID ='ALL' then
        V_CIFID:='%';
    else
        V_CIFID:=P_CIFID;
    end if;
--
OPEN PV_REFCURSOR FOR
        Select  rownum NO,
                v_TXNUM TXNUM, --NAM.LY
                ca6001.ClientName,ca6001.ClientAccount,
                To_char(getcurrdate,'dd/MM/yyyy') ReportingDate,
                case when cat.catype in ('009', '010', '011','015', '016', '017', '018', '020', '021', '024','027') then 'Mandatory events' else 'Voluntary events' end EventType,
                ca6001.SecuritiesID,
                ca6001.ISINCode,
                case when cat.catype in ('014') then ca6001.RightsCode else '' end RightsCode,
                case when cat.catype in ('014') then ca6001.RightISINCode else '' end RightISINCode,
                to_char(ca6001.RecordDate,'dd/MM/yyyy')RecordDate,
                cat.catypeName_en EventType, --NAM.LY 12-12-2019
                cat.catypeName_en EventType_en, --NAM.LY 12-12-2019
                ca6001.camastid EventRefNo,
                (case when cat.catype in ('006') then to_char(ca6001.submissiondl,'DD/MM/RRRR')
                      when cat.catype in ('010','011','014','015','016','017','020','021','023','024','027','005','028') then to_char(ca6001.actiondate,'DD/MM/RRRR')
                      when cat.catype in ('017') then to_char(ca6001.convertdate,'DD/MM/RRRR')
                      else to_char(ca6001.insdeadline,'DD/MM/RRRR') end) PaymentDate,
                (case when cat.catype ='023' then '' else to_char(ca6001.debitdate,'dd/MM/yyyy') END) DebitDate,
                UTILS.SO_THANH_CHU2(NVL(ca6001.s_trade,0)) EntitledHolding,
                UTILS.SO_THANH_CHU2(NVL(ca6001.s_aamt,0)) CashAmount,
                (case when cat.catype in ('010','027','024','016','015','028','006','005','014') then '0'
                      when cat.catype in ('011','020','017','021') then UTILS.SO_THANH_CHU2(NVL(ca6001.s_qtty,0))
                      when cat.catype in ('023') then UTILS.SO_THANH_CHU2(NVL(ca6001.s_pqtty,0))
                      else UTILS.SO_THANH_CHU2(NVL(ca6001.s_pqtty,0)) end) NoOfResultantShares,
                UTILS.SO_THANH_CHU2(NVL(ca6001.s_qtty,0)) PurchaseQuantity
        from  (
            SELECT  sec.seccode SecuritiesID,
                    sec.isincode ISINCode ,
                    sec.secname,
                    ca.optsymbol RightsCode,
                    CA.optISINCODE RightISINCode,
                    ca.reportdate RecordDate,
                    ca.catype,
                    gcb.shortname,
                    ca.insdeadline,
                    ca.actiondate,
                    ca.convertdate,
                    ca.submissiondl,
                    ca.debitdate,
                    ca.camastid,
                    sec.parvalue, ca.exprice,
                    cf.Fullname ClientName,
                    cf.cifid ClientAccount,
                    sum( cas.trade) s_trade,
        ----    SUBSTR (cf.custodycd, 4, 1) custodycd,
            sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then cas.qtty else 0 end) c_qtty,
            sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then cas.qtty else 0 end) f_qtty,
            sum(case when SUBSTR (cf.custodycd,4,1) in ('P','A') then cas.qtty else 0 end) p_qtty,
            sum(case when ca.catype in ('014') then (case when cas.status in ('V','M') then cas.pqtty + cas.qtty else cas.qtty end)
                     when ca.catype in ('023') then 0
                     else cas.qtty end) s_qtty,
            -- caschd.pbalance+caschd.roretailbal
            sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then cas.pbalance+cas.balance else 0 end) c_pqtty,
            sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then cas.pbalance+cas.balance else 0 end) f_pqtty,
            sum(case when SUBSTR (cf.custodycd,4,1) in ('P','A') then cas.pbalance+cas.balance else 0 end) p_pqtty,
            sum(case when ca.catype in ('023') then (case when cas.status in ('S') then cas.qtty
                                                          when ca.status = 'V' and cas.status ='V' then
                                                               (case when cas.ISREGIS = 'C' then cas.qtty else 0 end ) --trung.luu: 11-12-2020 SHBVNEX-1186
                                                          else cas.balance end)
                     else cas.pbalance+cas.balance end) s_pqtty,
            --
            sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then cas.aamt else 0 end) c_aamt,
            sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then cas.aamt else 0 end) f_aamt,
            sum(case when SUBSTR (cf.custodycd,4,1) in ('P','A') then cas.aamt else 0 end) p_aamt,
            sum(
                case when ca.catype in('015') then cas.intamt --nam.ly
                     --when ca.catype in('014') then (case when cas.status = 'V' then cas.paamt + cas.amt else cas.amt end)
                     when ca.catype in('014') then 0
                     when ca.catype in('023') then (
                        case when (cas.status = 'V' and cas.qtty = 0) then
                                case when ca.formofpayment <> '001' then (cas.trade * ca.parvalue * (1 + ca.interestrate/100))
                                     else cas.trade * ca.parvalue * ca.interestrate/100
                                end
                             else cas.amt end
                     )
                     else cas.amt
                     /*else cas.amt - (
                        case when ca.pitratemethod='NO' then 0 else (
                            case when cf.vat <> 'Y' then 0
                                 else (
                                    case when trim(ca.catype) in ('016','023','033') Then round (cas.intamt * ca.pitrate / 100)
                                         when ca.catype = '024' then round(cas.balance * ca.exprice * ca.pitrate / 100 / (to_number(substr(ca.exrate,0,instr(ca.exrate ,'/') - 1)) / to_number(substr(ca.exrate ,instr(ca.exrate ,'/')+1,length(ca.exrate )))))
                                         when ca.catype = '010' and cf.custtype = 'I' then round(nvl(cas.amt,0) * ca.pitrate / 100)
                                         when ca.catype = '010' and cf.custtype = 'B' then 0
                                         else round (cas.amt * ca.pitrate / 100)
                                    end)
                            end)
                        end)*/
                 end
                ) s_aamt
            FROM CFMAST cf,(Select autoid gcbid, shortname, fullname from famembers where roles='GCB' )gcb,
                            (Select autoid amcbid, shortname, fullname from famembers where roles='AMC' )amc,
                (
                    SELECT sb.codeid, sb.isincode, iss.issuerid, sb.symbol seccode, iss.fullname secname, sb.parvalue
                    FROM issuers iss, sbsecurities sb
                    WHERE iss.issuerid = sb.issuerid
                    AND SB.tradeplace NOT IN ('003')
            )sec, afmast af ,  caschd cas , camast ca
            WHERE cas.deltd <> 'Y'
            and cf.custid = af.custid
            and af.acctno = cas.afacctno
            and ca.camastid = cas.camastid(+)
            and cf.gcbid = gcb.gcbid(+) --trung.luu: 22-01-2021 SHBVNEX-1990 lay ca nhung kh khong co gcb,amc
            and nvl(gcb.shortname,'%') like V_GCBCODE
            and cf.amcid = amc.amcbid(+)
            and nvl(amc.shortname,'%') like V_AMCCODE
            and sec.codeid = (CASE WHEN ca.catype IN ('023','014','017','020') THEN ca.codeid ELSE nvl(ca.tocodeid,ca.codeid) END)
            --AND cas.status in('V','G','H','W')
            AND ca.deltd <> 'Y'
            --AND ca.status in('F','I','K','M','S','V','C')
            AND ( --nam.ly
                 CASE WHEN ca.catype IN ('010', '015', '024', '021', '011', '017', '020', '014', '023', '033') AND ca.status NOT IN  ('N','A','J', 'C') THEN 1
                      WHEN ca.catype IN ('016', '027') AND ca.status NOT IN ('N','A','J', 'C') THEN 1
                      WHEN ca.catype IN ('005', '028', '006') AND ca.status NOT IN ('N','A','I', 'C') THEN 1
                      WHEN ca.catype IN ('003','019','030','031','032') AND ca.status NOT IN ('V', 'M', 'S', 'I' , 'G', 'H') THEN 1
                      WHEN ca.status NOT IN ('N', 'C') AND
                           ca.catype NOT IN ('010', '015', '024', '021', '011', '017', '020', '014', '023', '033') AND
                           ca.catype NOT IN ('016', '027') AND
                           ca.catype NOT IN ('005', '028', '006') AND
                           ca.catype NOT IN ('003','019','030','031','032')
                      THEN 1
                 ELSE 0 END
                ) = 1
            AND NVL(cf.cifid,'%') like V_CIFID


        group by cf.cifid,
                cf.Fullname,
                sec.seccode,
                sec.isincode,
                sec.secname,
                ca.optsymbol,
                ca.catype ,
                sec.parvalue,
                ca.exprice,
                gcb.shortname,
                ca.actiondate,
                ca.reportdate,
                ca.insdeadline,
                ca.debitdate,
                ca.camastid,
                CA.ISINCODE,
                CA.optISINCODE,
                ca.convertdate,
                ca.submissiondl
        order by sec.seccode,ca.catype
        ) ca6001
        left join (
            select cdval catype, cdcontent catypeName, en_cdcontent  catypeName_en from allcode
            where cdname='CATYPE'
            order by lstodr
        ) cat on cat.catype=ca6001.catype
        --WHERE ca6001.camastid = '0001004589022919'
        ;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA600101: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
