SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_EBS_POSTING_ALL
(TXDATE, TXNUM, SUBTXNO, TRANS_TYPE, NOTES, 
 DRACCTNO, CRACCTNO, MODCODE, GLGRP, VOUCHER, 
 POST, AMOUNT, GLGP, CUSTOMER_NUMBER, CUSTOMER_NAME, 
 BUSDATE, CREATEDDT, CREATEDTM, POSTEDDT, POSTEDTM)
AS 
SELECT MST.TXDATE, MST.TXNUM, MST.SUBTXNO, MAX(MST.TRANS_TYPE) TRANS_TYPE, MAX(MST.DESCRIPTION) NOTES, 
SP_FORMAT_EBS_ACCOUTNO(MAX(MST.DRACCTNO)) DRACCTNO, SP_FORMAT_EBS_ACCOUTNO(MAX(MST.CRACCTNO)) CRACCTNO, 
MAX(APP.MODCODE) MODCODE, MAX(CASE WHEN MST.ACMODULE=APP.MODCODE THEN MST.GLGRP ELSE '' END) GLGRP,
MAX(GLLOGVOUCHER.VOUCHER) VOUCHER, MAX(GLLOGVOUCHER.POST) POST, MAX(MST.AMOUNT) AMOUNT, MAX(TLTX.GLGP) GLGP,
MAX(MST.CUSTOMER_NUMBER) CUSTOMER_NUMBER, MAX(MST.CUSTOMER_NAME) CUSTOMER_NAME, MAX(MST.BUSDATE) BUSDATE, 
MAX(MST.CREATEDDT) CREATEDDT, MAX(MST.CREATEDTM) CREATEDTM, MAX(GLLOGVOUCHER.POSTEDDT) POSTEDDT, MAX(GLLOGVOUCHER.POSTEDTM) POSTEDTM
FROM GLLOGHISTALL MST, TLTX, APPMODULES APP, GLLOGVOUCHERALL GLLOGVOUCHER
WHERE MST.TRANS_TYPE=TLTX.TLTXCD AND SUBSTR(TLTX.TLTXCD,1,2)=APP.TXCODE
AND MST.TXDATE=GLLOGVOUCHER.TXDATE AND MST.TXNUM=GLLOGVOUCHER.TXNUM AND GLLOGVOUCHER.POST<>'Y' 
GROUP BY MST.TXDATE, MST.TXNUM, MST.SUBTXNO
HAVING LENGTH(NVL(MAX(MST.DRACCTNO),''))>0 AND LENGTH(NVL(MAX(MST.CRACCTNO),''))>0
ORDER BY MST.TXDATE, MST.TXNUM, MST.SUBTXNO
/
