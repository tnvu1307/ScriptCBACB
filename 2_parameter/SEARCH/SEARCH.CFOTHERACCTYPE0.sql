SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFOTHERACCTYPE0','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFOTHERACCTYPE0', 'Thông tin đăng ký chuyển tiền trực tuyến tiểu khoản đã đang ký', 'Online money transfer information', 'SELECT  CFO.CIACCOUNT,CF2.CUSTODYCD, CF2.FULLNAME, CF2.IDCODE, CF2.IDPLACE, CF2.IDDATE from CFOTHERACC cfo, cfmast cf, CFMAST CF2,AFMAST AF where cfo.cfcustid = cf.custid(+) 
and type = ''0''  AND CFO.CIACCOUNT = AF.ACCTNO AND AF.CUSTID = CF2.CUSTID 
group by CF2.FULLNAME, CF2.IDCODE, CF2.IDPLACE, CF2.IDDATE,CF2.CUSTODYCD,CFO.CIACCOUNT', 'CFOTHERACC', 'frmAFOTHERACC', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;