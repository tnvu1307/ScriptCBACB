SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('LISTBA190002','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('LISTBA190002', 'Danh sách trái phiếu theo dõi', 'List of bonds agent', 'SELECT sb.CODEID, sb.SYMBOL, sb.issuerid, iss.fullname
FROM SBSECURITIES sb, ISSUERS iss
WHERE SECTYPE IN (''003'', ''006'', ''222'')
      --AND ROLEOFSHV IN (''002'', ''003'', ''004'')
      AND sb.CONTRACTNO IS NOT NULL
      AND iss.issuerid = sb.issuerid', 'LISTBA190002', NULL, NULL, NULL, 0, 1000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;