SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('SHVTXREQHIST','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('SHVTXREQHIST', 'Tra cứu thông tin chi tiết trạng thái điện gửi khách hàng(Quá khứ)', 'Manage the details of messages sent to client(Hist)', 'SELECT tbl.*, cf.cifid, cf.swiftcode
FROM (
  SELECT TO_CHAR(REQ.REQID) REQID,REQ.OBJNAME,SUBSTR(REQ.TRFCODE,1,3)TRFCODE,REQ.OBJKEY,TO_DATE(REQ.TXDATE,''DD/MM/RRRR'')TXDATE,
      CASE WHEN REQ.MSGACCT IN (SELECT CUSTODYCD FROM CFMAST WHERE CUSTODYCD = REQ.MSGACCT) THEN REQ.MSGACCT
           ELSE
              CASE WHEN REQ.AFACCTNO IN (SELECT ACCTNO FROM AFMAST WHERE ACCTNO = REQ.AFACCTNO)
                  THEN (SELECT CF.CUSTODYCD FROM CFMAST CF,AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = REQ.AFACCTNO)
                   WHEN REQ.MSGACCT IN (SELECT CF.CUSTID FROM CFMAST CF WHERE CF.CUSTID = REQ.MSGACCT)
                  THEN (SELECT CF.CUSTODYCD FROM CFMAST CF WHERE CF.CUSTID = REQ.MSGACCT)
              ELSE '''' END
           END MSGACCT,
      CODE.<@CDCONTENT> || (CASE WHEN REQ.OBJNAME in (''9999'',''1509'',''1515'',''3335'') THEN '' - ''||REQD.OCVAL ELSE '''' END) NOTES,
      REQ.AFACCTNO ,A5.<@CDCONTENT> MSGSTATUS,A5.CDVAL,
      REQ.VSD_ERR_MSG||'' ''||REQ.BOPROCESS_ERR VSD_ERR_MSG ,TO_CHAR(REQ.CREATEDATE,''HH24:MI:SS'') CREATEDATE ,REQ.TLID,TL.TLNAME,'''' AUTOCONF,
      refid.ocval   refMsgId
  FROM VSDTXREQ REQ, ALLCODE A5,TLPROFILES TL,
   (SELECT TRFCODE, DESCRIPTION CDCONTENT, EN_DESCRIPTION EN_CDCONTENT, TLTXCD FROM VSDTRFCODE) CODE,
   (SELECT * FROM VSDTXREQDTL WHERE FLDNAME in (''REPORTID'',''RPTID''))REQD,
   (SELECT * FROM VSDTXREQDTL WHERE FLDNAME in (''REFID'')) refid
  WHERE A5.CDTYPE=''SA'' AND A5.CDNAME=''VSDTXREQSTS'' AND A5.CDVAL=REQ.MSGSTATUS and REQ.MSGSTATUS <> ''S''
  AND REQ.TLID=TL.TLID(+)
  AND REQ.REQID = REQD.REQID(+) AND req.reqid = refid.reqid(+)
  AND REQ.TRFCODE = CODE.TRFCODE
  AND REQ.OBJNAME = CODE.TLTXCD
  AND REQ.BANKCODE =''CBP''
) tbl, cfmast cf
WHERE tbl.msgacct = cf.custodycd(+) ', 'SHVTXREQHIST', 'frmVSDTXREQHIST', 'TXDATE DESC,REQID DESC', '', NULL, 5000, 'Y', 1, '', 'Y', 'T', '', 'N', '');COMMIT;