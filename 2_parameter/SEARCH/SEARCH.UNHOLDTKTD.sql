SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('UNHOLDTKTD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('UNHOLDTKTD', 'Unhold số tiền phong tỏa trong ngày', 'Unhold blockade amount of the day', 'SELECT FL.*, TL.TXNUM REQTXNUM
FROM TLLOG TL, CFMAST CF,
(
    SELECT TXNUM, TXDATE,
    MAX(CASE WHEN F.FLDCD = ''88'' THEN F.CVALUE ELSE '''' END) CUSTODYCD,
    MAX(CASE WHEN F.FLDCD = ''03'' THEN F.CVALUE ELSE '''' END) DDACCTNO,
    MAX(CASE WHEN F.FLDCD = ''90'' THEN F.CVALUE ELSE '''' END) CUSTNAME,
    MAX(CASE WHEN F.FLDCD = ''89'' THEN F.CVALUE ELSE '''' END) CIFID,
    MAX(CASE WHEN F.FLDCD = ''91'' THEN F.CVALUE ELSE '''' END) ADDRESS,
    MAX(CASE WHEN F.FLDCD = ''92'' THEN F.CVALUE ELSE '''' END) LICENSE,
    MAX(CASE WHEN F.FLDCD = ''93'' THEN F.CVALUE ELSE '''' END) BANKACCT,
    MAX(CASE WHEN F.FLDCD = ''95'' THEN F.CVALUE ELSE '''' END) BANKNAME,
    MAX(CASE WHEN F.FLDCD = ''10'' THEN F.NVALUE ELSE  0 END) AMOUNT,
    MAX(CASE WHEN F.FLDCD = ''30'' THEN F.CVALUE ELSE '''' END) NOTE
    FROM TLLOGFLD F
    WHERE FLDCD IN (''88'', ''03'', ''90'', ''89'', ''91'',''92'',''93'',''95'',''10'',''30'')
    GROUP BY TXNUM, TXDATE
) FL
WHERE TL.TLTXCD = ''6603''
AND TL.TXNUM = FL.TXNUM
AND TL.TXDATE = FL.TXDATE
AND FL.CUSTODYCD = CF.CUSTODYCD
AND NOT EXISTS (
    SELECT FL2.CVALUE
    FROM TLLOG F2, TLLOGFLD FL2
    WHERE F2.TXNUM = FL2.TXNUM
    AND F2.TXDATE = FL2.TXDATE
    AND F2.TLTXCD = ''6604''
    AND FL2.FLDCD = ''96''
    AND F2.TXSTATUS IN(''1'', ''4'')
    AND FL2.CVALUE =  TL.TXNUM
)
ORDER BY TL.TXNUM', 'UNHOLDTKTD', '', '', '6604', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', '', 'N', '');COMMIT;