SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CI0035','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CI0035', 'Danh sách bảng kê ứng trước', 'List of advance payment ', 'SELECT AD.AUTOID, AD.TXNUM, AD.TXDATE, AD.ACCTNO, AD.AMT, AD.FEEAMT, AD.DELTD,
AD.BRID, BR.BRNAME,  AD.TLID, TL.TLNAME,
''Huy bang ke UTTB Ngay: '' || AD.TXDATE || '' So: '' || AD.TXNUM || '''' DESCRIPTION, A1.CDCONTENT STATUS, CF.FULLNAME
FROM ADMAST AD, CFMAST CF, ALLCODE A1, BRGRP BR, TLPROFILES TL
WHERE AD.ACCTNO = CF.CUSTID AND AD.STATUS=''P'' AND AD.STATUS =A1.CDVAL AND A1.CDTYPE =''AD'' AND A1.CDNAME =''STATUS''
AND BR.BRID = AD.BRID AND TL.TLID=AD.TLID
/*AND AD.TXDATE=TO_DATE(''<$BUSDATE>'',''DD/MM/RRRR'')*/ ', 'CIMAST', NULL, NULL, '0035', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;