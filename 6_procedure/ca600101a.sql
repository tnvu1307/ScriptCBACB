SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ca600101a(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   I_DATE                 IN       VARCHAR2, /*Tu ngay */
   P_GCBCODE              IN       VARCHAR2,
   P_AMCCODE              IN       VARCHAR2,
   P_CIFID                IN       VARCHAR2
   )
IS
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
    V_AMCCODE          varchar2(20);
    V_GCBCODE          varchar2(20);
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
     IF P_AMCCODE = 'ALL' THEN
        V_AMCCODE := '%';
     ELSE V_AMCCODE := P_AMCCODE;
     END IF;

     IF P_GCBCODE = 'ALL' THEN
        V_GCBCODE := '%';
     ELSE V_GCBCODE := P_GCBCODE;
     END IF;

     if P_CIFID ='ALL' then
        V_CIFID:='%';
    else
        V_CIFID:=P_CIFID;
    end if;

    v_InDate  := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
--
OPEN PV_REFCURSOR FOR
        Select  rownum NO,
                ca6001.ClientName,ca6001.ClientAccount,
                v_InDate ReportingDate,
                case when cat.catype in ('009', '010', '011','015', '016', '017', '018', '020', '021', '024','027') then 'Mandatory events' else 'Voluntary events' end EventType,
                ca6001.SecuritiesID,
                ca6001.ISINCode,
                ca6001.RightsCode,
                ca6001.RightISINCode,
                to_char(ca6001.RecordDate,'dd/MM/yyyy')RecordDate,
                --cat.catypeName_en EventType,   --NAM.LY 12-12-2019
                cat.catypeName_en EventType_en, --NAM.LY 12-12-2019
                ca6001.camastid EventRefNo,
                (case when cat.catype='017' then to_char(ca6001.convertdate,'dd/MM/yyyy')
                when cat.catype in ('010','027','024','016','015','028','006','005','014','011','033','020','021') then to_char(ca6001.actiondate,'dd/MM/yyyy')
                      else to_char(ca6001.insdeadline,'dd/MM/yyyy') end) PaymentDate,
                (case when cat.catype IN ('023','033') then '' else to_char(ca6001.debitdate,'dd/MM/yyyy') END) DebitDate,
                UTILS.SO_THANH_CHU2(NVL(ca6001.s_trade,0)) EntitledHolding,
                (case when cat.catype ='014' then '0' else UTILS.SO_THANH_CHU2(NVL(ca6001.s_aamt,0)) end ) CashAmount,
                (case when cat.catype ='014' then '0'
                      when cat.catype in ('010','027','024','016','015','028','006','005') then '0'
                      when cat.catype in ('011','020','017','023','021','033') then UTILS.SO_THANH_CHU2(NVL(ca6001.s_qtty,0))
                      else UTILS.SO_THANH_CHU2(NVL(ca6001.s_pqtty,0)) end) NoOfResultantShares,
                (case when cat.catype in ('011','021','023','017','020') then '0' else UTILS.SO_THANH_CHU2(NVL(ca6001.s_qtty,0)) end) PurchaseQuantity
        from  (
            SELECT  sec.seccode SecuritiesID,
                    sec.isincode ISINCode ,
                    sec.secname,
                    (case when ca.catype ='014' then ca.optsymbol else '' end) RightsCode,
                    CA.ISINCODE RightISINCode,
                    ca.reportdate RecordDate,
                    ca.catype,
                    gcb.shortname,
                    ca.insdeadline,
                    ca.convertdate,
                    ca.actiondate,
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
            sum(cas.qtty) s_qtty,
            -- caschd.pbalance+caschd.roretailbal
            sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then cas.pbalance+cas.balance else 0 end) c_pqtty,
            sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then cas.pbalance+cas.balance else 0 end) f_pqtty,
            sum(case when SUBSTR (cf.custodycd,4,1) in ('P','A') then cas.pbalance+cas.balance else 0 end) p_pqtty,
            sum(cas.pbalance+cas.balance) s_pqtty,
            --
            sum(case when SUBSTR (cf.custodycd,4,1) in ('C','B') then cas.aamt else 0 end) c_aamt,
            sum(case when SUBSTR (cf.custodycd,4,1) = 'F' then cas.aamt else 0 end) f_aamt,
            sum(case when SUBSTR (cf.custodycd,4,1) in ('P','A') then cas.aamt else 0 end) p_aamt,
            sum((case when ca.catype in('010','027','024') and nvl(ca.devidentrate,0) <> 0 then  to_number(nvl(ca.devidentrate,'0'))*cas.balance*ca.parvalue/100
            when ca.catype in('010','027') and nvl(ca.devidentrate,0) = 0 then ca.devidentvalue
              --when ca.catype in('016','015') then cas.intamt
              --when ca.catype in('023') then cas.amt
            when ca.catype in('015') then cas.intamt --nam.ly
            when ca.catype in('016','023','024','011','021','033','017','020','010','027') then cas.amt --nam.ly
                    else cas.aamt end )) s_aamt
            FROM CFMAST cf,(Select autoid amcid, shortname, fullname from famembers where roles='AMC' )amc,
                            (Select autoid gcbid, shortname, fullname from famembers where roles='GCB' )gcb,
            (
                SELECT sb.codeid, sb.isincode, iss.issuerid, sb.symbol seccode, iss.fullname secname, sb.parvalue
                FROM issuers iss, sbsecurities sb
                WHERE iss.issuerid = sb.issuerid
                --AND SB.tradeplace NOT IN ('003')
            )sec,afmast af ,  caschd cas , camast ca
            WHERE cas.deltd <> 'Y'
            and cf.custid = af.custid
            and ca.catype not in ('019','030','029','032','031','003')
            and  af.acctno = cas.afacctno
            and cas.camastid = ca.camastid
            and cf.amcid =amc.amcid (+)
            AND NVL(amc.shortname,'%') like V_AMCCODE
            and cf.gcbid =gcb.gcbid (+)
            AND NVL(gcb.shortname,'%') like V_GCBCODE
            AND NVL(cf.cifid,'%') like V_CIFID
            and sec.codeid = (CASE WHEN ca.catype IN ('023','014','017','020') THEN ca.codeid ELSE nvl(ca.tocodeid,ca.codeid) END)
            --AND cas.status in('V','G','H','W')
            AND ca.deltd <> 'Y'
            --AND ca.status in('F','I','K','M','S','V','C')
            AND ( --nam.ly
                 CASE WHEN ca.catype IN ('010', '015', '024', '021', '011', '017', '020', '014', '023', '033') AND
                           ca.status NOT IN  ('N','A','J', 'C')
                      THEN 1
                 ELSE
                 CASE WHEN ca.catype IN ('016', '027') AND
                           ca.status NOT IN ('N','A','J', 'C')
                      THEN 1
                 ELSE
                 CASE WHEN ca.catype IN ('005', '028', '006') AND
                           ca.status NOT IN ('N','A','I', 'C')
                      THEN 1
                 ELSE
                 CASE WHEN ca.status NOT IN ('N', 'C') AND
                           ca.catype NOT IN ('010', '015', '024', '021', '011', '017', '020', '014', '023', '033') AND
                           ca.catype NOT IN ('016', '027') AND
                           ca.catype NOT IN ('005', '028', '006')
                      THEN 1
                 ELSE 0
                 END END END END
                ) = 1

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
                ca.convertdate,
                ca.actiondate,
                ca.reportdate,
                ca.insdeadline,
                ca.debitdate,
                ca.camastid,
                CA.ISINCODE
        order by cf.Fullname,cf.cifid,ca.reportdate
        ) ca6001
        left join (
            select cdval catype, cdcontent catypeName, en_cdcontent  catypeName_en from allcode
            where cdname='CATYPE'
            order by lstodr
        ) cat on cat.catype=ca6001.catype;
EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CA600101: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
