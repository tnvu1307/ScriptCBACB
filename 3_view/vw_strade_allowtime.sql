SET DEFINE OFF;
CREATE OR REPLACE FORCE VIEW VW_STRADE_ALLOWTIME
(HOSTSTATUS, MT_FRTIME, MT_TOTIME, CA_FRTIME, CA_TOTIME)
AS 
SELECT max(case WHEN grname = 'SYSTEM' AND varname = 'HOSTATUS' THEN varvalue END) HOSTSTATUS,
max(case WHEN grname = 'STRADE' AND varname = 'MT_FRTIME' THEN varvalue END) MT_FRTIME,
max(case WHEN grname = 'STRADE' AND varname = 'MT_TOTIME' THEN varvalue END) MT_TOTIME,
max(case WHEN grname = 'STRADE' AND varname = 'CA_FRTIME' THEN varvalue END) CA_FRTIME,
max(case WHEN grname = 'STRADE' AND varname = 'CA_TOTIME' THEN varvalue END) CA_TOTIME
FROM sysvar
/
