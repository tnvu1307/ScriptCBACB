SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE ba0014 (
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,

   --PV_TCPH        IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_SYMBOL      IN       VARCHAR2,
   PV_SHARE      IN       VARCHAR2
   --PV_CUSTODYCD   IN       VARCHAR2
)
IS

   V_SYMBOL     VARCHAR2 (20);
   V_CUSTODYCD  VARCHAR2 (15);
   V_TCPH       VARCHAR2 (15);
   V_IDATE      DATE;
   V_SHARE     VARCHAR2 (20);
   V_STROPTION         VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID           VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0
   v_BackDate DATE;

BEGIN

    V_STROPTION := OPT;
    IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
    ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
    ELSE
        V_STRBRID:= BRID;
    END IF;

    v_BackDate       := getprevdate(I_DATE, 20);
--------------------------------------------
   /*IF  (PV_CUSTODYCD <> 'ALL')
   THEN
         V_CUSTODYCD := PV_CUSTODYCD;
   ELSE
        V_CUSTODYCD := '%';
   END IF;*/----------------------------
   IF  (PV_SYMBOL <> 'ALL')
   THEN
         V_SYMBOL := PV_SYMBOL;
   ELSE
      V_SYMBOL := '%';
   END IF;
   IF  (PV_SHARE <> 'ALL')
   THEN
         V_SHARE := PV_SHARE;
   ELSE
      V_SHARE := '%';
   END IF;
 --------------------------------------------
 V_IDATE := TO_DATE(I_DATE, SYSTEMNUMS.C_DATE_FORMAT);
 --V_TCPH := PV_TCPH;


 OPEN PV_REFCURSOR
 FOR
    SELECT V_IDATE CREATEDATE,
    --'22/MAY/2017' CREATEDATE,
        sb.symbol, --ma co phieu
        sb.sectype, --loai co phieu
        a1.cdcontent, --loai co phieu
        a1.en_cdcontent,
        sbr.tradingdt, --ngay lay gia tham chieu
        sbr.pclosed, --gia dong cua
        sbr.volume, --KL GD khop
        sbr.tranvalue valueoftrading, --tong gia tri gd
        --((sbr.pclosed * sbr.volume) / sbr.volume) averageprice, --gia co phieu binh quan
        ab.qtty, --SL co phan cam co
        (((sbr.pclosed * sbr.volume) / sbr.volume) * ab.qtty) secvalue,--gia co phan cam co
        ba.valueofissue, --gia tri phat hanh ma trai phieu
       -- (sb.valueofissue / (((sbr.pclosed * sbr.volume) / sbr.volume) * ab.qtty)) ltv, --ty le LTV
        ba.maxltvrate --max ltv
    from sbsecurities sb, sbrefmrkdata sbr, allcode a1, sbsecurities ba,
        (
            SELECT SE.AFACCTNO afacctno, SE.ACCTNO acctno, CF.FULLNAME CUSTNAME, CF.CUSTODYCD, SB.SYMBOL,
                SB.PARVALUE, mt.qtty qtty, SB.CODEID,
                 ba.issuerid, iss.Fullname ISSUERNAME, mt.bondcode, ba.symbol bondsymbol
            from (
                select se.acctno, se.afacctno, se.bondcode,
                 sum(case when se.tltxcd in ('2232') then se.qtty
                          when se.tltxcd in ('2253') then -se.qtty else 0 end) qtty
                 from semortage se
                 where se.status IN ('C')
                       and se.bondcode is not null
                       --and se.crplaceid is null
                 group by se.acctno, se.afacctno,se.bondcode
                 UNION ALL
                 select se.acctno, se.afacctno, se.bondcode,
                 sum(case when se.tltxcd in ('1900') then se.qtty
                          when se.tltxcd in ('1901') then -se.qtty else 0 end) qtty
                 from semortage se
                 where se.status IN ('C')
                       and se.bondcode is not null
                       --and se.crplaceid is null
                 group by se.acctno, se.afacctno,se.bondcode
            )mt, semast se, sbsecurities sb, afmast af, cfmast cf, ISSUER_MEMBER iss, sbsecurities ba
            where mt.acctno = se.acctno and se.mortage > 0 and se.codeid = sb.codeid
                  and se.afacctno = af.acctno and af.custid = cf.custid and mt.qtty > 0
                  and iss.custid = cf.custid
                  and ba.codeid = mt.bondcode
                  and iss.issuerid = ba.issuerid
                  and iss.rolecd = '006'
        )ab
    where
        sb.symbol = sbr.symbol
        and sb.symbol =ab.symbol
        and a1.cdname = 'SECTYPE'
        AND a1.cdval=sb.sectype
        and ab.bondcode = ba.CODEID
        AND sbr.txdate BETWEEN TO_DATE(v_BackDate, 'DD/MM/YYYY') AND TO_DATE(I_DATE, 'DD/MM/YYYY')
        --AND sbr.txdate BETWEEN TO_DATE('02/may/2017', 'DD/MM/YYYY') AND TO_DATE('22/may/2017', 'DD/MM/YYYY')
       -- and ba.symbol LIKE 'GEX%'
        --and sb.symbol LIKE 'ACB'
        and ba.symbol LIKE V_SYMBOL
        and sb.symbol LIKE V_SHARE
        order by sbr.txdate desc
      ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;
/
