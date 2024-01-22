SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_RM0012
(MSGACCT, REQTXNUM, TXNUM, TXDESC, CCYCD, 
 AMOUNT, TLNAME, TXTIME, SHORTNAME, BRNAME, 
 BRPHONE, NOTE, STATUS, STATUSTEXT, UNHOLD, 
 UNHOLDTEXT, TXSTATUSCD, APRALLOW, REFUSEALLOW, BANKACCTNO, 
 TRADINGDATE, CUSTODYCD, FULLNAME)
AS 
SELECT  MSGACCT,REQTXNUM,TXNUM,
case when txdesc like 'Unhold%' then 'Unhold' else 'Hold' end txdesc,CCYCD,AMOUNT,TLNAME,TXTIME,SHORTNAME,BRNAME,BRPHONE,NOTE,STATUS,STATUSTEXT,UNHOLD,UNHOLDTEXT,1 TXSTATUSCD,'N' APRALLOW,
 'N' REFUSEALLOW,BANKACCTNO,TRADINGDATE,CUSTODYCD,FULLNAME
           FROM (
                 SELECT    L.MSGACCT,'' REQTXNUM,l.txnum,x.EN_txdesc txdesc,f.bankacctno,dd.ccycd,l.msgamt AMOUNT,p.tlname,l.txtime,m.shortname,mx1.extraval brname,
                           mx2.extraval brphone, note, l.cfcustodycd custodycd,l.cffullname FULLNAME,'' status,'' STATUSTEXT,'' UNHOLD,'' UNHOLDTEXT,l.txdate TRADINGDATE
              FROM   vw_tllog_all l,
                     tltx x,
                      tlprofiles p,
                      famembers m,
                      famembersextra mx1,
                      famembersextra mx2,
                      ddmast dd,
                     (  SELECT   txdate, txnum,
                                 MAX (CASE WHEN f.fldcd = '05' THEN f.cvalue ELSE '' END)  memberid,
                                 MAX (CASE WHEN f.fldcd = '06' THEN f.cvalue ELSE '' END)  brname,
                                 MAX (CASE WHEN f.fldcd = '07' THEN f.cvalue ELSE '' END)  brphone,
                                 MAX (CASE WHEN f.fldcd = '93' THEN f.cvalue ELSE '' END)  bankacctno,
                                 MAX (CASE WHEN f.fldcd = '30' THEN f.cvalue ELSE '' END)  note
                          FROM   vw_tllogfld_all f
                         WHERE   fldcd IN ('05', '06', '07','93','30') 
                      GROUP BY   txdate, txnum) f                    
             WHERE       l.txnum = f.txnum and l.txdate = f.txdate and l.tlid = p.tlid
                     AND l.tltxcd IN ('6603','6604')
                     AND l.tltxcd = x.tltxcd
                     AND f.memberid = m.autoid
                     AND to_char(mx1.autoid) = f.brname
                     AND to_char(mx2.autoid) = f.brphone
                     and dd.acctno = L.MSGACCT and dd.status <> 'C'
                     and SUBSTR(l.cfcustodycd,0,4) = (select varvalue  from sysvar where varname = 'DEALINGCUSTODYCD')
             order by l.txnum desc
                       ) where 0=0 

-- End of DDL Script for View HOSTSHVTEST.V_COMPARE_IMPORT
/
