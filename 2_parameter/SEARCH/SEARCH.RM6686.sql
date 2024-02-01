SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM6686','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM6686', 'Tra cứu danh sách bảng kê chờ huỷ (6686)', 'View EOD report waiting for cancel (6686)', 'SELECT MST.AUTOID, MST.VERSION,MST.VERSIONLOCAL, MST.TXDATE, MST.REFBANK,NVL(CRB.BANKNAME,MST.REFBANK) BANKNAME
, MST.CREATETST, MST.SENDTST,FN_CRB_GETVOUCHERNO(MST.TRFCODE, MST.TXDATE, MST.VERSION) VOUCHERNO,MST.TRFCODE,MST.STATUS,
A0.CDCONTENT DESC_STATUS,ERR.ERRDESC, A1.CDCONTENT DESC_TRFCODE,MST.NOTES,MST.TLID,TL.TLNAME,MST.OFFID,TL1.TLNAME OFFNAME
FROM CRBTRFLOG MST, ALLCODE A0, ALLCODE A1,TLPROFILES TL,TLPROFILES TL1,CRBDEFBANK CRB,DEFERROR ERR
WHERE MST.TLID=TL.TLID(+) AND MST.OFFID = TL1.TLID(+) AND MST.ERRCODE=ERR.ERRNUM(+)
AND MST.REFBANK=CRB.BANKCODE(+) AND A0.CDTYPE=''RM'' AND A0.CDNAME=''TRFLOGSTS''
AND A0.CDVAL=MST.STATUS AND A1.CDTYPE=''SY'' AND A1.CDNAME=''TRFCODE''
AND MST.TRFCODE NOT IN (
    SELECT DISTINCT TRFCODE FROM CRBDEFACCT WHERE cspks_rmproc.is_number(MSGID)=1
)
AND A1.CDVAL=MST.TRFCODE AND MST.STATUS IN (''A'')', 'CRBTRFLOG', NULL, NULL, '6686', 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;