SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0075','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0075', 'Tra cứu trạng thái gửi SMS và Email', 'SMS/Email sent status', '
SELECT DISTINCT v.TLTXCD ,tltx.txdesc FROM V_APPMAP_BY_TLTXCD v,tltx  WHERE FIELD=''BALANCE''
AND v.TLTXCD NOT IN (SELECT TLTXCD FROM APPMAPBRAVO)
and v.TLTXCD = tltx.tltxcd
', 'CFLINK', NULL, NULL, NULL, NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;