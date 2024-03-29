SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM0013','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM0013', 'Tra cứu lịch sử HOLD/ UHOLD chứng khoán', 'Look up history of HOLD/ UNHOLD securities', 'SELECT TXNUM,SYMBOL,QTTY,TLNAME,TXTIME,SHORTNAME,BRNAME,BRPHONE,NOTE,STATUS,STATUSTEXT,SEACCOUNT,MEMBERID,BRNAMEID,BRPHONEID,TRADINGDATE,CUSTODYCD,FULLNAME,
       (CASE WHEN TXDESC LIKE ''Unhold%'' THEN ''Unhold'' ELSE ''Hold'' END) TXDESC    
FROM (
    SELECT L.TXNUM,X.EN_TXDESC TXDESC,L.MSGACCT SEACCOUNT,L.CFCUSTODYCD CUSTODYCD,L.CFFULLNAME FULLNAME,F.SYMBOL,L.MSGAMT QTTY,P.TLNAME,L.TXTIME,M.SHORTNAME,MX1.EXTRAVAL BRNAME,
           MX2.EXTRAVAL BRPHONE, NOTE, L.TXSTATUS STATUS, A.<@CDCONTENT> STATUSTEXT,F.MEMBERID ,F.BRNAME BRNAMEID, F.BRPHONE BRPHONEID, L.TXDATE TRADINGDATE
    FROM VW_TLLOG_ALL L, TLTX X, FAMEMBERS M, FAMEMBERSEXTRA MX1, FAMEMBERSEXTRA MX2, TLPROFILES P,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''TXSTATUS'' AND CDTYPE =''SY'')A,
    (
        SELECT TXDATE,TXNUM,
        MAX(CASE WHEN F.FLDCD = ''05'' THEN F.CVALUE ELSE '''' END)  MEMBERID,
        MAX(CASE WHEN F.FLDCD = ''06'' THEN F.CVALUE ELSE '''' END)  BRNAME,
        MAX(CASE WHEN F.FLDCD = ''07'' THEN F.CVALUE ELSE '''' END)  BRPHONE,
        MAX(CASE WHEN F.FLDCD = ''14'' THEN F.CVALUE ELSE '''' END)  SYMBOL,
        MAX(CASE WHEN F.FLDCD = ''30'' THEN F.CVALUE ELSE '''' END)  NOTE
        FROM VW_TLLOGFLD_ALL F
        WHERE FLDCD IN (''05'', ''06'', ''07'', ''14'',''30'')
        GROUP BY TXDATE,TXNUM
    ) F
    WHERE L.TXNUM = F.TXNUM 
    AND L.TXDATE = F.TXDATE 
    AND L.TLID = P.TLID
    AND F.MEMBERID = M.AUTOID
    AND TO_CHAR(MX1.AUTOID) = F.BRNAME
    AND TO_CHAR(MX2.AUTOID) = F.BRPHONE
    AND A.CDVAL=L.TXSTATUS
    AND L.TLTXCD IN (''2212'',''2213'')
    AND L.TLTXCD = X.TLTXCD
 ) WHERE 0=0', 'RM0013', NULL, 'TRADINGDATE DESC, TXTIME DESC', NULL, 0, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'Y', 'ACCTNO');COMMIT;