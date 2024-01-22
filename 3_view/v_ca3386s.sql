SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CA3386S
(CAMASTID, AFACCTNO, CODEID, CUSTODYCD, CATYPE, 
 PBALANCE, BALANCE, QTTY, NMQTTY, MAXQTTY, 
 AAMT, ISCOREBANK, COREBANK, SYMBOL, STATUS, 
 SEACCTNO, OPTSEACCTNO, PARVALUE, REPORTDATE, ACTIONDATE, 
 EXPRICE, DESCRIPTION, FULLNAME, AUTOID, SYMBOL_ORG, 
 ISINCODE, REFCODE, CONNECTS, TRFACCTNO)
AS 
SELECT   SUBSTR(MST.CAMASTID,1,4) || '.' || SUBSTR(MST.CAMASTID,5,6) || '.' || SUBSTR(MST.CAMASTID,11,6) CAMASTID,
 CA.AFACCTNO, MST.TOCODEID CODEID, CF.CUSTODYCD , A2.CDCONTENT CATYPE, CA.PBALANCE ,
round( (CAR.QTTY - CAR.CANCELQTTY ) * SUBSTR(MST.RIGHTOFFRATE,0,INSTR(MST.RIGHTOFFRATE,'/')-1) / SUBSTR(MST.RIGHTOFFRATE,INSTR(MST.RIGHTOFFRATE,'/')+1),0) BALANCE,
(CAR.QTTY - CAR.CANCELQTTY )  QTTY, NVL(ca.nmqtty,0) NMQTTY,
(CAR.QTTY - CAR.CANCELQTTY )  MAXQTTY , ((car.qtty  - car.cancelqtty) * MST.EXPRICE) AAMT ,
(CASE WHEN CI.COREBANK ='Y' THEN 0 ELSE 1 END) ISCOREBANK, (CASE WHEN CI.COREBANK ='Yes' THEN 'Y' ELSE 'No' END) COREBANK,
 SYM.SYMBOL, A1.CDCONTENT STATUS,
 (CA.AFACCTNO ||(CASE WHEN MST.ISWFT='Y' THEN (SELECT CODEID FROM SBSECURITIES WHERE REFCODEID =SYM.CODEID ) ELSE MST.TOCODEID END))SEACCTNO,
 CA.AFACCTNO||MST.OPTCODEID OPTSEACCTNO, SYM.PARVALUE PARVALUE, MST.REPORTDATE REPORTDATE,
 MST.ACTIONDATE,MST.EXPRICE, MST.description,  ISS.fullname ,ca.autoid,
 SYM_ORG.SYMBOL SYMBOL_ORG, MST.isincode, CAR.REQTXNUM REFCODE, 'Y' CONNECTS, CAR.TRFACCTNO
FROM (SELECT CAMASTID,CUSTODYCD,AFACCTNO,TRFACCTNO,SUM(QTTY) QTTY,SUM(AMT) AMT,sum(CANCELQTTY) CANCELQTTY, VSDSTOCKTYPE,REQTXNUM
        FROM CAREGISTER CAR
        WHERE CAR.QTTY - CAR.CANCELQTTY > 0
        AND CAR.REQTXNUM IS NOT NULL
        AND CAR.MSGSTATUS IN ('P') AND CAR.DELTD <> 'Y'
        GROUP BY CAMASTID,CUSTODYCD,AFACCTNO,TRFACCTNO,VSDSTOCKTYPE,REQTXNUM
    ) CAR,
    SBSECURITIES SYM, ALLCODE A1, CAMAST MST, CASCHD  CA, AFMAST AF,
    CFMAST CF , DDMAST CI, ISSUERS ISS, ALLCODE A2 ,SBSECURITIES SYM_ORG, CRBTXREQ REQ
WHERE  CAR.CAMASTID = CA.CAMASTID
      AND CAR.AFACCTNO = CA.AFACCTNO
      AND AF.ACCTNO = CI.AFACCTNO
      AND MST.CAMASTID = CA.CAMASTID
      AND A1.CDTYPE = 'CA' AND A1.CDNAME = 'CASTATUS' AND A1.CDVAL = CA.STATUS
      AND nvl(MST.TOCODEID,MST.CODEID) = SYM.CODEID
      AND MST.catype='014'
      AND CA.AFACCTNO = AF.ACCTNO AND ISS.issuerid = sym.issuerid
      AND MST.CATYPE = A2.CDVAL AND A2.CDTYPE = 'CA'
      AND A2.CDNAME = 'CATYPE' AND AF.CUSTID = CF.CUSTID AND CA.status IN( 'M')
      AND CA.status <>'Y' AND CA.balance > 0
      AND MST.CODEID = SYM_ORG.CODEID
      AND CAR.reqtxnum=REQ.reqtxnum(+)
      AND NVL(REQ.status,'E') = 'C'
/
