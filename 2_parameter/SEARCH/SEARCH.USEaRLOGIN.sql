SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('USEaRLOGIN','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('USEaRLOGIN', 'Thông tin đăng ký dịch vụ trực tuyến', 'Online service registration information', 'select * from (select ul.username,''***************'' loginpwd, ul.email,ul.handphone, a1.cdcontent AUTHTYPE, ul.ROLECD  from USERLOGIN ul inner join allcode a1 on ul.authtype = a1.cdval where a1.cdtype = ''CF'' and a1.cdname = ''OTAUTHTYPE'' order by ul.lastchanged desc) where 0 = 0', 'USERLOGIN', 'frmUSERLOGIN', '', '', 0, 5000, 'N', 1, 'YYYYYYYYYYN', 'Y', 'T', '', 'N', '');COMMIT;