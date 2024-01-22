SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CF0088','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CF0088', 'Tra cứu đóng tài khoản', 'View account for closing', 'SELECT DISTINCT
        CF.CUSTODYCD,
        CF.FULLNAME,
        CF.IDCODE,
        CF.IDDATE,
        CF.IDPLACE,
        CF.ADDRESS,
        CF.MOBILESMS PHONE,
        AF.ACCTNO AFACCTNO,
        '''' TYPENAME,
        A0.CDCONTENT STATUS,
        CF.MARGINCONTRACTNO,
       -- DD.BALANCE
        0 BALANCE
FROM CFMAST CF, AFMAST AF, ALLCODE A0--,DDMAST DD
WHERE CF.CUSTID = AF.CUSTID
AND A0.CDTYPE=''CF'' AND A0.CDNAME=''STATUS''
AND A0.CDVAL=AF.STATUS
AND CF.STATUS =''A'' AND AF.STATUS =''A''
--AND AF.ACCTNO = DD.AFACCTNO
--AND DD.ISDEFAULT=''Y'' AND DD.STATUS=''A''
AND ((NOT EXISTS ( SELECT F.CVALUE FROM TLLOG TL, TLLOGFLD F WHERE TL.TXNUM = F.TXNUM AND
                                    TL.TXDATE = F.TXDATE AND TL.TLTXCD = ''0088'' AND F.FLDCD
                                    = ''32'' AND TL.TXSTATUS IN(''1'', ''4'') AND F.CVALUE = CF.IDCODE)
    and cf.trusteeid = 0) OR cf.trusteeid <> 0)', 'CFLINK', '', '', '0088', NULL, 5000, 'N', 30, 'NYNNYYYNNY', 'Y', 'T', '', 'N', '');COMMIT;