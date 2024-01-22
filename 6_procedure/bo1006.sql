SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE bo1006 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTID      IN       VARCHAR2,
   PV_BONDID      IN       VARCHAR2,
   PV_CONTRACTNO  IN       VARCHAR2
)
IS

   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0

    V_CUSTID VARCHAR2 (100);
    V_BONDID VARCHAR2 (100);
BEGIN

   V_STROPTION := OPT;

  IF V_STROPTION = 'A' then
      V_STRBRID := '%';
  ELSIF V_STROPTION = 'B' then
      V_STRBRID := substr(BRID,1,2) || '__' ;
  else
      V_STRBRID:=BRID;
  END IF;

    V_CUSTID:=PV_CUSTID;
    V_BONDID:= PV_BONDID;


  -- GET REPORT'S DATA

OPEN PV_REFCURSOR FOR

SELECT PV_CONTRACTNO CONTRACTNO, CF1.FULLNAME,
    bo.txdate, bo.term, sb.symbol, bo.codeid, bc.bidqtty, bc.bidint, bc.winqtty, bc.amt, bo.PRIZEINTEREST,
    bo.COUPON,  bo.issdate, bo.expdate, bo.ISSPAYDATE, bo.BENECOMP, bo.BENEACCOUNT, bo.NOTES
FROM bondipo bo, bondcust bc, sbsecurities sb,(SELECT CUSTID, FULLNAME,CUSTODYCD FROM CFMAST WHERE CUSTODYCD = V_CUSTID) CF1
    where bo.bondid = bc.bondid and bo.codeid = sb.codeid
    AND BC.CUSTODYCD = CF1.CUSTODYCD
    AND BO.BONDID LIKE RTRIM(V_BONDID)

    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
 
 
/
