SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('TTDIENHIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('TTDIENHIST', 'Điện gửi VSD', 'Sent to VSD', 'SELECT EXT.<@CDCONTENT> CAPTION,
replace(decode(ext.fldtype, ''N'', to_char(nval), ocval),CHR(10),decode(REQ.OBJNAME,''9999'','' '','''')) VALUE
  FROm (select   CAPTION CDCONTENT, EN_CAPTION EN_CDCONTENT, FLDNAME,TRFCODE,OBJNAME,fldtype from VSDTXMAPEXT) EXT, VSDTXREQHIST REQ, VSDTXREQDTLHIST DTL
 WHERE REQ.REQID = DTL.REQID
   AND EXT.TRFCODE = REQ.TRFCODE
   AND EXT.OBJNAME = REQ.OBJNAME
   AND EXT.FLDNAME = DTL.FLDNAME
   AND REQ.REQID = ''<$KEYVAL>'' order by REQ.REQID desc', 'ST.TTDIEN', 'frmRECFDEF', NULL, NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;