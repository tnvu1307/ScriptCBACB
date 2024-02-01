SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('2235','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'STOCKTYPE', 'C', '$01', 'SELECT (CASE WHEN SECTYPE = ''006'' or SECTYPE = ''003'' THEN ''FAMT'' ELSE ''UNIT'' END) UNIT FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Loại chứng khoán', 'Type of securities', NULL, 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'SYMBOL', 'C', '$01', 'SELECT REPLACE(SYMBOL, ''_WFT'') SYMBOL FROM SBSECURITIES WHERE CODEID=''<$FILTERID>''', 'Mã chứng khoán', 'Securities code', NULL, 'N', 3);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'TXDATE', 'D', '<$BUSDATE>', NULL, 'Ngày tạo yêu cầu', 'Preparation Date', NULL, 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'VSDSTOCKTYPE', 'C', '@1', NULL, 'Loại chứng khoán', 'Type of securities', NULL, 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'CUSTODYCD', 'C', '$02', 'SELECT CUSTODYCD FROM CFMAST CF, AFMAST AF WHERE CF.CUSTID = AF.CUSTID AND AF.ACCTNO = ''<$FILTERID>'' ', 'Tài khoản lưu ký', 'Custody code', NULL, 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'DESC', 'C', '$30', NULL, 'Mô tả', 'Description', NULL, 'N', 8);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'PLACEID', 'C', '$04', 'SELECT CRPLACEID FROM SEMORTAGE M1 WHERE M1.AUTOID = ''<$FILTERID>''', 'Nơi nhận phong tỏa', 'Name of individual/organization who receive to block', NULL, 'N', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'QTTY', 'C', '$10', NULL, 'Số lượng', 'Quantity', NULL, 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'SETTLEMENTDATE', 'D', '$04', 'SELECT to_char(TXDATE,''DD/MM/RRRR'') FROM SEMORTAGE M1 WHERE M1.AUTOID = ''<$FILTERID>'' ', 'Ngày hạch toán', 'Settlement date', NULL, 'N', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'AFACCTNO', 'C', '$02', NULL, 'Tiểu khoản', 'Sub-account', NULL, 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'AUTONUMBER', 'C', '$01', 'SELECT LPAD(SEQ_VSDREQAUTOID.NEXTVAL,6,''0'') AUTONUMBER FROM DUAL', 'Số thứ tự của điện gửi trong phiên', 'EN:Số thứ tự của điện gửi trong phiên', 'C', 'N', 16);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'CONTRACTDATE', 'D', '$04', 'SELECT to_char(MDATE,''DD/MM/RRRR'') FROM SEMORTAGE M1 WHERE M1.AUTOID = ''<$FILTERID>'' ', 'Ngày phong tỏa', 'Date of contract', NULL, 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '2235', '524.NEWM.FROM//AVAL.TOBA//PLED', 'CONTRACTNO', 'C', '$04', 'SELECT NUM_MG FROM SEMORTAGE M1 WHERE M1.AUTOID = ''<$FILTERID>'' ', 'Số hợp đồng phong tỏa', 'Contract number', NULL, 'N', 6);COMMIT;