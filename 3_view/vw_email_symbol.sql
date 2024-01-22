SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_EMAIL_SYMBOL
(CUSTODYCD, EMAIL, SYMBOL, FULLNAME, LANGUAGEID)
AS 
select cf.custodycd , 'thucnt@bsc.com.vn'  email, sb.symbol ,cf.fullname ,
case when cf.country = '234' then '2' else '1' end languageid
from  semast se,afmast af,cfmast cf,sbsecurities sb
where se.afacctno = af.acctno
and af.custid = cf.custid
and se.codeid = sb.codeid
and cf.email is not null
and se.trade >0
/
