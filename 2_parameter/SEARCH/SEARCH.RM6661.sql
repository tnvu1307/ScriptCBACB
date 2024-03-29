SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM6661','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM6661', 'Tra cứu yên cầu UNHOLD chờ xác nhận (6661)', 'View pending UNHOLD to confirm  (6661)', 'SELECT REQ.REQID,REQ.TRFCODE,REQ.OBJKEY TXNUM,REQ.OBJNAME TLTX,REQ.TXDATE,REQ.BANKCODE,CF.CUSTODYCD,REQ.AFACCTNO,
CF.FULLNAME,CF.ADDRESS,CF.IDCODE LICENSE,REQ.BANKACCT BANKACCTNO,CRB.BANKCODE || '':'' || CRB.BANKNAME BANKNAME,
REQ.TXAMT,REQ.STATUS,CI.HOLDBALANCE
FROM CRBTXREQ REQ,AFMAST AF,CFMAST CF,CIMAST CI,CRBDEFBANK CRB
WHERE REQ.AFACCTNO=AF.ACCTNO AND AF.CUSTID=CF.CUSTID
AND AF.ACCTNO=CI.AFACCTNO AND CI.COREBANK=''Y'' AND REQ.BANKCODE=CRB.BANKCODE
AND REQ.TRFCODE IN (''UNHOLD'') AND REQ.STATUS=''P'' --AND REQ.REQID=p_reqid
AND NOT EXISTS (
   SELECT * FROM TLLOGFLD FLD,TLLOG TL
   WHERE FLD.TXNUM=TL.TXNUM AND FLD.FLDCD=''22''
   AND TL.TLTXCD=''6661'' AND FLD.CVALUE = TO_CHAR(REQ.REQID)
)
AND EXISTS (
    SELECT * FROM CRBTXREQLOG LG
    WHERE REQ.REFCODE=LG.refcode AND REQ.BANKCODE=LG.BANKCODE
    AND REQ.TRFCODE=LG.trfcode AND REQ.TXDATE=LG.txdate AND LG.STATUS=''C''
)', 'BANKINFO', NULL, NULL, '6661', NULL, 5000, 'N', 1, NULL, 'Y', 'T', NULL, 'N', NULL);COMMIT;