SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9019','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'ENTL_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''011,021'',CA.CATYPE) > 0 AND INSTR(''001,002,008,011'',B.SECTYPE)>0 THEN ''UNIT/''|| CAS.QTTY
             WHEN INSTR(''011,021'',CA.CATYPE) = 0 AND INSTR(''001,002,008,011'',C.SECTYPE)>0 THEN ''UNIT/''|| CAS.QTTY
             WHEN INSTR(''011,021'',CA.CATYPE) = 0 AND INSTR(''001,002,008,011'',C.SECTYPE)=0 THEN ''FAMT/''|| CAS.QTTY
             ELSE ''UNIT/''|| CAS.QTTY
        END )ELIG
FROM CAMAST CA,
(
    SELECT AUTOID, CAMASTID, REPLACE(TO_CHAR(NVL(QTTY,0),''FM999999999999990.999999''),''.'','','') QTTY FROM <$REFOBJ>
) CAS,
(
    SELECT CA.CAMASTID,CA.CATYPE, SB.SECTYPE FROM SBSECURITIES SB, CAMAST CA WHERE SB.CODEID = CA.CODEID AND CA.CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')
) B,
(
    SELECT CA.CAMASTID,CA.CATYPE, SB.SECTYPE FROM SBSECURITIES SB, CAMAST CA WHERE SB.CODEID = CA.TOCODEID AND CA.CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')
)C
WHERE CAS.AUTOID = ''<$FILTERID>''
AND CA.CAMASTID = B.CAMASTID(+)
AND CA.CAMASTID = C.CAMASTID(+)
AND CAS.CAMASTID = CA.CAMASTID', 'Số lượng CK được nhận', 'Receiving Quantity', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'PLIS_DESTINATION_TICKET', 'C', '<$TXNUM>', 'SELECT CASE WHEN INSTR(''011,021'',CA.CATYPE)>0 AND B.TRADEPLACE=''001'' THEN ''HOSE''
            WHEN INSTR(''011,021'',CA.CATYPE)>0 AND B.TRADEPLACE=''002'' THEN ''HNX''
            WHEN INSTR(''011,021'',CA.CATYPE)>0 AND B.TRADEPLACE=''003'' THEN ''DCCNY''
            WHEN INSTR(''011,021'',CA.CATYPE)>0 AND B.TRADEPLACE=''005'' THEN ''UPCOM''
            WHEN INSTR(''011,021'',CA.CATYPE)>0 AND B.TRADEPLACE=''010'' THEN ''BOND''
            WHEN INSTR(''011,021'',CA.CATYPE)=0 AND C.TRADEPLACE=''001'' THEN ''HOSE''
            WHEN INSTR(''011,021'',CA.CATYPE)=0 AND C.TRADEPLACE=''002'' THEN ''HNX''
            WHEN INSTR(''011,021'',CA.CATYPE)=0 AND C.TRADEPLACE=''003'' THEN ''DCCNY''
            WHEN INSTR(''011,021'',CA.CATYPE)=0 AND C.TRADEPLACE=''005'' THEN ''UPCOM''
            WHEN INSTR(''011,021'',CA.CATYPE)=0 AND C.TRADEPLACE=''010'' THEN ''BOND''
        END
FROM CAMAST CA,
(SELECT CA.CAMASTID, SB.TRADEPLACE FROM SBSECURITIES SB, CAMAST CA WHERE SB.CODEID = CA.CODEID AND CA.CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')) B,
(SELECT CA.CAMASTID, SB.TRADEPLACE FROM SBSECURITIES SB, CAMAST CA WHERE SB.CODEID = CA.TOCODEID AND CA.CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>''))C
WHERE  CA.CAMASTID = B.CAMASTID(+)
AND CA.CAMASTID = C.CAMASTID(+)
AND CA.CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID =''<$FILTERID>'')', 'Sàn giao dịch mã CK nhận', 'Place Listing of Destination Ticket', 'C', 'Y', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'PAYD_DT', 'C', '<$TXNUM>', 'select  case when instr(''005,028,006'',catype) >0  then ''RDTE//''||to_char(reportdate,''RRRRMMDD'')
            when instr(''005,028,006'',catype) <= 0  then ''XDTE//''||to_char(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'')
            else  '':98A:://UKWN'' end
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Ngày thanh toán', 'Settlement Date', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'ADEX_RATIO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,0,INSTR(CA.RATE, ''/'') - 1) ELSE CA.RATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,INSTR(CA.RATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM
    (
        SELECT (CASE WHEN CATYPE IN (''011'',''020'') THEN DEVIDENTSHARES ELSE EXRATE END) RATE
        FROM CAMAST
        WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')
    ) CA
) TMP', 'Tỷ lệ hưởng cổ tức', 'Devided Ratio', 'C', 'N', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'PLIS_SOURCE_TICKET_G', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TRADEPLACE=''001'' THEN ''HOSE''
            WHEN TRADEPLACE=''002'' THEN ''HNX''
            WHEN TRADEPLACE=''003'' THEN ''DCCNY''
            WHEN TRADEPLACE=''005'' THEN ''UPCOM''
            WHEN TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES
WHERE CODEID IN (SELECT CODEID FROM CASCHD WHERE AUTOID =''<$FILTERID>'')', 'Nơi niêm yết', 'Place Listing Underlying Stock', 'C', 'Y', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'DESTINATION_TICKET', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''011,021'',CA.CATYPE)>0 THEN  B.ISINCODE
                ELSE C.ISINCODE END)ISIN
    FROM CAMAST CA,
        (SELECT CA.CAMASTID, SB.ISINCODE FROM sbsecurities SB, CAMAST CA WHERE SB.CODEID = CA.CODEID  AND CA.CAMASTID IN(SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')) B,
        (SELECT CA.CAMASTID, SB.ISINCODE FROM sbsecurities SB,CAMAST CA WHERE SB.CODEID = CA.TOCODEID  AND CA.CAMASTID IN(SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>''))C
    WHERE   CA.CAMASTID = B.CAMASTID(+)
        AND CA.CAMASTID = C.CAMASTID(+)
        AND CA.CAMASTID IN(SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Mã chứng khoán được nhận', 'Destination Ticket', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'PLIS_SOURCE_TICKET', 'C', '<$TXNUM>', 'SELECT CASE WHEN (CA.CATYPE=''017'' OR CA.CATYPE=''020'') AND SB.TRADEPLACE=''001'' THEN ''||''||'':16R:FIA''||''||''||'':94B::PLIS//EXCH/''||''HOSE''||''||''||'':16S:FIA''
            WHEN (CA.CATYPE=''017'' OR CA.CATYPE=''020'') AND SB.TRADEPLACE=''002'' THEN ''||''||'':16R:FIA''||''||''||'':94B::PLIS//EXCH/''||''HNX''||''||''||'':16S:FIA''
            WHEN (CA.CATYPE=''017'' OR CA.CATYPE=''020'') AND SB.TRADEPLACE=''003'' THEN ''||''||'':16R:FIA''||''||''||'':94B::PLIS//EXCH/''||''DCCNY''||''||''||'':16S:FIA''
            WHEN (CA.CATYPE=''017'' OR CA.CATYPE=''020'') AND SB.TRADEPLACE=''005'' THEN ''||''||'':16R:FIA''||''||''||'':94B::PLIS//EXCH/''||''UPCOM''||''||''||'':16S:FIA''
            WHEN (CA.CATYPE=''017'' OR CA.CATYPE=''020'') AND SB.TRADEPLACE=''010'' THEN ''||''||'':16R:FIA''||''||''||'':94B::PLIS//EXCH/''||''BOND''||''||''||'':16S:FIA''
            ELSE '''' END
FROM SBSECURITIES SB, CAMAST CA
WHERE SB.CODEID = CA.CODEID
AND CA.CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID =''<$FILTERID>'')', 'Sàn giao dịch mã CK ghi giảm', 'Place Listing of Source Ticket', 'C', 'N', 20);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'DESCRIPTIONS', 'C', '@VSD confirmed', NULL, 'Mô tả', 'Transaction Description', 'C', 'Y', 24);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CICCODE', 'C', '<$TXNUM>', 'SELECT CF.SWIFTCODE
FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID=AF.CUSTID AND AF.ACCTNO IN (SELECT AFACCTNO  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'SEME_ID', 'C', '<$TXNUM>', 'select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>''', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CIF_NO', 'C', '<$TXNUM>', 'select cf.cifid from afmast af, cfmast cf
where af.custid =cf.custid and af.acctno in (select afacctno from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'SOURCE_TICKET', 'C', '<$TXNUM>', 'select isincode from sbsecurities where codeid in (select codeid from <$REFOBJ> where autoid =''<$FILTERID>'' )', 'Chứng khoán gốc', 'Underlying stock', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CORP_STOCK_CODE', 'C', '<$TXNUM>', 'select camastid from <$REFOBJ> where autoid = ''<$FILTERID>''', 'Mã thực hiện quyền', 'The corporate action reference number', 'C', 'Y', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'VALU_DT', 'C', '<$TXNUM>', 'select to_char(actiondate,''RRRRMMDD'') from CAMAST WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 23);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CRDB_IND', 'C', '<$TXNUM>', NULL, 'CRDB_IND', 'CRDB_IND', 'C', 'N', 18);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CAEP_IND', 'C', '<$TXNUM>', 'select case when instr(''010,015,016,027,024,021,011,017,020,014,023'',catype) >0 then ''DISN''
            when instr(''005,028,006,029,031,032,003,030,019'',catype) >0 then ''GENL'' END
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Loại thông báo thực hiện quyền', 'Type of Notification', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CAEV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,024'',catype) >0 then ''DVCA''
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
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CAMV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,015,016,027,024,021,011,017,029,031,032,003,019,020'',catype) >0 then ''MAND'' else ''VOLU'' END
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'CAMV_IND', 'CAMV_IND', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'ACTD_DT', 'C', '<$TXNUM>', 'select to_char(actiondate,''RRRRMMDD'') from CAMAST WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 22);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'CRLFPAYD_DT', 'C', '<$TXNUM>', 'select  case when instr(''005,028,006'',catype) >0  then ''||:98A::MEET//''||to_char(actiondate,''RRRRMMDD'')
            when instr(''005,028,006'',catype) <= 0  then ''||:98A::RDTE//''||to_char(reportdate,''RRRRMMDD'')
             else  '''' end
from camast where camastid in (select camastid  from <$REFOBJ> where autoid = ''<$FILTERID>'')', 'Ngày thanh toán', 'Settlement Date', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'ELIG_TYPE', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE)>0 THEN ''UNIT/''|| REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/''|| REPLACE(TO_CHAR(CAS.TRADE * M.PARVALUE,''FM999999999999990.999999''),''.'','','')
         END) ELIG
FROM <$REFOBJ> CAS,SBSECURITIES SB, CAMAST M
WHERE CAS.AUTOID = ''<$FILTERID>''
AND CAS.CODEID = SB.CODEID
AND CAS.CAMASTID = M.CAMASTID', 'Số CK chốt quyền', 'The balance of the stock', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'SOURCE_TICKET_D', 'C', '<$TXNUM>', 'select case when CA.catype=''017'' or CA.catype=''020'' then ''||:22H::CRDB//DEBT||:35B::ISIN ''||SB.isincode else '''' end
from sbsecurities SB, CAMAST CA where SB.codeid = CA.CODEID AND CA.camastid  in (select camastid from <$REFOBJ> where autoid =''<$FILTERID>'' )', 'Mã chứng khoán ghi giảm', 'Source Ticket', 'C', 'N', 19);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'ROUND', 'C', '<$TXNUM>', 'SELECT (CASE WHEN EXPRICE <= 0 THEN '':22F::DISF//RDDN'' ELSE '':22F::DISF//CINL'' || ''||'' || '':90B::CINL//ACTU/VND'' || REPLACE(TO_CHAR(EXPRICE,''FM999999999999990.999999''),''.'','','') END) ROUND
FROM CAMAST
WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Round', 'Round', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9019', '564.CORP.REPE.CP', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'') FROM CAMAST
WHERE CAMASTID  IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);COMMIT;