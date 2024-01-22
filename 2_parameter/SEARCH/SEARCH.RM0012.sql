SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('RM0012','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('RM0012', 'Tra cứu lịch sử HOLD/ UNHOLD tiền', 'Look up history of HOLD/ UNHOLD money', 'select *from (
SELECT  MSGACCT,REQTXNUM,TXNUM,
case when txdesc like ''Unhold%'' then ''Unhold'' else ''Hold'' end txdesc,CCYCD,AMOUNT,TLNAME,TXTIME,SHORTNAME,BRNAME,BRPHONE,NOTE,STATUS,STATUSTEXT,UNHOLD,UNHOLDTEXT,
case when UNHOLD=''N'' then 4 else 1 end TXSTATUSCD,case when UNHOLD=''N'' then ''Y'' else ''N'' end APRALLOW,
 ''N'' REFUSEALLOW,BANKACCTNO,TRADINGDATE,CUSTODYCD,FULLNAME
           FROM (
                 SELECT    L.MSGACCT,R.REQTXNUM,l.txnum,x.EN_txdesc txdesc,f.bankacctno,f.ccycd,l.msgamt AMOUNT,p.tlname,l.txtime,m.shortname,mx1.extraval brname,
                           mx2.extraval brphone, note, l.cfcustodycd custodycd,l.cffullname fullname,r.STATUS,A.<@CDCONTENT> STATUSTEXT,r.UNHOLD,A1.<@CDCONTENT> UNHOLDTEXT,l.txdate TRADINGDATE
              FROM   vw_tllog_all l,
                     tltx x,
                     vw_crbtxreq_all r,
                     famembers m,
                     famembersextra mx1,
                     famembersextra mx2,
                      tlprofiles p,
                      (select * from allcode where  CDNAME = ''RMSTATUS'' AND CDTYPE = ''CI'') A,
                      (select * from allcode where  CDNAME = ''UNHOLD'' AND CDTYPE = ''MT'') A1,
                     (  SELECT   txdate, txnum,
                                 MAX (CASE WHEN f.fldcd = ''05'' THEN f.cvalue ELSE '''' END)  memberid,
                                 MAX (CASE WHEN f.fldcd = ''06'' THEN f.cvalue ELSE '''' END)  brname,
                                 MAX (CASE WHEN f.fldcd = ''07'' THEN f.cvalue ELSE '''' END)  brphone,
                                 MAX (CASE WHEN f.fldcd = ''20'' THEN f.cvalue ELSE '''' END)  ccycd,
                                 MAX (CASE WHEN f.fldcd = ''93'' THEN f.cvalue ELSE '''' END)  bankacctno,
                                 MAX (CASE WHEN f.fldcd = ''30'' THEN f.cvalue ELSE '''' END)  note
                          FROM   vw_tllogfld_all f
                         WHERE   fldcd IN (''05'', ''06'', ''07'', ''20'', ''93'',''30'')
                      GROUP BY   txdate, txnum) f
             WHERE       l.txnum = f.txnum and l.txdate = f.txdate and l.tlid = p.tlid
                     AND f.memberid = m.autoid
                     AND to_char(mx1.autoid) = f.brname
                     AND to_char(mx2.autoid) = f.brphone
                     AND l.tltxcd IN (''6690'',''6691'')
                     AND l.tltxcd = x.tltxcd
                     AND R.STATUS =A.CDVAL
                     AND R.UNHOLD =A1.CDVAL
                     and r.objkey = l.txnum and  r.txdate = l.txdate
             order by l.txnum desc
                       ) where 0=0
union all
select *from V_RM0012
) where 0 = 0', 'RM0012', '', 'tradingdate desc', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'Y', 'ACCTNO');COMMIT;