SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('USERLOGIN_CF','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('USERLOGIN_CF', 'Tra cứu thông tin khách hàng và thành viên có tài khoản', 'Search member and customer', 'select * from (select USERNAME, FULLNAME, cf.EMAIL , cf.ADDRESS, cf.MOBILE   from cfmast cf
union
select USERNAME , FULLNAME, cf.EMAIL , cf.ADDRESS, TELEPHONE MOBILE from famembers cf) data where data.username is not null', 'USERLOGIN_CF', '', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;