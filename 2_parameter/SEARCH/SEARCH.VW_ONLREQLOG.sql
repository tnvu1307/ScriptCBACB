SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('VW_ONLREQLOG','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('VW_ONLREQLOG', 'Chi tiết', 'Detail', 'SELECT FL.ODRNUM, FL.<@CDCONTENT> CAPTION, NVL(A1.<@CDCONTENT>, (CASE WHEN FL.DATATYPE = ''N'' THEN TO_CHAR(TF.NVALUE) ELSE TF.CVALUE END)) VALUE
FROM ONLREQUESTLOG OL, VW_TLLOGFLD_ALL TF,
(
    SELECT OBJNAME, FLDNAME, DATATYPE, ODRNUM, CAPTION CDCONTENT, EN_CAPTION EN_CDCONTENT FROM FLDMASTER
) FL,
(SELECT * FROM ALLCODE WHERE CDNAME = ''TRAN_PHY_TYPE'') A1
WHERE OL.TXDATE = TF.TXDATE
AND OL.TXNUM = TF.TXNUM
AND OL.TLTXCD = FL.OBJNAME
AND TF.FLDCD = FL.FLDNAME
AND (CASE WHEN FL.DATATYPE = ''N'' THEN TO_CHAR(TF.NVALUE) ELSE TF.CVALUE END) = A1.CDVAL(+)
AND OL.AUTOID = <$KEYVAL>
ORDER BY FL.ODRNUM', 'VW_ONLREQLOG', '', '', '', NULL, 1000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;