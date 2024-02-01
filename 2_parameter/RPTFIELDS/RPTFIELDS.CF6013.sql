SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF6013','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'F_DATE', 'CF6013', 'F_DATE', 'Ngày', 'Date', -1, 'M', '99/99/9999', 'dd/MM/yyyy', 10, NULL, NULL, '<$BUSDATE>', 'Y', 'N', 'Y', NULL, NULL, 'N', 'D', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'T_DATE', 'CF6013', 'T_DATE', 'Đến ngày', 'To date', 0, 'M', '99/99/9999', 'dd/MM/yyyy', 10, NULL, NULL, '<$BUSDATE>', 'N', 'N', 'Y', NULL, NULL, 'N', 'D', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'Report_No', 'CF6013', 'Report_No', 'Số chứng từ', 'Report No', 1, 'M', 'ccc', '_', 3, NULL, NULL, '001', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'PV_CUSTODYCD', 'CF6013', 'IN_CUSTODYCD', 'Số TK luu ký', 'Trading account', 2, 'M', 'cccc.cccccc', '_', 10, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTODYCD_TX', 'CF', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_SYMBOL', 'CF6013', 'P_SYMBOL', 'Chứng khoán', 'Ticker', 3, 'M', 'cccccccccccccccccccc', '_', 20, 'SELECT SYMBOL_NAME VALUE,SYMBOL_NAME VALUECD, SYMBOL_NAME DISPLAY, SYMBOL_NAME EN_DISPLAY, SYMBOL_NAME DESCRIPTION FROM(SELECT SYMBOL SYMBOL_NAME, SYMBOL ODR  FROM SBSECURITIES   UNION ALL SELECT ''ALL'' SYMBOL_NAME , ''1'' ODR  FROM DUAL) ORDER BY ODR', NULL, 'ALL', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_SHARESOUTTYP', 'CF6013', 'P_SHARESOUTTYP', 'KL lưu hành', 'Shares outstanding', 4, 'T', 'ccc', '_', 30, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''SHARESOUTTYP'' ORDER BY LSTODR', NULL, 'N', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''SHARESOUTTYP'' ORDER BY LSTODR', NULL, 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_SIGNUSER', 'CF6013', 'P_SIGNUSER', 'Người ký', 'Signature', 5, 'T', 'ccc', '_', 30, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, EN_CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''POSOFSIGN'' ORDER BY LSTODR', NULL, '001', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''POSOFSIGN'' ORDER BY LSTODR', NULL, 'Y', 'C', 'N');COMMIT;