SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_UNHOLDSEF8_UNHOLDSEF8
(TXNUM, TXDESC, CODEID, CFCUSTODYCD, CFFULLNAME, 
 SYMBOL, QTTY, TLNAME, TXTIME, SHORTNAME, 
 BRNAME, BRPHONE, NOTE, STATUS, STATUSTEXT, 
 SEACCOUNT, MEMBERID, BRNAMEID, BRPHONEID)
AS 
SELECT TXNUM,TXDESC,CODEID,CFCUSTODYCD,CFFULLNAME,A.SYMBOL,QTTY,TLNAME,TXTIME,SHORTNAME,BRNAME,BRPHONE,NOTE,status,statustext,seaccount,B.members memberid ,brnameid, brphoneid
             FROM (
            SELECT   '' txnum,se.CODEID,cf.custodycd cfcustodycd,cf.fullname cffullname,''  txdesc,se.acctno seaccount,sb.symbol,se.hold qtty,'' tlname,'' txtime,'' shortname,''  brname,
                     ''  brphone,''  note, ''  status,'' statustext,'' memberid ,''  brnameid, '' brphoneid
              FROM   semast se, cfmast cf, sbsecurities sb
             WHERE       se.hold >0 
                and se.codeid = sb.codeid 
                and se.afacctno = cf.custid
 ) A,buf_se_member B where 0=0 AND A.CFCUSTODYCD = B.custodycd(+) AND A.SYMBOL = B.SYMBOL(+)
/
