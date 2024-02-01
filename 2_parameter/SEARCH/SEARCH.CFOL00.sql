SET DEFINE OFF;DELETE FROM SEARCH WHERE 1 = 1 AND NVL(SEARCHCODE,'NULL') = NVL('CFOL00','NULL');Insert into SEARCH   (SEARCHCODE, SEARCHTITLE, EN_SEARCHTITLE, SEARCHCMDSQL, OBJNAME, FRMNAME, ORDERBYCMDSQL, TLTXCD, CNTRECORD, ROWPERPAGE, AUTOSEARCH, INTERVAL, AUTHCODE, ROWLIMIT, CMDTYPE, CONDDEFFLD, BANKINQ, BANKACCT) Values   ('CFOL00', 'Quản lý các tài khoản đăng ký từ online', 'Management online register', 'select REG.AUTOID,REG.CustomerType,A1.CDCONTENT CustomerTypeDesc,
       REG.CustomerName,REG.CustomerBirth,REG.IDType,
       REG.IDCode,REG.Iddate,REG.Idplace,REG.Expiredate,REG.Address,REG.Taxcode,REG.PrivatePhone,
       REG.Mobile,REG.Fax,REG.Email,REG.Office,REG.Position,REG.Country,REG.CustomerCity,
       REG.TKTGTT
from REGISTERONLINE REG,ALLCODE A1
where REG.AUTOID not in (select OLAUTOID from CFMAST where OPENVIA=''O'')
and A1.CDNAME = ''CUSTTYPE''
and A1.CDTYPE=''CF''
and A1.CDVAL=REG.CustomerType', 'ONLINERES', NULL, NULL, 'EXEC', NULL, 5000, 'N', 1, 'NYNNYYYNNN', 'Y', 'T', NULL, 'N', NULL);COMMIT;