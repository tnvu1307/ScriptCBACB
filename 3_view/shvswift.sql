SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW SHVSWIFT
(REQUESTID, SWIFTDTLVIEW)
AS 
select swiftid REQUESTID ,to_char((trim(replace(substr(msgbody,662,1023),chr(0)))|| trim(replace(substr(msgbody,2710,9999),chr(0))) || substr(msgbody,1686,2)) )SWIFT
from crblog where msgtype = 'ST' and IORO = 'I'
/
