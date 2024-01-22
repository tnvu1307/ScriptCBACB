SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_EBS_GENTX_VOUCHER
(TXDATE, TXNUM, TLTXCD, GLGP, MODCODE, 
 GLGRP, BRID)
AS 
(/*SELECT MST.TXDATE, MST.TXNUM, MAX(TLTX.TLTXCD) TLTXCD, MAX(TLTX.GLGP) GLGP,
MAX(APP.MODCODE) MODCODE, MAX(CASE WHEN MST.ACMODULE=APP.MODCODE THEN MST.GLGRP ELSE '' END) GLGRP, MAX(BRID) BRID
FROM GLLOGHIST MST, TLTX, APPMODULES APP
WHERE MST.TRANS_TYPE=TLTX.TLTXCD AND SUBSTR(TLTX.TLTXCD,1,2)=APP.TXCODE
AND TO_CHAR(MST.TXDATE,'DD/MM/RRRR') || TO_CHAR(MST.TXNUM) NOT IN
(SELECT TO_CHAR(GLLOGVOUCHER.TXDATE,'DD/MM/RRRR') || TO_CHAR(GLLOGVOUCHER.TXNUM) FROM GLLOGVOUCHER)
GROUP BY MST.TXDATE, MST.TXNUM*/
SELECT MST.TXDATE, MST.TXNUM, MAX(TLTX.TLTXCD) TLTXCD, MAX(TLTX.GLGP) GLGP,
MAX(APP.MODCODE) MODCODE, MAX(CASE WHEN MST.ACMODULE=APP.MODCODE THEN MST.GLGRP ELSE '' END) GLGRP, MAX(BRID) BRID
FROM GLLOGHIST MST, TLTX, APPMODULES APP, GLLOGVOUCHER GLLOGV
WHERE MST.TRANS_TYPE=TLTX.TLTXCD AND SUBSTR(TLTX.TLTXCD,1,2)=APP.TXCODE
AND MST.TXDATE = GLLOGV.TXDATE(+)
AND MST.TXNUM = GLLOGV.TXNUM(+)
AND GLLOGV.POST IS NULL
GROUP BY MST.TXDATE, MST.TXNUM
)
/
