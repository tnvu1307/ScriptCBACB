SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE BO1002_1 (
   PV_REFCURSOR   IN OUT   PKG_REPORT.REF_CURSOR,
   OPT            IN       VARCHAR2,
   BRID           IN       VARCHAR2,
   I_DATE         IN       VARCHAR2,
   PV_CUSTODYCD   IN       VARCHAR2
)
IS
--
-- PURPOSE: BRIEFLY EXPLAIN THE FUNCTIONALITY OF THE PROCEDURE
-- DANH SACH NGUOI SO HUU CHUNG KHOAN  LUU KY
-- MODIFICATION HISTORY
-- PERSON      DATE    COMMENTS
-- NAMNT   20-DEC-06  CREATED
-- ---------   ------  -------------------------------------------
   V_STROPTION     VARCHAR2 (5);            -- A: ALL; B: BRANCH; S: SUB-BRANCH
   V_STRBRID       VARCHAR2 (4);                   -- USED WHEN V_NUMOPTION > 0



   V_IDATE            DATE;
   V_STRCUSTODYCD     VARCHAR2(20);


    V_BUYQTTY   NUMBER;
    V_BUYAMT   NUMBER;
    V_BUYfeeamt   NUMBER;
    V_BUYtaxamt   NUMBER;
    V_SELLQTTY   NUMBER;
    V_SELLAMT   NUMBER;
    V_SELLfeeamt   NUMBER;
    V_SELLtaxamt   NUMBER;

BEGIN

   V_STROPTION := OPT;

  IF V_STROPTION = 'A' then
      V_STRBRID := '%';
  ELSIF V_STROPTION = 'B' then
      V_STRBRID := substr(BRID,1,2) || '__' ;
  else
      V_STRBRID:=BRID;
  END IF;

 -- GET REPORT'S PARAMETERS
    V_IDATE := TO_DATE(I_DATE,'DD/MM/RRRR');

    V_STRCUSTODYCD := UPPER(PV_CUSTODYCD);

 -- END OF GETTING REPORT'S PARAMETERS
    SELECT sum(case when MST.BORS = 'B' then MST.QTTY else 0 end) B_QTTY,
    sum(case when MST.BORS = 'B' then MST.QTTY*MST.PRICE else 0 end) B_AMT,
    sum(case when MST.BORS = 'B' then (MST.QTTY*MST.PRICE)*(mst.feebrk/100) else 0 end) B_feeamt,
    0 B_taxamt,
    sum(case when MST.BORS = 'S' then MST.QTTY else 0 end) S_QTTY,
    sum(case when MST.BORS = 'S' then MST.QTTY*MST.PRICE else 0 end) S_AMT,
    sum(case when MST.BORS = 'S' then (MST.QTTY*MST.PRICE)*(mst.feebrk/100) else 0 end) S_feeamt,
    sum(case when MST.BORS = 'S' AND CF.VAT='Y' then (MST.QTTY*MST.PRICE)*(to_number(sys.varvalue)/100) else 0 end) S_taxamt
    into V_BUYQTTY, V_BUYAMT, V_BUYfeeamt, V_BUYtaxamt, V_SELLQTTY, V_SELLAMT, V_SELLfeeamt, V_SELLtaxamt
FROM BONDDEAL MST, CFMAST CF, SBSECURITIES SB, ALLCODE A0, ALLCODE A2,
    (SELECT CUSTID, FULLNAME FROM CFMAST UNION ALL SELECT 'NULL' CUSTID, '---' FULLNAME FROM DUAL) RCF,
    sysvar sys
WHERE MST.CUSTID=CF.CUSTID AND MST.CODEID=SB.CODEID AND NVL(MST.PCUSTID,'NULL') = RCF.CUSTID
    AND A0.CDTYPE='SY' AND A0.CDNAME='TYPESTS' AND A0.CDVAL=MST.STATUS
    AND A2.CDTYPE='SA' AND A2.CDNAME='BORS' AND A2.CDVAL=MST.BORS
    AND MST.BORS = 'S'
    AND MST.DEALTYPE='P' and sys.varname = 'ADVSELLDUTY' and sys.grname = 'SYSTEM'
    AND CF.CUSTODYCD = V_STRCUSTODYCD
    AND MST.TRANSDATE = V_IDATE;
  -- GET REPORT'S DATA

OPEN PV_REFCURSOR
     FOR
SELECT V_BUYQTTY BUYQTTY, V_BUYAMT BUYAMT, V_BUYfeeamt BUYfeeamt, V_BUYtaxamt BUYtaxamt,
    V_SELLQTTY SELLQTTY, V_SELLAMT SELLAMT, V_SELLfeeamt SELLfeeamt, V_SELLtaxamt SELLtaxamt,
    MST.AUTOID, A0.CDCONTENT STATUS,
    A2.CDCONTENT DEALTYPE,
    MST.CUSTID, CF.CUSTODYCD, MST.TRANSDATE, SB.SYMBOL,
    MST.QTTY, MST.QTTY*MST.PRICE AMT, mst.feebrk feerate, mst.feeexc feevsd, mst.feecomm feehh,
    mst.feersv TL_KHTH, CF.FULLNAME, MST.PRICE,
    case when MST.BORS = 'S' and cf.vat = 'Y'  then to_number(sys.varvalue) else 0 end varvalue,
    getduedate(MST.TRANSDATE, 'B', '000', 1) nextdate
FROM BONDDEAL MST, CFMAST CF, SBSECURITIES SB, ALLCODE A0, ALLCODE A2,
    (SELECT CUSTID, FULLNAME FROM CFMAST UNION ALL SELECT 'NULL' CUSTID, '---' FULLNAME FROM DUAL) RCF,
    sysvar sys
WHERE MST.CUSTID=CF.CUSTID AND MST.CODEID=SB.CODEID AND NVL(MST.PCUSTID,'NULL') = RCF.CUSTID
    AND A0.CDTYPE='SY' AND A0.CDNAME='TYPESTS' AND A0.CDVAL=MST.STATUS
    AND A2.CDTYPE='SA' AND A2.CDNAME='BORS' AND A2.CDVAL=MST.BORS
    AND MST.BORS = 'S'
    AND MST.DEALTYPE='P' and varname = 'ADVSELLDUTY' and sys.grname = 'SYSTEM'
    AND CF.CUSTODYCD = V_STRCUSTODYCD
    AND MST.TRANSDATE = V_IDATE
    ;

EXCEPTION
   WHEN OTHERS
   THEN
      RETURN;
END;                                                              -- PROCEDURE

 
 
 
 
 
/
