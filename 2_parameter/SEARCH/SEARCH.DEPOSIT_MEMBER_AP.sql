SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('DEPOSIT_MEMBER_AP','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('DEPOSIT_MEMBER_AP', 'Quản lý thành viên lưu ký', 'Deposit member management', 'SELECT DEPOSITID, SHORTNAME,FULLNAME, OFFICENAME, ADDRESS,PHONE, FAX,DESCRIPTION,BICCODE,INTERBICCODE  FROM DEPOSIT_MEMBER WHERE 0=0 ', 'DEPOSIT_MEMBER', 'frmDEPOSIT_MEMBER', '', '', NULL, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;