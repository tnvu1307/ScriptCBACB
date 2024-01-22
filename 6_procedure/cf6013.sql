SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE cf6013 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*Tu ngay */
   T_DATE                 IN       VARCHAR2, /*den ngay */
   REPORT_NO              IN       VARCHAR2, -- So chung tu
   PV_CUSTODYCD           IN       VARCHAR2, /*So TK Luu ky */
   P_SYMBOL               IN       VARCHAR2, -- Chung khoan
   P_SHARESOUTTYP         IN       VARCHAR2, -- KL luu hanh
   P_SIGNUSER             IN       VARCHAR2 -- Nguoi ky
   )
IS
    -- Giay dang ky ma so giao dich
    -- person      date                 comments
    -- ---------   ------               -------------------------------------------
    -- truongld    18-10-2019           created
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    v_FromDate          date;
    v_ToDate            date;
    v_CurrDate          date;
    V_NEXTDATE          DATE;
    v_CustodyCD         varchar2(20);
    v_Symbol            varchar2(50);
    v_BRADDRESS         varchar2(200);
    v_BRADDRESS_EN      varchar2(200);
    v_HEADOFFICE        varchar2(200);
    v_HEADOFFICE_EN     varchar2(200);
    v_EMAIL             varchar2(200);
    v_PHONE             varchar2(200);
    v_FAX               varchar2(200);
    v_1IDCODE           varchar2(200);
    v_1OFFICE           varchar2(200);
    v_1REFNAME          varchar2(200);
    v_2IDCODE           varchar2(200);
    v_2OFFICE           varchar2(200);
    v_2REFNAME          varchar2(200);
    v_BUSSINESSID       varchar2(200);
    -- Ty le so huu co dong lon
    v_MAJORSHAREHOLDER  number(20,4);
    v_CLEARDAY          number;
    v_amcid             varchar2(200);
    V_FRPREVDATE        DATE;
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

    v_CustodyCD := REPLACE(PV_CUSTODYCD,'.','');
    Begin
    select amcid into v_amcid from cfmast where CustodyCD= v_CustodyCD;
    EXCEPTION
      WHEN OTHERS
       THEN v_amcid := '';
    END;
    v_FromDate  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    v_ToDate    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_FRPREVDATE := GETPREVDATE(V_FROMDATE,1);
    V_NEXTDATE  := GETPDATE_NEXT(V_FROMDATE,2);

    Select max(case when  varname='BRADDRESS' then varvalue else '' end),
           max(case when  varname='BRADDRESS_EN' then varvalue else '' end),
           max(case when  varname='HEADOFFICE' then varvalue else '' end),
           max(case when  varname='HEADOFFICE_EN' then varvalue else '' end),
           max(case when  varname='EMAIL' then varvalue else '' end),
           max(case when  varname='PHONE' then varvalue else '' end),
           max(case when  varname='FAX' then varvalue else '' end),
           max(case when  varname='MAJORSHAREHOLDER' then varvalue else '' end),
           max(case when  varname='CLEARDAY' then varvalue else '' end)
       into v_BRADDRESS,v_BRADDRESS_EN,v_HEADOFFICE,v_HEADOFFICE_EN,v_EMAIL,v_PHONE,v_FAX, v_MAJORSHAREHOLDER, v_CLEARDAY
    from sysvar WHERE varname IN ('BRADDRESS','BRADDRESS_EN','HEADOFFICE','HEADOFFICE_EN','EMAIL','PHONE','FAX', 'MAJORSHAREHOLDER', 'CLEARDAY');

    Select max(case when  varname='1IDCODE' then varvalue else '' end),
           max(case when  varname='1OFFICE' then varvalue else '' end),
           max(case when  varname='1REFNAME' then varvalue else '' end),
           max(case when  varname='2IDCODE' then varvalue else '' end),
           max(case when  varname='2OFFICE' then varvalue else '' end),
           max(case when  varname='2REFNAME' then varvalue else '' end),
           max(case when  varname='BUSSINESSID' then varvalue else '' end)
        into v_1IDCODE, v_1OFFICE, v_1REFNAME, v_2IDCODE, v_2OFFICE, v_2REFNAME, v_BUSSINESSID
    from sysvar WHERE varname IN ('1IDCODE','1OFFICE','1REFNAME','2IDCODE','2OFFICE','2REFNAME','BUSSINESSID');


OPEN PV_REFCURSOR FOR
    select -- Thong tin HSV
           v_headoffice headoffice,
           v_headoffice_en headoffice_en,
           v_braddress braddress,
           v_braddress_en braddress_en,
           v_email email,
           v_phone phone,
           v_fax fax,
           v_bussinessid bussinessid,
           REPORT_NO AS CT,
           -- thong tin nguoi dai dien
           case when P_SIGNUSER =002 then v_1refname else v_2refname  end refname,
           case when P_SIGNUSER =002 then v_1office  else v_2office  end office,
           case when P_SIGNUSER =002 then v_1idcode  else v_2idcode  end idcode,
           v_1refname refname1,
           v_2refname refname2,
           v_fromdate reportdate,
           mst.custodycd,
           mst.symbol,
           mst.issfullname,
           mst.en_issfullname,
           mst.exchanges,
           mst.en_exchanges, mst.listingqtty
    from
    (
        select cf.custodycd, sb.symbol, sb.issfullname, sb.en_issfullname, sb.exchanges, sb.en_exchanges, sb.listingqtty,
               -- KL CK cuoi ngay from date
               (CASE WHEN SE.CUSTATCOM = 'Y' THEN SE.TRADE + SE.RECEIVING - NVL(TR.NAMT,0) ELSE SE.TRADE END) endqtty
        from cfmast cf, (
            SELECT SE.ACCTNO, SE.AFACCTNO, SE.CODEID, SE.CUSTID, SE.TRADE, SE.RECEIVING, SE.MORTAGE, SE.BLOCKED, SE.EMKQTTY, CF.CUSTATCOM
            FROM SEMAST SE, CFMAST CF
            WHERE SE.CUSTID = CF.CUSTID
            AND CF.CUSTATCOM = 'Y'
            UNION ALL
            SELECT SE.ACCTNO, SE.AFACCTNO, SE.CODEID, SE.CUSTID, SUM(CASE WHEN SE.TXDATE = V_NEXTDATE THEN SE.TRADE ELSE 0 END) TRADE, SE.RECEIVING, SE.MORTAGE, SE.BLOCKED, SE.EMKQTTY, CF.CUSTATCOM
            FROM SENOCUSTATCOM SE, CFMAST CF
            WHERE SE.CUSTID = CF.CUSTID
            AND CF.CUSTATCOM = 'N'
            AND TXDATE BETWEEN V_FRPREVDATE AND V_NEXTDATE
            GROUP BY SE.ACCTNO, SE.AFACCTNO, SE.CODEID, SE.CUSTID, SE.RECEIVING, SE.MORTAGE, SE.BLOCKED, SE.EMKQTTY, CF.CUSTATCOM
        ) se,
            (
                select sb.codeid, sb.symbol,
                       iss.fullname issfullname, -- Ten TCPH
                       iss.en_fullname en_issfullname, -- Ten TA TCPH
                       a1.cdcontent exchanges,          -- Ten so GDCK
                       a1.en_cdcontent  en_exchanges,   -- Ten TA so GDCK
                       si.listingqtty                   -- KL Niem yet
                from issuers iss, sbsecurities sb, allcode a1,
                     (
                        Select codeid,
                        sum(case when P_SHARESOUTTYP='O' then oldcirculatingqtty else newcirculatingqtty end) listingqtty
                        from vw_securities_info_hist
                        where symbol like p_symbol
                        and histdate BETWEEN V_FRPREVDATE AND V_FROMDATE
                        GROUP by codeid
                    ) si
                where iss.issuerid = sb.issuerid
                    and sb.tradeplace = a1.cdval and a1.cdname='EXCHANGES'
                    and sb.codeid = si.codeid (+)
                    and sb.symbol = p_symbol
            )sb,
            -- Phat sinh tu from date
            (
                select custodycd, acctno, symbol, sum(case when  txtype='C' then namt else -namt end) namt
                 from vw_setran_gen
                 where txdate > v_FromDate and field in ('TRADE','RECEIVING')
                    and symbol like p_symbol||'%'
                 group by custodycd, acctno, symbol
            )tr
        where cf.custid = se.custid
        and se.codeid = sb.codeid
        and se.acctno = tr.acctno (+)
        and (cf.custodycd = v_CustodyCD or cf.amcid = v_amcid)
        and cf.status <> 'C'
        and SUBSTR(cf.custodycd,0,3) <> 'OTC'
              -- Ty le so huu
            --  and (case when sb.listingqtty = 0 then 100 else (se.trade + se.receiving - nvl(tr.namt,0)) / sb.listingqtty end) >= v_MAJORSHAREHOLDER
    )mst order by mst.custodycd;

EXCEPTION
  WHEN OTHERS
   THEN
      plog.error ('CF6013: ' || SQLERRM || dbms_utility.format_error_backtrace);
      Return;
End;
/
