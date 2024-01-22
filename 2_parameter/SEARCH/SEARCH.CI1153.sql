SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1153','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1153', 'Ứng trước lệnh bán theo ngày (1153)', 'View available order for advance payment (1153)', '
SELECT FN_GET_LOCATION(substr(ACCTNO,1,4)) LOCATION, CUSTODYCD, CUSTID, FULLNAME,IDCODE, IDTYPE, IDDATE,IDPLACE, ADDRESS, ACCTNO, AUTOADV, ACTYPE, TRFBANK, COREBANK,
BANKACCT, BANKCODE, CLEARDATE, TXDATE, CURRDATE, GREATEST(MAXAVLAMT-ROUND(DEALPAID,0),0) MAXAVLAMT, EXECAMT, AMT,
AAMT, PAIDAMT, PAIDFEEAMT, BRKFEEAMT, RIGHTTAX, INCOMETAXAMT, DAYS, CASE WHEN ISVSD = ''N'' THEN 0 ELSE 1 END ISVSDFAKE, ISVSD
FROM (
    SELECT VW.CUSTODYCD, VW.CUSTID, VW.FULLNAME, VW.ACCTNO, VW.AUTOADV, VW.ACTYPE, VW.TRFBANK, VW.COREBANK,
    VW.BANKACCT, VW.BANKCODE, VW.CLEARDATE, VW.TXDATE, VW.CURRDATE, VW.MAXAVLAMT, VW.EXECAMT, VW.AMT,
    VW.AAMT, VW.PAIDAMT, VW.PAIDFEEAMT, VW.BRKFEEAMT, VW.RIGHTTAX, VW.INCOMETAXAMT, VW.DAYS,
    (CASE WHEN VW.TXDATE =TO_DATE(SYS.VARVALUE,''DD/MM/RRRR'') AND ISVSD=''N'' THEN fn_getdealgrppaid(VW.ACCTNO) ELSE 0 END)*
    (1+ADT.ADVRATE/100/365*VW.days) DEALPAID,CF.IDCODE, CF.IDTYPE, CF.IDDATE, CF.IDPLACE, CF.ADDRESS, ISVSD
    FROM VW_ADVANCESCHEDULE VW, SYSVAR SYS,AFMAST AF, AFTYPE AFT ,ADTYPE ADT,CFMAST CF
    WHERE SYS.GRNAME=''SYSTEM'' AND SYS.VARNAME =''CURRDATE''
    AND VW.ACCTNO = AF.ACCTNo AND AF.ACTYPE=AFT.ACTYPE AND AFT.ADTYPE=ADT.ACTYPE
  AND CF.CUSTID = AF.CUSTID
) WHERE 0=0
', 'CIMAST', '', '', '', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;