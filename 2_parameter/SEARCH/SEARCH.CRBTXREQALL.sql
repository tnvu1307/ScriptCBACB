SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CRBTXREQALL','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CRBTXREQALL', 'Quản lý thông tin điện gửi qua ngân hàng', 'Bank request management', 'SELECT *FROM (
SELECT  R.REQID,R.objkey TXNUM,R.TRFCODE,n.description REQCODE,nvl(R.REQTXNUM,R.objkey) REQTXNUM,D.CUSTODYCD,
        R.TXDATE,R.BANKACCT,RBANKACCOUNT,RBANKNAME,D.ccycd CURRENCY,R.TXAMT AMOUNT, R.STATUS,A.CDCONTENT STATUSTEXT,
        R.ERRORDESC, R.REFVAL,R.CREATEDATE,
        D.refcasaacct REFCASAACCT,
        AF.acctno ACCOUNTNO,
        cf.fullname CUSTNAME,
        BUF.cifid CIFID,
        D.BALANCE,
        D.HOLDBALANCE,
        buf.holdbalance BANKHOLDEDBYBROKER,
        VW_MBR.display BRNAME,
        VW_MP.display BRPHONE,
        BUF.memberid MEMBERID,
        D.ACCTNO DDACCTNO
FROM CRBTXREQ R,ALLCODE A, CRBTRFCODE N, DDMAST D,cfmast cf,AFMAST AF,buf_dd_member buf,vw_member_broker VW_MBR,vw_member_phone VW_MP
WHERE A.CDNAME = ''RMSTATUS'' AND A.CDTYPE = ''CI''
AND R.STATUS =A.CDVAL
AND R.REQCODE = N.TRFCODE
AND R.AFACCTNO= D.ACCTNO
and R.status = ''R''
AND R.objname = ''6690''
and cf.custodycd = d.custodycd
AND BUF.memberid = VW_MBR.filtercd
AND BUF.memberid = VW_MP.filtercd
AND buf.DDACCTNO = D.acctno
AND BUF.CUSTODYCD = D.CUSTODYCD
AND CF.CUSTID = AF.CUSTID
and not exists ( select f.nvalue from
                                    tllog tl, tllogfld f where tl.txnum = f.txnum and
                                    tl.txdate = f.txdate and tl.tltxcd = ''6690'' and f.fldcd
                                    = ''95'' and tl.txstatus in(''1'', ''4'') and f.nvalue = R.REQTXNUM)
) WHERE 0 = 0', 'CRBTXREQALL', NULL, NULL, '6690', NULL, 5000, 'N', 1, 'NNNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;