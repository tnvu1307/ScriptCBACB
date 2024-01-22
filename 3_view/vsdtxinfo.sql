SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VSDTXINFO
(FINFILENAME, SWIFT)
AS 
select UPPER(REPLACE(finfilename,'.fin','')), finbody swift from vsd_fin_log
/
