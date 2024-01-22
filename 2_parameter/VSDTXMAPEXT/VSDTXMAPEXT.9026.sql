SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9026','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'') FROM CAMAST
WHERE CAMASTID IN
(SELECT CAMASTID FROM CASCHD WHERE AUTOID = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'PREP_DT', 'C', '<$TXNUM>', 'select to_char(SYSDATE,''RRRRMMDDHh24mmss'')PREP from dual', 'Ngày tạo', 'Prepair Date', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'CIF_NO', 'C', '<$TXNUM>', 'SELECT CIFID FROM CFMAST WHERE CUSTODYCD IN
    (select cf.custodycd from cfmast cf, caschd cas, afmast af where    cas.afacctno = af.acctno and cf.custid = af.custid and cas.autoid = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'PAYD_DT', 'C', '<$BUSDATE>', 'select to_char(to_date(''<$FILTERID>'',''DD/MM/YYYY''),''RRRRMMDD'') FROM DUAL', 'Ngày thanh toán', 'Payment Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'SEME_ID', 'C', '<$TXNUM>', 'SELECT  camastid from caschd where autoid = ''<$FILTERID>''', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'ADEX_RATIO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT CATYPE,
           REPLACE(TO_CHAR((CASE WHEN INSTR(RIGHTOFFRATE, ''/'') > 0 THEN SUBSTR(RIGHTOFFRATE,0,INSTR(RIGHTOFFRATE, ''/'') - 1) ELSE RIGHTOFFRATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(RIGHTOFFRATE, ''/'') > 0 THEN SUBSTR(RIGHTOFFRATE,INSTR(RIGHTOFFRATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM CAMAST
    WHERE CAMASTID IN (SELECT CAMASTID FROM CASCHD WHERE AUTOID = ''<$FILTERID>'')
) TMP', 'Tỷ lệ chuyển đổi', 'Convertion Ratio', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'PLIS_DESTINATION_TICKET', 'C', '<$TXNUM>', 'SELECT (CASE WHEN SB.TRADEPLACE=''001'' THEN ''HOSE''
             WHEN SB.TRADEPLACE=''002'' THEN ''HNX''
             WHEN SB.TRADEPLACE=''003'' THEN ''DCCNY''
             WHEN SB.TRADEPLACE=''005'' THEN ''UPCOM''
             WHEN SB.TRADEPLACE=''010'' THEN ''BOND'' END) PLIS
FROM SBSECURITIES SB, CAMAST CA
WHERE SB.CODEID = CA.CODEID
AND CA.CAMASTID IN (SELECT CAMASTID FROM CASCHD WHERE AUTOID = ''<$FILTERID>'')', 'Sàn giao dịch mã CK nhận', 'Place Listing of Destination Ticket', 'C', 'Y', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'RDTE_DT', 'C', '<$TXNUM>', 'select to_char(REPORTDATE,''RRRRMMDD'') from camast
where camastid  in
    (select camastid from caschd where autoid = ''<$FILTERID>'')', 'Ngày đăng ký cuối cùng', 'RDTE_DT', 'C', 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'SOURCE_TICKET', 'C', '<$TXNUM>', 'select SB.isincode ISIN
from sbsecurities sb,caschd cas
    WHERE   sb.codeid = cas.codeid
        and cas.autoid = ''<$FILTERID>''', 'Mã CK đã cắt', 'Source Ticket', 'C', 'Y', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'CAEV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,024'',catype) >0 then ''DVCA''
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
from camast where camastid in (select camastid from caschd where autoid = ''<$FILTERID>'')', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'TICKET_INFO', 'C', '<$TXNUM>', 'select sb.isincode
    from sbsecurities sb ,camast ca
    where   sb.codeid = ca.codeid
        and ca.camastid  in(SELECT  camastid from caschd where autoid = ''<$FILTERID>'')', 'Mã chứng khoán', 'Ticket Information', 'C', 'Y', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'CONB_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
            ELSE ''FAMT/'' || REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
       END) VAL
FROM CASCHD CAS, SBSECURITIES SB
WHERE CAS.CODEID = SB.CODEID
AND CAS.AUTOID = ''<$FILTERID>''', 'Số lượng CK được chốt quyền', 'Account Balance', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'INTR_RATIO', 'C', '<$TXNUM>', 'SELECT NVL(interestrate,0) FROM CAMAST WHERE CAMASTID IN
    (SELECT  camastid from caschd where autoid = ''<$FILTERID>'')', 'Tỷ lệ lãi được hưởng trên 1 trái phiếu', 'Interest Ratio', 'C', 'N', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'DESTINATION_TICKET', 'C', '<$TXNUM>', 'select sb.isincode
    from sbsecurities sb, camast ca
        where   sb.codeid = ca.tocodeid
            and ca.camastid in
                (select camastid from caschd where autoid = ''<$FILTERID>'')', 'Mã CK nhận', 'Destination Ticket', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'POST_DT', 'C', '<$BUSDATE>', 'select to_char(to_date(''<$FILTERID>'',''DD/MM/YYYY''),''RRRRMMDD'') FROM DUAL', 'Ngày thực tế phân bổ', 'Posting Date', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'VALU_DT', 'C', '<$BUSDATE>', 'select to_char(to_date(''<$FILTERID>'',''DD/MM/YYYY''),''RRRRMMDD'') FROM DUAL', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'PSTA_RECEIVE_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(CAS.QTTY,''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/'' || REPLACE(TO_CHAR(CAS.QTTY,''FM999999999999990.999999''),''.'','','')
       END) VAL
FROM SBSECURITIES SB, CAMAST CA, CASCHD CAS
WHERE SB.CODEID = CA.CODEID
AND CA.CAMASTID = CAS.CAMASTID
AND CAS.AUTOID = ''<$FILTERID>''', 'Số lượng CK được phân bổ', 'The receiving quatity', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9026', '566.CORP.CONF.QM', 'CICCODE', 'C', '<$TXNUM>', 'SELECT SWIFTCODE FROM CFMAST WHERE CUSTODYCD IN
(SELECT cf.CUSTODYCD from cfmast cf, afmast af,caschd cas where   cf.custid = af.custid and af.acctno = cas.afacctno and cas.autoid = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);COMMIT;