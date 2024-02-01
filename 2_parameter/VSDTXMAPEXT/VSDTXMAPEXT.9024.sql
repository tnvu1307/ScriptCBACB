SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9024','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'')
FROM CAMAST
WHERE CAMASTID IN (SELECT MAX(CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID FROM TLLOGFLD F WHERE F.TXNUM = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'CAEV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,024'',catype) >0 then ''DVCA''
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
from camast where camastid in (SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'CICCODE', 'C', '<$TXNUM>', 'SELECT CF.SWIFTCODE
FROM CFMAST CF WHERE  CF.CUSTODYCD IN (SELECT  MAX (CASE WHEN f.fldcd = ''19'' THEN f.cvalue ELSE '''' END)  CAID
                                                            FROM TLLOGFLD F
                                                                WHERE TXNUM = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'SEME_ID', 'C', '<$TXNUM>', 'SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'TICKET_INFO', 'C', '<$TXNUM>', 'select isincode from sbsecurities where codeid in
(SELECT  MAX (CASE WHEN f.fldcd = ''24'' THEN f.cvalue ELSE '''' END)  SB
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Mã chứng khoán', 'Ticket Information', 'C', 'Y', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'VALU_DT', 'C', '<$TXNUM>', 'SELECT  to_char(to_date(f.cvalue,''dd/mm/yyyy''),''RRRRMMDD'')
    FROM TLLOGFLD F
        WHERE   F.FLDCD IN (''07'')
            AND F.TXNUM = ''<$FILTERID>''', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'ADEX_RATIO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,0,INSTR(CA.RATE, ''/'') - 1) ELSE CA.RATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,INSTR(CA.RATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM
    (
        SELECT (CASE WHEN CATYPE IN (''011'') THEN DEVIDENTSHARES
                     ELSE EXRATE
                END) RATE
        FROM CAMAST
        WHERE CAMASTID IN (
            SELECT  MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID
            FROM TLLOGFLD F
            WHERE TXNUM = ''<$FILTERID>''
        )
    ) CA
) TMP', 'Tỷ lệ chia cổ tức', 'Dividend Rate', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'CIF_NO', 'C', '<$TXNUM>', 'SELECT CIFID FROM CFMAST WHERE CUSTODYCD IN
(SELECT  MAX (CASE WHEN f.fldcd = ''19'' THEN f.cvalue ELSE '''' END)  CUSTODYCD
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'CONB_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/'' || REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
        END)  TRADE
FROM CASCHD CAS,SBSECURITIES SB
WHERE CAS.CODEID = SB.CODEID
AND (CAS.CAMASTID, CAS.AUTOID) IN (
    SELECT MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID,
           MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END) CASCHD_ID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
)', 'Số lượng CK được chốt quyền', 'Account Balance', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'DESTINATION_TICKET', 'C', '<$TXNUM>', 'select isincode from sbsecurities where codeid in
(SELECT  MAX (CASE WHEN f.fldcd = ''24'' THEN f.cvalue ELSE '''' END)  SB
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Mã chứng khoán nhận', 'Destination Ticket', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'INTR_RATIO', 'C', '<$TXNUM>', 'SELECT interestrate FROM CAMAST WHERE CAMASTID IN
(SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Tỷ lệ lãi được hưởng trên 1 trái phiếu', 'Interest Ratio', 'C', 'N', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'PAYD_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thanh toán', 'Payment Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'PLIS_DESTINATION_TICKET', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TRADEPLACE=''001'' THEN ''HOSE''
             WHEN TRADEPLACE=''002'' THEN ''HNX''
             WHEN TRADEPLACE=''003'' THEN ''DCCNY''
             WHEN TRADEPLACE=''005'' THEN ''UPCOM''
             WHEN TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES
WHERE CODEID IN (SELECT MAX(CASE WHEN F.FLDCD = ''24'' THEN F.CVALUE ELSE '''' END) SB
                FROM TLLOGFLD F
                WHERE F.TXNUM = ''<$FILTERID>'')', 'Sàn giao dịch mã CK nhận', 'Place Listing of Destination Ticket', 'C', 'Y', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'POST_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thực tế phân bổ', 'Posting Date', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'PREP_DT', 'C', '<$TXNUM>', 'select to_char(SYSDATE,''RRRRMMDDHh24mmss'')PREP from dual', 'Ngày tạo', 'Prepair Date', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'PSTA_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(CAS.QTTY,''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/'' || REPLACE(TO_CHAR(CAS.QTTY,''FM999999999999990.999999''),''.'','','')
        END)  QTTY
FROM CASCHD CAS,SBSECURITIES SB
WHERE CAS.CODEID = SB.CODEID
AND (CAS.CAMASTID, CAS.AUTOID) IN (
SELECT MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID,
       MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END) CASCHD_ID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
)', 'Số lượng CK được phân bổ', 'Receiving Quantity', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9024', '566.CORP.CONF.CP', 'RDTE_DT', 'C', '<$TXNUM>', 'select to_char(REPORTDATE,''RRRRMMDD'') from camast
where camastid  in (SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Ngày đăng ký cuối cùng', 'RDTE_DT', 'C', 'N', 8);COMMIT;