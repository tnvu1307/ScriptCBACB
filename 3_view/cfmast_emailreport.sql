SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW CFMAST_EMAILREPORT
(CUSTID, REGISTTYPE)
AS 
select custid, (CASE WHEN AMC IS NOT NULL THEN AMC  ELSE '' END)|| 
                (CASE WHEN GCB IS NOT NULL THEN (CASE WHEN AMC IS NOT NULL THEN ',' ||GCB ELSE GCB END) ELSE '' END) ||
                (CASE WHEN CUS IS NOT NULL THEN (CASE WHEN GCB IS NOT NULL THEN ',' ||CUS ELSE CUS END)    ELSE '' END) REGISTTYPE
FROM 
(
    select custid,
                max(case when registtype = 'AMC' THEN A2.CDCONTENT else '' end) AMC,
                max(case when registtype = 'GCB' THEN A2.CDCONTENT else '' end) GCB,
                max(case when registtype = 'CUS' THEN A2.CDCONTENT else '' end) CUS
    From emailreport E,(select * from allcode where cdtype = 'CF' and cdname = 'REGISTTYPE') A2 
    where   deltd <> 'Y' 
        AND E.registtype = A2.CDVAL(+)
    group by custid
)
/
