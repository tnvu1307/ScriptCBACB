SET DEFINE OFF;DELETE FROM VSDTXMAPEXT WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('9007','NULL');Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9007', '950.STMT.MSG', 'AC_IDENTN', 'C', '@ACCT_123', NULL, 'Thông tin tài khoản tiền', 'Account Identification', 'C', 'Y', 2);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9007', '950.STMT.MSG', 'CICCODE', 'C', '@SHBKKRSEA', NULL, 'CICCODE Client', 'CICCODE Client', 'C', 'N', 1);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9007', '950.STMT.MSG', 'CLOSING_BAL', 'C', '@C170201USD447734.09', NULL, 'Số dư cuối kỳ', 'Closing Balance', 'C', 'N', 7);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9007', '950.STMT.MSG', 'DESCRIPTION', 'C', '@123acb', NULL, 'Mô tả giao dịch', 'Description', 'C', 'Y', 6);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9007', '950.STMT.MSG', 'OPENING_BAL', 'C', '@C 190826 USD1191311.92', NULL, 'Số dư đầu kỳ', 'Opening Balance', 'C', 'N', 4);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9007', '950.STMT.MSG', 'STATEMENT_LINE', 'C', '@170131 CD 32518.92 FTRF           NONREF//17BASBBBPRR ', NULL, 'Statement Line', 'Statement Line', 'C', 'Y', 5);Insert into VSDTXMAPEXT   (OBJTYPE, OBJNAME, TRFCODE, FLDNAME, FLDTYPE, AMTEXP, CMDSQL, CAPTION, EN_CAPTION, CHSTATUS, SPLIT, ODRNUM) Values   ('T', '9007', '950.STMT.MSG', 'STATEMENT_NO', 'C', '@00165/00001', NULL, 'Số thông báo', 'Statement Number', 'C', 'N', 3);COMMIT;