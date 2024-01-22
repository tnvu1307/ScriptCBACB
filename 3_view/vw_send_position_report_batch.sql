SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_SEND_POSITION_REPORT_BATCH
(REGISTTYPE)
AS 
(
SELECT e.registtype
    FROM emailreport e, cfmast cf
    where   e.custid = cf.custid
        and e.deltd <> 'Y'
        and cf.mailposition= 'Y'
    group by e.registtype
)
/
