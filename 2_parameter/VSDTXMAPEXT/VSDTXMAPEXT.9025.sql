SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9025','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'DESTINATION_TICKET', 'C', '<$TXNUM>', 'select case when a1.cvalue = ''N'' then a2.isincode else a3.isincode end
from
    (select cvalue,txnum from tllogfld where txnum = ''<$FILTERID>'' and fldcd = ''10'') a1,
    (select sb.isincode,a2.txnum from tllogfld a2, sbsecurities sb where txnum = ''<$FILTERID>'' and fldcd = ''24'' and a2.cvalue = sb.codeid(+)) a2,
    (select sb.isincode,f.txnum from tllogfld f, sbsecurities sb, camast ca where txnum = ''<$FILTERID>'' and f.fldcd = ''02'' and f.cvalue = ca.camastid and ca.codeid = sb.codeid )a3
where   a1.txnum = a2.txnum
    and a1.txnum = a3.txnum', 'Mã CK nhận', 'Destination Ticket', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'CONB_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
            ELSE ''FAMT/'' || REPLACE(TO_CHAR(CAS.TRADE*CA.PARVALUE,''FM999999999999990.999999''),''.'','','')
        END)
FROM CASCHD CAS ,SBSECURITIES SB,CAMAST CA,
(
    SELECT  MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID,
    MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END) AUTOID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
)F
WHERE CAS.CODEID = SB.CODEID
AND CAS.CAMASTID = F.CAID
AND CAS.CAMASTID = CA.CAMASTID
AND CAS.AUTOID = F.AUTOID', 'Số lượng CK được chốt quyền', 'Account Balance', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'PREP_DT', 'C', '<$TXNUM>', 'select to_char(SYSDATE,''RRRRMMDDHh24mmss'')PREP from dual', 'Ngày tạo', 'Prepair Date', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'CIF_NO', 'C', '<$TXNUM>', 'SELECT CIFID FROM CFMAST WHERE CUSTODYCD IN
(SELECT  MAX (CASE WHEN f.fldcd = ''19'' THEN f.cvalue ELSE '''' END)  CUSTODYCD
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'RDTE_DT', 'C', '<$TXNUM>', 'select to_char(REPORTDATE,''RRRRMMDD'') from camast
where camastid  in (SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Ngày đăng ký cuối cùng', 'RDTE_DT', 'C', 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'PAYD_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thanh toán', 'Payment Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'SOURCE_TICKET', 'C', '<$TXNUM>', 'select (case when f.de = ''Y'' THEN SB.isincode ELSE '''' END) ISIN
from sbsecurities sb,
        (SELECT TXNUM,
                MAX (CASE WHEN f.fldcd = ''24'' THEN f.cvalue ELSE '''' END)  SB,
                 MAX (CASE WHEN f.fldcd = ''10'' THEN f.cvalue ELSE '''' END)  de
            FROM TLLOGFLD F
                group by txnum
        )f
    WHERE  f.txnum = ''<$FILTERID>''
        and f.sb = sb.codeid', 'Mã CK đã cắt', 'Source Ticket', 'C', 'Y', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'SEME_ID', 'C', '<$TXNUM>', 'SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'CAEV_IND', 'C', '<$TXNUM>', 'select case when instr(''010,024'',catype) >0 then ''DVCA''
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
        WHERE TXNUM = ''<$FILTERID>'')', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'TICKET_INFO', 'C', '<$TXNUM>', 'select sb.isincode
    from sbsecurities sb ,caschd cas,
        (
            SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID,
                        MAX (CASE WHEN f.fldcd = ''01'' THEN f.cvalue ELSE '''' END) autoid
                    FROM TLLOGFLD F
                        WHERE TXNUM = ''<$FILTERID>''
        )f
    where   sb.codeid = cas.codeid
        and cas.camastid  = f.caid
        and cas.autoid = f.autoid', 'Mã chứng khoán', 'Ticket Information', 'C', 'Y', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'POST_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thực tế phân bổ', 'Posting Date', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'VALU_DT', 'C', '<$TXNUM>', 'SELECT  to_char(to_date(f.cvalue,''dd/mm/yyyy''),''RRRRMMDD'')
    FROM TLLOGFLD F
        WHERE   F.FLDCD IN (''07'')
            AND F.TXNUM = ''<$FILTERID>''', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'PSTA_DEVIDED_QUANTITY', 'C', '<$TXNUM>', 'select (case when f.de = ''Y'' THEN F.SL ELSE 0 END)PSTA from
(
    SELECT  txnum,
        MAX (CASE WHEN f.fldcd = ''11'' THEN f.Nvalue ELSE 0 END)  SL,
        MAX (CASE WHEN f.fldcd = ''10'' THEN f.cvalue ELSE '''' END)  de
        FROM TLLOGFLD F
            group by f.txnum) f
WHERE f.TXNUM = ''<$FILTERID>''', 'Số lượng CK đã cắt', 'The debited quantity', 'C', 'N', 19);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'POST_DT_D', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thực tế phân bổ', 'Posting Date', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'VALU_DT_D', 'C', '<$TXNUM>', 'SELECT  to_char(to_date(f.cvalue,''dd/mm/yyyy''),''RRRRMMDD'')
    FROM TLLOGFLD F
        WHERE   F.FLDCD IN (''07'')
            AND F.TXNUM = ''<$FILTERID>''', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 15);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'PAYD_DT_D', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thanh toán', 'Payment Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'')
FROM CAMAST
WHERE CAMASTID IN (SELECT MAX(CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID FROM TLLOGFLD F WHERE F.TXNUM = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'CICCODE', 'C', '<$TXNUM>', 'SELECT SWIFTCODE FROM CFMAST WHERE CUSTODYCD IN
(SELECT  MAX (CASE WHEN f.fldcd = ''19'' THEN f.cvalue ELSE '''' END)  CUSTODYCD
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'ADEX_RATIO_D', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,0,INSTR(CA.RATE, ''/'') - 1) ELSE CA.RATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,INSTR(CA.RATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM
    (
        SELECT (CASE WHEN CATYPE =''020'' THEN DEVIDENTSHARES
                     WHEN CATYPE =''014'' THEN RIGHTOFFRATE
                     ELSE EXRATE
                END) RATE
        FROM CAMAST
        WHERE CAMASTID IN (
            SELECT MAX(CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAMASTID
            FROM TLLOGFLD F
            WHERE TXNUM = ''<$FILTERID>''
        )
    ) CA
) TMP', 'Tỷ lệ chuyển đổi', 'Convertion Ratio', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'INTR_RATIO', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(INTERESTRATE,''FM999999999999990.999999''),''.'','','')
FROM CAMAST
WHERE CAMASTID IN (SELECT MAX(CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID FROM TLLOGFLD F WHERE TXNUM = ''<$FILTERID>'')', 'Tỷ lệ lãi được hưởng trên 1 trái phiếu', 'Interest Ratio', 'C', 'N', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'PSTA_RECEIVE_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN F.N_10 = ''N'' THEN (
            CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(F.N_11,''FM999999999999990.999999''),''.'','','')
                 ELSE ''FAMT/'' || REPLACE(TO_CHAR(F.N_11,''FM999999999999990.999999''),''.'','','')
            END
       )
       ELSE (
            CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(F.N_13,''FM999999999999990.999999''),''.'','','')
                 ELSE ''FAMT/'' || REPLACE(TO_CHAR(F.N_13,''FM999999999999990.999999''),''.'','','')
            END
       )
       END) VAL
FROM (
    SELECT MAX (CASE WHEN FLDCD = ''02'' THEN CVALUE ELSE '''' END)CAMASTID,
           MAX (CASE WHEN FLDCD = ''11'' THEN NVALUE ELSE 0 END)N_11,
           MAX (CASE WHEN FLDCD = ''24'' THEN CVALUE ELSE '''' END)CODEID,
           MAX (CASE WHEN FLDCD = ''13'' THEN NVALUE ELSE 0 END)N_13,
           MAX (CASE WHEN FLDCD = ''10'' THEN CVALUE ELSE '''' END)N_10
    FROM TLLOGFLD WHERE TXNUM = ''<$FILTERID>''
) F,SBSECURITIES SB
WHERE  F.CODEID = SB.CODEID', 'Số lượng CK được phân bổ', 'The receiving quatity', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'ADEX_RATIO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END)
FROM(
    SELECT REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,0,INSTR(CA.RATE, ''/'') - 1) ELSE CA.RATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(CA.RATE, ''/'') > 0 THEN SUBSTR(CA.RATE,INSTR(CA.RATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM
    (
        SELECT (CASE WHEN CATYPE IN (''020'') THEN DEVIDENTSHARES
                     WHEN CATYPE IN (''014'') THEN RIGHTOFFRATE
                     ELSE EXRATE
                END) RATE
        FROM CAMAST
        WHERE CAMASTID IN (
            SELECT MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID
            FROM TLLOGFLD F
            WHERE TXNUM = ''<$FILTERID>''
        )
    ) CA
) TMP', 'Tỷ lệ chuyển đổi', 'Convertion Ratio', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'PLIS_DESTINATION_TICKET', 'C', '<$TXNUM>', 'SELECT (CASE WHEN A1.CVALUE =''N''
                THEN (CASE WHEN A2.TRADEPLACE=''001'' THEN ''HOSE''
                           WHEN A2.TRADEPLACE=''002'' THEN ''HNX''
                           WHEN A2.TRADEPLACE=''003'' THEN ''DCCNY''
                           WHEN A2.TRADEPLACE=''005'' THEN ''UPCOM''
                           WHEN A2.TRADEPLACE=''010'' THEN ''BOND'' END)
                ELSE (CASE WHEN A3.TRADEPLACE=''001'' THEN ''HOSE''
                           WHEN A3.TRADEPLACE=''002'' THEN ''HNX''
                           WHEN A3.TRADEPLACE=''003'' THEN ''DCCNY''
                           WHEN A3.TRADEPLACE=''005'' THEN ''UPCOM''
                           WHEN A3.TRADEPLACE=''010'' THEN ''BOND'' END)
       END)PLIS
FROM (
    SELECT CVALUE, TXNUM FROM TLLOGFLD WHERE TXNUM = ''<$FILTERID>'' AND FLDCD = ''10''
) A1,
(
    SELECT SB.TRADEPLACE,A2.TXNUM FROM TLLOGFLD A2, SBSECURITIES SB WHERE TXNUM = ''<$FILTERID>'' AND FLDCD = ''24'' AND A2.CVALUE = SB.CODEID(+)
) A2,
(
    SELECT SB.TRADEPLACE,F.TXNUM FROM TLLOGFLD F, SBSECURITIES SB, CAMAST CA WHERE TXNUM = ''<$FILTERID>'' AND F.FLDCD = ''02'' AND F.CVALUE = CA.CAMASTID AND CA.CODEID = SB.CODEID
)A3
WHERE A1.TXNUM = A2.TXNUM
AND A1.TXNUM = A3.TXNUM', 'Sàn giao dịch mã CK nhận', 'Place Listing of Destination Ticket', 'C', 'Y', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9025', '566.CORP.CONF.BOND', 'CRED_DEBT', 'C', '<$TXNUM>', 'select (case when de =''N'' then ''CRED'' else ''DEBT'' end)D from (
SELECT  MAX (CASE WHEN f.fldcd = ''10'' THEN f.cvalue ELSE '''' END)  de
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''
        )', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);COMMIT;