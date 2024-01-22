SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_DD_6691
(CUSTODYCD, REFTXNUM, SECACCOUNT, DDACCTNO, CUSTNAME, 
 REFCASAACCT, MEMBERID, BRNAME, BRPHONE, CCYCD, 
 AMOUNT, NOTE, BALANCE, HOLDBALANCE)
AS 
SELECT  CUSTODYCD,txnum REFTXNUM ,SECACCOUNT, DDACCTNO , CUSTNAME, REFCASAACCT,  MEMBERID,BRNAME,
BRPHONE,  CCYCD,  AMOUNT, note,BALANCE,HOLDBALANCE
           FROM (
    select *from (
            SELECT    l.txnum,x.txdesc,f.bankacctno REFCASAACCT,f.DDACCTNO ,dd.afacctno SECACCOUNT,f.memberid ,f.ccycd,l.msgamt amount,p.tlname,l.txtime,m.shortname,mx1.extraval brname,
                           mx2.extraval brphone, note , l.cfcustodycd custodycd,l.cffullname CUSTNAME,DD.BALANCE,DD.HOLDBALANCE
                  FROM   vw_tllog_all l,
                         tltx x,
                         famembers m,
                         famembersextra mx1,
                         famembersextra mx2,
                         DDMAST DD,(select * from crbtxreq where unhold='N' and objname = '6690' and status = 'C') rq,
                          tlprofiles p,
                         (
                              SELECT   txnum,txdate,
                                     MAX (CASE WHEN f.fldcd = '04' THEN f.cvalue ELSE '' END)  DDACCTNO,
                                     MAX (CASE WHEN f.fldcd = '05' THEN f.cvalue ELSE '' END)  memberid,
                                     MAX (CASE WHEN f.fldcd = '06' THEN f.cvalue ELSE '' END)  brname,
                                     MAX (CASE WHEN f.fldcd = '07' THEN f.cvalue ELSE '' END)  brphone,
                                     MAX (CASE WHEN f.fldcd = '20' THEN f.cvalue ELSE '' END)  ccycd,
                                     MAX (CASE WHEN f.fldcd = '93' THEN f.cvalue ELSE '' END)  bankacctno,
                                     MAX (CASE WHEN f.fldcd = '30' THEN f.cvalue ELSE '' END)  note
                              FROM   vw_tllogfld_all f
                              WHERE   fldcd IN ('04','05', '06', '07', '20', '93','30')
                              GROUP BY   txnum,txdate
                         ) f
                    WHERE       l.txnum = f.txnum and l.txdate = f.txdate and l.tlid = p.tlid
                            AND f.memberid = m.autoid
                            AND mx1.autoid = f.brname
                            AND mx2.autoid = f.brphone
                            AND l.tltxcd in( '6690')
                            AND l.tltxcd = x.tltxcd
                            AND l.msgacct = DD.acctno
                            AND DD.acctno = f.DDACCTNO
                            AND DD.HOLDBALANCE > 0
                            and l.txnum=rq.objkey
                            and l.txdate = rq.txdate
        union all
            SELECT    l.txnum,x.txdesc,f.bankacctno REFCASAACCT,f.DDACCTNO ,dd.afacctno SECACCOUNT,f.memberid ,f.ccycd,l.msgamt amount,p.tlname,l.txtime,m.shortname,mx1.extraval brname,
                           mx2.extraval brphone, note , l.cfcustodycd custodycd,l.cffullname CUSTNAME,DD.BALANCE,DD.HOLDBALANCE
                  FROM   vw_tllog_all l,
                         tltx x,
                         famembers m,
                         famembersextra mx1,
                         famembersextra mx2,
                         DDMAST DD,(select * from crbtxreq where unhold='N' and objname = '6690' and status = 'C') rq,
                          tlprofiles p,
                         (
                              SELECT   txnum,txdate,
                                     MAX (CASE WHEN f.fldcd = '04' THEN f.cvalue ELSE '' END)  DDACCTNO,
                                     MAX (CASE WHEN f.fldcd = '05' THEN f.cvalue ELSE '' END)  memberid,
                                     MAX (CASE WHEN f.fldcd = '06' THEN f.cvalue ELSE '' END)  brname,
                                     MAX (CASE WHEN f.fldcd = '07' THEN f.cvalue ELSE '' END)  brphone,
                                     MAX (CASE WHEN f.fldcd = '20' THEN f.cvalue ELSE '' END)  ccycd,
                                     MAX (CASE WHEN f.fldcd = '93' THEN f.cvalue ELSE '' END)  bankacctno,
                                     MAX (CASE WHEN f.fldcd = '30' THEN f.cvalue ELSE '' END)  note
                              FROM   vw_tllogfld_all f
                              WHERE   fldcd IN ('04','05', '06', '07', '20', '93','30')
                              GROUP BY   txnum,txdate
                         ) f
                    WHERE       l.txnum = f.txnum and l.txdate = f.txdate and l.tlid = p.tlid
                            AND f.memberid = m.autoid
                            AND mx1.autoid = f.brname
                            AND mx2.autoid = f.brphone
                            AND l.tltxcd in( '6689')
                            AND l.tltxcd = x.tltxcd
                            AND l.msgacct = DD.acctno
                            AND DD.acctno = f.DDACCTNO
                            AND DD.HOLDBALANCE > 0
                            and l.txnum=rq.objkey
                            and l.txdate = rq.txdate
            )
)
where 0=0
/
