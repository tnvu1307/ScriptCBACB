SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9020','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'PLIS_DESTINATION_TICKET', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TRADEPLACE=''001'' THEN ''HOSE''
             WHEN TRADEPLACE=''002'' THEN ''HNX''
             WHEN TRADEPLACE=''003'' THEN ''DCCNY''
             WHEN TRADEPLACE=''005'' THEN ''UPCOM''
             WHEN TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES
WHERE CODEID IN (SELECT CODEID FROM CASCHD WHERE AUTOID =''<$FILTERID>'')', 'Sàn giao dịch CK được nhận', 'Place Listing of Destination Ticket', 'C', 'Y', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'PAYD_DT', 'C', '<$TXNUM>', 'select  case when instr(''005,028,006'',catype) >0  then ''RDTE//''||to_char(reportdate,''RRRRMMDD'')
             when instr(''005,028,006'',catype) <= 0  then ''XDTE//''||to_char(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'')
              else  '':98A:://UKWN'' end
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Ngày thanh toán', 'Settlement Date', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'ELIG_TYPE', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/''|| REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/''|| REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
        END) ELIG
FROM <$REFOBJ> CAS, CAMAST CA, SBSECURITIES SB
WHERE CA.CODEID  = SB.CODEID
AND CAS.CAMASTID = CA.CAMASTID
AND CAS.AUTOID = ''<$FILTERID>''', 'Số CK chốt quyền', 'The balance of the stock', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'INBA', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 then ''UNIT/''||CAS.pbalance
            ELSE ''FAMT/''||CAS.pbalance END)
    FROM <$REFOBJ> CAS,sbsecurities SB, CAMAST CA
    WHERE   CAS.AUTOID = ''<$FILTERID>''
        AND CA.CODEID = SB.CODEID
        AND CAS.CAMASTID = CA.CAMASTID', 'SL chứng khoán quyền', 'The balance of the stock', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'PLIS_SOURCE_TICKET', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TRADEPLACE=''001'' THEN ''HOSE''
             WHEN TRADEPLACE=''002'' THEN ''HNX''
             WHEN TRADEPLACE=''003'' THEN ''DCCNY''
             WHEN TRADEPLACE=''005'' THEN ''UPCOM''
             WHEN TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES
WHERE CODEID IN (SELECT CODEID FROM CASCHD WHERE AUTOID =''<$FILTERID>'')', 'Nơi niêm yết', 'Place Listing Underlying Stock', 'C', 'Y', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'BALANCE', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT REPLACE(TO_CHAR((CASE WHEN INSTR(EXRATE, ''/'') > 0 THEN SUBSTR(EXRATE,0,INSTR(EXRATE, ''/'') - 1) ELSE EXRATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(EXRATE, ''/'') > 0 THEN SUBSTR(EXRATE,INSTR(EXRATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM CAMAST
    WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')
) TMP', 'Balance', 'Destination Ticket', 'C', 'Y', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'ADEX_RATIO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT REPLACE(TO_CHAR((CASE WHEN INSTR(RIGHTOFFRATE, ''/'') > 0 THEN SUBSTR(RIGHTOFFRATE,0,INSTR(RIGHTOFFRATE, ''/'') - 1) ELSE RIGHTOFFRATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(RIGHTOFFRATE, ''/'') > 0 THEN SUBSTR(RIGHTOFFRATE,INSTR(RIGHTOFFRATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM CAMAST
    WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')
) TMP', 'Tỷ lệ quyền hoặc chứng khoán mới', 'Conversion Ratio', 'C', 'N', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'DESCRIPTIONS', 'C', '@VSD confirmed', NULL, 'Mô tả', 'Transaction Description', 'C', 'Y', 20);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'CAMV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,015,016,027,024,021,011,017,029,031,032,003,019,020'',catype) >0 then ''MAND'' else ''VOLU'' END
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'CAMV_IND', 'CAMV_IND', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'SEME_ID', 'C', '<$TXNUM>', 'select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>''', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'CIF_NO', 'C', '<$TXNUM>', 'select cf.cifid from afmast af, cfmast cf
where af.custid =cf.custid and af.acctno in (select afacctno from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'SOURCE_TICKET', 'C', '<$TXNUM>', 'select isincode from sbsecurities where codeid in (select codeid from <$REFOBJ> where autoid =''<$FILTERID>'' )', 'Chứng khoán gốc', 'Underlying stock', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'CORP_STOCK_CODE', 'C', '<$TXNUM>', 'select camastid from <$REFOBJ> where autoid = ''<$FILTERID>''', 'Mã thực hiện quyền', 'The corporate action reference number', 'C', 'Y', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'VALU_DT', 'C', '<$TXNUM>', 'select TO_CHAR(actiondate,''RRRRMMDD'') from CAMAST WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 19);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'ENTL_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/''|| REPLACE(TO_CHAR(CAS.PQTTY,''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/''|| REPLACE(TO_CHAR(CAS.PQTTY,''FM999999999999990.999999''),''.'','','')
        END)B
FROM <$REFOBJ> CAS,CAMAST CA, SBSECURITIES SB
WHERE CA.CODEID = SB.CODEID
AND CA.CAMASTID = CAS.CAMASTID
AND CAS.AUTOID = ''<$FILTERID>''', 'Số lượng CK được nhận', 'Receiving Quantity', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'CRLFPAYD_DT', 'C', '<$TXNUM>', 'select  case when instr(''005,028,006'',catype) >0  then ''||:98A::MEET//''||to_char(actiondate,''RRRRMMDD'')
            when instr(''005,028,006'',catype) <= 0  then ''||:98A::RDTE//''||to_char(reportdate,''RRRRMMDD'')
             else  '''' end
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Ngày thanh toán', 'Settlement Date', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'CAEP_IND', 'C', '<$TXNUM>', 'select case when instr(''010,015,016,027,024,021,011,017,020,014,023'',catype) >0 then ''DISN''
            when instr(''005,028,006,029,031,032,003,030,019'',catype) >0 then ''GENL'' END
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Loại thông báo thực hiện quyền', 'Type of Notification', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'CAEV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,024'',catype) >0 then ''DVCA''
            when instr(''011'',catype) >0 then ''DVSE''
            when instr(''014'',catype) >0 then ''RHTS''
            when instr(''021'',catype) >0 then ''BONU''
            when instr(''005'',catype) >0 then ''MEET''
            when instr(''028,006'',catype) >0 then ''XMET''
            when instr(''015'',catype) >0 then ''INTR''
            when instr(''027'',catype) >0 then ''LIQU''
            when instr(''017,020,023'',catype) >0 then ''CONV''
            when instr(''019'',catype) >0 then ''CHAN''
            when instr(''030'',catype) >0 and instr(''001,003'',CASUBTYPE) >0 then ''TEND''
            when instr(''030'',catype) >0 and CASUBTYPE=''002'' then ''OTHR''
            when instr(''031,032'',catype) >0 then ''OTHR''
            when instr(''003'',catype) >0 then ''DLST''
            when instr(''016'',catype) >0 then ''REDM''
            when instr(''029'',catype) >0 then ''INFO''    END
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'OPTSYMBOL', 'C', '<$TXNUM>', 'SELECT optisincode FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Mã CK quyền trung gian', 'Destination Ticket', 'C', 'Y', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'DESTINATION_TICKET', 'C', '<$TXNUM>', 'SELECT SB.isincode FROM camast CA, sbsecurities SB where ca.tocodeid = sb.codeid and ca.camastid in (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Sàn giao dịch CK được nhận', 'Place Listing of Destination Ticket', 'C', 'Y', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'ACTD_DT', 'C', '<$TXNUM>', 'select TO_CHAR(actiondate,''RRRRMMDD'') from CAMAST WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 19);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'CICCODE', 'C', '<$TXNUM>', 'SELECT CF.SWIFTCODE
FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID=AF.CUSTID AND AF.ACCTNO IN (SELECT AFACCTNO  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'PRICE', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(EXPRICE,''FM999999999999990.999999''),''.'','','') PRICE
FROM CAMAST
WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Giá đặt mua', 'Price', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9020', '564.CORP.REPE.QM', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'') FROM CAMAST
WHERE CAMASTID  IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);COMMIT;