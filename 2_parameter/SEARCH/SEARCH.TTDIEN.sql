SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TTDIEN','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TTDIEN', 'Điện gửi VSD', 'Sent to VSD', 'SELECT EXT.<@CDCONTENT> CAPTION,
       REPLACE(DECODE(EXT.FLDTYPE, ''N'', TO_CHAR(DTL.NVAL), DTL.OCVAL), CHR(10),DECODE(REQ.OBJNAME,''9999'','' '','''')) VALUE
FROM VSDTXREQ REQ,
(
    SELECT CAPTION CDCONTENT, EN_CAPTION EN_CDCONTENT, FLDNAME, TRFCODE, OBJNAME, FLDTYPE FROM VSDTXMAPEXT
) EXT,
(
    SELECT FLDNAME, REQID, OCVAL, NVAL FROM VSDTXREQDTL GROUP BY FLDNAME, REQID, OCVAL, NVAL
) DTL
WHERE REQ.REQID = DTL.REQID
AND EXT.TRFCODE = REQ.TRFCODE
AND EXT.OBJNAME = REQ.OBJNAME
AND EXT.FLDNAME = DTL.FLDNAME
AND REQ.REQID = ''<$KEYVAL>'' 
ORDER BY REQ.REQID DESC', 'MT.SHVTXREQ', 'frmRECFDEF', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;