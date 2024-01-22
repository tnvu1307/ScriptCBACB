SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_TYPE
(TYPE, ACTYPE, TYPENAME)
AS 
SELECT 'AFTYPE' TYPE, to_char(actype) actype, to_char(typename) typename FROM aftype
UNION ALL
SELECT 'DDTYPE' TYPE, to_char(actype) actype, to_char(typename) typename FROM DDTYPE
UNION ALL
SELECT 'SETYPE' TYPE, to_char(actype) actype, to_char(typename) typename FROM SETYPE
UNION ALL
SELECT 'ODTYPE' TYPE, to_char(actype) actype, to_char(typename) typename FROM ODTYPE
union all
SELECT 'AFTYPE' TYPE, 'ALL' actype, 'Tat ca' typename FROM dual
UNION ALL
SELECT 'DDTYPE' TYPE, 'ALL' actype, 'Tat ca' typename FROM dual
UNION ALL
SELECT 'SETYPE' TYPE, 'ALL' actype, 'Tat ca' typename FROM dual
UNION ALL
SELECT 'ODTYPE' TYPE, 'ALL' actype, 'Tat ca' typename FROM dual
UNION ALL
SELECT 'SYSTEM' TYPE, 'ALL' actype, 'Tat ca' typename FROM dual
/
