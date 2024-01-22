SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE bo1008 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   PV_CUSTODYCD      IN       VARCHAR2,
   PV_BONDID      IN       VARCHAR2
)
IS

   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0

    V_CUSTODYCD VARCHAR2 (100);
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

    V_CUSTODYCD:=PV_CUSTODYCD;
    V_BONDID:= PV_BONDID;


  -- GET REPORT'S DATA

OPEN PV_REFCURSOR FOR

SELECT getcurrdate v_currdate ,bo.TXDATE, bo.BIDSESSION, iss.fullname issName, sb.symbol, bo.ISSTMPDATE, bo.ISSDATE,bo.ISSPAYDATE,
    bo.EXPDATE,bo.TERM,sb.parvalue, bo.BIDCALLQTTY,bo.PRIZEINTEREST,bo.COUPON,
    cf1.fullname custname, cf1.custodycd custodycd, bo.IPOTYPE, a0.cdcontent IPOTYPEName,bc.BIDINT,bc.BIDQTTY, bo.PRIZEINTEREST,
    bc.WINQTTY,bc.AMT, bc.TOTALBID, bc.TOTALTRAF, bc.BIDBLK, bc.AMT+  bc.TOTALBID + bc.TOTALTRAF - bc.BIDBLK TOTALPAYMNT, cf1.MNEMONIC
FROM bondipo bo, bondcust bc, sbsecurities sb, issuers iss, (SELECT CUSTID, custodycd, FULLNAME,MNEMONIC FROM CFMAST WHERE custodycd = V_CUSTODYCD) CF1,
    ALLCODE a0
    where bo.bondid = bc.bondid and bo.codeid = sb.codeid and sb.issuerid=iss.issuerid and bc.custodycd=CF1.custodycd
        and a0.CDTYPE = 'SA' AND a0.CDNAME = 'IPOTYPE' and a0.cdval=bo.IPOTYPE AND BO.BONDID = RTRIM(V_BONDID)
        -- AND BC.winqtty > 0
;


EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE
 
 
/
