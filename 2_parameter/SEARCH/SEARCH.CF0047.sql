SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0047','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0047', 'Thông tin khách hàng', 'Customer information', 'SELECT CF.CUSTID, CF.CUSTODYCD, CF.FULLNAME, CF.IDCODE, CF.IDPLACE, CF.MOBILESMS,
      (A0.CDCONTENT) ISDEPOFREE, CF.FREEFRDATE, CF.FREETODATE,
      GETCURRDATE FRDATE, FN_GET_NEXTDATE(GETCURRDATE,TO_NUMBER(SY.VARVALUE)) TODATE
FROM CFMAST CF, SYSVAR SY,ALLCODE A0
WHERE SY.VARNAME = ''FREEDEPOFEEDATES''
      AND A0.CDNAME = ''YESNO''
      AND A0.CDTYPE = ''SY''
      AND A0.CDVAL = CF.ISDEPOFREE', 'CFMAST', 'frmCFMAST', NULL, '0047', 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;