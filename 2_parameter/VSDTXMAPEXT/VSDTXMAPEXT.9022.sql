SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9022','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'PLIS_SOURCE_TICKET', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TRADEPLACE=''001'' THEN ''HOSE''
            WHEN TRADEPLACE=''002'' THEN ''HNX''
            WHEN TRADEPLACE=''003'' THEN ''DCCNY''
            WHEN TRADEPLACE=''005'' THEN ''UPCOM''
            WHEN TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES
WHERE CODEID IN (SELECT CODEID FROM CASCHD WHERE AUTOID =''<$FILTERID>'')', 'Nơi niêm yết', 'Place Listing Underlying Stock', 'C', 'Y', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'CAEP_IND', 'C', '<$TXNUM>', 'select case when instr(''010,015,016,027,024,021,011,017,020,014,023'',catype) >0 then ''DISN''
            when instr(''005,028,006,029,031,032,003,030,019'',catype) >0 then ''GENL'' END
from camast where camastid in (select camastid  from CASCHD where autoid = ''<$FILTERID>'')', 'Loại thông báo thực hiện quyền', 'Type of Notification', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'CAEV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,024'',catype) >0 then ''DVCA''
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
from camast where camastid in (select camastid  from CASCHD where autoid = ''<$FILTERID>'')', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'CIF_NO', 'C', '<$TXNUM>', 'select cf.cifid from afmast af, cfmast cf
where af.custid =cf.custid and af.acctno in (select afacctno from caschd where autoid = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'PAYD_DT', 'C', '<$TXNUM>', 'select  case when instr(''005,028,006'',catype) >0  then ''RDTE//''||to_char(reportdate,''RRRRMMDD'')
            when instr(''005,028,006'',catype) <= 0  then ''XDTE//''||to_char(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'')
            else  '':98A:://UKWN'' end
from camast where camastid in (select camastid  from CASCHD where autoid = ''<$FILTERID>'')', 'Ngày thanh toán', 'Settlement Date', 'C', 'Y', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'DESCRIPTIONS', 'C', '@VSD confirmed', 'SELECT PURPOSEDESC FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID FROM CASCHD WHERE AUTOID = ''<$FILTERID>'')', 'Mô tả', 'Transaction Description', 'C', 'Y', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'CRLFPAYD_DT', 'C', '<$TXNUM>', 'select  case when instr(''005,028,006'',catype) >0  then ''||:98A::MEET//''||to_char(actiondate,''RRRRMMDD'')
            when instr(''005,028,006'',catype) <= 0  then ''||:98A::RDTE//''||to_char(reportdate,''RRRRMMDD'')
             else  '''' end
from camast where camastid in (select camastid  from CASCHD where autoid = ''<$FILTERID>'')', 'Ngày thanh toán', 'Settlement Date', 'C', 'Y', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'DESCRIPTION', 'C', '<$TXNUM>', 'SELECT CA.DESCRIPTION ||
       (CASE WHEN CA.MEETINGPLACE IS NULL THEN '''' ELSE ''||'' || CA.MEETINGPLACE END) ||
       (CASE WHEN CA.MEETINGDATETIME IS NULL THEN '''' ELSE ''||'' || CA.MEETINGDATETIME END) ||
       (CASE WHEN V.VOTE IS NULL THEN '''' ELSE ''||'' || V.VOTE END)
FROM <$REFOBJ> CAS, CAMAST CA,
(
    SELECT CAMASTID, LISTAGG(VOTING, ''||'') WITHIN GROUP (ORDER BY CAMASTID) VOTE
    FROM CAVOTING
    GROUP BY CAMASTID
) V
WHERE CAS.AUTOID = ''<$FILTERID>''
AND CAS.CAMASTID = CA.CAMASTID
AND CAS.CAMASTID=V.CAMASTID(+)', 'Mô tả', 'Transaction Description', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'ELIG_TYPE', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/''|| REPLACE(TO_CHAR(NVL(CAS.TRADE,0),''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/''|| REPLACE(TO_CHAR(NVL(CAS.TRADE,0) * CA.PARVALUE,''FM999999999999990.999999''),''.'','','')
        END) ELIG
FROM SBSECURITIES SB, CAMAST CA ,<$REFOBJ> CAS
WHERE SB.CODEID = CA.CODEID
AND CA.CAMASTID = CAS.CAMASTID
AND CAS.AUTOID = ''<$FILTERID>''', 'Số CK chốt quyền', 'The balance of the stock', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'CICCODE', 'C', '<$TXNUM>', 'SELECT CF.SWIFTCODE
FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID=AF.CUSTID AND AF.ACCTNO IN (SELECT AFACCTNO  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'SEME_ID', 'C', '<$TXNUM>', 'select camastid  from CASCHD where autoid = ''<$FILTERID>''', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'SOURCE_TICKET', 'C', '<$TXNUM>', 'select isincode from sbsecurities where codeid in (select codeid from caschd where autoid =''<$FILTERID>'' )', 'Chứng khoán gốc', 'Underlying stock', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'CORP_STOCK_CODE', 'C', '<$TXNUM>', 'select camastid from caschd where autoid = ''<$FILTERID>''', 'Mã thực hiện quyền', 'The corporate action reference number', 'C', 'Y', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'CAMV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,015,016,027,024,021,011,017,029,031,032,003,019,020'',catype) >0 then ''MAND'' else ''VOLU'' END
from camast where camastid in (select camastid  from CASCHD where autoid = ''<$FILTERID>'')', 'CAMV_IND', 'CAMV_IND', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9022', '564.CORP.REPE.ANN', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'') FROM CAMAST
WHERE CAMASTID  IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);COMMIT;