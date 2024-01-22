SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_CFOTHERACCCV
(CUSTODYCD, BANKACC, BANKACNAME, BANKNAME, CITYBANK, 
 CITYEF, ACNIDCODE, ACNIDDATE, ACNIDPLACE)
AS 
select cf.custodycd ,cfo.BANKACC, NVL(cfo.BANKACNAME,' ')BANKACNAME,NVL(cfo.BANKNAME,' ')BANKNAME , nvl(cfo.CITYBANK,' ') CITYBANK
 ,nvl(CITYEF,' ') CITYEF,nvl(ACNIDCODE,' ') ACNIDCODE, nvl( TO_char( acniddate,'DD-MM-YYYY') ,' ')    ACNIDDATE,nvl(ACNIDPLACE,' ') ACNIDPLACE
from cfotheracc cfo,cfmast cf
where cfo.cfcustid = cf.custid
order by cf.custodycd ,cfo.BANKACC
/
