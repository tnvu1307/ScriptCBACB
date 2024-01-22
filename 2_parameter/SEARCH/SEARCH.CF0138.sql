SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0138','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0138', 'Tạo yêu cầu mở tài khoản cho khách hàng nước ngoài( GD0138)', 'Create an account opening request for foreign customers (GD0138)', 'SELECT MST.CUSTID, MST.CUSTODYCD, MST.FULLNAME, MST.IDCODE, MST.IDDATE, MST.IDPLACE,
MST.IDTYPE, MST.COUNTRY, MST.ADDRESS, mst.MOBILESMS MOBILE, MST.EMAIL, MST.DESCRIPTION,
A0.<@CDCONTENT> VSD_IDTYPE, A1.<@CDCONTENT> VSD_COUNTRY,
A3.<@CDCONTENT> DESC_IDTYPE, A4.<@CDCONTENT> DESC_COUNTRY,MST.IDEXPIRED, MST.OPNDATE, A5.<@CDCONTENT> NSDSTATUS, nvl(tlp.tlname,'''') TLID ,
 nvl(tlp1.tlname,'''') LAST_OFID,MST.NSDSTATUS CFVSDSTATUS,MST.DATEOFBIRTH, MST.CUSTTYPE, A6.CDCONTENT CUSTTYPENAME, MST.SIDC, MST.PCOD, MST.TRADINGCODE
FROM CFMAST MST, ALLCODE A0, ALLCODE A1,ALLCODE A3, ALLCODE a4,allcode a5,tlprofiles tlp , ALLCODE a6, tlprofiles tlp1
where MST.NSDSTATUS=''O'' and mst.status != ''P''
AND A0.CDTYPE=''SA'' AND A0.CDNAME=''VSDIDTYPE'' AND A0.CDVAL=MST.IDTYPE
AND A1.CDTYPE=''CF'' AND A1.CDNAME=''NATIONAL'' AND A1.CDVAL=MST.COUNTRY
AND A3.CDTYPE=''CF'' AND A3.CDNAME=''IDTYPE'' AND A3.CDVAL=MST.IDTYPE
AND A4.CDTYPE=''CF'' AND A4.CDNAME=''COUNTRY'' AND A4.CDVAL=MST.COUNTRY
AND A5.CDTYPE=''SA'' AND A5.CDNAME=''NSDSTATUS'' AND A5.CDVAL=MST.NSDSTATUS
AND A6.Cdtype=''CF'' AND A6.CDNAME=''CUSTTYPE'' AND A6.CDVAL=MST.CUSTTYPE
AND MST.TLID= TLP.TLID (+)
AND NVL(MST.LAST_OFID,''XXX'')= tlp1.TLID (+)
AND MST.CUSTODYCD IS NOT NULL
AND MST.COUNTRY <> ''234''', 'CFMAST', 'frmSATLID', 'CUSTODYCD', '0138', NULL, 50, 'N', 30, 'NYNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;