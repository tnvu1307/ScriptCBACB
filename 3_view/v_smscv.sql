SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW V_SMSCV
(CUSTODYCD, MOBILESMS, BRID)
AS 
select CF.custodycd , cf.mobilesms,CF.BRID FROM cfmast CF, AFMAST AF where CF.CUSTID = AF.CUSTID AND LENGTH( cf.mobilesms)>1
order by custodycd
/
