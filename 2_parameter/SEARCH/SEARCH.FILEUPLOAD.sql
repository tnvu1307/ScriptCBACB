SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('FILEUPLOAD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('FILEUPLOAD', 'Quản lý file', 'Management of the file', 'SELECT F.AUTOID, A1.<@CDCONTENT> BUSINESS, A2.CDCONTENT DOCTYPE,  F.CLIENT, F.CONTRACTNO, F.CREATEDATE, F.CUSTODYCD,
       F.FILENO, F.NOTE, F.TICKER, TL.TLNAME TLID, F.TXDATE, F.TXNUM, CF.FULLNAME
FROM FILEUPLOAD F, TLPROFILES TL, CFMAST CF,
     (SELECT * FROM ALLCODE WHERE CDNAME = ''FILEUPLOAD_BUSINESS'') A1,
     (SELECT * FROM FILEUPLOADDOCTYPE) A2
WHERE F.BUSINESS = A1.CDVAL 
AND F.DOCTYPE = NVL(A2.OLD_KEY, TO_CHAR(A2.AUTOID))
AND F.TLID = TL.TLID
AND F.CUSTODYCD = CF.CUSTODYCD(+)', 'FILEUPLOAD', 'frmFILEUPLOAD', 'autoid desc', '', 0, 5000, 'N', 1, 'YYYYYYYNNNN', 'Y', 'T', '', 'N', '');COMMIT;