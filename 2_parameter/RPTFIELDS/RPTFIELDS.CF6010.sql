SET DEFINE OFF;DELETE FROM RPTFIELDS WHERE 1 = 1 AND NVL(OBJNAME,'NULL') = NVL('CF6010','NULL');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'F_DATE', 'CF6010', 'F_DATE', 'Ngày', 'Date', 0, 'M', '99/99/9999', 'dd/MM/yyyy', 10, NULL, NULL, '<$BUSDATE>', 'Y', 'N', 'Y', NULL, NULL, 'N', 'D', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_ReportNo', 'CF6010', 'P_ReportNo', 'Số chứng từ', 'Report No', 1, 'T', 'ccc', '-', 3, NULL, NULL, '001', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'T_DATE', 'CF6010', 'T_DATE', 'Đến ngày', 'To date', 2, 'M', '99/99/9999', 'dd/MM/yyyy', 10, NULL, NULL, '<$BUSDATE>', 'N', 'N', 'Y', NULL, NULL, 'N', 'D', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', NULL, 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_CUSTODYCD', 'CF6010', 'P_CUSTODYCD', 'Số TK lưu ký', 'Trading account', 3, 'M', 'cccc.cccccc', '-', 10, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, 'CUSTODYCD_TX', 'CF', NULL, NULL, NULL, NULL, 'Y', 'T', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_SYMBOL', 'CF6010', 'P_SYMBOL', 'Chứng khoán', 'Ticker', 4, 'M', 'cccccccccccccccccccc', '-', 20, 'SELECT SYMBOL_NAME VALUE,SYMBOL_NAME VALUECD, SYMBOL_NAME DISPLAY, SYMBOL_NAME EN_DISPLAY, SYMBOL_NAME DESCRIPTION FROM(SELECT SYMBOL SYMBOL_NAME, SYMBOL ODR  FROM SBSECURITIES   UNION ALL SELECT ''ALL'' SYMBOL_NAME , ''1'' ODR  FROM DUAL) ORDER BY ODR', NULL, 'ALL', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_SHARESOUTTYP', 'CF6010', 'P_SHARESOUTTYP', 'KL lưu hành', 'Shares outstanding', 5, 'T', 'ccc', '-', 30, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''SHARESOUTTYP'' ORDER BY LSTODR', NULL, 'N', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''SHARESOUTTYP'' ORDER BY LSTODR', NULL, 'Y', 'C', 'N');Insert into RPTFIELDS   (MODCODE, FLDNAME, OBJNAME, DEFNAME, CAPTION, EN_CAPTION, ODRNUM, FLDTYPE, FLDMASK, FLDFORMAT, FLDLEN, LLIST, LCHK, DEFVAL, VISIBLE, DISABLE, MANDATORY, AMTEXP, VALIDTAG, LOOKUP, DATATYPE, INVNAME, FLDSOURCE, FLDDESC, CHAINNAME, PRINTINFO, LOOKUPNAME, SEARCHCODE, SRMODCODE, INVFORMAT, TAGFIELD, TAGLIST, TAGVALUE, ISPARAM, CTLTYPE, CHKSCOPE) Values   ('CF', 'P_SIGNTYPE', 'CF6010', 'P_SIGNTYPE', 'Người ký', 'Signature', 6, 'T', 'ccc', '-', 30, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''POSOFSIGN'' ORDER BY LSTODR', NULL, '001', 'Y', 'N', 'Y', NULL, NULL, 'N', 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SELECT CDVAL VALUE, CDVAL VALUECD, CDCONTENT DISPLAY, CDCONTENT EN_DISPLAY, CDCONTENT DESCRIPTION
FROM ALLCODE WHERE CDTYPE = ''CF'' AND CDNAME = ''POSOFSIGN'' ORDER BY LSTODR', NULL, 'Y', 'C', 'N');COMMIT;