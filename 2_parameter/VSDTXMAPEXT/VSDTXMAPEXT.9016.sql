SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9016','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'ADEX_RATIO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT REPLACE(TO_CHAR((CASE WHEN INSTR(EXRATE, ''/'') > 0 THEN SUBSTR(EXRATE,0,INSTR(EXRATE, ''/'') - 1) ELSE EXRATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(EXRATE, ''/'') > 0 THEN SUBSTR(EXRATE,INSTR(EXRATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM CAMAST
    WHERE CAMASTID IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')
) TMP', 'Nơi niêm yết', 'Place Information', 'C', 'Y', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'INTR_PERCENT', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(INTERESTRATE,''FM999999999999990.999999''),''.'','','')
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Tỷ lệ lãi', 'Coupon Rate', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'INT_AMT', 'C', '<$TXNUM>', 'SELECT ''VND'' || REPLACE(TO_CHAR(ROUND(PARVALUE*INTERESTRATE/100,6),''FM999999999999990.999999''),''.'','','')
FROM CAMAST
WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'So tien tren 1 trai phieu', 'Value per bond', 'C', 'N', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'EXPLIS_INFO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN SB.TRADEPLACE=''001'' THEN ''HOSE''
            WHEN SB.TRADEPLACE=''002'' THEN ''HNX''
            WHEN SB.TRADEPLACE=''003'' THEN ''DCCNY''
            WHEN SB.TRADEPLACE=''005'' THEN ''UPCOM''
            WHEN SB.TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES SB
WHERE SB.CODEID IN (SELECT CA.TOCODEID FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID = ''<$FILTERID>'' AND CA.CAMASTID = L.CAMASTID)', 'Nơi niêm yết', 'Place Information', 'C', 'Y', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'PLIS_INFO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TRADEPLACE=''001'' THEN ''HOSE''
            WHEN TRADEPLACE=''002'' THEN ''HNX''
            WHEN TRADEPLACE=''003'' THEN ''DCCNY''
            WHEN TRADEPLACE=''005'' THEN ''UPCOM''
            WHEN TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES
WHERE CODEID IN (SELECT CODEID FROM <$REFOBJ> WHERE AUTOID =''<$FILTERID>'')', 'Nơi niêm yết', 'Place Information', 'C', 'Y', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CAID', 'C', '<$TXNUM>', 'SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>''', 'CAMV_IND', 'CAMV_IND', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'DIVIREGR', 'C', '<$TXNUM>', 'SELECT CASE WHEN CATYPE=''010'' OR  CATYPE=''024'' OR  CATYPE=''015'' THEN '':22F:DIVI//REGR
'' ELSE '''' END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'TRDP_PERIOD', 'C', '<$TXNUM>', 'SELECT TO_CHAR(CA.FRDATETRANSFER,''RRRRMMDD'')||''/''||TO_CHAR(CA.TODATETRANSFER,''RRRRMMDD'')
FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'MKDT_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(CA.INSDEADLINE,''RRRRMMDD'')
FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'PWAL_DT_FROM', 'C', '<$TXNUM>', 'SELECT TO_CHAR(CA.BEGINDATE,''RRRRMMDD'')||''/''||TO_CHAR(CA.DUEDATE,''RRRRMMDD'')
FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'BUY_PRICE', 'C', '<$TXNUM>', 'SELECT CA.EXPRICE
FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'SUBSCRIPTION_PRICE', 'C', '<$TXNUM>', 'SELECT PARVALUE
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày thanh toán', 'Payment Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'PAYMENT_PERCENT', 'C', '<$TXNUM>', 'SELECT CASE WHEN CATYPE=''010'' THEN ''GRSS//VND''||TO_CHAR(DECODE(TYPERATE,''R'',PARVALUE*DEVIDENTRATE,DEVIDENTVALUE))
            WHEN CATYPE=''024'' THEN ''GRSS//VND''||TO_CHAR(DECODE(TYPERATE,''R'',EXPRICE*DEVIDENTRATE,DEVIDENTVALUE))
            WHEN CATYPE=''015'' THEN ''INTP//VND''||TO_CHAR(INTERESTRATE*PARVALUE)
       ELSE '''' END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Tỷ lệ phân bổ', 'Interest Amount', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'DIVISPEC', 'C', '<$TXNUM>', 'SELECT CASE WHEN CATYPE=''011'' THEN '':22F:DIVI//SPEC
'' ELSE '''' END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'STOCK_DESTINATION', 'C', '<$TXNUM>', 'SELECT SB.ISINCODE FROM SBSECURITIES SB WHERE SB.CODEID IN (
SELECT CA.TOCODEID
FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID)', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CRDBDEBT', 'C', '<$TXNUM>', 'SELECT CASE WHEN CATYPE=''017'' OR CATYPE=''020'' THEN '':22H:CRDB//DEBT
'' ELSE '''' END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'STOCK_OPTION', 'C', '<$TXNUM>', 'SELECT CA.OPTSYMBOL FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'INBA_AMT', 'C', '<$TXNUM>', 'SELECT PBALANCE FROM <$REFOBJ>  WHERE AUTOID =''<$FILTERID>''', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'SELL_IND', 'C', '<$TXNUM>', 'SELECT CASE WHEN TRFLIMIT =''N'' THEN ''NREN'' ELSE ''RENO'' END
FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'RTUN_RATE', 'C', '<$TXNUM>', 'SELECT CA.EXRATE
FROM <$REFOBJ> L, CAMAST CA WHERE L.AUTOID =''<$FILTERID>'' AND CA.CAMASTID =L.CAMASTID', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CICCODE', 'C', '<$TXNUM>', 'SELECT CF.SWIFTCODE
FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID=AF.CUSTID AND AF.ACCTNO IN (SELECT AFACCTNO  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CAMV_IND', 'C', '<$TXNUM>', 'SELECT CASE WHEN INSTR(''010,015,016,027,024,021,011,017,029,031,032,003,019'',CATYPE) >0 THEN ''MAND'' ELSE ''VOLU'' END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'CAMV_IND', 'CAMV_IND', 'C', 'N', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CAEP_IND', 'C', '<$TXNUM>', 'SELECT CASE WHEN INSTR(''010,015,016,027,024,021,011,017,020,014,023'',CATYPE) >0 THEN ''DISN''
            WHEN INSTR(''005,028,006,029,031,032,003,030,019'',CATYPE) >0 THEN ''GENL'' END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Loại thông báo thực hiện quyền', 'Type of Notification', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'EVENT_TP', 'C', '<$TXNUM>', 'SELECT CASE WHEN SWIFTCLIENT=''N'' THEN ''NEWM'' WHEN SWIFTCLIENT=''U'' THEN ''REPL''
            WHEN SWIFTCLIENT=''D'' THEN ''CANC'' WHEN SWIFTCLIENT=''M'' THEN ''RMDR'' END  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>''', 'Loại sự kiện doanh nghiệp', 'Corporate Action Event', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CAEV_IND', 'C', '<$TXNUM>', 'SELECT CASE WHEN INSTR(''010,024'',CATYPE) >0 THEN ''DVCA''
            WHEN INSTR(''011'',CATYPE) >0 THEN ''DVSE''
            WHEN INSTR(''014'',CATYPE) >0 THEN ''RHTS''
            WHEN INSTR(''021'',CATYPE) >0 THEN ''BONU''
            WHEN INSTR(''005'',CATYPE) >0 THEN ''MEET''
            WHEN INSTR(''028,006'',CATYPE) >0 THEN ''XMET''
            WHEN INSTR(''015'',CATYPE) >0 THEN ''INTR''
            WHEN INSTR(''027'',CATYPE) >0 THEN ''LIQU''
            WHEN INSTR(''017,020,023'',CATYPE) >0 THEN ''CONV''
            WHEN INSTR(''019'',CATYPE) >0 THEN ''CHAN''
            WHEN INSTR(''030'',CATYPE) >0 AND INSTR(''001,003'',CASUBTYPE) >0 THEN ''TEND''
            WHEN INSTR(''030'',CATYPE) >0 AND CASUBTYPE=''002'' THEN ''OTHR''
            WHEN INSTR(''031,032'',CATYPE) >0 THEN ''OTHR''
            WHEN INSTR(''003'',CATYPE) >0 THEN ''DLST''
            WHEN INSTR(''016'',CATYPE) >0 THEN ''REDM''
            WHEN INSTR(''029'',CATYPE) >0 THEN ''INFO''    END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'') FROM CAMAST
WHERE CAMASTID  IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CIF_NO', 'C', '<$TXNUM>', 'SELECT CF.CIFID FROM AFMAST AF, CFMAST CF
WHERE AF.CUSTID =CF.CUSTID AND AF.ACCTNO IN (SELECT AFACCTNO FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'STOCK_INFO', 'C', '<$TXNUM>', 'SELECT ISINCODE FROM SBSECURITIES WHERE CODEID IN (SELECT CODEID FROM <$REFOBJ> WHERE AUTOID =''<$FILTERID>'' )', 'Thông tin chứng khoán', 'Stock Information', 'C', 'Y', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'PROC_STATUS', 'C', '<$TXNUM>', 'SELECT CASE WHEN INSTR(''030'',CATYPE) >0 AND INSTR(''001,002'',CASUBTYPE) >0 THEN ''PREC''
            ELSE ''COMP''  END
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Trạng thái thông tin', 'Processing Status', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'RDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(REPORTDATE,''RRRRMMDD'') FROM CAMAST
WHERE CAMASTID  IN (SELECT CAMASTID FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày đăng ký cuối cùng', 'RDTE_DT', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'CAOP_IND', 'C', '@CASH', '', 'Loại phân bố', 'Supplement information', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'PAYD_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(ACTIONDATE,''RRRRMMDD'')
FROM CAMAST WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Ngày thanh toán', 'Payment Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9016', '564.CORP.NOTF.BOND', 'PRICE', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(EXPRICE,''FM999999999999990.999999''),''.'','','') PRICE
FROM CAMAST
WHERE CAMASTID IN (SELECT CAMASTID  FROM <$REFOBJ> WHERE AUTOID = ''<$FILTERID>'')', 'Giá đặt mua', 'Price', 'C', 'N', 11);COMMIT;