SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_CFMAST_SMS
(MOBILESMS, EMAIL, EMAILBR, CUSTODYCD, CUSTID, 
 FULLNAME, ADDRESS, IDCODE, IDDATE, IDPLACE, 
 MNEMONIC)
AS 
select nvl( case when
             LENGTH(cf.mobilesms)>=10 and substr(cf.mobilesms,1,2) in ('09','08','07','03','05') then REGEXP_REPLACE(substr(regexp_replace(cf.mobilesms, '[^[:digit:]]', ''),1,10), '[^[:digit:]]', '' )
              else (case when LENGTH(cf.mobilesms)>=10 and substr(cf.mobilesms,1,2) in ('01') then REGEXP_REPLACE(substr(regexp_replace(cf.mobilesms, '[^[:digit:]]', ''),1,11), '[^[:digit:]]', '' )
              WHEN LENGTH(cf.mobilesms)>=10 and substr(cf.mobilesms,1,2) in ('84') THEN '0' || REGEXP_REPLACE(substr(regexp_replace(cf.mobilesms, '[^[:digit:]]', ''),3,length(cf.mobilesms)), '[^[:digit:]]', '' )
               else '' end ) end,
            '' ) mobilesms
, trim(cf.email), TRIM(cf.emailbr), cf.custodycd,cf.custid,cf.fullname,cf.address,cf.idcode,cf.iddate,cf.idplace, cf.mnemonic
from cfmast cf
/
