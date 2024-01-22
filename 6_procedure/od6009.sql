SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE od6009(
   PV_REFCURSOR           IN OUT   PKG_REPORT.REF_CURSOR,
   OPT                    IN       VARCHAR2,
   BRID                   IN       VARCHAR2,
   F_DATE                 IN       VARCHAR2, /*TU NGAY */
   T_DATE                 IN       VARCHAR2, /*DEN NGAY */
   P_BRK                  IN       VARCHAR2 /*SO TK LUU KY */
   )
IS
    -- REPORT ON THE DAY BECOME/IS NO LONGER MAJOR SHAREHOLDER, INVESTORS HOLDING 5% OR MORE OF SHARES
    -- PERSON      DATE                 COMMENTS
    -- ---------   ------               -------------------------------------------
    -- THOAI.TRAN    11-11-2019           CREATED
    V_STROPTION    VARCHAR2 (5);       -- A: ALL; B: BRANCH; S: SUB-BRANCH
    V_STRBRID      VARCHAR2 (4);       -- USED WHEN V_NUMOPTION > 0

    V_FROMDATE          DATE;
    V_TODATE            DATE;
    V_BRK               VARCHAR(20);
   BEGIN
     V_STROPTION := OPT;
     IF V_STROPTION = 'A' THEN
        V_STRBRID := '%';
     ELSIF V_STROPTION = 'B' THEN
        V_STRBRID := SUBSTR(BRID,1,2) || '__' ;
     ELSE
        V_STRBRID:=BRID;
     END IF;
     IF (P_BRK = 'ALL') THEN
        V_BRK := '%';
     ELSE
        V_BRK:= P_BRK;
     END IF;
    V_FROMDATE  :=     TO_DATE(F_DATE, SYSTEMNUMS.C_DATE_FORMAT);
    V_TODATE    :=     TO_DATE(T_DATE, SYSTEMNUMS.C_DATE_FORMAT);
OPEN PV_REFCURSOR FOR
    SELECT OD.ID,OD.BANKNAME,OD.CITADCODE,OD.BANKACCTNO,OD.CUSTOMERNAME,OD.CUSSHORTNAME,
           SUM(AMOUNT) AMOUNT,OD.CLEARDATE,
           OD.PAYMENTINSTRUCTION, OD.INSTRUCTION3, OD.INSTRUCTION4
    FROM (
        SELECT FA.AUTOID ID,FA.BANKNAME BANKNAME,FA.BANKCITADCODE CITADCODE,FA.BANKACCTNO BANKACCTNO,FA.FULLNAME CUSTOMERNAME, FA.SHORTNAME CUSSHORTNAME,
               ST.FEEAMT + ST.VAT + OD.TAXRATE AMOUNT,'VALUE DATE: '||TO_CHAR(OD.CLEARDATE,'dd Mon yyyy')||' Broker fee' CLEARDATE,
               (CASE WHEN ST.FEEAMT <> 0 THEN 'TAX' ELSE '' END) PAYMENTINSTRUCTION,
               SUBSTR(FA.BRANCHNAME,1,35) INSTRUCTION3, SUBSTR(FA.BRANCHNAME,36) INSTRUCTION4
        FROM FAMEMBERS FA,vw_odmast_all  OD, vw_stschd_all  ST
        WHERE OD.ORDERID=ST.ORDERID
        AND FA.AUTOID=OD.MEMBER
        AND ST.DUETYPE IN ('SS','SM')
        AND (ST.FEEAMT<>0 OR OD.TAXRATE<>0)
        AND OD.CLEARDATE BETWEEN V_FROMDATE AND V_TODATE
        AND FA.SHORTNAME LIKE V_BRK
    )OD
    GROUP BY OD.ID,OD.BANKNAME,OD.CITADCODE,OD.BANKACCTNO,OD.CUSTOMERNAME,OD.CUSSHORTNAME,OD.CLEARDATE,
    OD.PAYMENTINSTRUCTION, OD.INSTRUCTION3, OD.INSTRUCTION4;
EXCEPTION
  WHEN OTHERS
   THEN
      PLOG.ERROR ('OD6009: ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN;
END;
/
