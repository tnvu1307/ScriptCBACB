SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9023','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'TAXR_AMT', 'C', '<$TXNUM>', 'SELECT '':19B::TAXR//VND'' || REPLACE(TO_CHAR(
(
    CASE WHEN VAT <> ''Y'' THEN AMT
    ELSE (
        CASE WHEN CATYPE = ''010'' THEN (CASE WHEN CUSTTYPE = ''B'' THEN 0 ELSE NETT1 END)
             WHEN CATYPE = ''024'' THEN NETT2
             WHEN CATYPE IN (''027'',''015'') THEN NETT1
             WHEN CATYPE IN (''016'') THEN NETT3
        ELSE 0 END
    )
    END
),''FM999999999999990.999999''),''.'','','') TAXR
FROM (
    SELECT CF.VAT, CF.CUSTTYPE, CA.CATYPE, NVL(CAD.AMT, CAS.AMT) AMT,
           ROUND(NVL(CAD.AMT,CAS.AMT) * CA.PITRATE/100) NETT1,
           GREATEST(0, ROUND(CAS.BALANCE * CA.PITRATE/100 * CA.EXPRICE / CA.EXRATE)) NETT2,
           ROUND(CAS.INTAMT * CA.PITRATE/100) NETT3
    FROM CASCHD CAS, CFMAST CF, AFMAST AF,
    (
        SELECT CAMASTID, CATYPE, PITRATE, EXPRICE,
               NVL(CASE WHEN INSTR(EXRATE, ''/'') = 0 THEN TO_NUMBER(EXRATE) ELSE TO_NUMBER(SUBSTR(EXRATE, 0, INSTR(EXRATE, ''/'') - 1)) / TO_NUMBER(SUBSTR(EXRATE, INSTR(EXRATE,''/'') + 1, LENGTH(EXRATE))) END,1) EXRATE
        FROM CAMAST
    ) CA,
    (
        SELECT * FROM CASCHDDTL WHERE TXNUM = ''<$FILTERID>''
    ) CAD,
    (
        SELECT MAX (CASE WHEN F.FLDCD = ''10'' THEN F.NVALUE ELSE 0 END)  NVALUE,
                MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID,
                MAX (CASE WHEN F.FLDCD = ''05'' THEN F.CVALUE ELSE '''' END)  CATYPE,
                MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END)  AUTOID
        FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''
    ) A
    WHERE CAS.AUTOID = A.AUTOID
    AND A.CAID = CA.CAMASTID
    AND CF.CUSTID = AF.CUSTID
    AND AF.ACCTNO = CAS.AFACCTNO
    AND A.AUTOID = CAD.AUTOID_CASCHD(+)
)', 'Số tiền thuế', 'Tax mount', 'C', 'N', 14);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'TICKET_INFO', 'C', '<$TXNUM>', 'select isincode from sbsecurities where codeid in
(SELECT  MAX (CASE WHEN f.fldcd = ''24'' THEN f.cvalue ELSE '''' END)  SB
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Mã chứng khoán', 'Ticket Information', 'C', 'Y', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'PAYD_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thanh toán', 'Settlement Date', 'C', 'N', 18);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'POST_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(TL.TXDATE,''YYYYMMDD'')
    FROM TLLOG TL
        WHERE  TL.TXNUM = ''<$FILTERID>''', 'Ngày thực tế phân bổ', 'Posting Date', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'PREP_DT', 'C', '<$TXNUM>', 'select to_char(SYSDATE,''RRRRMMDDHh24mmss'')PREP from dual', 'Ngày tạo', 'Prepair Date', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'TAXR_RATE', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(CASE WHEN (CA.CATYPE = ''010'' AND CF.CUSTTYPE = ''B'') THEN 0 ELSE CA.PITRATE END,''FM999999999999990.999999''),''.'','','') RATE
FROM CASCHD CAS, CAMAST CA, CFMAST CF, AFMAST AF,
(
    SELECT MAX (CASE WHEN F.FLDCD = ''10'' THEN F.NVALUE ELSE 0 END)  NVALUE,
            MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID,
            MAX (CASE WHEN F.FLDCD = ''05'' THEN F.CVALUE ELSE '''' END)  CATYPE,
            MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END)  AUTOID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
) A
WHERE CAS.AUTOID = A.AUTOID
AND A.CAID = CA.CAMASTID
AND CF.CUSTID = AF.CUSTID
AND AF.ACCTNO = CAS.AFACCTNO', 'Tỷ lệ thuế khấu trừ', 'Tax Rate', 'C', 'N', 20);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'CONB_QUANTITY', 'C', '<$TXNUM>', 'SELECT (CASE WHEN INSTR(''001,002,008,011'',SB.SECTYPE) > 0 THEN ''UNIT/'' || REPLACE(TO_CHAR(CAS.TRADE,''FM999999999999990.999999''),''.'','','')
             ELSE ''FAMT/'' || REPLACE(TO_CHAR(CAS.TRADE* CA.PARVALUE,''FM999999999999990.999999''),''.'','','')
        END)  TRADE
FROM CASCHD CAS,SBSECURITIES SB,CAMAST CA
WHERE CAS.CODEID = SB.CODEID
AND CAS.CAMASTID = CA.CAMASTID
AND (CAS.CAMASTID,CAS.AUTOID) IN (
    SELECT  MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID,
            MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END) CASCHD_ID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
)', 'Số lượng CK được chốt quyền', 'Account Balance', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'INTP_RATE', 'C', '<$TXNUM>', 'SELECT REPLACE(
   CASE WHEN CA.CATYPE=''010'' THEN ''||:92F::GRSS//VND''||TO_CHAR(DECODE(CA.TYPERATE,''R'',CA.PARVALUE*CADL.DEVIDENTRATE/100,CADL.DEVIDENTVALUE),''FM999999999999990.999999'')
        WHEN CA.CATYPE=''015'' THEN ''||:92F::INTP//VND''||TO_CHAR(CA.INTERESTRATE/100*CA.PARVALUE,''FM999999999999990.999999'')
   ELSE '''' END
   ,''.'','','') VAL
FROM CAMAST CA, CAMASTDTL CADL,
(
    SELECT MAX(CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAMASTID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
) LOG
WHERE LOG.CAMASTID = CA.CAMASTID
AND LOG.CAMASTID = CADL.CAMASTID(+)', 'Cổ tức trên 1 mã CK', 'The rate per unit', 'C', 'N', 19);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'INTR_RATIO', 'C', '<$TXNUM>', 'SELECT (CASE WHEN CATYPE=''015'' THEN ''||:92A::INTR//'' || REPLACE(TO_CHAR(INTERESTRATE,''FM999999999999990.9999999999''),''.'','','') ELSE '''' END) VAL
FROM CAMAST
WHERE CAMASTID IN (SELECT MAX(CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID FROM TLLOGFLD F WHERE TXNUM = ''<$FILTERID>'')', 'Tỷ lệ lãi được hưởng trên 1 trái phiếu', 'Interest Ratio', 'C', 'N', 9);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'OFFR_PRICE', 'C', '<$TXNUM>', 'SELECT (CASE WHEN CATYPE=''016'' THEN ''||:90B::OFFR//ACTU/VND'' || REPLACE(TO_CHAR(PARVALUE*INTERESTRATE/100+PARVALUE,''FM999999999999990.999999''),''.'','','')
             WHEN CATYPE=''024'' THEN ''||:90B::OFFR//ACTU/VND'' || REPLACE(TO_CHAR(DECODE(TYPERATE,''R'',PARVALUE*DEVIDENTRATE/100,DEVIDENTVALUE),''FM999999999999990.999999''),''.'','','')
             WHEN CATYPE=''027'' THEN ''||:90B::OFFR//ACTU/VND'' || REPLACE(TO_CHAR(DECODE(TYPERATE,''R'',PARVALUE*DEVIDENTRATE/100,DEVIDENTVALUE),''FM999999999999990.999999''),''.'','','')
             ELSE ''''
       END) VAL
FROM CAMAST WHERE CAMASTID IN
(
    SELECT  MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
)', 'Số tiền trả cho 1 trái phiếu', 'The rate per bond', 'C', 'N', 21);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'WAPA_92D', 'C', '<$TXNUM>', 'SELECT CASE WHEN TMP.CATYPE = ''024'' THEN ''||:16R:FIA||:92D::WAPA//'' || (CASE WHEN TMP.DR = ''0,'' THEN TMP.DL ELSE TMP.DL || ''/'' || TMP.DR END) || ''||:16S:FIA'' ELSE '''' END
FROM(
    SELECT CATYPE,
           REPLACE(TO_CHAR((CASE WHEN INSTR(EXRATE, ''/'') > 0 THEN SUBSTR(EXRATE,0,INSTR(EXRATE, ''/'') - 1) ELSE EXRATE END),''FM999999999999990.999999''),''.'','','') DL,
           REPLACE(TO_CHAR((CASE WHEN INSTR(EXRATE, ''/'') > 0 THEN SUBSTR(EXRATE,INSTR(EXRATE, ''/'') + 1) ELSE ''0'' END),''FM999999999999990.999999''),''.'','','') DR
    FROM CAMAST
    WHERE CAMASTID IN (
        SELECT  MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID
        FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''
    )
) TMP', 'Tỷ lệ thực hiện', 'Conversion ratio', 'C', 'N', 18);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'VALU_DT', 'C', '<$TXNUM>', 'SELECT  to_char(to_date(f.cvalue,''dd/mm/yyyy''),''RRRRMMDD'')
    FROM TLLOGFLD F
        WHERE   F.FLDCD IN (''07'')
            AND F.TXNUM = ''<$FILTERID>''', 'Ngày hiệu lực', 'Effective Date', 'C', 'N', 17);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'NEWM_23G', 'C', '<$TXNUM>', 'SELECT CASE WHEN DELTD <> ''Y'' THEN ''NEWM'' ELSE ''REVR'' END FROM TLLOG WHERE TXNUM = ''<$FILTERID>''', 'NEWM/REVR', 'NEWM/REVR', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'CAEV_IND', 'C', '<$TXNUM>', 'SELECT CASE WHEN INSTR(''010'',CATYPE) >0 THEN ''DVCA''
            WHEN INSTR(''011'',CATYPE) >0 THEN ''DVSE''
            WHEN INSTR(''024'',CATYPE) >0 THEN ''EXWA''
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
FROM CAMAST WHERE CAMASTID IN (
    SELECT  MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
)', 'Loại sự kiện quyền', 'Corporate Action Event Indicator', 'C', 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'CICCODE', 'C', '<$TXNUM>', 'SELECT CF.SWIFTCODE
FROM CFMAST CF WHERE  CF.CUSTODYCD IN (SELECT  MAX (CASE WHEN f.fldcd = ''19'' THEN f.cvalue ELSE '''' END)  CAID
                                                            FROM TLLOGFLD F
                                                                WHERE TXNUM = ''<$FILTERID>'')', 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'CIF_NO', 'C', '<$TXNUM>', 'SELECT CF.CIFID FROM CFMAST CF WHERE CUSTODYCD IN
(SELECT  MAX (CASE WHEN f.fldcd = ''19'' THEN f.cvalue ELSE '''' END)  CUSTODYCD
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Số CIF của khách hàng', 'Customer Number', 'C', 'Y', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'CST_BANK_ACCT_NO', 'C', '<$TXNUM>', 'select dd.refcasaacct
from ddmast dd
where    dd.custodycd in (
                        SELECT  MAX (CASE WHEN f.fldcd = ''19'' THEN f.cvalue ELSE '''' END)  DDACCTNO
                            FROM TLLOGFLD F
                                WHERE TXNUM = ''<$FILTERID>'' )
     and dd.status <> ''C''
     and dd.isdefault = ''Y''', 'Tài khoản nhận tiền cổ tức', 'The bank cash account of customer', 'C', 'Y', 10);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'GRSS_AMT', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(NVL(CAD.AMT, CAS.AMT),''FM999999999999990.999999''),''.'','','') GRSS
FROM CASCHD CAS,CAMAST CA,SBSECURITIES SB, CFMAST CF, AFMAST AF,
(
    SELECT  MAX (CASE WHEN F.FLDCD = ''10'' THEN F.NVALUE ELSE 0 END)  NVALUE,
    MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID,
    MAX (CASE WHEN F.FLDCD = ''05'' THEN F.CVALUE ELSE '''' END)  CATYPE,
    MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END)  AUTOID
    FROM TLLOGFLD F
    WHERE TXNUM = ''<$FILTERID>''
) A,
(
    SELECT * FROM CASCHDDTL WHERE TXNUM = ''<$FILTERID>''
) CAD
WHERE CAS.AUTOID = A.AUTOID
AND A.CAID = CA.CAMASTID
AND SB.CODEID = CAS.CODEID
AND CF.CUSTID = AF.CUSTID
AND AF.ACCTNO = CAS.AFACCTNO
AND A.AUTOID = CAD.AUTOID_CASCHD(+)', 'Số tiền nhận chưa trừ thuế', 'Gross Amount', 'C', 'N', 12);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'NETT_AMT', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(
(
    CASE WHEN VAT <> ''Y'' THEN AMT
    ELSE (
        CASE WHEN CATYPE = ''010'' THEN (CASE WHEN CUSTTYPE = ''B'' THEN AMT ELSE NETT1 END)
             WHEN CATYPE = ''024'' THEN NETT2
             WHEN CATYPE IN (''027'',''015'') THEN NETT1
             WHEN CATYPE IN (''016'') THEN NETT3
        ELSE AMT END
    )
    END
),''FM999999999999990.999999''),''.'','','') NETT
FROM (
    SELECT CF.VAT, CF.CUSTTYPE, CA.CATYPE, NVL(CAD.AMT, CAS.AMT) AMT,
           GREATEST(0, NVL(CAD.AMT, CAS.AMT) - ROUND(NVL(CAD.AMT, CAS.AMT) * CA.PITRATE/100)) NETT1,
           GREATEST(0, NVL(CAD.AMT, CAS.AMT) - ROUND(CAS.BALANCE * CA.PITRATE/100 * CA.EXPRICE / CA.EXRATE)) NETT2,
           GREATEST(0, NVL(CAD.AMT, CAS.AMT) - ROUND(CAS.INTAMT * CA.PITRATE/100)) NETT3
    FROM CASCHD CAS, CFMAST CF, AFMAST AF,
    (
        SELECT MAX (CASE WHEN F.FLDCD = ''10'' THEN F.NVALUE ELSE 0 END)  NVALUE,
                MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID,
                MAX (CASE WHEN F.FLDCD = ''05'' THEN F.CVALUE ELSE '''' END)  CATYPE,
                MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END)  AUTOID
        FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''
    ) A,
    (
        SELECT CAMASTID, CATYPE, PITRATE, EXPRICE,
               NVL(CASE WHEN INSTR(EXRATE, ''/'') = 0 THEN TO_NUMBER(EXRATE) ELSE TO_NUMBER(SUBSTR(EXRATE, 0, INSTR(EXRATE, ''/'') - 1)) / TO_NUMBER(SUBSTR(EXRATE, INSTR(EXRATE,''/'') + 1, LENGTH(EXRATE))) END,1) EXRATE
        FROM CAMAST
    ) CA,
    (
        SELECT * FROM CASCHDDTL WHERE TXNUM = ''<$FILTERID>''
    ) CAD
    WHERE CAS.AUTOID = A.AUTOID
    AND A.CAID = CA.CAMASTID
    AND CF.CUSTID = AF.CUSTID
    AND AF.ACCTNO = CAS.AFACCTNO
    AND A.AUTOID = CAD.AUTOID_CASCHD(+)
)', 'Số tiền đã trừ thuế', 'Amount after tax', 'C', 'N', 13);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'XDTE_DT', 'C', '<$TXNUM>', 'SELECT TO_CHAR(GETPREVDATE(REPORTDATE,1),''RRRRMMDD'')
FROM CAMAST
WHERE CAMASTID IN (SELECT MAX(CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END) CAID FROM TLLOGFLD F WHERE F.TXNUM = ''<$FILTERID>'')', 'Ngày giao dịch không hưởng quyền', 'XDTE_DT', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'PSTA_AMT', 'C', '<$TXNUM>', 'SELECT REPLACE(TO_CHAR(
(
    CASE WHEN VAT <> ''Y'' THEN AMT
    ELSE (
        CASE WHEN CATYPE = ''010'' THEN (CASE WHEN CUSTTYPE = ''B'' THEN AMT ELSE NETT1 END)
             WHEN CATYPE = ''024'' THEN NETT2
             WHEN CATYPE IN (''027'',''015'') THEN NETT1
             WHEN CATYPE IN (''016'') THEN NETT3
        ELSE AMT END
    )
    END
),''FM999999999999990.999999''),''.'','','') NETT
FROM (
    SELECT CF.VAT, CF.CUSTTYPE, CA.CATYPE, NVL(CAD.AMT, CAS.AMT) AMT,
           GREATEST(0, NVL(CAD.AMT, CAS.AMT) - ROUND(NVL(CAD.AMT, CAS.AMT) * CA.PITRATE/100)) NETT1,
           GREATEST(0, NVL(CAD.AMT, CAS.AMT) - ROUND(CAS.BALANCE * CA.PITRATE/100 * CA.EXPRICE / CA.EXRATE)) NETT2,
           GREATEST(0, NVL(CAD.AMT, CAS.AMT) - ROUND(CAS.INTAMT * CA.PITRATE/100)) NETT3
    FROM CASCHD CAS, CFMAST CF, AFMAST AF,
    (
        SELECT MAX (CASE WHEN F.FLDCD = ''10'' THEN F.NVALUE ELSE 0 END)  NVALUE,
                MAX (CASE WHEN F.FLDCD = ''02'' THEN F.CVALUE ELSE '''' END)  CAID,
                MAX (CASE WHEN F.FLDCD = ''05'' THEN F.CVALUE ELSE '''' END)  CATYPE,
                MAX (CASE WHEN F.FLDCD = ''01'' THEN F.CVALUE ELSE '''' END)  AUTOID
        FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''
    ) A,
    (
        SELECT CAMASTID, CATYPE, PITRATE, EXPRICE,
               NVL(CASE WHEN INSTR(EXRATE, ''/'') = 0 THEN TO_NUMBER(EXRATE) ELSE TO_NUMBER(SUBSTR(EXRATE, 0, INSTR(EXRATE, ''/'') - 1)) / TO_NUMBER(SUBSTR(EXRATE, INSTR(EXRATE,''/'') + 1, LENGTH(EXRATE))) END,1) EXRATE
        FROM CAMAST
    ) CA,
    (
        SELECT * FROM CASCHDDTL WHERE TXNUM = ''<$FILTERID>''
    ) CAD
    WHERE CAS.AUTOID = A.AUTOID
    AND A.CAID = CA.CAMASTID
    AND CF.CUSTID = AF.CUSTID
    AND AF.ACCTNO = CAS.AFACCTNO
    AND A.AUTOID = CAD.AUTOID_CASCHD(+)
)', 'Số tiền thực tế đã phân bổ', 'The allotment amount', 'C', 'N', 11);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'RDTE_DT', 'C', '<$TXNUM>', 'select to_char(REPORTDATE,''RRRRMMDD'') from camast
where camastid  in (SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>'')', 'Ngày đăng ký cuối cùng', 'RDTE_DT', 'C', 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9023', '566.CORP.CONF.TIEN', 'SEME_ID', 'C', '<$TXNUM>', 'SELECT  MAX (CASE WHEN f.fldcd = ''02'' THEN f.cvalue ELSE '''' END)  CAID
    FROM TLLOGFLD F
        WHERE TXNUM = ''<$FILTERID>''', 'Số hiệu yêu cầu', 'Reference identitication', 'C', 'N', 2);COMMIT;