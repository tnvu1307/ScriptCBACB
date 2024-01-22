SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE se0009 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   F_DATE         IN       VARCHAR2,
   T_DATE         IN       VARCHAR2,
   CUSTODYCD      IN       VARCHAR2,
   CIACCTNO       IN       VARCHAR2,
   SYMBOL         IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- BAO CAO SO DU PHONG TOA CHUNG KHOAN
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- DUNGNH   11-JUL-10  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION        VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRCIACCTNO      VARCHAR (20);
   V_STRSYMBOL        VARCHAR (20);
   V_STRCUSTODYCD     VARCHAR2 (20);
   V_FDATE           DATE;
   V_TDATE           DATE;
   V_INBRID        VARCHAR2(4);
   V_STRBRID      VARCHAR2 (50);

-- DECLARE PROGRAM VARIABLES AS SHOWN ABOVE
BEGIN
  V_STROPTION := upper(OPT);
  V_INBRID := BRID;
    if(V_STROPTION = 'A') then
        V_STRBRID := '%%';
    else
        if(V_STROPTION = 'B') then
            select br.mapid into V_STRBRID from brgrp br where  br.brid = V_INBRID;
        else
            V_STRBRID := V_INBRID;
        end if;
    end if;

   -- GET REPORT'S PARAMETERS

   IF(upper(CUSTODYCD) = 'ALL' or CUSTODYCD is null) THEN
     V_STRCUSTODYCD := '%';
   ELSE
     V_STRCUSTODYCD := CUSTODYCD;
   END IF;

   IF(upper(CIACCTNO) = 'ALL' or CIACCTNO is null) THEN
     V_STRCIACCTNO := '%';
   ELSE
     V_STRCIACCTNO := CIACCTNO;
   END IF;

   IF(SYMBOL  <> 'ALL')
   THEN
      V_STRSYMBOL := replace(SYMBOL,' ','_');
   ELSE
      V_STRSYMBOL := '%%';
   END IF;

   V_FDATE := to_date(F_DATE,'DD/MM/YYYY');
   V_TDATE := to_date(T_DATE,'DD/MM/YYYY');

-- GET REPORT'S DATA
OPEN PV_REFCURSOR
    FOR
    /*
---giao dich 2200 tren chung khoan giao dich
SELECT TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end) SYMBOL,
    sum(TR.NAMT) namt,
    avg(case when sb.refcodeid is null then '1' else '7' end) sectype
FROM VW_SETRAN_GEN TR, CFMAST CF, sbsecurities sb, sbsecurities sb1
WHERE TR.TLTXCD = '2200'
    AND TR.FIELD = 'TRADE'
    and tr.codeid = sb.codeid
    and sb.refcodeid = sb1.codeid(+)
    AND TR.DELTD <> 'Y' AND TR.CUSTODYCD = CF.CUSTODYCD
    AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    AND TR.AFACCTNO LIKE V_STRCIACCTNO
    AND TR.TXDATE >= V_FDATE
    AND TR.TXDATE <= V_TDATE
    and (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end)  like  V_STRSYMBOL
GROUP BY TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end)
union all
---giao dich 2200 tren chung khoan phong toa
SELECT TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end) SYMBOL,
    sum(TR.NAMT) namt,
    avg(case when sb.refcodeid is null then '2' else '8' end) sectype
FROM VW_SETRAN_GEN TR, CFMAST CF, sbsecurities sb, sbsecurities sb1
WHERE TR.TLTXCD = '2200'
    AND TR.FIELD = 'BLOCKED'
    and tr.codeid = sb.codeid
    and sb.refcodeid = sb1.codeid(+)
    AND TR.DELTD <> 'Y' AND TR.CUSTODYCD = CF.CUSTODYCD
    AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    AND TR.AFACCTNO LIKE V_STRCIACCTNO
    AND TR.TXDATE >= V_FDATE
    AND TR.TXDATE <= V_TDATE
        and (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end)  like  V_STRSYMBOL
GROUP BY TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end)
union all
SELECT DISTINCT TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end) SYMBOL,
    0 namt,
    null sectype
FROM VW_SETRAN_GEN TR, CFMAST CF, sbsecurities sb, sbsecurities sb1,
    v_tllog
WHERE TR.TLTXCD IN ('2294','2292','2293','2201')
    AND TR.DELTD <> 'Y' AND TR.CUSTODYCD = CF.CUSTODYCD
    and tr.codeid = sb.codeid
    and sb.refcodeid = sb1.codeid(+)
    AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    AND TR.AFACCTNO LIKE V_STRCIACCTNO
    AND TR.TXDATE >= V_FDATE
    AND TR.TXDATE <= V_TDATE
        and (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end)  like  V_STRSYMBOL
*/
---giao dich 2200 tren chung khoan phong toa
select * from
(
SELECT TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end) SYMBOL,
    sum(TR.NAMT) namt,
    (case when sb.refcodeid is null then
        (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '1,2'
              when wd.withdraw = 0 then '2' else '1' end) else
         (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '7,8'
               when wd.withdraw = 0 then '8' else '7' end) end)  sectype,
    wd.txdate opdate
FROM VW_SETRAN_GEN TR, CFMAST CF, sbsecurities sb, sbsecurities sb1,
    sewithdrawdtl wd
WHERE TR.TLTXCD = '2200'
    AND TR.FIELD in ('TRADE','BLOCKED')
    and tr.codeid = sb.codeid
    and sb.refcodeid = sb1.codeid(+)
    and tr.txnum = wd.txnum and tr.txdate = wd.txdate
    AND TR.DELTD <> 'Y' AND TR.CUSTODYCD = CF.CUSTODYCD
    ---AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    ---AND TR.AFACCTNO LIKE V_STRCIACCTNO
    ---AND TR.TXDATE >= V_FDATE
    ---AND TR.TXDATE <= V_TDATE
    ---and (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end)  like  V_STRSYMBOL
GROUP BY TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end) ,
    (case when sb.refcodeid is null then
        (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '1,2'
              when wd.withdraw = 0 then '2' else '1' end) else
         (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '7,8'
               when wd.withdraw = 0 then '8' else '7' end) end), wd.txdate
union all
SELECT DISTINCT TR.AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end) SYMBOL,
    (wd.withdraw+wd.blockwithdraw) namt,
    (case when sb.refcodeid is null then
        (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '1,2'
              when wd.withdraw = 0 then '2' else '1' end) else
         (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '7,8'
               when wd.withdraw = 0 then '8' else '7' end) end)  sectype,
    wd.txdate opdate
FROM vw_setran_gen TR, CFMAST CF, sbsecurities sb, sbsecurities sb1,
    vw_tllogfld_all tl, sewithdrawdtl wd
WHERE TR.TLTXCD IN ('2293','2201')
    and tl.fldcd = '07' and tl.txnum = tr.txnum and tl.txdate = tr.txdate
    and tl.cvalue = wd.txdatetxnum
    AND TR.DELTD <> 'Y' AND TR.CUSTODYCD = CF.CUSTODYCD
    and tr.codeid = sb.codeid
    and sb.refcodeid = sb1.codeid(+)
        ---AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    ---AND TR.AFACCTNO LIKE V_STRCIACCTNO
    ---AND TR.TXDATE >= V_FDATE
    ---AND TR.TXDATE <= V_TDATE
    ---and (case when sb.refcodeid is null then TR.SYMBOL else sb1.symbol end)  like  V_STRSYMBOL
union all
SELECT DISTINCT af.acctno AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then sb.symbol else sb1.symbol end) SYMBOL,
    (wd.withdraw+wd.blockwithdraw) namt,
    (case when sb.refcodeid is null then
        (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '1,2'
              when wd.withdraw = 0 then '2' else '1' end) else
         (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '7,8'
               when wd.withdraw = 0 then '8' else '7' end) end)  sectype,
    wd.txdate opdate
FROM vw_tllog_all TR, CFMAST CF, sbsecurities sb, sbsecurities sb1,
    sewithdrawdtl wd, afmast af
WHERE TR.TLTXCD = '2292'
    and tr.msgacct = wd.txdatetxnum
    AND TR.DELTD <> 'Y' AND wd.afacctno = af.acctno
    and af.custid = CF.custid
    AND AF.ACTYPE NOT IN ('0000')
    and wd.codeid = sb.codeid
    and sb.refcodeid = sb1.codeid(+)
        ---AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    ---AND af.ACCTNO LIKE V_STRCIACCTNO
    ---AND TR.TXDATE >= V_FDATE
    ---AND TR.TXDATE <= V_TDATE
    ---and (case when sb.refcodeid is null then sb.SYMBOL else sb1.symbol end)  like  V_STRSYMBOL
union all
SELECT DISTINCT af.acctno AFACCTNO, CF.FULLNAME, CF.CUSTODYCD, TR.TXNUM, TR.TXDATE, TR.TLTXCD,
    (case when sb.refcodeid is null then sb.symbol else sb1.symbol end) SYMBOL,
    (wd.withdraw+wd.blockwithdraw) namt,
    (case when sb.refcodeid is null then
        (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '1,2'
              when wd.withdraw = 0 then '2' else '1' end) else
         (case when wd.withdraw <> 0 and wd.blockwithdraw <> 0 then '7,8'
               when wd.withdraw = 0 then '8' else '7' end) end)  sectype,
    wd.txdate opdate
FROM vw_tllog_all TR, CFMAST CF, sbsecurities sb, sbsecurities sb1,
    sewithdrawdtl wd, afmast af
WHERE TR.TLTXCD = '2294'
    and tr.msgacct = wd.txdatetxnum
    AND TR.DELTD <> 'Y' AND wd.afacctno = af.acctno
    and af.custid = CF.custid
    AND AF.ACTYPE NOT IN ('0000')
    and wd.codeid = sb.codeid
    and sb.refcodeid = sb1.codeid(+)
        ---AND CF.CUSTODYCD LIKE V_STRCUSTODYCD
    ---AND af.ACCTNO LIKE V_STRCIACCTNO
    ---AND TR.TXDATE >= V_FDATE
    ---AND TR.TXDATE <= V_TDATE
    ---and (case when sb.refcodeid is null then sb.SYMBOL else sb1.symbol end)  like  V_STRSYMBOL
)
order by CUSTODYCD, TXDATE, TXNUM
;


 EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
/
