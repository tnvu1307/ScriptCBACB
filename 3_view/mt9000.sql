SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW MT9000
(ID, SWIFTDTLVIEW)
AS 
select ID  ,MSG swiftdtlview
from mg_swift_msg_history where 0 = 0
/
