SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('BROKER_SEHOLD','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('BROKER_SEHOLD', 'Tra cứu thông tin tài khoản thấu chi', 'Overdraft account information', 'SELECT TXNUM,TXDESC,SYMBOL,QTTY,TLNAME,TXTIME,SHORTNAME,BRNAME,BRPHONE,NOTE,status,statustext,seaccount,memberid ,brnameid, brphoneid
             FROM (
            SELECT   l.txnum,x.en_txdesc txdesc,l.msgacct seaccount,l.cfcustodycd custodycd,f.symbol,l.msgamt qtty,p.tlname,l.txtime,m.shortname,mx1.extraval brname,
                     mx2.extraval brphone, note, l.txstatus status, a.<@CDCONTENT> statustext,f.memberid ,f.brname brnameid, f.brphone brphoneid
              FROM   tllog l,
                     tltx x,
                     famembers m,
                     famembersextra mx1,
                     famembersextra mx2,
                      tlprofiles p,
                      (select * from allcode where cdname = ''TXSTATUS'' and cdtype =''SY'')a,
                     (  SELECT   txnum,
                                 MAX (CASE WHEN f.fldcd = ''05'' THEN f.cvalue ELSE '''' END)  memberid,
                                 MAX (CASE WHEN f.fldcd = ''06'' THEN f.cvalue ELSE '''' END)  brname,
                                 MAX (CASE WHEN f.fldcd = ''07'' THEN f.cvalue ELSE '''' END)  brphone,
                                 MAX (CASE WHEN f.fldcd = ''14'' THEN f.cvalue ELSE '''' END)  symbol,
                                 MAX (CASE WHEN f.fldcd = ''30'' THEN f.cvalue ELSE '''' END)  note
                          FROM   tllogfld f
                         WHERE   fldcd IN (''05'', ''06'', ''07'', ''14'',''30'')
                      GROUP BY   txnum) f
             WHERE       l.txnum = f.txnum and l.tlid = p.tlid
                     AND f.memberid = m.autoid
                     AND mx1.autoid = f.brname
                     AND mx2.autoid = f.brphone
                     AND a.cdval=l.txstatus
                     AND l.tltxcd IN (''2212'')
                     AND l.tltxcd = x.tltxcd 
                order by l.txnum desc
 ) where 0=0', 'CIMAST', '', '', '', 0, 5000, 'N', 1, '', 'Y', 'T', '', 'N', '');COMMIT;