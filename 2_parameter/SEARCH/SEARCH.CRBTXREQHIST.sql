SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBTXREQHIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBTXREQHIST', 'Quản lý lịch sử thông tin điện gửi qua ngân hàng', 'Bank request management hist', 'SELECT * FROM (
    SELECT distinct R.REQID,R.OBJKEY TXNUM,R.TRFCODE,N.DESCRIPTION REQCODE,NVL(R.REQTXNUM,R.OBJKEY) REQTXNUM,
            CASE WHEN R.TRFCODE LIKE ''PAYMENTINTEREST%'' THEN NULL 
                when r.trfcode in( ''SCOA'') then gl.custodycd
            ELSE NVL(D.CUSTODYCD, '''') END CUSTODYCD,R.TXDATE,
            R.BANKACCT,RBANKACCOUNT,RBANKNAME,
            R.CURRENCY CURRENCY,
            R.TXAMT AMOUNT, R.STATUS,A.<@CDCONTENT> STATUSTEXT,R.ERRORDESC, R.REFVAL,
            to_char(R.CREATEDATE,''dd/MM/yyyy hh24:mi:ss'')CREATEDATE,
            R.RBANKCITAD,R.FEEAMT,R.TAXAMT, a2.<@CDCONTENT> FEETYPE,R.FEECODE,R.NOTES,
            (case when R.trfcode = ''CITAD'' AND R.FEETYPE = ''3'' then R.TXAMT - nvl(R.FEEAMT,0) - nvl(R.TAXAMT,0)
                  WHEN R.trfcode = ''CITAD'' AND R.FEETYPE <> ''3'' THEN R.TXAMT ELSE 0 END ) NETAMT,
            CF.MASTERCIF CIFID
    FROM CRBTXREQHIST R, CRBTRFCODE N, GL_EXP_RESULTS gl,
    (SELECT NVL(CF.MCIFID, CF.CIFID) MASTERCIF FROM CFMAST CF GROUP BY NVL(CF.MCIFID, CF.CIFID)) CF,
    (SELECT * FROM DDMAST WHERE STATUS <> ''C'') D,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''RMSTATUS'' AND CDTYPE = ''CI'') A,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''IOROFEE'' AND CDTYPE = ''SA'') A2
    WHERE R.STATUS = A.CDVAL
    AND R.REQCODE = N.TRFCODE(+)
    AND R.BANKACCT= D.REFCASAACCT(+)
    AND R.AFACCTNO =  CF.MASTERCIF(+)
    and r.reqtxnum = gl.bankreqid(+)
    AND R.FEETYPE=A2.CDVAL(+)
    AND R.trfcode NOT IN (''CA3387_CITAD'')
    
    UNION ALL
    SELECT distinct R.REQID,R.OBJKEY TXNUM,R.TRFCODE,N.DESCRIPTION REQCODE,NVL(R.REQTXNUM,R.OBJKEY) REQTXNUM,
            CASE WHEN R.TRFCODE LIKE ''PAYMENTINTEREST%'' THEN NULL 
                when r.trfcode in( ''SCOA'') then gl.custodycd
            ELSE NVL(CF.CUSTODYCD, '''') END CUSTODYCD,R.TXDATE,
            R.BANKACCT,RBANKACCOUNT,RBANKNAME,
            R.CURRENCY CURRENCY,
            R.TXAMT AMOUNT, R.STATUS,A.<@CDCONTENT> STATUSTEXT,R.ERRORDESC, R.REFVAL,
            to_char(R.CREATEDATE,''dd/MM/yyyy hh24:mi:ss'')CREATEDATE,
            R.RBANKCITAD,R.FEEAMT,R.TAXAMT, a2.<@CDCONTENT> FEETYPE,R.FEECODE,R.NOTES,
            (case when R.trfcode = ''CITAD'' AND R.FEETYPE = ''3'' then R.TXAMT - nvl(R.FEEAMT,0) - nvl(R.TAXAMT,0)
                  WHEN R.trfcode = ''CITAD'' AND R.FEETYPE <> ''3'' THEN R.TXAMT ELSE 0 END ) NETAMT,
            CF.MASTERCIF CIFID
    FROM CRBTXREQHIST R, CRBTRFCODE N, GL_EXP_RESULTS gl,
    (SELECT NVL(CF.MCIFID, CF.CIFID) MASTERCIF,CF.CUSTID,CF.CUSTODYCD FROM CFMAST CF GROUP BY NVL(CF.MCIFID, CF.CIFID),CF.CUSTID,CF.CUSTODYCD) CF,
    (SELECT * FROM DDMAST WHERE STATUS <> ''C'') D,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''RMSTATUS'' AND CDTYPE = ''CI'') A,
    (SELECT * FROM ALLCODE WHERE CDNAME = ''IOROFEE'' AND CDTYPE = ''SA'') A2
    WHERE R.STATUS = A.CDVAL
    AND R.REQCODE = N.TRFCODE(+)
    AND R.BANKACCT= D.REFCASAACCT(+)
    AND R.AFACCTNO = CF.CUSTID(+)
    and r.reqtxnum = gl.bankreqid(+)
    AND R.FEETYPE=A2.CDVAL(+)
    AND R.trfcode  IN (''CA3387_CITAD'')
)
WHERE 0=0', 'CRBTXREQHIST', '', 'REQID DESC', '', 0, 500, 'Y', 1, 'NNNNYYNNNNNY', 'Y', 'T', '', 'N', '');COMMIT;