SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW SHVTXREQ
(REQID, SWIFT)
AS 
SELECT CBREQKEY REQID, TO_CHAR(TRIM(SUBSTR(MSGBODY,662,1024)) || TRIM(SUBSTR(MSGBODY,2710,9999)) || SUBSTR(MSGBODY,1686,2)) SWIFT
FROM CRBLOG
/
