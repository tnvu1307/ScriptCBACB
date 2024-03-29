SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI1114','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI1114', 'Tra cứu lệnh chuyển khoản sang Ngân hàng khác để từ chối (1114)', 'View pending transfer to other bank to reject (1114)', 'SELECT FN_GET_LOCATION(af.brid) LOCATION, CF.FULLNAME,T1.TLNAME MAKER,T2.TLNAME OFFICER,
SUBSTR(CF.CUSTODYCD,1,3) || ''.'' || SUBSTR(CF.CUSTODYCD,4,1) || ''.'' || SUBSTR(CF.CUSTODYCD,5,6) CUSTODYCD,
CD1.CDCONTENT DESC_IDTYPE, CF.IDCODE, SUBSTR(AF.ACCTNO,1,4) || ''.'' || SUBSTR(AF.ACCTNO,5,6) ACCTNO,
CF.CUSTID, RM.TXDATE, RM.TXNUM, RM.TXNUM||TO_CHAR(RM.TXDATE,''DD/MM/YYYY'')REFKEY ,
RM.BANKID,RM.BENEFBANK,RM.CITYBANK,RM.CITYEF, RM.BENEFACCT, RM.BENEFCUSTNAME, RM.BENEFLICENSE, RM.BENEFIDDATE, RM.BENEFIDPLACE,
RM.AMT, RM.FEEAMT, RM.VAT , AF.ACCTNO || '' : '' || ''Từ chối chuyển khoản tiền ra ngân hàng/'' || CF.CUSTODYCD DESCRIPTION, A1.CDCONTENT FEENAME,RM.FEETYPE
FROM CIREMITTANCE RM, AFMAST AF, CFMAST CF, ALLCODE A1,  ALLCODE CD1,
(SELECT TLID, TLNAME FROM TLPROFILES UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL) T1,
(SELECT TLID, TLNAME FROM TLPROFILES  UNION ALL SELECT ''____'' TLID, ''____'' TLNAME FROM DUAL) T2,
(SELECT * FROM
        (SELECT * FROM TLLOG WHERE TLTXCD in (''1101'',''1108'',''1111'',''1119'',''1133'') UNION SELECT * FROM TLLOGALL WHERE TLTXCD in (''1101'',''1108'',''1111'',''1119'',''1133'')) TL
          where ''<$BRID>'' =''0001''   OR ''<$BRID>'' =tl.BRID    ) tl
WHERE CF.CUSTID=AF.CUSTID AND RM.ACCTNO=AF.ACCTNO AND RM.DELTD=''N'' AND RM.RMSTATUS=''P'' AND TL.TXNUM=RM.TXNUM AND TL.TXDATE=RM.TXDATE
AND CD1.CDTYPE=''CF'' AND CD1.CDNAME=''IDTYPE'' AND CD1.CDVAL=CF.IDTYPE
AND A1.CDTYPE=''SA'' AND A1.CDNAME=''IOROFEE'' AND A1.CDVAL= NVL(RM.FEETYPE,''0'')
AND (CASE WHEN TL.TLID IS NULL THEN ''____'' ELSE TL.TLID END)=T1.TLID
AND (CASE WHEN TL.OFFID IS NULL THEN ''____'' ELSE TL.OFFID END)=T2.TLID', 'CI.CIMAST', NULL, NULL, '1114', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;