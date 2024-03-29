SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CA3334','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CA3334', 'Danh sách khách hàng đi tiền chuyển nhượng quyền mua', 'List of customers on money right issue transfer', 'SELECT MST.AUTOID, MST.CAMASTID, MST.NOTRANSCT, SB1.SYMBOL, SB2.SYMBOL TOSYMBOL,
    MST.TOACCTNO TOCUSTODYCD,CF.CIFID TOCIFID, MST.CUSTNAME2,MST.IDDATE2, --Ben Mua
    MST.CUSTODYCD,CF1.CIFID,MST.CUSTNAME FULLNAME, MST.IDDATE, --Ben Ban
    MST.REMOACCOUNT, MST.CITAD,MST.TOMEMCUS,MST.AMT QTTY,MST.TRANSFERPRICE EXPRICE,MST.AMT*MST.TRANSFERPRICE AMOUNT,
    CF1.MCUSTODYCD
FROM CATRANSFER MST, SBSECURITIES SB1, SBSECURITIES SB2, CFMAST CF1, CFMAST CF --them CF check thong tin tai khoan
, camast ca
WHERE MST.CODEID=SB1.CODEID
AND MST.OPTCODEID=SB2.CODEID
AND MST.STATUS=''H'' AND (MST.MSGSTATUS IN (''S'',''C'') OR MST.OPTSEACCTNODR IS NULL)
AND MST.THGOMONEY=''Y''
AND MST.TOACCTNO=CF.CUSTODYCD
AND MST.CUSTODYCD=CF1.CUSTODYCD(+)
and mst.camastid = ca.camastid
--Kiem tra tai khoan luu ky tai SHV moi di tien
AND CF.CUSTATCOM=''Y''', 'CAMAST', NULL, NULL, '3334', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;